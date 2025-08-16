import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart';
import 'package:path_provider/path_provider.dart';
import '../models/processed_audio_result.dart';
import 'sherpa_vad_service.dart';
import 'sherpa_asr_service.dart';

/// Compute-based audio processor that runs VAD in background and ASR on main thread
/// 
/// This service prevents UI blocking by using Flutter's compute function
/// for VAD processing while using the existing ASR service for reliable transcription
class ComputeAudioProcessor extends ChangeNotifier {
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
  
  // Processing queue
  final Queue<Uint8List> _processingQueue = Queue<Uint8List>();
  bool _isProcessingQueue = false;
  
  // Model paths for VAD compute functions
  String? _vadModelPath;
  
  // ASR service reference (passed from LocalAudioProcessor)
  SherpaAsrService? _asrService;
  
  // Getters
  bool get isInitialized => _isInitialized;
  bool get isProcessing => _isProcessing;
  bool get isEnabled => _isEnabled;
  bool get isSpeechActive => _isSpeechActive;
  List<ProcessedAudioResult> get processingResults => List.unmodifiable(_processingResults);
  Stream<ProcessedAudioResult> get resultStream => _resultController.stream;
  Stream<bool> get speechStateStream => _speechStateController.stream;
  
  /// Set the ASR service reference (called by LocalAudioProcessor)
  void setAsrService(SherpaAsrService asrService) {
    _asrService = asrService;
    debugPrint('ComputeAudioProcessor: ASR service reference set');
  }
  
  /// Initialize the compute-based audio processor
  Future<bool> initialize() async {
    if (_isInitialized) {
      debugPrint('ComputeAudioProcessor: Already initialized');
      return true;
    }
    
    try {
      debugPrint('ComputeAudioProcessor: Initializing compute-based audio processor...');
      
      // Copy VAD model file for compute functions
      _vadModelPath = await _copyVadModel();
      
      if (_vadModelPath == null) {
        debugPrint('ComputeAudioProcessor: Failed to copy VAD model file');
        return false;
      }
      
      // Test compute function availability
      final testResult = await compute(_testComputeFunction, 'test');
      if (testResult != 'test_success') {
        debugPrint('ComputeAudioProcessor: Compute function test failed');
        return false;
      }
      
      _isInitialized = true;
      debugPrint('ComputeAudioProcessor: Compute-based audio processor initialized successfully');
      notifyListeners();
      return true;
      
    } catch (e) {
      debugPrint('ComputeAudioProcessor: Failed to initialize: $e');
      return false;
    }
  }
  
  /// Copy VAD model file
  Future<String?> _copyVadModel() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final vadDir = Directory('${cacheDir.path}/sherpa_onnx_models');
      if (!await vadDir.exists()) {
        await vadDir.create(recursive: true);
      }
      
      final vadModelPath = '${vadDir.path}/silero_vad_v5.onnx';
      final vadModelFile = File(vadModelPath);
      
      if (!await vadModelFile.exists()) {
        final vadModelBytes = await rootBundle.load('assets/onnx/vad/silero_vad_v5.onnx');
        await vadModelFile.writeAsBytes(vadModelBytes.buffer.asUint8List());
      }
      
      return vadModelPath;
    } catch (e) {
      debugPrint('ComputeAudioProcessor: Failed to copy VAD model: $e');
      return null;
    }
  }
  
  /// Enable audio processing
  void enable() {
    if (!_isInitialized) {
      debugPrint('ComputeAudioProcessor: Cannot enable - not initialized');
      return;
    }
    
    _isEnabled = true;
    debugPrint('ComputeAudioProcessor: Audio processing enabled');
    notifyListeners();
  }
  
  /// Disable audio processing
  void disable() {
    _isEnabled = false;
    _isProcessing = false;
    _isSpeechActive = false;
    _speechStartTime = null;
    
    // Clear buffers
    _audioBuffer.clear();
    _detectedSegments.clear();
    _processingQueue.clear();
    _isProcessingQueue = false;
    
    debugPrint('ComputeAudioProcessor: Audio processing disabled');
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
    
    // Add audio data to buffer immediately (lightweight operation)
    _audioBuffer.addAll(pcmData);
    
    // Queue audio data for background processing
    _processingQueue.add(pcmData);
    
    // Start processing if not already processing
    if (!_isProcessingQueue) {
      _processQueueInBackground();
    }
    
    // Process final audio chunk if requested
    if (isFinal) {
      _processFinalAudioInBackground();
    }
  }
  
  /// Process the audio queue in background using compute
  Future<void> _processQueueInBackground() async {
    if (_processingQueue.isEmpty || _isProcessingQueue) {
      return;
    }
    
    _isProcessingQueue = true;
    
    try {
      while (_processingQueue.isNotEmpty) {
        final pcmData = _processingQueue.removeFirst();
        
        // Process VAD in background using compute
        final vadInput = VadComputeInput(
          pcmData: pcmData,
          vadModelPath: _vadModelPath!,
        );
        final vadResult = await compute(_processVadInBackground, vadInput);
        
        if (vadResult.isSpeech && !_isSpeechActive) {
          // Speech started
          _isSpeechActive = true;
          _speechStartTime = DateTime.now();
          _speechStateController.add(true);
          debugPrint('ComputeAudioProcessor: Speech activity started');
        } else if (!vadResult.isSpeech && _isSpeechActive) {
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
            
            debugPrint('ComputeAudioProcessor: Speech activity ended, duration: $speechDuration');
            
            // Process speech segment with ASR on main thread
            _processSpeechSegmentOnMainThread(segment);
          }
          
          _speechStateController.add(false);
          _speechStartTime = null;
        }
        
        notifyListeners();
      }
    } catch (e) {
      debugPrint('ComputeAudioProcessor: Error processing audio queue: $e');
    } finally {
      _isProcessingQueue = false;
    }
  }
  
  /// Process speech segment on main thread using existing ASR service
  Future<void> _processSpeechSegmentOnMainThread(VadSpeechSegment segment) async {
    try {
      // Check if ASR service is available
      if (_asrService == null) {
        debugPrint('ComputeAudioProcessor: ASR service not available, skipping transcription');
        return;
      }
      
      // Extract audio data for this segment
      final segmentAudio = _extractSegmentAudio(segment);
      if (segmentAudio.isEmpty) {
        debugPrint('ComputeAudioProcessor: No audio data to transcribe');
        return;
      }
      
      // Process ASR on main thread using existing service
      debugPrint('ComputeAudioProcessor: Starting ASR transcription for speech segment...');
      final transcription = await _asrService!.transcribeAudioBuffer(segmentAudio);
      
      if (transcription != null && transcription.text.isNotEmpty) {
        // Create processed result
        final result = ProcessedAudioResult(
          speechSegment: segment,
          transcription: transcription,
          processingTime: transcription.timestamp,
          audioDataSize: segmentAudio.length,
        );
        
        // Add to results history
        _addToResultsHistory(result);
        
        // Broadcast result
        _resultController.add(result);
        
        debugPrint('ComputeAudioProcessor: Speech transcribed successfully: "${transcription.text}"');
      } else {
        debugPrint('ComputeAudioProcessor: ASR returned null or empty transcription');
      }
      
    } catch (e) {
      debugPrint('ComputeAudioProcessor: Error processing speech segment: $e');
    }
  }
  
  /// Process final audio chunk on main thread
  Future<void> _processFinalAudioInBackground() async {
    if (_audioBuffer.isEmpty) {
      return;
    }
    
    try {
      // Check if ASR service is available
      if (_asrService == null) {
        debugPrint('ComputeAudioProcessor: ASR service not available, skipping final transcription');
        return;
      }
      
      // Process entire audio buffer with ASR on main thread
      debugPrint('ComputeAudioProcessor: Starting final ASR transcription...');
      final transcription = await _asrService!.transcribeAudioBuffer(Uint8List.fromList(_audioBuffer));
      
      if (transcription != null && transcription.text.isNotEmpty) {
        // Create final result
        final result = ProcessedAudioResult(
          speechSegment: null, // No specific segment for final processing
          transcription: transcription,
          processingTime: transcription.timestamp,
          audioDataSize: _audioBuffer.length,
          isFinalResult: true,
        );
        
        // Add to results history
        _addToResultsHistory(result);
        
        // Broadcast result
        _resultController.add(result);
        
        debugPrint('ComputeAudioProcessor: Final audio transcribed successfully: "${transcription.text}"');
      } else {
        debugPrint('ComputeAudioProcessor: Final ASR returned null or empty transcription');
      }
      
      // Clear buffer after final processing
      _audioBuffer.clear();
      
    } catch (e) {
      debugPrint('ComputeAudioProcessor: Error processing final audio: $e');
    }
  }
  
  /// Extract audio data for a specific speech segment
  Uint8List _extractSegmentAudio(VadSpeechSegment segment) {
    if (_audioBuffer.isEmpty) {
      return Uint8List(0);
    }
    
    // For now, return the current buffer content
    // In a more sophisticated implementation, you'd extract the specific segment
    // based on the start and end times
    return Uint8List.fromList(_audioBuffer);
  }
  
  /// Add result to history with size limit
  void _addToResultsHistory(ProcessedAudioResult result) {
    _processingResults.add(result);
    
    // Keep only the latest results
    if (_processingResults.length > _maxResultsHistory) {
      _processingResults.removeRange(0, _processingResults.length - _maxResultsHistory);
    }
  }
  
  /// Get language name from language code
  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Spanish';
      case 'zh':
        return 'Chinese';
      default:
        return 'Unknown';
    }
  }
  
  /// Clear all processing results
  void clearResults() {
    _processingResults.clear();
    _detectedSegments.clear();
    debugPrint('ComputeAudioProcessor: Processing results cleared');
    notifyListeners();
  }
  
  /// Get the latest processing result
  ProcessedAudioResult? get latestResult {
    return _processingResults.isNotEmpty ? _processingResults.last : null;
  }
  
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
      'processingQueueSize': _processingQueue.length,
      'isProcessingQueue': _isProcessingQueue,
      'asrServiceAvailable': _asrService != null,
    };
  }
  
  /// Dispose the processor and clean up resources
  void dispose() {
    debugPrint('ComputeAudioProcessor: Disposing compute-based audio processor...');
    
    // Clear all data
    _audioBuffer.clear();
    _detectedSegments.clear();
    _processingResults.clear();
    _processingQueue.clear();
    
    // Close stream controllers
    _resultController.close();
    _speechStateController.close();
    
    _isInitialized = false;
    _isProcessing = false;
    _isEnabled = false;
    
    debugPrint('ComputeAudioProcessor: Compute-based audio processor disposed');
  }
}

/// Test compute function
String _testComputeFunction(String input) {
  return '${input}_success';
}

/// VAD compute input
class VadComputeInput {
  final Uint8List pcmData;
  final String vadModelPath;
  
  VadComputeInput({
    required this.pcmData,
    required this.vadModelPath,
  });
}

/// Process VAD in background isolate
VadResult _processVadInBackground(VadComputeInput input) {
  try {
    // Create VAD configuration
    final config = VadModelConfig(
      sileroVad: SileroVadModelConfig(
        model: input.vadModelPath,
        threshold: 0.5,
        minSilenceDuration: 0.5,
        minSpeechDuration: 0.3,
        windowSize: 512,
        maxSpeechDuration: 30.0,
      ),
      sampleRate: 16000,
      numThreads: 1,
      provider: 'cpu',
      debug: false,
    );
    
    // Initialize VAD service in the isolate
    final vadService = VoiceActivityDetector(
      config: config,
      bufferSizeInSeconds: 2.0,
    );
    
    // Convert PCM to Float32List
    final floatData = _convertPcmToFloat32(input.pcmData);
    
    // Process audio
    vadService.acceptWaveform(floatData);
    final speechDetected = vadService.isDetected();
    
    return VadResult(
      isSpeech: speechDetected,
      confidence: speechDetected ? 0.8 : 0.2,
      timestamp: DateTime.now(),
    );
  } catch (e) {
    // Fallback to simple audio content check if VAD fails
    return VadResult(
      isSpeech: _checkAudioContent(input.pcmData),
      confidence: 0.5,
      timestamp: DateTime.now(),
    );
  }
}

/// Convert PCM data to Float32List
Float32List _convertPcmToFloat32(Uint8List pcmData) {
  final floatData = Float32List(pcmData.length ~/ 2);
  
  for (int i = 0; i < floatData.length; i++) {
    final sample = (pcmData[i * 2] | (pcmData[i * 2 + 1] << 8));
    // Convert 16-bit signed integer to float32 (-1.0 to 1.0)
    floatData[i] = sample / 32768.0;
  }
  
  return floatData;
}

/// Check if audio data contains meaningful content (not just silence)
bool _checkAudioContent(Uint8List audioData) {
  if (audioData.isEmpty) return false;
  
  // Convert to 16-bit samples and check for non-zero values
  final samples = audioData.length ~/ 2;
  int nonZeroSamples = 0;
  
  for (int i = 0; i < samples; i++) {
    int sample = (audioData[i * 2] | (audioData[i * 2 + 1] << 8));
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

/// VAD result from compute function
class VadResult {
  final bool isSpeech;
  final double confidence;
  final DateTime timestamp;
  
  VadResult({
    required this.isSpeech,
    required this.confidence,
    required this.timestamp,
  });
}
