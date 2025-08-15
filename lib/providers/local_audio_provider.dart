import 'package:flutter/foundation.dart';
import '../services/sherpa_vad_service.dart';
import '../services/sherpa_asr_service.dart';
import '../services/local_audio_processor.dart';
import '../models/processed_audio_result.dart';

/// Provider for local audio processing services (VAD and ASR)
/// 
/// This provider manages the lifecycle of local audio processing services
/// and provides them to the rest of the application
class LocalAudioProvider extends ChangeNotifier {
  // Services
  late SherpaVadService _vadService;
  late SherpaAsrService _asrService;
  late LocalAudioProcessor _localAudioProcessor;
  
  // State
  bool _isInitialized = false;
  bool _isInitializing = false;
  String? _initializationError;
  
  // Getters
  bool get isInitialized => _isInitialized;
  bool get isInitializing => _isInitializing;
  String? get initializationError => _initializationError;
  
  // Service getters
  SherpaVadService get vadService => _vadService;
  SherpaAsrService get asrService => _asrService;
  LocalAudioProcessor get localAudioProcessor => _localAudioProcessor;
  
  LocalAudioProvider() {
    _initializeServices();
  }
  
  /// Initialize all local audio processing services
  Future<void> _initializeServices() async {
    if (_isInitialized || _isInitializing) {
      return;
    }
    
    try {
      _isInitializing = true;
      _initializationError = null;
      notifyListeners();
      
      debugPrint('LocalAudioProvider: Initializing local audio services...');
      
      // Create VAD service
      _vadService = SherpaVadService();
      
      // Create ASR service
      _asrService = SherpaAsrService();
      
      // Create integrated local audio processor
      _localAudioProcessor = LocalAudioProcessor(_vadService, _asrService);
      
      // Initialize the integrated processor (this will initialize VAD and ASR)
      final success = await _localAudioProcessor.initialize();
      
      if (success) {
        _isInitialized = true;
        debugPrint('LocalAudioProvider: Local audio services initialized successfully');
      } else {
        throw Exception('Failed to initialize local audio processor');
      }
      
    } catch (e) {
      _initializationError = e.toString();
      debugPrint('LocalAudioProvider: Failed to initialize local audio services: $e');
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }
  
  /// Reinitialize services (useful for error recovery)
  Future<void> reinitialize() async {
    _isInitialized = false;
    _initializationError = null;
    notifyListeners();
    
    await _initializeServices();
  }
  
  /// Set the language for ASR transcription (defaults to English)
  Future<bool> setLanguage(String language) async {
    if (!_isInitialized) {
      debugPrint('LocalAudioProvider: Cannot set language - services not initialized');
      return false;
    }
    
    final success = await _localAudioProcessor.setLanguage(language);
    if (success) {
      notifyListeners();
    }
    
    return success;
  }
  
  /// Get current language
  String get currentLanguage => _localAudioProcessor.currentLanguage;
  
  /// Get supported languages
  List<String> get supportedLanguages => _localAudioProcessor.supportedLanguages;
  
  /// Get all processing results (transcriptions)
  List<ProcessedAudioResult> get processingResults => _localAudioProcessor.processingResults;
  
  /// Get latest transcription result
  ProcessedAudioResult? get latestTranscription {
    final results = _localAudioProcessor.processingResults;
    return results.isNotEmpty ? results.last : null;
  }
  
  /// Stream of new transcription results
  Stream<ProcessedAudioResult> get transcriptionStream => _localAudioProcessor.resultStream;
  
  /// Stream of VAD speech detection events
  Stream<bool> get speechDetectionStream => _localAudioProcessor.speechDetectionStream;
  
  /// Enable local audio processing (called automatically when hardware connects)
  void enableProcessing() {
    if (!_isInitialized) {
      debugPrint('LocalAudioProvider: Cannot enable - services not initialized');
      return;
    }
    
    _localAudioProcessor.enable();
    debugPrint('LocalAudioProvider: Local audio processing enabled automatically');
    notifyListeners();
  }
  
  /// Get processing statistics
  Map<String, dynamic> getStats() {
    if (!_isInitialized) {
      return {
        'isInitialized': false,
        'error': 'Services not initialized',
      };
    }
    
    return {
      'isInitialized': _isInitialized,
      'isInitializing': _isInitializing,
      'initializationError': _initializationError,
      'localAudioProcessorStats': _localAudioProcessor.getStats(),
      'vadStats': _vadService.getStats(),
      'asrStats': _asrService.getStats(),
    };
  }
  
  @override
  void dispose() {
    _localAudioProcessor.dispose();
    super.dispose();
  }
}
