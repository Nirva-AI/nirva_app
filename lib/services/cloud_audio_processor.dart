import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'sherpa_vad_service.dart';
import 'deepgram_service.dart';
import 'opus_decoder_service.dart';
import 'cloud_asr_storage_service.dart';
import 'api_logging_service.dart';
import 'audio_config.dart';
import '../my_hive_objects.dart';

/// Cloud audio processor that combines local VAD with cloud ASR
/// 
/// This processor uses local VAD to detect meaningful speech segments
/// and then sends them to Deepgram for transcription
/// 
/// ENFORCES SINGLETON PATTERN: Only one audio segment can be created at a time
class CloudAudioProcessor extends ChangeNotifier {
  final SherpaVadService _vadService;
  final DeepgramService _deepgramService;
  final OpusDecoderService _opusDecoderService; // Only needed for WAV creation, not decoding
  final CloudAsrStorageService _storageService; // Persistent storage service
  final ApiLoggingService _loggingService; // API logging service
  
  // User identification
  String? _userId;
  
  // Processing state
  bool _isInitialized = false;
  bool _isProcessing = false;
  bool _isEnabled = false;
  
  // VAD configuration - using centralized AudioConfig
  // All timing constants are now synchronized with VAD service
  
  // Speech detection state
  bool _isSpeechActive = false;
  DateTime? _lastSpeechTime;
  Timer? _segmentCloseTimer;
  int? _lastLoggedSeconds; // Track last logged second to avoid duplicate logs
  
  // Current segment tracking
  String? _currentSegmentPath;
  DateTime? _currentSegmentStartTime;
  final List<int> _currentSegmentBuffer = [];
  final int _maxSegmentBufferSize = AudioConfig.maxSegmentBufferSize;
  
  // SINGLETON PATTERN: Mutex lock to prevent overlapping segments
  bool _isSegmentCreationLocked = false;
  bool _isSegmentClosing = false;
  DateTime? _lastSegmentEndTime;
  
  // SEQUENTIAL PROCESSING: Queue to ensure audio packets are processed one by one
  final Queue<Uint8List> _audioQueue = Queue<Uint8List>();
  bool _isProcessingAudio = false;
  
  // Audio processing statistics
  int _totalAudioBytesProcessed = 0;
  
  // Transcription results
  final List<CloudAudioResult> _transcriptionResults = [];
  final int _maxResultsHistory = AudioConfig.maxResultsHistory;
  
  // Temporary files that should be cleaned up later
  final List<String> _temporaryFiles = [];
  
  // Audio player for transcription playback
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  // Stream controllers
  final StreamController<CloudAudioResult> _resultController = 
      StreamController<CloudAudioResult>.broadcast();
  final StreamController<bool> _speechStateStream = 
      StreamController<bool>.broadcast();
  final StreamController<String> _statusStream = 
      StreamController<String>.broadcast();
  
  // Getters
  bool get isInitialized => _isInitialized;
  bool get isProcessing => _isProcessing;
  bool get isEnabled => _isEnabled;
  bool get isSpeechActive => _isSpeechActive;
  bool get isSegmentCreationLocked => _isSegmentCreationLocked;
  bool get isSegmentClosing => _isSegmentClosing;
  List<CloudAudioResult> get transcriptionResults => List.unmodifiable(_transcriptionResults);
  Stream<CloudAudioResult> get resultStream => _resultController.stream;
  Stream<bool> get speechStateStream => _speechStateStream.stream;
  Stream<String> get statusStream => _statusStream.stream;
  bool get isStorageServiceInitialized => _storageService.isInitialized;
  bool get isAudioPlayerInitialized => _audioPlayer != null;
  
  // Service getters
  SherpaVadService get vadService => _vadService;
  DeepgramService get deepgramService => _deepgramService;
  
  // Audio player getters
  AudioPlayer get audioPlayer => _audioPlayer;
  
  CloudAudioProcessor(
    this._vadService, 
    this._deepgramService, 
    this._opusDecoderService,
    {CloudAsrStorageService? storageService, String? userId}
  ) : _storageService = storageService ?? CloudAsrStorageService(),
      _loggingService = ApiLoggingService() {
    // Store user ID for later use
    _userId = userId;
  }
  
  /// Initialize the cloud audio processor
  Future<bool> initialize() async {
    debugPrint('CloudAudioProcessor: initialize() method called');
    if (_isInitialized) {
      debugPrint('CloudAudioProcessor: Already initialized');
      return true;
    }
    
    try {
      debugPrint('CloudAudioProcessor: Initializing cloud audio processor...');
      
      // Initialize logging service
      try {
        await _loggingService.initialize();
        debugPrint('CloudAudioProcessor: Logging service initialized successfully');
        debugPrint('CloudAudioProcessor: Log file path: ${_loggingService.logFilePath}');
        
        // Display current log contents
        await _loggingService.displayLogContents();
      } catch (e) {
        debugPrint('CloudAudioProcessor: ERROR initializing logging service: $e');
      }
      
      // Initialize VAD service
      debugPrint('CloudAudioProcessor: Initializing VAD service...');
      debugPrint('CloudAudioProcessor: VAD service reference: ${_vadService != null ? 'Available' : 'Not available'}');
      final vadInitialized = await _vadService.initialize();
      debugPrint('CloudAudioProcessor: VAD service initialization result: $vadInitialized');
      
      if (!vadInitialized) {
        debugPrint('CloudAudioProcessor: Failed to initialize VAD service');
        debugPrint('CloudAudioProcessor: VAD service status: ${_vadService.isInitialized}');
        _isInitialized = false;
        return false;
      }
      
      // Initialize Deepgram service
      debugPrint('CloudAudioProcessor: Initializing Deepgram service...');
      final deepgramInitialized = await _deepgramService.initialize();
      debugPrint('CloudAudioProcessor: Deepgram service initialization result: $deepgramInitialized');
      
      if (!deepgramInitialized) {
        debugPrint('CloudAudioProcessor: Failed to initialize Deepgram service');

        _isInitialized = false;
        return false;
      }
      
      // Note: Opus decoder service is passed in and should already be initialized
      debugPrint('CloudAudioProcessor: Using existing Opus decoder service for WAV creation');
      debugPrint('CloudAudioProcessor: OpusDecoderService reference: ${_opusDecoderService != null ? 'Available' : 'Not available'}');
      debugPrint('CloudAudioProcessor: OpusDecoderService initialized: ${_opusDecoderService?.isInitialized ?? false}');
      
      // Initialize storage service
      debugPrint('CloudAudioProcessor: Initializing storage service...');
      final storageInitialized = await _storageService.initialize(
        userId: _userId,
        deviceInfo: 'mobile_app',
      );
      debugPrint('CloudAudioProcessor: Storage service initialization result: $storageInitialized');
      
      if (!storageInitialized) {
        debugPrint('CloudAudioProcessor: Warning - Storage service failed to initialize, results will not be persisted');

      }
      
      _isInitialized = vadInitialized && deepgramInitialized;
      
      if (_isInitialized) {
        debugPrint('CloudAudioProcessor: Cloud audio processor initialized successfully');
        debugPrint('  - VAD Service: Initialized');
        debugPrint('  - Deepgram Service: Initialized');
        debugPrint('  - Opus Decoder Service: Using existing instance for WAV creation');
        debugPrint('  - Segment Close Delay: ${AudioConfig.segmentCloseDelay.inSeconds}s');
        debugPrint('  - Max Segment Duration: ${AudioConfig.maxSegmentDuration.inSeconds}s');
        
        // Validate configuration consistency
        final configValid = AudioConfig.validateTimingConsistency();
        if (configValid) {
          debugPrint('CloudAudioProcessor: ✅ Configuration validation passed - all timing constants are synchronized');
        } else {
          debugPrint('CloudAudioProcessor: ⚠️ Configuration validation failed - timing constants are not synchronized!');
          debugPrint('CloudAudioProcessor: Configuration summary: ${AudioConfig.getConfigSummary()}');
        }
        
        notifyListeners();
      } else {
        debugPrint('CloudAudioProcessor: Failed to initialize required services');
      }
      
      return _isInitialized;
      
    } catch (e, stackTrace) {
      debugPrint('CloudAudioProcessor: Failed to initialize: $e');
      debugPrint('CloudAudioProcessor: Stack trace: $stackTrace');
      

      
      _isInitialized = false;
      notifyListeners();
      return false;
    }
  }

  /// Initialize just the storage service to access stored data
  Future<bool> initializeStorageService() async {
    try {
      debugPrint('CloudAudioProcessor: Initializing storage service only...');
      final storageInitialized = await _storageService.initialize(
        userId: _userId,
        deviceInfo: 'mobile_app',
      );
      debugPrint('CloudAudioProcessor: Storage service initialization result: $storageInitialized');
      
      if (storageInitialized) {
        debugPrint('CloudAudioProcessor: Storage service initialized successfully');
        // Notify listeners that storage data is available
        notifyListeners();
      } else {
        debugPrint('CloudAudioProcessor: Failed to initialize storage service');
      }
      
      return storageInitialized;
      
    } catch (e) {
      debugPrint('CloudAudioProcessor: Error initializing storage service: $e');
      return false;
    }
  }

  /// Initialize just the audio player for playback functionality
  Future<bool> initializeAudioPlayer() async {
    try {
      debugPrint('CloudAudioProcessor: Initializing audio player only...');
      
      // Initialize the audio player
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.setVolume(1.0);
      
      debugPrint('CloudAudioProcessor: Audio player initialized successfully');
      return true;
      
    } catch (e) {
      debugPrint('CloudAudioProcessor: Error initializing audio player: $e');
      return false;
    }
  }
  
  /// Enable cloud audio processing
  void enable() {
    if (!_isInitialized) {
      debugPrint('CloudAudioProcessor: Cannot enable - not initialized');
      return;
    }
    
    _isEnabled = true;
    debugPrint('CloudAudioProcessor: Cloud audio processing enabled');
    notifyListeners();
  }
  
  /// Disable cloud audio processing
  void disable() {
    _isEnabled = false;
    _isProcessing = false;
    _isSpeechActive = false;
    _lastSpeechTime = null;
    
    // Cancel segment close timer
    _segmentCloseTimer?.cancel();
    _segmentCloseTimer = null;
    
    // SINGLETON ENFORCEMENT: Reset all locks to prevent stuck state
    _isSegmentCreationLocked = false;
    _isSegmentClosing = false;
    _lastSegmentEndTime = null;
    
    // SEQUENTIAL PROCESSING: Clear audio processing queue
    _audioQueue.clear();
    _isProcessingAudio = false;
    
    // Clear buffers
    _currentSegmentBuffer.clear();
    
    debugPrint('CloudAudioProcessor: Cloud audio processing disabled');
    _statusStream.add('Cloud audio processing disabled - all locks reset');
    notifyListeners();
  }
  
  /// Process audio data with VAD and create segments
  void processAudioData(Uint8List pcmData) {
    if (!_isEnabled || !_isInitialized) {
      return;
    }

    try {
      _isProcessingAudio = true;
      _totalAudioBytesProcessed += pcmData.length;
      
      // Add audio data to queue
      _audioQueue.add(pcmData);
      
      // Process VAD to detect speech
      final speechDetected = _vadService.processAudioFrame(pcmData);
      final now = DateTime.now();
      
      if (speechDetected) {
        _lastSpeechTime = now;
        
        // Start new segment if not already active
        if (!_isSpeechActive && !_isSegmentCreationLocked) {
          // LOCK segment creation to prevent overlaps
          _isSegmentCreationLocked = true;
          
          // Speech started
          _isSpeechActive = true;
          _speechStateStream.add(true);
          
          // Start new segment
          _startNewSegment(now);
          
          debugPrint('CloudAudioProcessor: Speech detected - new segment created (LOCKED)');
          _statusStream.add('Segment creation locked - preventing overlaps');
        }
        
        // Cancel existing segment close timer
        _segmentCloseTimer?.cancel();
        
        // Add current audio data to current segment
        _currentSegmentBuffer.addAll(pcmData);
        
        // Keep segment buffer size manageable
        if (_currentSegmentBuffer.length > _maxSegmentBufferSize) {
          _currentSegmentBuffer.removeRange(0, _currentSegmentBuffer.length - _maxSegmentBufferSize);
        }
        
      } else {
        // Handle silence detection
        _handleSilenceDetected();
        
        // Still add audio to current segment if we have one
        if (_currentSegmentBuffer.isNotEmpty) {
          _currentSegmentBuffer.addAll(pcmData);
          
          // Keep segment buffer size manageable
          if (_currentSegmentBuffer.length > _maxSegmentBufferSize) {
            _currentSegmentBuffer.removeRange(0, _currentSegmentBuffer.length - _maxSegmentBufferSize);
          }
        }
      }
      
      // CRITICAL: Always add audio to segment buffer if we have an active segment
      if (_isSpeechActive && _currentSegmentStartTime != null && _currentSegmentBuffer.isEmpty) {
        debugPrint('CloudAudioProcessor: WARNING - Active segment but empty buffer! Adding audio data.');
        _currentSegmentBuffer.addAll(pcmData);
      }
      
    } catch (e) {
      debugPrint('CloudAudioProcessor: Error processing audio data: $e');
    } finally {
      _isProcessingAudio = false;
    }
  }
  
  /// Process audio queue sequentially to prevent overlapping segments
  Future<void> _processAudioQueue() async {
    if (_isProcessingAudio || _audioQueue.isEmpty) {
      return;
    }
    
    _isProcessingAudio = true;
    
    try {
      while (_audioQueue.isNotEmpty) {
        final pcmData = _audioQueue.removeFirst();
        
        // SINGLETON ENFORCEMENT: Check if VAD is ready to process new audio
        if (!_vadService.isReadyForNewAudio()) {
          debugPrint('CloudAudioProcessor: VAD not ready for new audio - skipping to prevent overlap');
          continue;
        }

        try {
          _isProcessing = true;
          notifyListeners();

          // Process audio with VAD
          final speechDetected = _vadService.processAudioFrame(pcmData);

          if (speechDetected) {
            _handleSpeechDetected(pcmData);
          } else {
            _handleSilenceDetected();
          }

        } catch (e) {
          debugPrint('CloudAudioProcessor: Error processing audio data: $e');
        } finally {
          _isProcessing = false;
          notifyListeners();
        }

        // Small delay to ensure VAD processing completes before next packet
        await Future.delayed(Duration(milliseconds: 10));
      }
    } finally {
      _isProcessingAudio = false;
    }
  }
  
  /// Handle speech detection
  void _handleSpeechDetected(Uint8List pcmData) {
    final now = DateTime.now();
    
    // SINGLETON ENFORCEMENT: Check if segment creation is locked
    if (_isSegmentCreationLocked) {
      // If we have an existing segment, extend it; otherwise, just buffer the audio
      if (_currentSegmentPath != null && _currentSegmentStartTime != null) {
        debugPrint('CloudAudioProcessor: Segment creation is LOCKED - extending existing segment to prevent overlap');
        _extendExistingSegment(now);
      } else {
        // No existing segment to extend - just buffer audio until segment creation is unlocked
        debugPrint('CloudAudioProcessor: Segment creation is LOCKED but no existing segment - buffering audio');
        _currentSegmentBuffer.addAll(pcmData);
      }
      return;
    }
    
    // SINGLETON ENFORCEMENT: Check if we're currently closing a segment
    if (_isSegmentClosing) {
      // If we have an existing segment, extend it; otherwise, just buffer the audio
      if (_currentSegmentPath != null && _currentSegmentStartTime != null) {
        debugPrint('CloudAudioProcessor: Segment is currently closing - extending existing segment to prevent overlap');
        _extendExistingSegment(now);
      } else {
        // No existing segment to extend - just buffer audio until segment closing is complete
        debugPrint('CloudAudioProcessor: Segment is currently closing but no existing segment - buffering audio');
        _currentSegmentBuffer.addAll(pcmData);
      }
      return;
    }
    
    // SINGLETON ENFORCEMENT: Check minimum time gap since last segment ended
    if (_lastSegmentEndTime != null) {
      final timeSinceLastSegment = now.difference(_lastSegmentEndTime!);
      if (timeSinceLastSegment < AudioConfig.minSegmentGap) {
        // If we have an existing segment, extend it; otherwise, just buffer the audio
        if (_currentSegmentPath != null && _currentSegmentStartTime != null) {
          debugPrint('CloudAudioProcessor: Too soon since last segment ended (${timeSinceLastSegment.inMilliseconds}ms < ${AudioConfig.minSegmentGap.inMilliseconds}ms) - extending existing segment to prevent false splits');
          _extendExistingSegment(now);
        } else {
          // No existing segment to extend - just buffer audio until minimum gap is met
          debugPrint('CloudAudioProcessor: Too soon since last segment ended but no existing segment - buffering audio');
          _currentSegmentBuffer.addAll(pcmData);
        }
        return;
      }
    }
    
    if (!_isSpeechActive) {
      // Check if we should start a new segment or extend existing one
      if (_shouldStartNewSegment(now)) {
        // LOCK segment creation to prevent overlaps
        _isSegmentCreationLocked = true;
        
        // Speech started
        _isSpeechActive = true;
        _speechStateStream.add(true);
        
        // Start new segment
        _startNewSegment(now);
        
        debugPrint('CloudAudioProcessor: Speech started, new segment created (LOCKED)');
        _statusStream.add('Segment creation locked - preventing overlaps');
      } else {
        // Extend existing segment instead of creating new one
        debugPrint('CloudAudioProcessor: Speech detected but extending existing segment (overlap prevention)');
        _extendExistingSegment(now);
        return;
      }
    }
    
    // Update last speech time
    _lastSpeechTime = now;
    
    // Cancel existing segment close timer
    _segmentCloseTimer?.cancel();
    
    // Add current audio data to current segment
    _currentSegmentBuffer.addAll(pcmData);
    
    // Keep segment buffer size manageable
    if (_currentSegmentBuffer.length > _maxSegmentBufferSize) {
      _currentSegmentBuffer.removeRange(0, _currentSegmentBuffer.length - _maxSegmentBufferSize);
    }
  
  }
  
  /// Handle silence detection
  void _handleSilenceDetected() {
    if (_isSpeechActive && _lastSpeechTime != null) {
      // Check if enough silence has passed to close the segment
      final silenceDuration = DateTime.now().difference(_lastSpeechTime!);
      
      // Add minimum segment duration check to prevent very short segments
      final segmentDuration = _currentSegmentStartTime != null 
          ? DateTime.now().difference(_currentSegmentStartTime!)
          : Duration.zero;
      
      // Only close segment if it has meaningful content (at least 2 seconds of audio)
      if (segmentDuration.inMilliseconds < 2000 || _currentSegmentBuffer.length < 64000) {
        // debugPrint('CloudAudioProcessor: Segment too small - extending instead of closing');
        _extendSegmentForMinimumDuration();
        return;
      }
      
      if (silenceDuration >= AudioConfig.segmentCloseDelay && segmentDuration >= AudioConfig.minSegmentDuration) {
        // Close the current segment
        // debugPrint('CloudAudioProcessor: Closing segment due to sufficient silence and duration');
        _closeCurrentSegment();
      } else if (silenceDuration >= AudioConfig.segmentCloseDelay && segmentDuration < AudioConfig.minSegmentDuration) {
        // Segment too short - extend it instead of closing
        // debugPrint('CloudAudioProcessor: Segment too short - extending instead of closing');
        _extendSegmentForMinimumDuration();
      } else {
        // Schedule segment close timer
        // debugPrint('CloudAudioProcessor: Scheduling segment close timer');
        _scheduleSegmentClose();
      }
    }
  }
  
  /// Check if we should start a new segment or extend existing one
  bool _shouldStartNewSegment(DateTime now) {
    // SINGLETON ENFORCEMENT: If segment creation is locked, never start new segment
    if (_isSegmentCreationLocked) {
      debugPrint('CloudAudioProcessor: Segment creation is LOCKED - cannot start new segment');
      return false;
    }
    
    // SINGLETON ENFORCEMENT: If segment is currently closing, never start new segment
    if (_isSegmentClosing) {
      debugPrint('CloudAudioProcessor: Segment is currently closing - cannot start new segment');
      return false;
    }
    
    // If no current segment, always start new one
    if (_currentSegmentPath == null || _currentSegmentStartTime == null) {
      debugPrint('CloudAudioProcessor: No current segment - starting new one');
      return true;
    }
    
    // Check if current segment is too long (merge long segments)
    final timeSinceSegmentStart = now.difference(_currentSegmentStartTime!);
    if (timeSinceSegmentStart > AudioConfig.maxSegmentDuration) {
      debugPrint('CloudAudioProcessor: Current segment too long (${timeSinceSegmentStart.inSeconds}s) - forcing new segment');
      return true;
    }
    
    // CRITICAL: If we already have an active segment, NEVER start a new one
    // This prevents overlapping segments from being created
    // Only allow new segments when the current one is completely closed
    if (_isSpeechActive) {
      debugPrint('CloudAudioProcessor: Preventing new segment - current segment is still active (${timeSinceSegmentStart.inSeconds}s)');
      return false;
    }
    
    // SINGLETON ENFORCEMENT: Check minimum time gap since last segment ended
    if (_lastSegmentEndTime != null) {
      final timeSinceLastSegment = now.difference(_lastSegmentEndTime!);
      if (timeSinceLastSegment < AudioConfig.minSegmentGap) {
        debugPrint('CloudAudioProcessor: Preventing new segment - too soon after last segment ended (${timeSinceLastSegment.inMilliseconds}ms < ${AudioConfig.minSegmentGap.inMilliseconds}ms)');
        return false;
      }
    }
    
    // If speech is not active but we have a segment, check if it's been closed long enough
    // This prevents rapid segment creation that could cause overlaps
    final timeSinceLastSpeech = _lastSpeechTime != null ? now.difference(_lastSpeechTime!) : Duration.zero;
    if (timeSinceLastSpeech < AudioConfig.minSegmentGap) {
      debugPrint('CloudAudioProcessor: Preventing new segment - too soon after last speech (${timeSinceLastSpeech.inMilliseconds}ms < ${AudioConfig.minSegmentGap.inMilliseconds}ms)');
      return false;
    }
    
    debugPrint('CloudAudioProcessor: Allowing new segment - current segment inactive and sufficient time passed');
    return true;
  }
  
  /// Extend existing segment instead of creating new one
  void _extendExistingSegment(DateTime now) {
    if (_currentSegmentPath == null || _currentSegmentStartTime == null) {
      // No existing segment to extend - this should not happen in normal flow
      debugPrint('CloudAudioProcessor: WARNING - _extendExistingSegment called but no existing segment! This indicates a logic error.');
      return;
    }
    
    // Update last speech time to extend current segment
    _lastSpeechTime = now;
    
    // Cancel existing segment close timer
    _segmentCloseTimer?.cancel();
    
    // Log the extension for debugging
    final segmentDuration = now.difference(_currentSegmentStartTime!);
    debugPrint('CloudAudioProcessor: Extended existing segment: $_currentSegmentPath (duration: ${segmentDuration.inMilliseconds}ms)');
    
    // If segment is getting very long, consider forcing a new one
    if (segmentDuration > AudioConfig.maxSegmentDuration) {
      debugPrint('CloudAudioProcessor: Segment extended beyond max duration (${segmentDuration.inSeconds}s) - will force new segment on next speech detection');
    }
  }
  
  /// Start a new audio segment
  void _startNewSegment(DateTime startTime) {
    // Ensure no existing segment is active
    if (_isSpeechActive) {
      debugPrint('CloudAudioProcessor: WARNING - Starting new segment while speech is active! This should not happen.');
    }
    
    _currentSegmentStartTime = startTime;
    _currentSegmentBuffer.clear();
    _lastLoggedSeconds = null; // Reset logging state for new segment
    
    // Generate segment filename
    final timestamp = startTime.millisecondsSinceEpoch;
    _currentSegmentPath = 'segment_$timestamp.wav';
    
    debugPrint('CloudAudioProcessor: New segment started: $_currentSegmentPath');
    debugPrint('CloudAudioProcessor: Segment start time: $_currentSegmentStartTime');
  }
  
  /// Extend segment to meet minimum duration requirement
  void _extendSegmentForMinimumDuration() {
    if (_currentSegmentStartTime == null) return;
    
    final segmentDuration = DateTime.now().difference(_currentSegmentStartTime!);
    final remainingTime = AudioConfig.minSegmentDuration - segmentDuration;
    
    if (remainingTime.isNegative) return;
    
    // Schedule a timer to close the segment after minimum duration
    _segmentCloseTimer?.cancel();
    _segmentCloseTimer = Timer(remainingTime, () {
      debugPrint('CloudAudioProcessor: Closing segment after minimum duration extension');
      _closeCurrentSegment();
    });
  
  }
  
  /// Schedule segment close timer
  void _scheduleSegmentClose() {
    _segmentCloseTimer?.cancel();
    
    // Calculate the minimum time needed to reach minimum segment duration
    final segmentDuration = _currentSegmentStartTime != null 
        ? DateTime.now().difference(_currentSegmentStartTime!)
        : Duration.zero;
    final minDurationNeeded = AudioConfig.minSegmentDuration - segmentDuration;
    
    // Use the longer of: silence delay or minimum duration needed
    var remainingDelay = AudioConfig.segmentCloseDelay - DateTime.now().difference(_lastSpeechTime!);
    if (remainingDelay.isNegative) {
      remainingDelay = Duration.zero;
    }
    
    // Ensure we don't close before minimum duration
    if (minDurationNeeded.isNegative == false && minDurationNeeded > remainingDelay) {
      remainingDelay = minDurationNeeded;
    }
    
    _segmentCloseTimer = Timer(remainingDelay, () {
      debugPrint('CloudAudioProcessor: Segment close timer fired - closing segment');
      _closeCurrentSegment();
    });
  }
  
  /// Check if current segment overlaps with previous segments
  bool _hasOverlapWithPreviousSegments(Duration currentDuration) {
    // This method is no longer needed since we prevent overlaps by ensuring only one segment is active
    // Keeping for backward compatibility but it should never return true
    return false;
  }
  
  /// Merge current segment with previous segment instead of creating new one
  void _mergeWithPreviousSegment() {
    // This method is no longer needed since we prevent overlaps by ensuring only one segment is active
    debugPrint('CloudAudioProcessor: Merge method called but not needed - overlaps prevented by single active segment');
    _closeCurrentSegment();
  }
  
  /// Validate segment timing to prevent overlaps
  bool _validateSegmentTiming(DateTime startTime, DateTime endTime) {
    // Use lastSegmentEndTime for validation since it's more reliable than transcriptionResults
    if (_lastSegmentEndTime == null) {
      return true; // First segment is always valid
    }
    
    // Check against the last segment end time to prevent overlaps
    final timeBetweenSegments = startTime.difference(_lastSegmentEndTime!);
    
    // Ensure there's sufficient gap between segments (at least 1 second)
    if (timeBetweenSegments < Duration(seconds: 1)) {
      debugPrint('CloudAudioProcessor: WARNING - Potential segment overlap detected!');
      debugPrint('CloudAudioProcessor: Last segment ended at: ${_lastSegmentEndTime!.toIso8601String()}');
      debugPrint('CloudAudioProcessor: New segment starts at: ${startTime.toIso8601String()}');
      debugPrint('CloudAudioProcessor: Gap between segments: ${timeBetweenSegments.inMilliseconds}ms (should be >= 1000ms)');
      return false;
    }
    
    debugPrint('CloudAudioProcessor: Segment timing validated - gap: ${timeBetweenSegments.inMilliseconds}ms');
    return true;
  }
  
  /// Check if segments should be merged due to timing proximity
  bool _shouldMergeWithPreviousSegment() {
    // This method is no longer needed since we prevent overlaps by ensuring only one segment is active
    return false;
  }
  
  /// Reset segment state
  void _resetSegment() {
     // Cancel any pending timers first
     _segmentCloseTimer?.cancel();
     _segmentCloseTimer = null;
     
     // Clear segment data
     _currentSegmentPath = null;
     _currentSegmentStartTime = null;
     _currentSegmentBuffer.clear();
     
     // Reset speech state
     _isSpeechActive = false;
     _lastSpeechTime = null;
     _lastLoggedSeconds = null; // Reset logging state
     
     // SINGLETON ENFORCEMENT: Unlock segment creation
     _isSegmentCreationLocked = false;
     _isSegmentClosing = false;
     
     // Notify listeners of state change
     _speechStateStream.add(false);
     
     // Reset VAD state to ensure proper synchronization
     // This is critical to prevent overlapping segments
     _vadService.resetVadState();
     
     _statusStream.add('Segment creation unlocked - ready for new segments');
   }
  
  /// Close the current audio segment
  void _closeCurrentSegment() {
    if (!_isSpeechActive || _currentSegmentStartTime == null) {
      debugPrint('CloudAudioProcessor: Cannot close segment - not active or no start time');
      return;
    }
    
    // SINGLETON ENFORCEMENT: Set closing flag to prevent new segments
    _isSegmentClosing = true;
    _statusStream.add('Closing segment - preventing new segments');
    
    try {
      final endTime = DateTime.now();
      final segmentDuration = endTime.difference(_currentSegmentStartTime!);
      final bufferSize = _currentSegmentBuffer.length;
      
      debugPrint('CloudAudioProcessor: Closing segment: $_currentSegmentPath (duration: $segmentDuration)');
      debugPrint('CloudAudioProcessor: Segment buffer size: $bufferSize bytes');
      debugPrint('CloudAudioProcessor: Segment start time: ${_currentSegmentStartTime!.toIso8601String()}');
      debugPrint('CloudAudioProcessor: Segment end time: ${endTime.toIso8601String()}');
      
      // CRITICAL: Don't close segments that are too small
      if (segmentDuration.inMilliseconds < 2000 || bufferSize < 64000) {
        debugPrint('CloudAudioProcessor: Segment too small - duration: ${segmentDuration.inMilliseconds}ms, size: ${bufferSize} bytes. Extending instead of closing.');
        _extendSegmentForMinimumDuration();
        _isSegmentClosing = false; // Reset closing flag
        return;
      }
      
      // Validate segment timing to prevent overlaps
      if (!_validateSegmentTiming(_currentSegmentStartTime!, endTime)) {
        debugPrint('CloudAudioProcessor: Segment timing validation failed - discarding segment to prevent overlap');
        _resetSegment();
        return;
      }
      
      // Create segment result
      final segmentResult = CloudAudioResult(
        segmentPath: _currentSegmentPath ?? 'unknown',
        startTime: _currentSegmentStartTime!,
        endTime: endTime,
        duration: segmentDuration,
        audioData: Uint8List.fromList(_currentSegmentBuffer),
        isFinal: false,
        processingTime: DateTime.now(),
      );
      
      debugPrint('CloudAudioProcessor: Created segment result with ${segmentResult.audioData.length} bytes of audio data');
      
      // Send to Deepgram for transcription (asynchronously)
      _transcribeSegmentAsync(segmentResult);
      
      // Update last segment end time for overlap prevention
      _lastSegmentEndTime = endTime;
      
      // Don't reset segment state immediately - wait for transcription to complete
      // This ensures the segment data is available for the UI
      debugPrint('CloudAudioProcessor: Segment sent for transcription - keeping segment data until completion');
      
      debugPrint('CloudAudioProcessor: Segment closed successfully');
      _statusStream.add('Segment closed - ready for new segments');
      
    } catch (e) {
      debugPrint('CloudAudioProcessor: Error closing segment: $e');
      // Even if there's an error, reset the segment to prevent stuck state
      _resetSegment();
    }
  }
  
  /// Process final audio chunk
  void _processFinalAudioChunk() {
    if (_isSpeechActive) {
      // Close any remaining segment
      _closeCurrentSegment();
    }
    
    debugPrint('CloudAudioProcessor: Final audio chunk processed');
  }
  
  /// Transcribe segment asynchronously using Deepgram
  Future<void> _transcribeSegmentAsync(CloudAudioResult segmentResult) async {
    try {
      debugPrint('CloudAudioProcessor: Starting async transcription for segment: ${segmentResult.segmentPath}');
      
      // Create temporary WAV file for transcription
      final rawFilePath = await _createTemporaryWavFile(segmentResult);
      if (rawFilePath == null) {
        debugPrint('CloudAudioProcessor: Failed to create temporary raw PCM file');
        return;
      }
      
      // Send to Deepgram for transcription
      final transcriptionResult = await _deepgramService.transcribeAudioFile(
        rawFilePath,
        startTime: segmentResult.startTime,
        endTime: segmentResult.endTime,
      );
      
      if (transcriptionResult != null) {
        // Create final result with transcription
        final finalResult = segmentResult.copyWith(
          transcription: transcriptionResult.transcription,
          confidence: transcriptionResult.confidence,
          language: transcriptionResult.language,
          isFinal: true,
          audioFilePath: rawFilePath, // Include the file path for playback
        );
        
        // Log the API response to file
        try {
          await _loggingService.logTranscriptionResponse(
            audioSegmentPath: segmentResult.segmentPath,
            transcription: transcriptionResult.transcription,
            confidence: transcriptionResult.confidence,
            language: transcriptionResult.language,
            processingTime: DateTime.now().difference(segmentResult.startTime),
            rawResponse: transcriptionResult.rawResponse,
          );
        } catch (e) {
          debugPrint('CloudAudioProcessor: ERROR logging transcription response: $e');
        }
        
        // Add to results history
        _addToResultsHistory(finalResult);
        
        // Store result persistently
        try {
          final stored = await _storageService.storeResult(finalResult);
          if (!stored) {
            debugPrint('CloudAudioProcessor: Failed to store result persistently: ${finalResult.segmentPath}');
          }
        } catch (e) {
          debugPrint('CloudAudioProcessor: Error storing result: $e');
        }
        
        // Broadcast result
        _resultController.add(finalResult);
        
        // Now reset the segment state after transcription is complete
        // This prevents overlapping segments and cleans up resources
        debugPrint('CloudAudioProcessor: Transcription completed - resetting segment state');
        _resetSegment();
        
      }
      
      // Note: Temporary file cleanup is delayed until user leaves the page
      
    } catch (e) {
      debugPrint('CloudAudioProcessor: Error during async transcription: $e');
      
      // Log the error to file
      await _loggingService.logTranscriptionResponse(
        audioSegmentPath: segmentResult.segmentPath,
        transcription: 'Transcription failed',
        error: e.toString(),
      );
      
      // Create error result (use available fields only)
      final errorResult = segmentResult.copyWith(
        transcription: 'Transcription failed: $e',
        confidence: 0.0,
        language: 'en',
        isFinal: true,
      );
      
      // Add error result to history and broadcast
      _addToResultsHistory(errorResult);
      _resultController.add(errorResult);
      
      // Reset segment state even for errors to prevent stuck state
      debugPrint('CloudAudioProcessor: Transcription failed - resetting segment state');
      _resetSegment();
    }
  }
  
  /// Create temporary WAV file for transcription
  Future<String?> _createTemporaryWavFile(CloudAudioResult segmentResult) async {
    try {
      debugPrint('CloudAudioProcessor: Creating WAV file for segment: ${segmentResult.segmentPath}');
      debugPrint('CloudAudioProcessor: Audio data size: ${segmentResult.audioData.length} bytes');
      debugPrint('CloudAudioProcessor: Segment duration: ${segmentResult.duration.inMilliseconds}ms');
      
      // Get temporary directory using path_provider
      final tempDir = await getTemporaryDirectory();
      final rawFilePath = '${tempDir.path}/${segmentResult.segmentPath.replaceAll('.wav', '.raw')}';
      
      // Create WAV file directly from PCM data using the proven OpusDecoderService
      final wavData = _opusDecoderService.convertPcmToWav(
        segmentResult.audioData, // Use PCM data directly
        sampleRate: AudioConfig.audioSampleRate,
        channels: AudioConfig.audioChannels,
        bitDepth: AudioConfig.audioBitDepth,
      );
      
      debugPrint('CloudAudioProcessor: Converted to WAV: ${wavData.length} bytes');
      
      final file = File(rawFilePath.replaceAll('.raw', '.wav'));
      await file.writeAsBytes(wavData);
      
      // Store the file path for later cleanup
      _temporaryFiles.add(file.path);
      
      debugPrint('CloudAudioProcessor: WAV file created: ${file.path} (${wavData.length} bytes)');
      return file.path;
      
    } catch (e) {
      debugPrint('CloudAudioProcessor: Error creating raw PCM file: $e');
      return null;
    }
  }
  

  

  

  
  /// Add result to history with size limit
  void _addToResultsHistory(CloudAudioResult result) {
    _transcriptionResults.add(result);
    
    // Keep only the latest results
    if (_transcriptionResults.length > _maxResultsHistory) {
      _transcriptionResults.removeRange(0, _transcriptionResults.length - _maxResultsHistory);
    }
  }
  
  /// Clear all processing results
  void clearResults() {
    _transcriptionResults.clear();
    debugPrint('CloudAudioProcessor: Processing results cleared');
    notifyListeners();
  }
  
  /// Clean up all temporary files (call this when user leaves the page)
  /// DISABLED: Files are now stored persistently for playback across sessions
  Future<void> cleanupTemporaryFiles() async {
    debugPrint('CloudAudioProcessor: File cleanup DISABLED - files are stored persistently');
    debugPrint('CloudAudioProcessor: ${_temporaryFiles.length} files will remain available for playback');
    
    // Commented out to preserve audio files for persistent storage
    // for (final filePath in _temporaryFiles) {
    //   try {
    //     final file = File(filePath);
    //     if (await file.exists()) {
    //       await file.delete();
    //       debugPrint('CloudAudioProcessor: Deleted temporary file: $filePath');
    //     }
    //   } catch (e) {
    //       debugPrint('CloudAudioProcessor: Error deleting temporary file $filePath: $e');
    //     }
    //   }
    //   
    //   _temporaryFiles.clear();
    //   debugPrint('CloudAudioProcessor: Temporary file cleanup completed');
    // }
  }
  
  /// Play audio file for transcription result
  Future<void> playAudioFile(String filePath) async {
    try {
      debugPrint('CloudAudioProcessor: Playing audio file: $filePath');
      
      // Check if file exists
      final file = File(filePath);
      if (!await file.exists()) {
        debugPrint('CloudAudioProcessor: ERROR - Audio file does not exist: $filePath');
        return;
      }
      
      // Check file size
      final fileSize = await file.length();
      debugPrint('CloudAudioProcessor: Audio file size: $fileSize bytes');
      
      if (fileSize == 0) {
        debugPrint('CloudAudioProcessor: ERROR - Audio file is empty: $filePath');
        return;
      }
      
      // Stop any currently playing audio
      await _audioPlayer.stop();
      
      // Play the new audio file
      await _audioPlayer.play(DeviceFileSource(filePath));
      
      debugPrint('CloudAudioProcessor: Audio playback started successfully');
    } catch (e) {
      debugPrint('CloudAudioProcessor: Error playing audio file: $e');
      debugPrint('CloudAudioProcessor: File path: $filePath');
      
      // Try to get more details about the error
      try {
        final file = File(filePath);
        final exists = await file.exists();
        final size = exists ? await file.length() : 0;
        debugPrint('CloudAudioProcessor: File exists: $exists, size: $size bytes');
      } catch (fileCheckError) {
        debugPrint('CloudAudioProcessor: Error checking file: $fileCheckError');
      }
    }
  }
  
  /// Stop audio playback
  Future<void> stopAudioPlayback() async {
    try {
      await _audioPlayer.stop();
      debugPrint('CloudAudioProcessor: Audio playback stopped');
    } catch (e) {
      debugPrint('CloudAudioProcessor: Error stopping audio playback: $e');
    }
  }
  
  /// Get audio player state
  Stream<PlayerState> get audioPlayerStateStream => _audioPlayer.onPlayerStateChanged;
  
  /// Get current processor statistics
  Map<String, dynamic> getStats() {
    final now = DateTime.now();
    final currentSegmentDuration = _currentSegmentStartTime != null 
        ? now.difference(_currentSegmentStartTime!).inMilliseconds 
        : 0;
    final timeSinceLastSpeech = _lastSpeechTime != null 
        ? now.difference(_lastSpeechTime!).inMilliseconds 
        : 0;
    
    return {
      'isInitialized': _isInitialized,
      'isProcessing': _isProcessing,
      'isEnabled': _isEnabled,
      'isSpeechActive': _isSpeechActive,
      'currentSegmentPath': _currentSegmentPath,
      'currentSegmentStartTime': _currentSegmentStartTime?.toIso8601String(),
      'currentSegmentDuration': '${currentSegmentDuration}ms',
      'currentSegmentBufferSize': _currentSegmentBuffer.length,
      'timeSinceLastSpeech': '${timeSinceLastSpeech}ms',
      'segmentCloseDelay': AudioConfig.segmentCloseDelay.inSeconds,
      'minSegmentDuration': AudioConfig.minSegmentDuration.inSeconds,
      'maxSegmentDuration': AudioConfig.maxSegmentDuration.inSeconds,
      'minSegmentGap': AudioConfig.minSegmentGap.inMilliseconds,
      'hasSegmentCloseTimer': _segmentCloseTimer != null,
      'vadStats': _vadService.getStats(),
      'deepgramStats': _deepgramService.getStats(),
      'totalResults': _transcriptionResults.length,
      'lastResultTime': _transcriptionResults.isNotEmpty 
          ? _transcriptionResults.last.endTime.toIso8601String() 
          : 'None',
    };
  }
  
  /// Get current audio configuration status
  Map<String, dynamic> getConfigurationStatus() {
    return {
      'configuration': AudioConfig.getConfigSummary(),
      'timingConsistency': AudioConfig.validateTimingConsistency(),
      'processorState': {
        'isInitialized': _isInitialized,
        'isEnabled': _isEnabled,
        'isProcessing': _isProcessing,
        'isSpeechActive': _isSpeechActive,
      },
      'segmentState': {
        'currentSegmentPath': _currentSegmentPath,
        'currentSegmentStartTime': _currentSegmentStartTime?.toIso8601String(),
        'currentSegmentBufferSize': _currentSegmentBuffer.length,
        'hasSegmentCloseTimer': _segmentCloseTimer != null,
      },
    };
  }
  
  /// Get all persistent results from storage
  List<CloudAsrResultStorage> getPersistentResults() {
    return _storageService.getAllResults();
  }
  
  /// Get results for a specific session
  List<CloudAsrResultStorage> getSessionResults(String sessionId) {
    return _storageService.getSessionResults(sessionId);
  }
  
  /// Get all sessions
  List<CloudAsrSessionStorage> getAllSessions() {
    return _storageService.getAllSessions();
  }
  
  /// Get storage statistics
  Map<String, dynamic> getStorageStats() {
    return _storageService.getStorageStats();
  }
  
  /// Get current singleton state for debugging
  Map<String, dynamic> getSingletonState() {
    return {
      'isSegmentCreationLocked': _isSegmentCreationLocked,
      'isSegmentClosing': _isSegmentClosing,
      'isSpeechActive': _isSpeechActive,
      'currentSegmentPath': _currentSegmentPath,
      'currentSegmentStartTime': _currentSegmentStartTime?.toIso8601String(),
      'lastSegmentEndTime': _lastSegmentEndTime?.toIso8601String(),
      'lastSpeechTime': _lastSpeechTime?.toIso8601String(),
      'segmentBufferSize': _currentSegmentBuffer.length,
      'hasSegmentCloseTimer': _segmentCloseTimer != null,
      'overlapPreventionActive': _isSegmentCreationLocked || _isSegmentClosing,
      // SEQUENTIAL PROCESSING: Queue status
      'audioQueueSize': _audioQueue.length,
      'isProcessingAudio': _isProcessingAudio,
    };
  }
  
  /// Force unlock segment creation (emergency reset)
  void forceUnlockSegmentCreation() {
    debugPrint('CloudAudioProcessor: EMERGENCY - Force unlocking segment creation');
    _isSegmentCreationLocked = false;
    _isSegmentClosing = false;
    _statusStream.add('Emergency unlock - segment creation unlocked');
    notifyListeners();
  }
  
  /// Clear audio processing queue (emergency reset)
  void clearAudioQueue() {
    debugPrint('CloudAudioProcessor: EMERGENCY - Clearing audio processing queue');
    _audioQueue.clear();
    _isProcessingAudio = false;
    _statusStream.add('Emergency queue clear - audio queue cleared');
    notifyListeners();
  }
  
  /// Get debug information about current state
  Map<String, dynamic> getDebugInfo() {
    return {
      'isEnabled': _isEnabled,
      'isInitialized': _isInitialized,
      'isProcessing': _isProcessing,
      'isSpeechActive': _isSpeechActive,
      'isSegmentCreationLocked': _isSegmentCreationLocked,
      'isSegmentClosing': _isSegmentClosing,
      'currentSegmentPath': _currentSegmentPath,
      'currentSegmentStartTime': _currentSegmentStartTime?.toIso8601String(),
      'lastSpeechTime': _lastSpeechTime?.toIso8601String(),
      'lastSegmentEndTime': _lastSegmentEndTime?.toIso8601String(),
      'segmentBufferSize': _currentSegmentBuffer.length,
      'audioQueueSize': _audioQueue.length,
      'isProcessingAudio': _isProcessingAudio,
      'totalAudioBytesProcessed': _totalAudioBytesProcessed,
      'transcriptionResults': _transcriptionResults.length,
      'vadServiceStatus': {
        'initialized': _vadService.isInitialized,
        'processing': _vadService.isProcessing,
        'speechDetected': _vadService.isSpeechDetected,
        'totalFrames': _vadService.totalFramesProcessed,
        'speechFrames': _vadService.speechFramesDetected,
        'silenceFrames': _vadService.silenceFramesDetected,
      },
    };
  }
  

  
  @override
  void dispose() {
    _segmentCloseTimer?.cancel();
    _resultController.close();
    _speechStateStream.close();
    
    // Stop and dispose audio player
    _audioPlayer.stop();
    _audioPlayer.dispose();
    
    // Note: Don't dispose _opusDecoderService since we don't own it
    
    // Clean up temporary files when disposing
    cleanupTemporaryFiles();
    
    super.dispose();
  }
}

/// Represents a cloud audio processing result
class CloudAudioResult {
  final String segmentPath;
  final DateTime startTime;
  final DateTime endTime;
  final Duration duration;
  final Uint8List audioData;
  final String? transcription;
  final double? confidence;
  final String? language;
  final bool isFinal;
  final DateTime processingTime;
  final String? audioFilePath; // Path to the temporary WAV file for playback
  
  const CloudAudioResult({
    required this.segmentPath,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.audioData,
    this.transcription,
    this.confidence,
    this.language,
    required this.isFinal,
    required this.processingTime,
    this.audioFilePath,
  });
  
  /// Create a copy with updated fields
  CloudAudioResult copyWith({
    String? segmentPath,
    DateTime? startTime,
    DateTime? endTime,
    Duration? duration,
    Uint8List? audioData,
    String? transcription,
    double? confidence,
    String? language,
    bool? isFinal,
    DateTime? processingTime,
    String? audioFilePath,
  }) {
    return CloudAudioResult(
      segmentPath: segmentPath ?? this.segmentPath,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      audioData: audioData ?? this.audioData,
      transcription: transcription ?? this.transcription,
      confidence: confidence ?? this.confidence,
      language: language ?? this.language,
      isFinal: isFinal ?? this.isFinal,
      processingTime: processingTime ?? this.processingTime,
      audioFilePath: audioFilePath ?? this.audioFilePath,
    );
  }
  
  @override
  String toString() {
    return 'CloudAudioResult(segment: $segmentPath, duration: $duration, transcription: "$transcription", isFinal: $isFinal)';
  }
}
