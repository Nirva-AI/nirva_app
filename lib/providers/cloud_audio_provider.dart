import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/cloud_audio_processor.dart';
import '../services/sherpa_vad_service.dart';
import '../services/deepgram_service.dart';
import '../services/opus_decoder_service.dart';
import '../my_hive_objects.dart';

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
  String? _userId;
  
  CloudAudioProvider({OpusDecoderService? opusDecoderService, String? userId}) {
    _userId = userId;
    debugPrint('CloudAudioProvider: Creating provider with userId: $_userId');
    
    // Initialize services
    _vadService = SherpaVadService();
    _deepgramService = DeepgramService();
    
    // Use provided OpusDecoderService or create a new one if none provided
    final opusService = opusDecoderService ?? OpusDecoderService();
    
    // Create cloud processor with storage service
    _cloudProcessor = CloudAudioProcessor(
      _vadService, 
      _deepgramService, 
      opusService,
      userId: _userId,
    );
    
    debugPrint('CloudAudioProvider: CloudAudioProcessor created with userId: $_userId');
    
    // Listen to processor changes
    _cloudProcessor.addListener(_onProcessorChanged);
    
    // Initialize storage service immediately to make stored data available
    _initializeStorageService();
  }
  
  /// Initialize storage service immediately to access stored data
  Future<void> _initializeStorageService() async {
    try {
      debugPrint('CloudAudioProvider: Initializing storage service immediately...');
      await _cloudProcessor.initializeStorageService();
      debugPrint('CloudAudioProvider: Storage service initialized successfully');
      
      // Check what data is available
      try {
        final persistentResults = _cloudProcessor.getPersistentResults();
        final allSessions = _cloudProcessor.getAllSessions();
        final storageStats = _cloudProcessor.getStorageStats();
        
        debugPrint('CloudAudioProvider: Available data after storage init - Results: ${persistentResults.length}, Sessions: ${allSessions.length}');
        debugPrint('CloudAudioProvider: Storage stats: $storageStats');
        
        if (persistentResults.isNotEmpty) {
          debugPrint('CloudAudioProvider: First result transcription: "${persistentResults.first.transcription}"');
          debugPrint('CloudAudioProvider: First result audio path: ${persistentResults.first.audioFilePath}');
        }
      } catch (e) {
        debugPrint('CloudAudioProvider: Error checking storage data: $e');
      }
      
      // Notify listeners that data is available
      notifyListeners();
      
    } catch (e) {
      debugPrint('CloudAudioProvider: Error initializing storage service: $e');
    }
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
  
  // Persistent storage getters
  List<CloudAsrResultStorage> get persistentResults {
    try {
      if (!_cloudProcessor.isStorageServiceInitialized) {
        debugPrint('CloudAudioProvider: Storage service not initialized yet, returning empty results');
        return [];
      }
      return _cloudProcessor.getPersistentResults();
    } catch (e) {
      debugPrint('CloudAudioProvider: Error getting persistent results: $e');
      return [];
    }
  }
  
  List<CloudAsrSessionStorage> get allSessions {
    try {
      if (!_cloudProcessor.isStorageServiceInitialized) {
        debugPrint('CloudAudioProvider: Storage service not initialized yet, returning empty sessions');
        return [];
      }
      return _cloudProcessor.getAllSessions();
    } catch (e) {
      debugPrint('CloudAudioProvider: Error getting all sessions: $e');
      return [];
    }
  }
  
  Map<String, dynamic> get storageStats {
    try {
      if (!_cloudProcessor.isStorageServiceInitialized) {
        debugPrint('CloudAudioProvider: Storage service not initialized yet, returning empty stats');
        return {};
      }
      return _cloudProcessor.getStorageStats();
    } catch (e) {
      debugPrint('CloudAudioProvider: Error getting storage stats: $e');
      return {};
    }
  }
  
  /// Initialize the cloud audio provider
  Future<bool> initialize() async {
    if (_isInitialized) {
      debugPrint('CloudAudioProvider: Already initialized');
      return true;
    }
    
    try {
      debugPrint('CloudAudioProvider: Initializing cloud audio provider...');
      debugPrint('CloudAudioProvider: User ID: $_userId');
      
      // Initialize the cloud processor
      final initialized = await _cloudProcessor.initialize();
      
      if (initialized) {
        _isInitialized = true;
        debugPrint('CloudAudioProvider: Cloud audio provider initialized successfully');
        
        // Check storage status after initialization
        try {
          final persistentResults = _cloudProcessor.getPersistentResults();
          final allSessions = _cloudProcessor.getAllSessions();
          final storageStats = _cloudProcessor.getStorageStats();
          
          debugPrint('CloudAudioProvider: Storage status after initialization:');
          debugPrint('CloudAudioProvider: - Persistent results: ${persistentResults.length}');
          debugPrint('CloudAudioProvider: - All sessions: ${allSessions.length}');
          debugPrint('CloudAudioProvider: - Storage stats: $storageStats');
        } catch (e) {
          debugPrint('CloudAudioProvider: Error checking storage status: $e');
        }
        
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
