import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart';
import 'package:path_provider/path_provider.dart';

/// Automatic Speech Recognition (ASR) service using sherpa_onnx
/// 
/// This service provides offline speech-to-text transcription
/// supporting English, Spanish, and Chinese languages
class SherpaAsrService extends ChangeNotifier {
  // ASR configuration
  static const int _sampleRate = 16000;  // Match OMI firmware sample rate
  static const int _channels = 1;         // Mono audio
  
  // Language support
  static const Map<String, String> _supportedLanguages = {
    'en': 'English',
    'es': 'Spanish',
    'zh': 'Chinese',
  };
  
  // ASR state
  bool _isInitialized = false;
  bool _isProcessing = false;
  String _currentLanguage = 'auto';
  
  // ASR instances for each language
  final Map<String, OfflineRecognizer> _recognizers = {};
  OfflineRecognizer? _currentRecognizer;
  
  // Transcription results
  final List<TranscriptionResult> _transcriptionHistory = [];
  final int _maxHistorySize = 100;
  
  // Stream controllers
  final StreamController<TranscriptionResult> _transcriptionController = 
      StreamController<TranscriptionResult>.broadcast();
  final StreamController<String> _partialResultController = 
      StreamController<String>.broadcast();
  
  // Getters
  bool get isInitialized => _isInitialized;
  bool get isProcessing => _isProcessing;
  String get currentLanguage => _currentLanguage;
  List<String> get supportedLanguages => _supportedLanguages.keys.toList();
  List<TranscriptionResult> get transcriptionHistory => List.unmodifiable(_transcriptionHistory);
  Stream<TranscriptionResult> get transcriptionStream => _transcriptionController.stream;
  Stream<String> get partialResultStream => _partialResultController.stream;
  
  /// Initialize the ASR service
  Future<bool> initialize() async {
    if (_isInitialized) {
      debugPrint('SherpaAsrService: Already initialized');
      return true;
    }

    try {
      debugPrint('SherpaAsrService: Initializing ASR service...');
      debugPrint('  - Sample Rate: $_sampleRate Hz');
      debugPrint('  - Channels: $_channels');
      debugPrint('  - Supported Languages: ${_supportedLanguages.keys.join(', ')}');
      
      // Initialize single multilingual Whisper model
      debugPrint('SherpaAsrService: Initializing multilingual Whisper model...');
      
      final success = await _initializeRecognizer('multilingual'); // Use generic key for multilingual model
      if (!success) {
        debugPrint('SherpaAsrService: Failed to initialize Whisper model');
        return false;
      }
      
      // Set the recognizer
      _currentRecognizer = _recognizers['multilingual'];
      _currentLanguage = 'auto'; // Mark as auto-detection mode
      _isInitialized = true;
      
      debugPrint('SherpaAsrService: Multilingual Whisper model initialized successfully');
      notifyListeners();
      return true;
      
    } catch (e) {
      debugPrint('SherpaAsrService: Failed to initialize ASR service: $e');
      debugPrint('SherpaAsrService: Error details: ${e.toString()}');
      _isInitialized = false;
      notifyListeners();
      return false;
    }
  }
  
  /// Initialize recognizer for a specific language
  Future<bool> _initializeRecognizer(String language) async {
    try {
      debugPrint('SherpaAsrService: Initializing multilingual Whisper recognizer...');
      
      // Copy the model files from assets to a temporary directory
      final modelPaths = await _copyModelFiles();
      if (modelPaths == null) {
        debugPrint('SherpaAsrService: Failed to copy model files');
        return false;
      }
      
      debugPrint('SherpaAsrService: Using model files: ${modelPaths.values.join(', ')}');
      
      // Whisper model configuration
      final config = OfflineRecognizerConfig(
        feat: FeatureConfig(
          sampleRate: _sampleRate,
          featureDim: 80,
        ),
        model: OfflineModelConfig(
          whisper: OfflineWhisperModelConfig(
            encoder: modelPaths['encoder']!,
            decoder: modelPaths['decoder']!,
            task: 'transcribe',
          ),
          tokens: modelPaths['tokens']!,
          numThreads: 1,
          debug: false, // Disable debug to reduce memory usage
          provider: 'cpu',
        ),
        decodingMethod: 'greedy_search',
        maxActivePaths: 4,
      );
      
      // Create recognizer
      try {
        debugPrint('SherpaAsrService: Creating multilingual Whisper recognizer...');
        final recognizer = OfflineRecognizer(config);
        debugPrint('SherpaAsrService: Recognizer created successfully');
        
        // Test the recognizer with a small audio sample
        final testResult = await _testRecognizer(recognizer);
        if (!testResult) {
          debugPrint('SherpaAsrService: Recognizer test failed');
          recognizer.free();
          return false;
        }
        
        _recognizers[language] = recognizer;
        debugPrint('SherpaAsrService: Multilingual Whisper recognizer initialized successfully');
        
        return true;
        
      } catch (e, stackTrace) {
        debugPrint('SherpaAsrService: Failed to create recognizer: $e');
        debugPrint('SherpaAsrService: Stack trace: $stackTrace');
        return false;
      }
      
    } catch (e) {
      debugPrint('SherpaAsrService: Error initializing recognizer: $e');
      return false;
    }
  }
  
  /// Test a recognizer with a minimal audio sample
  Future<bool> _testRecognizer(OfflineRecognizer recognizer) async {
    try {
      // Create a minimal test audio sample (silence)
      final testAudio = Float32List(_sampleRate); // 1 second of silence
      
      // Create a stream and test it
      final stream = recognizer.createStream();
      stream.acceptWaveform(samples: testAudio, sampleRate: _sampleRate);
      recognizer.decode(stream);
      
      // This should not throw an error
      return true;
    } catch (e) {
      debugPrint('SherpaAsrService: Recognizer test failed: $e');
      return false;
    }
  }
  
  /// Set the current language for transcription
  Future<bool> setLanguage(String language) async {
    // No longer needed with Whisper's automatic language detection
    debugPrint('SherpaAsrService: Language setting not needed - Whisper detects language automatically');
    return true;
  }
  
  /// Transcribe PCM audio data
  /// 
  /// [pcmData] - Raw PCM audio data (16-bit, little-endian)
  /// [isFinal] - Whether this is the final chunk of audio
  /// Returns transcription result
  Future<TranscriptionResult?> transcribeAudio(
    Uint8List pcmData, {
    bool isFinal = false,
  }) async {
    if (!_isInitialized || _currentRecognizer == null) {
      debugPrint('SherpaAsrService: Cannot transcribe - ASR not initialized');
      return null;
    }
    
    if (pcmData.isEmpty) {
      debugPrint('SherpaAsrService: Cannot transcribe empty audio data');
      return null;
    }
    
    try {
      _isProcessing = true;
      notifyListeners();
      
      // Convert PCM to Float32List
      final floatAudio = _convertPcmToFloat32(pcmData);
      
      // Create a stream for processing
      final stream = _currentRecognizer!.createStream();
      
      // Feed audio data to the stream
      stream.acceptWaveform(samples: floatAudio, sampleRate: _sampleRate);
      
      if (isFinal) {
        // Get final result
        _currentRecognizer!.decode(stream);
        
        final result = _currentRecognizer!.getResult(stream);
        
        if (result.text.isNotEmpty) {
          final transcription = TranscriptionResult(
            text: result.text,
            language: _currentLanguage,
            languageName: _supportedLanguages[_currentLanguage] ?? 'Unknown',
            timestamp: DateTime.now(),
            confidence: 0.9, // Whisper doesn't provide confidence scores
            isFinal: true,
          );
          
          // Add to history
          _addToHistory(transcription);
          
          // Broadcast result
          _transcriptionController.add(transcription);
          
          debugPrint('SherpaAsrService: Final transcription completed: "${result.text}"');
          return transcription;
        } else {
          debugPrint('SherpaAsrService: Final result has empty text');
        }
      } else {
        // For non-final chunks, we could implement partial results
        // but this requires a different approach with online recognition
        // For now, just process the audio without getting results
      }
      
      return null;
      
    } catch (e) {
      debugPrint('SherpaAsrService: Error transcribing audio: $e');
      return null;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
  
  /// Transcribe a complete audio buffer
  /// 
  /// [pcmData] - Complete PCM audio buffer
  /// Returns transcription result
  Future<TranscriptionResult?> transcribeAudioBuffer(Uint8List pcmData) async {
    if (!_isInitialized || _currentRecognizer == null) {
      debugPrint('SherpaAsrService: Cannot transcribe - ASR not initialized');
      return null;
    }
    
    if (pcmData.isEmpty) {
      debugPrint('SherpaAsrService: Cannot transcribe empty audio buffer');
      return null;
    }
    
    try {
      // Check if audio has meaningful content
      final hasContent = _checkAudioContent(pcmData);
      if (!hasContent) {
        debugPrint('SherpaAsrService: Audio buffer contains only silence, skipping transcription');
        return null;
      }
      
      // Use single multilingual Whisper model for automatic language detection
      debugPrint('SherpaAsrService: Starting transcription with multilingual Whisper...');
      
      final result = await transcribeAudio(pcmData, isFinal: true);
      
      if (result != null && result.text.isNotEmpty) {
        // Whisper automatically detects the language, so we just use 'auto'
        _currentLanguage = 'auto';
        
        debugPrint('SherpaAsrService: Transcription successful: "${result.text}" (language: auto-detected)');
        return TranscriptionResult(
          text: result.text,
          language: 'auto',
          languageName: 'Auto-Detected',
          timestamp: DateTime.now(),
          confidence: 0.9,
          isFinal: true,
        );
      } else {
        debugPrint('SherpaAsrService: No transcription result returned or empty text');
      }
      
      return null;
      
    } catch (e) {
      debugPrint('SherpaAsrService: Error transcribing audio buffer: $e');
      return null;
    }
  }
  
  /// Check if audio data contains meaningful content (not just silence)
  bool _checkAudioContent(Uint8List pcmData) {
    if (pcmData.isEmpty) return false;
    
    // Convert to 16-bit samples and check for non-zero values
    final samples = pcmData.length ~/ 2;
    int nonZeroSamples = 0;
    
    for (int i = 0; i < samples; i++) {
      int sample = (pcmData[i * 2] | (pcmData[i * 2 + 1] << 8));
      if (sample > 32767) {
        sample = sample - 65536; // Handle signed 16-bit
      }
      if (sample.abs() > 100) { // Threshold for meaningful audio
        nonZeroSamples++;
      }
    }
    
    final audioRatio = nonZeroSamples / samples;
    return audioRatio > 0.01; // At least 1% non-silence
  }


  
  /// Convert PCM data to Float32List for ASR processing
  Float32List _convertPcmToFloat32(List<int> pcmData) {
    final floatData = Float32List(pcmData.length ~/ 2);
    
    for (int i = 0; i < floatData.length; i++) {
      final sample = (pcmData[i * 2] | (pcmData[i * 2 + 1] << 8));
      // Convert 16-bit signed integer to float32 (-1.0 to 1.0)
      floatData[i] = sample / 32768.0;
    }
    
    return floatData;
  }
  
  /// Add transcription result to history
  void _addToHistory(TranscriptionResult result) {
    _transcriptionHistory.add(result);
    
    // Maintain history size limit
    if (_transcriptionHistory.length > _maxHistorySize) {
      _transcriptionHistory.removeAt(0);
    }
  }
  
  /// Get transcription for a specific language
  List<TranscriptionResult> getTranscriptionsForLanguage(String language) {
    return _transcriptionHistory
        .where((result) => result.language == language)
        .toList();
  }
  
  /// Get current ASR statistics
  Map<String, dynamic> getStats() {
    return {
      'isInitialized': _isInitialized,
      'isProcessing': _isProcessing,
      'currentLanguage': _currentLanguage,
      'supportedLanguages': _supportedLanguages.keys.toList(),
      'transcriptionHistorySize': _transcriptionHistory.length,
      'recognizersInitialized': _recognizers.length,
      'sampleRate': _sampleRate,
      'channels': _channels,
    };
  }
  
  /// Get memory usage statistics
  Map<String, dynamic> getMemoryStats() {
    return {
      'recognizersLoaded': _recognizers.length,
      'currentLanguage': _currentLanguage,
      'isMultilingual': true,
    };
  }
  
  /// Unload Chinese recognizer to free memory when not needed
  void unloadChineseRecognizer() {
    // No longer needed with single multilingual model
    debugPrint('SherpaAsrService: Memory management not needed with single multilingual model');
  }
  
  /// Schedule automatic memory cleanup
  // void _scheduleMemoryCleanup() { // Removed as per edit hint
  //   _memoryCleanupTimer?.cancel();
  //   _memoryCleanupTimer = Timer(_memoryCleanupDelay, () {
  //     if (_recognizers.containsKey('zh') && _currentLanguage != 'zh') {
  //       debugPrint('SherpaAsrService: Auto-unloading Chinese recognizer due to inactivity');
  //       unloadChineseRecognizer();
  //     }
  //   });
  // }
  
  /// Cancel memory cleanup timer
  // void _cancelMemoryCleanup() { // Removed as per edit hint
  //   _memoryCleanupTimer?.cancel();
  // }
  
  /// Dispose of resources
  @override
  void dispose() {
    // Cancel memory cleanup timer
    // _memoryCleanupTimer?.cancel(); // Removed as per edit hint
    
    // Free all recognizers
    final recognizersToFree = Map<String, OfflineRecognizer>.from(_recognizers);
    _recognizers.clear();
    
    for (final recognizer in recognizersToFree.values) {
      if (recognizer != null) {
        recognizer.free();
      }
    }
    
    _transcriptionController.close();
    _partialResultController.close();
    super.dispose();
  }

  /// Copy the ASR model files from assets to a temporary directory
  Future<Map<String, String>?> _copyModelFiles() async {
    try {
      // Get the temporary directory
      final tempDir = await getTemporaryDirectory();
      final modelDir = Directory('${tempDir.path}/sherpa_onnx_models');
      
      // Create the directory if it doesn't exist
      if (!await modelDir.exists()) {
        await modelDir.create(recursive: true);
      }
      
      final encoderPath = '${modelDir.path}/small-encoder.onnx';
      final decoderPath = '${modelDir.path}/small-decoder.onnx';
      final tokensPath = '${modelDir.path}/small-tokens.txt';
      
      // Check if the model files already exist
      if (await File(encoderPath).exists() && 
          await File(decoderPath).exists() && 
          await File(tokensPath).exists()) {
        debugPrint('SherpaAsrService: Model files already exist');
        return {
          'encoder': encoderPath,
          'decoder': decoderPath,
          'tokens': tokensPath,
        };
      }
      
      // Copy the model files from assets
      debugPrint('SherpaAsrService: Copying model files from assets...');
      
      // Copy encoder
      final encoderData = await rootBundle.load('assets/onnx/whisper_small/small-encoder.onnx');
      final encoderFile = File(encoderPath);
      await encoderFile.writeAsBytes(encoderData.buffer.asUint8List());
      
      // Copy decoder
      final decoderData = await rootBundle.load('assets/onnx/whisper_small/small-decoder.onnx');
      final decoderFile = File(decoderPath);
      await decoderFile.writeAsBytes(decoderData.buffer.asUint8List());
      
      // Copy tokens
      final tokensData = await rootBundle.load('assets/onnx/whisper_small/small-tokens.txt');
      final tokensFile = File(tokensPath);
      await tokensFile.writeAsBytes(tokensData.buffer.asUint8List());
      
      debugPrint('SherpaAsrService: Model files copied successfully');
      return {
        'encoder': encoderPath,
        'decoder': decoderPath,
        'tokens': tokensPath,
      };
      
    } catch (e) {
      debugPrint('SherpaAsrService: Failed to copy model files: $e');
      return null;
    }
  }


}

/// Represents a transcription result from ASR
class TranscriptionResult {
  final String text;
  final String language;
  final String languageName;
  final DateTime timestamp;
  final double confidence;
  final bool isFinal;
  
  const TranscriptionResult({
    required this.text,
    required this.language,
    required this.languageName,
    required this.timestamp,
    required this.confidence,
    required this.isFinal,
  });
  
  @override
  String toString() {
    return 'TranscriptionResult(text: "$text", language: $language, timestamp: $timestamp, confidence: $confidence, isFinal: $isFinal)';
  }
}
