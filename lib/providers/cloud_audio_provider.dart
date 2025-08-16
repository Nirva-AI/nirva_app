import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/cloud_audio_processor.dart';
import '../services/sherpa_vad_service.dart';
import '../services/deepgram_service.dart';
import '../services/opus_decoder_service.dart';

/// Provider for cloud audio processing functionality
/// 
/// This provider manages the cloud audio processor and provides
/// access to cloud transcription results
class CloudAudioProvider extends ChangeNotifier {
  // Core services
  late final SherpaVadService _vadService;
  late final DeepgramService _deepgramService;
  late final CloudAudioProcessor _cloudProcessor;
  
  // State
  bool _isInitialized = false;
  bool _isProcessingEnabled = false;
  
  CloudAudioProvider({OpusDecoderService? opusDecoderService}) {
    // Initialize services
    _vadService = SherpaVadService();
    _deepgramService = DeepgramService();
    
    // Use provided OpusDecoderService or create a new one if none provided
    final opusService = opusDecoderService ?? OpusDecoderService();
    
    _cloudProcessor = CloudAudioProcessor(_vadService, _deepgramService, opusService);
    
    // Listen to processor changes
    _cloudProcessor.addListener(_onProcessorChanged);
  }
  
  // Getters
  bool get isInitialized => _isInitialized;
  bool get isProcessingEnabled => _isProcessingEnabled;
  CloudAudioProcessor get cloudProcessor => _cloudProcessor;
  SherpaVadService get vadService => _vadService;
  DeepgramService get deepgramService => _deepgramService;
  
  // Audio player getters
  AudioPlayer get audioPlayer => _cloudProcessor.audioPlayer;
  Stream<PlayerState> get audioPlayerStateStream => _cloudProcessor.audioPlayerStateStream;
  
  /// Initialize the cloud audio provider
  Future<bool> initialize() async {
    if (_isInitialized) {
      debugPrint('CloudAudioProvider: Already initialized');
      return true;
    }
    
    try {
      debugPrint('CloudAudioProvider: Initializing cloud audio provider...');
      
      // Initialize the cloud processor
      final initialized = await _cloudProcessor.initialize();
      
      if (initialized) {
        _isInitialized = true;
        debugPrint('CloudAudioProvider: Cloud audio provider initialized successfully');
        notifyListeners();
      } else {
        debugPrint('CloudAudioProvider: Failed to initialize cloud processor');
      }
      
      return initialized;
      
    } catch (e) {
      debugPrint('CloudAudioProvider: Error during initialization: $e');
      _isInitialized = false;
      notifyListeners();
      return false;
    }
  }
  
  /// Enable cloud audio processing
  void enableProcessing() {
    if (!_isInitialized) {
      debugPrint('CloudAudioProvider: Cannot enable - not initialized');
      return;
    }
    
    _cloudProcessor.enable();
    _isProcessingEnabled = true;
    debugPrint('CloudAudioProvider: Cloud audio processing enabled');
    notifyListeners();
  }
  
  /// Disable cloud audio processing
  void disableProcessing() {
    _cloudProcessor.disable();
    _isProcessingEnabled = false;
    debugPrint('CloudAudioProvider: Cloud audio processing disabled');
    notifyListeners();
  }
  
  /// Process audio data from hardware
  void processAudioData(List<int> pcmData, {bool isFinal = false}) {
    if (!_isProcessingEnabled || !_isInitialized) {
      return;
    }
    
    try {
      _cloudProcessor.processAudioData(
        Uint8List.fromList(pcmData),
        isFinal: isFinal,
      );
    } catch (e) {
      debugPrint('CloudAudioProvider: Error processing audio data: $e');
    }
  }
  
  /// Play audio file for transcription result
  Future<void> playAudioFile(String filePath) async {
    if (!_isInitialized) {
      debugPrint('CloudAudioProvider: Cannot play audio - not initialized');
      return;
    }
    
    await _cloudProcessor.playAudioFile(filePath);
  }
  
  /// Stop audio playback
  Future<void> stopAudioPlayback() async {
    if (!_isInitialized) {
      return;
    }
    
    await _cloudProcessor.stopAudioPlayback();
  }
  
  /// Clear all processing results
  void clearResults() {
    _cloudProcessor.clearResults();
    debugPrint('CloudAudioProvider: Processing results cleared');
    notifyListeners();
  }
  
  /// Get current provider statistics
  Map<String, dynamic> getStats() {
    return {
      'isInitialized': _isInitialized,
      'isProcessingEnabled': _isProcessingEnabled,
      'cloudProcessorStats': _cloudProcessor.getStats(),
    };
  }
  
  /// Handle processor state changes
  void _onProcessorChanged() {
    // Update local state based on processor changes
    _isProcessingEnabled = _cloudProcessor.isEnabled;
    notifyListeners();
  }
  
  @override
  void dispose() {
    _cloudProcessor.removeListener(_onProcessorChanged);
    _cloudProcessor.dispose();
    super.dispose();
  }
}
