import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'sherpa_vad_service.dart';
import 'sherpa_asr_service.dart';
import '../models/processed_audio_result.dart';

/// Integrated local audio processing service combining VAD and ASR
/// 
/// This service processes audio streams from hardware devices to:
/// 1. Detect speech segments using VAD
/// 2. Transcribe speech using local ASR
/// 3. Integrate with existing hardware audio pipeline
class LocalAudioProcessor extends ChangeNotifier {
  final SherpaVadService _vadService;
  final SherpaAsrService _asrService;
  
  // Processing state
  bool _isInitialized = false;
  bool _isProcessing = false;
  bool _isEnabled = false;
  
  // Audio processing
  final List<int> _audioBuffer = [];
  final int _bufferThreshold = 16000 * 2; // 2 seconds of audio at 16kHz
  
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
    try {
      debugPrint('LocalAudioProcessor: Initializing local audio processor...');
      
      // Initialize VAD service
      final vadInitialized = await _vadService.initialize();
      if (!vadInitialized) {
        debugPrint('LocalAudioProcessor: Failed to initialize VAD service');
        // Don't fail completely, just log the error
        // _isInitialized = false;
        // return false;
      }
      
      // Initialize ASR service
      final asrInitialized = await _asrService.initialize();
      if (!asrInitialized) {
        debugPrint('LocalAudioProcessor: Failed to initialize ASR service');
        // Don't fail completely, just log the error
        // _isInitialized = false;
        // return false;
      }
      
      // Consider initialized if at least one service works
      _isInitialized = vadInitialized || asrInitialized;
      
      if (_isInitialized) {
        debugPrint('LocalAudioProcessor: Local audio processor initialized successfully');
        
        // Set up stream listeners if services are available
        if (vadInitialized) {
          try {
            _vadService.speechDetectionStream.listen(
              _onVadSpeechDetection,
              onError: (error) => debugPrint('LocalAudioProcessor: VAD stream error: $error'),
            );
          } catch (e) {
            debugPrint('LocalAudioProcessor: Failed to set up VAD stream listener: $e');
          }
        }
        
        if (asrInitialized) {
          try {
            _asrService.transcriptionStream.listen(
              _onAsrTranscription,
              onError: (error) => debugPrint('LocalAudioProcessor: ASR stream error: $error'),
            );
          } catch (e) {
            debugPrint('LocalAudioProcessor: Failed to set up ASR stream listener: $e');
          }
        }
        
        notifyListeners();
      } else {
        debugPrint('LocalAudioProcessor: No audio services could be initialized');
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
    debugPrint('LocalAudioProcessor: Local audio processing enabled automatically');
    notifyListeners();
  }
  
  /// Disable local audio processing
  void disable() {
    _isEnabled = false;
    _isProcessing = false;
    _isSpeechActive = false;
    _speechStartTime = null;
    
    // Clear buffers
    _audioBuffer.clear();
    _detectedSegments.clear();
    
    debugPrint('LocalAudioProcessor: Local audio processing disabled automatically');
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
      
      // Add audio data to buffer
      _audioBuffer.addAll(pcmData);
      
      // Process audio with VAD for speech detection
      final speechDetected = _vadService.processAudioFrame(pcmData);
      
      if (speechDetected && !_isSpeechActive) {
        // Speech started
        _isSpeechActive = true;
        _speechStartTime = DateTime.now();
        _speechStateController.add(true);
        debugPrint('LocalAudioProcessor: Speech activity started');
      } else if (!speechDetected && _isSpeechActive) {
        // Speech ended
        _isSpeechActive = false;
        if (_speechStartTime != null) {
          final speechDuration = DateTime.now().difference(_speechStartTime!);
          
          // Create speech segment
          final segment = VadSpeechSegment(
            startTime: Duration(milliseconds: _speechStartTime!.millisecondsSinceEpoch),
            endTime: Duration(milliseconds: DateTime.now().millisecondsSinceEpoch),
          );
          
          _detectedSegments.add(segment);
          
          // Process speech segment with ASR if we have enough audio data
          if (_audioBuffer.length >= _bufferThreshold) {
            _processSpeechSegment(segment);
          }
          
          debugPrint('LocalAudioProcessor: Speech activity ended, duration: $speechDuration');
        }
        
        _speechStateController.add(false);
        _speechStartTime = null;
      }
      
      // Process final audio chunk if requested
      if (isFinal && _audioBuffer.isNotEmpty) {
        _processFinalAudio();
      }
      
    } catch (e) {
      debugPrint('LocalAudioProcessor: Error processing audio data: $e');
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
  
  /// Process a detected speech segment with ASR
  Future<void> _processSpeechSegment(VadSpeechSegment segment) async {
    try {
      debugPrint('LocalAudioProcessor: Processing speech segment: $segment');
      
      // Extract audio data for this segment
      final segmentAudio = _extractSegmentAudio(segment);
      if (segmentAudio.isEmpty) {
        debugPrint('LocalAudioProcessor: No audio data for segment');
        return;
      }
      
      // Transcribe the speech segment
      final transcription = await _asrService.transcribeAudioBuffer(segmentAudio);
      if (transcription != null) {
        // Create processed result
        final result = ProcessedAudioResult(
          speechSegment: segment,
          transcription: transcription,
          processingTime: DateTime.now(),
          audioDataSize: segmentAudio.length,
        );
        
        // Add to results history
        _addToResultsHistory(result);
        
        // Broadcast result
        _resultController.add(result);
        
        debugPrint('LocalAudioProcessor: Speech segment processed: ${transcription.text}');
      }
      
    } catch (e) {
      debugPrint('LocalAudioProcessor: Error processing speech segment: $e');
    }
  }
  
  /// Process final audio chunk
  Future<void> _processFinalAudio() async {
    try {
      debugPrint('LocalAudioProcessor: Processing final audio chunk');
      
      if (_audioBuffer.isEmpty) return;
      
      // Process entire audio buffer with ASR
      final transcription = await _asrService.transcribeAudioBuffer(
        Uint8List.fromList(_audioBuffer),
      );
      
      if (transcription != null) {
        // Create final result
        final result = ProcessedAudioResult(
          speechSegment: null, // No specific segment for final processing
          transcription: transcription,
          processingTime: DateTime.now(),
          audioDataSize: _audioBuffer.length,
          isFinalResult: true,
        );
        
        // Add to results history
        _addToResultsHistory(result);
        
        // Broadcast result
        _resultController.add(result);
        
        debugPrint('LocalAudioProcessor: Final audio processed: ${transcription.text}');
      }
      
      // Clear buffer after final processing
      _audioBuffer.clear();
      
    } catch (e) {
      debugPrint('LocalAudioProcessor: Error processing final audio: $e');
    }
  }
  
  /// Extract audio data for a specific speech segment
  Uint8List _extractSegmentAudio(VadSpeechSegment segment) {
    // This is a simplified implementation
    // In a real scenario, you'd want to map timestamps to audio buffer positions
    // For now, return the current buffer content
    return Uint8List.fromList(_audioBuffer);
  }
  
  /// Handle VAD speech detection events
  void _onVadSpeechDetection(bool isSpeech) {
    // This is handled in processAudioData for real-time processing
    debugPrint('LocalAudioProcessor: VAD speech detection: $isSpeech');
  }
  
  /// Handle ASR transcription results
  void _onAsrTranscription(TranscriptionResult transcription) {
    debugPrint('LocalAudioProcessor: ASR transcription: ${transcription.text}');
  }
  
  /// Add result to history
  void _addToResultsHistory(ProcessedAudioResult result) {
    _processingResults.add(result);
    
    // Maintain history size limit
    if (_processingResults.length > _maxResultsHistory) {
      _processingResults.removeAt(0);
    }
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
    };
  }
  
  /// Dispose of resources
  @override
  void dispose() {
    _resultController.close();
    _speechStateController.close();
    super.dispose();
  }
}

/// Represents a processed audio result combining VAD and ASR

