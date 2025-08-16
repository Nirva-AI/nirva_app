import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'dart:isolate';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'sherpa_vad_service.dart';
import 'sherpa_asr_service.dart';
import '../models/processed_audio_result.dart';
import 'compute_audio_processor.dart';

/// Integrated local audio processing service combining VAD and ASR
/// 
/// This service processes audio streams from hardware devices to:
/// 1. Detect speech segments using VAD
/// 2. Transcribe speech using local ASR
/// 3. Integrate with existing hardware audio pipeline
class LocalAudioProcessor extends ChangeNotifier {
  final SherpaVadService _vadService;
  final SherpaAsrService _asrService;
  
  // Compute-based audio processor for heavy computational work
  late final ComputeAudioProcessor _computeProcessor;
  
  // Processing state
  bool _isInitialized = false;
  bool _isProcessing = false;
  bool _isEnabled = false;
  
  // Audio processing
  final List<int> _audioBuffer = [];
  
  // Speech processing
  bool _isSpeechActive = false;
  DateTime? _speechStartTime;
  final List<VadSpeechSegment> _detectedSegments = [];
  
  // Transcription results
  final List<ProcessedAudioResult> _processingResults = [];
  final int _maxResultsHistory = 50;
  
  // Stream controllers
  final StreamController<ProcessedAudioResult> _resultController = 
      StreamController<ProcessedAudioResult>.broadcast();
  final StreamController<bool> _speechStateController = 
      StreamController<bool>.broadcast();
  
  // Stream subscriptions
  StreamSubscription<ProcessedAudioResult>? _isolateResultSubscription;
  StreamSubscription<bool>? _isolateSpeechStateSubscription;
  StreamSubscription<TranscriptionResult>? _asrTranscriptionSubscription;
  
  // Getters
  bool get isInitialized => _isInitialized;
  bool get isProcessing => _isProcessing;
  bool get isEnabled => _isEnabled;
  bool get isSpeechActive => _isSpeechActive;
  List<VadSpeechSegment> get detectedSegments => List.unmodifiable(_detectedSegments);
  List<ProcessedAudioResult> get processingResults => List.unmodifiable(_processingResults);
  Stream<ProcessedAudioResult> get resultStream => _resultController.stream;
  Stream<bool> get speechDetectionStream => _speechStateController.stream;
  Stream<bool> get speechStateStream => _speechStateController.stream;
  
  // Service getters
  SherpaVadService get vadService => _vadService;
  SherpaAsrService get asrService => _asrService;
  
  LocalAudioProcessor(this._vadService, this._asrService);
  
  /// Initialize the local audio processor
  Future<bool> initialize() async {
    if (_isInitialized) {
      debugPrint('LocalAudioProcessor: Already initialized');
      return true;
    }
    
    try {
      debugPrint('LocalAudioProcessor: Initializing local audio processor...');
      
      // Initialize VAD service
      debugPrint('LocalAudioProcessor: Initializing VAD service...');
      final vadInitialized = await _vadService.initialize();
      debugPrint('LocalAudioProcessor: VAD service initialization result: $vadInitialized');
      
      if (!vadInitialized) {
        debugPrint('LocalAudioProcessor: Failed to initialize VAD service');
        _isInitialized = false;
        return false;
      }
      
      // Initialize ASR service
      debugPrint('LocalAudioProcessor: Initializing ASR service...');
      final asrInitialized = await _asrService.initialize();
      debugPrint('LocalAudioProcessor: ASR service initialization result: $asrInitialized');
      
      if (!asrInitialized) {
        debugPrint('LocalAudioProcessor: Failed to initialize ASR service');
        _isInitialized = false;
        return false;
      }
      
      // Initialize compute-based audio processor
      debugPrint('LocalAudioProcessor: Initializing compute-based audio processor...');
      _computeProcessor = ComputeAudioProcessor();
      final computeInitialized = await _computeProcessor.initialize();
      debugPrint('LocalAudioProcessor: Compute processor initialization result: $computeInitialized');
      
      if (!computeInitialized) {
        debugPrint('LocalAudioProcessor: Failed to initialize compute processor');
        _isInitialized = false;
        return false;
      }
      
      // Pass ASR service reference to compute processor
      _computeProcessor.setAsrService(_asrService);
      debugPrint('LocalAudioProcessor: ASR service reference passed to compute processor');
      
      // All services must be initialized
      _isInitialized = vadInitialized && asrInitialized && computeInitialized;
      
      debugPrint('LocalAudioProcessor: Final initialization result: $_isInitialized');
      
      if (_isInitialized) {
        debugPrint('LocalAudioProcessor: Local audio processor initialized successfully');
        
        // Set up compute processor stream listeners
        try {
          // Cancel existing subscriptions if any
          await _isolateResultSubscription?.cancel();
          await _isolateSpeechStateSubscription?.cancel();
          
          _isolateResultSubscription = _computeProcessor.resultStream.listen(
            _onIsolateResult,
            onError: (error) => debugPrint('LocalAudioProcessor: Compute result stream error: $error'),
          );
          
          _isolateSpeechStateSubscription = _computeProcessor.speechStateStream.listen(
            _onIsolateSpeechState,
            onError: (error) => debugPrint('LocalAudioProcessor: Compute speech state stream error: $error'),
          );
          
          debugPrint('LocalAudioProcessor: Compute processor stream listeners set up successfully');
        } catch (e) {
          debugPrint('LocalAudioProcessor: Failed to set up compute processor stream listeners: $e');
        }
        
        notifyListeners();
      } else {
        debugPrint('LocalAudioProcessor: Failed to initialize required services');
      }
      
      return _isInitialized;
      
    } catch (e, stackTrace) {
      debugPrint('LocalAudioProcessor: Failed to initialize local audio processor: $e');
      debugPrint('LocalAudioProcessor: Stack trace: $stackTrace');
      _isInitialized = false;
      return false;
    }
  }
  
  /// Enable local audio processing
  void enable() {
    if (!_isInitialized) {
      debugPrint('LocalAudioProcessor: Cannot enable - not initialized');
      return;
    }
    
    _isEnabled = true;
    _computeProcessor.enable();
    debugPrint('LocalAudioProcessor: Local audio processing enabled');
    notifyListeners();
  }
  
  /// Disable local audio processing
  void disable() {
    _isEnabled = false;
    _isProcessing = false;
    _isSpeechActive = false;
    _speechStartTime = null;
    
    // Disable compute processor
    _computeProcessor.disable();
    
    // Cancel stream subscriptions
    _isolateResultSubscription?.cancel();
    _isolateSpeechStateSubscription?.cancel();
    
    // Clear buffers
    _audioBuffer.clear();
    _detectedSegments.clear();
    
    debugPrint('LocalAudioProcessor: Local audio processing disabled');
    notifyListeners();
  }
  
  /// Process PCM audio data from hardware
  /// 
  /// [pcmData] - Raw PCM audio data (16-bit, little-endian)
  /// [isFinal] - Whether this is the final chunk of audio
  void processAudioData(Uint8List pcmData, {bool isFinal = false}) {
    if (!_isEnabled || !_isInitialized) {
      debugPrint('LocalAudioProcessor: Skipping - enabled: $_isEnabled, initialized: $_isInitialized');
      return;
    }
    
    // Add audio data to buffer immediately (lightweight operation)
    _audioBuffer.addAll(pcmData);
    
    // Send audio data to compute processor for background processing
    _computeProcessor.processAudioData(pcmData, isFinal: isFinal);
    
    // Process final audio chunk if requested
    if (isFinal) {
      _processFinalAudioInBackground();
    }
  }

  /// Process final audio chunk in background
  Future<void> _processFinalAudioInBackground() async {
    // This is now handled by the compute processor
    // The compute processor will handle final audio processing automatically
    debugPrint('LocalAudioProcessor: Final audio processing delegated to compute processor');
  }
  
  /// Handle results from isolate processor
  void _onIsolateResult(ProcessedAudioResult result) {
    // Add to results history
    _addToResultsHistory(result);
    
    // Broadcast result
    _resultController.add(result);
    
    debugPrint('LocalAudioProcessor: Received result from isolate processor: "${result.transcription.text}"');
    notifyListeners();
  }
  
  /// Handle speech state changes from isolate processor
  void _onIsolateSpeechState(bool isSpeech) {
    _isSpeechActive = isSpeech;
    _speechStateController.add(isSpeech);
    
    if (isSpeech) {
      _speechStartTime = DateTime.now();
      debugPrint('LocalAudioProcessor: Speech activity started (from isolate)');
    } else {
      if (_speechStartTime != null) {
        final speechDuration = DateTime.now().difference(_speechStartTime!);
        debugPrint('LocalAudioProcessor: Speech activity ended (from isolate), duration: $speechDuration');
      }
      _speechStartTime = null;
    }
    
    notifyListeners();
  }
  
  /// Add result to history with size limit
  void _addToResultsHistory(ProcessedAudioResult result) {
    _processingResults.add(result);
    
    // Keep only the latest results
    if (_processingResults.length > _maxResultsHistory) {
      _processingResults.removeRange(0, _processingResults.length - _maxResultsHistory);
    }
  }
  
  /// Clear all processing results
  void clearResults() {
    _processingResults.clear();
    _detectedSegments.clear();
    debugPrint('LocalAudioProcessor: Processing results cleared');
    notifyListeners();
  }
  
  /// Get the latest processing result
  ProcessedAudioResult? get latestResult {
    return _processingResults.isNotEmpty ? _processingResults.last : null;
  }
  
  /// Get all results for a specific time range
  List<ProcessedAudioResult> getResultsInRange(DateTime start, DateTime end) {
    return _processingResults.where((result) {
      return result.processingTime.isAfter(start) && result.processingTime.isBefore(end);
    }).toList();
  }
  

  
  /// Set ASR language (defaults to English)
  Future<bool> setLanguage(String language) async {
    if (!_isInitialized) {
      debugPrint('LocalAudioProcessor: Cannot set language - not initialized');
      return false;
    }
    
    final success = await _asrService.setLanguage(language);
    if (success) {
      debugPrint('LocalAudioProcessor: Language set to $language');
      notifyListeners();
    }
    
    return success;
  }
  
  /// Get current language
  String get currentLanguage => _asrService.currentLanguage;
  
  /// Get supported languages
  List<String> get supportedLanguages => _asrService.supportedLanguages;
  
  /// Get current processor statistics
  Map<String, dynamic> getStats() {
    return {
      'isInitialized': _isInitialized,
      'isProcessing': _isProcessing,
      'isEnabled': _isEnabled,
      'isSpeechActive': _isSpeechActive,
      'audioBufferSize': _audioBuffer.length,
      'detectedSegmentsCount': _detectedSegments.length,
      'processingResultsCount': _processingResults.length,
      'currentLanguage': currentLanguage,
      'supportedLanguages': supportedLanguages,
      'vadStats': _vadService.getStats(),
      'asrStats': _asrService.getStats(),
      'computeProcessorStats': _computeProcessor.getStats(),
    };
  }
  
  @override
  void dispose() {
    // Disable and dispose compute processor
    _computeProcessor.disable();
    _computeProcessor.dispose();
    
    // Cancel stream subscriptions
    _isolateResultSubscription?.cancel();
    _isolateSpeechStateSubscription?.cancel();
    
    // Close stream controllers
    _resultController.close();
    _speechStateController.close();
    
    super.dispose();
  }
}

