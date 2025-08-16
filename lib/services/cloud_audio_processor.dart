import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'sherpa_vad_service.dart';
import 'deepgram_service.dart';
import 'opus_decoder_service.dart';

/// Cloud audio processor that combines local VAD with cloud ASR
/// 
/// This processor uses local VAD to detect meaningful speech segments
/// and then sends them to Deepgram for transcription
class CloudAudioProcessor extends ChangeNotifier {
  final SherpaVadService _vadService;
  final DeepgramService _deepgramService;
  final OpusDecoderService _opusDecoderService; // Only needed for WAV creation, not decoding
  
  // Processing state
  bool _isInitialized = false;
  bool _isProcessing = false;
  bool _isEnabled = false;
  
  // VAD configuration
  static const Duration _segmentCloseDelay = Duration(seconds: 3); // 3 second wait time
  

  
  // Speech detection state
  bool _isSpeechActive = false;
  DateTime? _lastSpeechTime;
  Timer? _segmentCloseTimer;
  
  // Current segment tracking
  String? _currentSegmentPath;
  DateTime? _currentSegmentStartTime;
  final List<int> _currentSegmentBuffer = [];
  final int _maxSegmentBufferSize = 1024 * 1024; // 1MB per segment
  
  // Transcription results
  final List<CloudAudioResult> _transcriptionResults = [];
  final int _maxResultsHistory = 100;
  
  // Temporary files that should be cleaned up later
  final List<String> _temporaryFiles = [];
  
  // Audio player for transcription playback
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  // Stream controllers
  final StreamController<CloudAudioResult> _resultController = 
      StreamController<CloudAudioResult>.broadcast();
  final StreamController<bool> _speechStateStream = 
      StreamController<bool>.broadcast();
  
  // Getters
  bool get isInitialized => _isInitialized;
  bool get isProcessing => _isProcessing;
  bool get isEnabled => _isEnabled;
  bool get isSpeechActive => _isSpeechActive;
  List<CloudAudioResult> get transcriptionResults => List.unmodifiable(_transcriptionResults);
  Stream<CloudAudioResult> get resultStream => _resultController.stream;
  Stream<bool> get speechStateStream => _speechStateStream.stream;
  
  // Service getters
  SherpaVadService get vadService => _vadService;
  DeepgramService get deepgramService => _deepgramService;
  
  // Audio player getters
  AudioPlayer get audioPlayer => _audioPlayer;
  
  CloudAudioProcessor(this._vadService, this._deepgramService, this._opusDecoderService);
  
  /// Initialize the cloud audio processor
  Future<bool> initialize() async {
    if (_isInitialized) {
      debugPrint('CloudAudioProcessor: Already initialized');
      return true;
    }
    
    try {
      debugPrint('CloudAudioProcessor: Initializing cloud audio processor...');
      
      // Initialize VAD service
      debugPrint('CloudAudioProcessor: Initializing VAD service...');
      final vadInitialized = await _vadService.initialize();
      debugPrint('CloudAudioProcessor: VAD service initialization result: $vadInitialized');
      
      if (!vadInitialized) {
        debugPrint('CloudAudioProcessor: Failed to initialize VAD service');
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
      
      _isInitialized = vadInitialized && deepgramInitialized;
      
      if (_isInitialized) {
        debugPrint('CloudAudioProcessor: Cloud audio processor initialized successfully');
        debugPrint('  - VAD Service: Initialized');
        debugPrint('  - Deepgram Service: Initialized');
        debugPrint('  - Opus Decoder Service: Using existing instance for WAV creation');
        debugPrint('  - Segment Close Delay: $_segmentCloseDelay');
        
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
    
    // Clear buffers
    _currentSegmentBuffer.clear();
    
    debugPrint('CloudAudioProcessor: Cloud audio processing disabled');
    notifyListeners();
  }
  
  /// Process PCM audio data from hardware
  /// 
  /// [pcmData] - Raw PCM audio data (16-bit, little-endian)
  /// [isFinal] - Whether this is the final chunk of audio
  void processAudioData(Uint8List pcmData, {bool isFinal = false}) {
    if (!_isEnabled || !_isInitialized) {
      return;
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
      
      // Process final audio chunk if requested
      if (isFinal) {
        _processFinalAudioChunk();
      }
      
    } catch (e) {
      debugPrint('CloudAudioProcessor: Error processing audio data: $e');
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
  
  /// Handle speech detection
  void _handleSpeechDetected(Uint8List pcmData) {
    final now = DateTime.now();
    
    if (!_isSpeechActive) {
      // Speech started
      _isSpeechActive = true;
      _speechStateStream.add(true);
      
      // Start new segment
      _startNewSegment(now);
      
      debugPrint('CloudAudioProcessor: Speech started, new segment created');
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
      
      if (silenceDuration >= _segmentCloseDelay) {
        // Close the current segment
        _closeCurrentSegment();
      } else {
        // Schedule segment close timer
        _scheduleSegmentClose();
      }
    }
  }
  
  /// Start a new audio segment
  void _startNewSegment(DateTime startTime) {
    _currentSegmentStartTime = startTime;
    _currentSegmentBuffer.clear();
    
    // Generate segment filename
    final timestamp = startTime.millisecondsSinceEpoch;
    _currentSegmentPath = 'segment_$timestamp.wav';
    
    debugPrint('CloudAudioProcessor: New segment started: $_currentSegmentPath');
  }
  
  /// Schedule segment close timer
  void _scheduleSegmentClose() {
    _segmentCloseTimer?.cancel();
    
    var remainingDelay = _segmentCloseDelay - DateTime.now().difference(_lastSpeechTime!);
    if (remainingDelay.isNegative) {
      remainingDelay = Duration.zero;
    }
    
    _segmentCloseTimer = Timer(remainingDelay, () {
      _closeCurrentSegment();
    });
    
    debugPrint('CloudAudioProcessor: Segment close scheduled in ${remainingDelay.inMilliseconds}ms');
  }
  
  /// Close the current audio segment
  void _closeCurrentSegment() {
    if (!_isSpeechActive || _currentSegmentStartTime == null) {
      return;
    }
    
    try {
      final endTime = DateTime.now();
      final segmentDuration = endTime.difference(_currentSegmentStartTime!);
      
      debugPrint('CloudAudioProcessor: Closing segment: $_currentSegmentPath (duration: $segmentDuration)');
      
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
      
      // Send to Deepgram for transcription (asynchronously)
      _transcribeSegmentAsync(segmentResult);
      
      // Reset segment state
      _currentSegmentPath = null;
      _currentSegmentStartTime = null;
      _currentSegmentBuffer.clear();
      
      // Update speech state
      _isSpeechActive = false;
      _lastSpeechTime = null;
      _speechStateStream.add(false);
      
      // Cancel segment close timer
      _segmentCloseTimer?.cancel();
      _segmentCloseTimer = null;
      
      debugPrint('CloudAudioProcessor: Segment closed successfully');
      
    } catch (e) {
      debugPrint('CloudAudioProcessor: Error closing segment: $e');
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
          
          // Add to results history
          _addToResultsHistory(finalResult);
          
          // Broadcast result
          _resultController.add(finalResult);
          
          debugPrint('CloudAudioProcessor: Transcription completed: "${transcriptionResult.transcription}"');
        }
      
      // Note: Temporary file cleanup is delayed until user leaves the page
      
    } catch (e) {
      debugPrint('CloudAudioProcessor: Error during async transcription: $e');
      
      // Create error result
      final errorResult = segmentResult.copyWith(
        transcription: 'Transcription failed: $e',
        confidence: 0.0,
        language: 'en',
        isFinal: true,
      );
      
      // Broadcast error result
      _resultController.add(errorResult);
    }
  }
  
  /// Create temporary WAV file for transcription
  Future<String?> _createTemporaryWavFile(CloudAudioResult segmentResult) async {
    try {
      // Get temporary directory using path_provider
      final tempDir = await getTemporaryDirectory();
      final rawFilePath = '${tempDir.path}/${segmentResult.segmentPath.replaceAll('.wav', '.raw')}';
      
      // Debug: Show PCM data details
      debugPrint('CloudAudioProcessor: PCM data details - Length: ${segmentResult.audioData.length} bytes, First 8 bytes: ${segmentResult.audioData.take(8).toList()}');
      
      // Debug: Show PCM data format in hex
      if (segmentResult.audioData.length >= 20) {
        final pcmHex = segmentResult.audioData.take(20).map((b) => '0x${b.toRadixString(16).padLeft(2, '0')}').join(' ');
        debugPrint('CloudAudioProcessor: PCM data hex (first 20 bytes): $pcmHex');
      }
      
      // Debug: Check if PCM data length is even (should be for 16-bit samples)
      if (segmentResult.audioData.length % 2 != 0) {
        debugPrint('CloudAudioProcessor: WARNING - PCM data length is odd (${segmentResult.audioData.length}), should be even for 16-bit samples');
      }
      
      // Debug: Show first few 16-bit samples
      if (segmentResult.audioData.length >= 8) {
        final sample1 = segmentResult.audioData[0] | (segmentResult.audioData[1] << 8);
        final sample2 = segmentResult.audioData[2] | (segmentResult.audioData[3] << 8);
        debugPrint('CloudAudioProcessor: First 16-bit samples (little-endian): $sample1, $sample2');
      }
      
      // Create WAV file directly from PCM data using the proven OpusDecoderService
      final wavData = _opusDecoderService.convertPcmToWav(
        segmentResult.audioData, // Use PCM data directly
        sampleRate: 16000,
        channels: 1,
        bitDepth: 16,
      );
      
      final file = File(rawFilePath.replaceAll('.raw', '.wav'));
      await file.writeAsBytes(wavData);
      
      // Store the file path for later cleanup
      _temporaryFiles.add(file.path);
      
      debugPrint('CloudAudioProcessor: WAV file created: ${file.path} (${wavData.length} bytes)');
      debugPrint('CloudAudioProcessor: WAV file created using OpusDecoderService - PCM data: ${segmentResult.audioData.length} bytes, Sample rate: 16000Hz, Channels: 1, Bits: 16');
      debugPrint('CloudAudioProcessor: File stored for delayed cleanup. Total temp files: ${_temporaryFiles.length}');
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
  Future<void> cleanupTemporaryFiles() async {
    debugPrint('CloudAudioProcessor: Cleaning up ${_temporaryFiles.length} temporary files');
    
    for (final filePath in _temporaryFiles) {
      try {
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
          debugPrint('CloudAudioProcessor: Deleted temporary file: $filePath');
        }
      } catch (e) {
        debugPrint('CloudAudioProcessor: Error deleting temporary file $filePath: $e');
      }
    }
    
    _temporaryFiles.clear();
    debugPrint('CloudAudioProcessor: Temporary file cleanup completed');
  }
  
  /// Play audio file for transcription result
  Future<void> playAudioFile(String filePath) async {
    try {
      debugPrint('CloudAudioProcessor: Playing audio file: $filePath');
      
      // Stop any currently playing audio
      await _audioPlayer.stop();
      
      // Play the new audio file
      await _audioPlayer.play(DeviceFileSource(filePath));
      
      debugPrint('CloudAudioProcessor: Audio playback started');
    } catch (e) {
      debugPrint('CloudAudioProcessor: Error playing audio file: $e');
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
    return {
      'isInitialized': _isInitialized,
      'isProcessing': _isProcessing,
      'isEnabled': _isEnabled,
      'isSpeechActive': _isSpeechActive,

      'currentSegmentBufferSize': _currentSegmentBuffer.length,
      'segmentCloseDelay': _segmentCloseDelay.inSeconds,
      'vadStats': _vadService.getStats(),
      'deepgramStats': _deepgramService.getStats(),
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
