import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart';
import 'package:path_provider/path_provider.dart';

/// Voice Activity Detection (VAD) service using sherpa_onnx
/// 
/// This service processes audio streams to detect speech segments
/// and integrates with the existing hardware audio pipeline
class SherpaVadService extends ChangeNotifier {
  // VAD configuration
  static const int _sampleRate = 16000;  // Match OMI firmware sample rate
  static const int _channels = 1;         // Mono audio
  static const int _frameSize = 160;      // 10ms frames (16000Hz / 160 = 100Hz)
  
  // VAD state
  bool _isInitialized = false;
  bool _isProcessing = false;
  bool _isSpeechDetected = false;
  
  // VAD instance
  VoiceActivityDetector? _vad;
  
  // Audio processing
  final List<int> _audioBuffer = [];
  final int _bufferThreshold = _sampleRate * 2; // 2 seconds of audio
  
  // Speech detection state
  DateTime? _speechStartTime;
  DateTime? _speechEndTime;
  int _speechDuration = 0; // Duration in milliseconds
  
  // Statistics
  int _totalFramesProcessed = 0;
  int _speechFramesDetected = 0;
  int _silenceFramesDetected = 0;
  
  // Stream controllers
  final StreamController<bool> _speechDetectionController = 
      StreamController<bool>.broadcast();
  final StreamController<Duration> _speechDurationController = 
      StreamController<Duration>.broadcast();
  
  // Getters
  bool get isInitialized => _isInitialized;
  bool get isProcessing => _isProcessing;
  bool get isSpeechDetected => _isSpeechDetected;
  Duration get speechDuration => Duration(milliseconds: _speechDuration);
  Stream<bool> get speechDetectionStream => _speechDetectionController.stream;
  Stream<Duration> get speechDurationStream => _speechDurationController.stream;
  
  // Statistics getters
  int get totalFramesProcessed => _totalFramesProcessed;
  int get speechFramesDetected => _speechFramesDetected;
  int get silenceFramesDetected => _silenceFramesDetected;
  double get speechRatio => _totalFramesProcessed > 0 
      ? _speechFramesDetected / _totalFramesProcessed 
      : 0.0;
  
  /// Initialize the VAD service
  Future<bool> initialize() async {
    if (_isInitialized) {
      debugPrint('SherpaVadService: Already initialized');
      return true;
    }

    try {
      debugPrint('SherpaVadService: Initializing VAD service...');
      
      // Copy the model file from assets to a temporary directory
      final modelPath = await _copyModelFile();
      if (modelPath == null) {
        debugPrint('SherpaVadService: Failed to copy model file');
        return false;
      }
      
      debugPrint('SherpaVadService: Using model file at: $modelPath');
      
      // Create VAD configuration
      final config = VadModelConfig(
        sileroVad: SileroVadModelConfig(
          model: modelPath,
          threshold: 0.5,
          minSilenceDuration: 0.5,
          minSpeechDuration: 0.5,
          windowSize: 512, // Use standard window size like test config
          maxSpeechDuration: 5.0,
        ),
        sampleRate: _sampleRate,
        numThreads: 1,
        provider: 'cpu',
        debug: false, // Disable debug to reduce memory usage
      );
      
      debugPrint('SherpaVadService: VAD config created, attempting to create VAD instance...');
      
      try {
        // Create VAD instance
        _vad = VoiceActivityDetector(
          config: config,
          bufferSizeInSeconds: 2.0,
        );
        debugPrint('SherpaVadService: VAD instance created successfully');
        
        _isInitialized = true;
        debugPrint('SherpaVadService: VAD service initialized successfully');
        debugPrint('  - Sample Rate: $_sampleRate Hz');
        debugPrint('  - Channels: $_channels');
        debugPrint('  - Frame Size: $_frameSize samples');
        
        notifyListeners();
        return true;
        
      } catch (e, stackTrace) {
        debugPrint('SherpaVadService: Failed to create VAD instance: $e');
        debugPrint('SherpaVadService: Stack trace: $stackTrace');
        return false;
      }
      
    } catch (e) {
      debugPrint('SherpaVadService: Failed to initialize VAD service: $e');
      debugPrint('SherpaVadService: Error details: ${e.toString()}');
      _isInitialized = false;
      notifyListeners();
      return false;
    }
  }
  
  /// Process PCM audio data for voice activity detection
  /// 
  /// [pcmData] - Raw PCM audio data (16-bit, little-endian)
  /// Returns true if speech is detected in the current frame
  bool processAudioFrame(Uint8List pcmData) {
    if (!_isInitialized || _vad == null) {
      debugPrint('SherpaVadService: Cannot process - VAD not initialized');
      return false;
    }
    
    if (pcmData.isEmpty) {
      debugPrint('SherpaVadService: Cannot process empty audio data');
      return false;
    }
    
    try {
      _isProcessing = true;
      notifyListeners();
      
      // Add audio data to buffer
      _audioBuffer.addAll(pcmData);
      
      // Process frames when we have enough data
      bool speechDetected = false;
      while (_audioBuffer.length >= _frameSize * 2) { // 2 bytes per sample (16-bit)
        final frameData = _audioBuffer.take(_frameSize * 2).toList();
        _audioBuffer.removeRange(0, _frameSize * 2);
        
        // Convert to Float32List for VAD processing
        final floatFrame = _convertPcmToFloat32(frameData);
        
        // Process frame with VAD
        _vad!.acceptWaveform(floatFrame);
        
        // Check if speech is detected
        if (_vad!.isDetected()) {
          // Speech detected in this frame
          speechDetected = true;
          _speechFramesDetected++;
          
          // Update speech state
          if (!_isSpeechDetected) {
            _isSpeechDetected = true;
            _speechStartTime = DateTime.now();
            _speechDetectionController.add(true);
            debugPrint('SherpaVadService: Speech detected');
          }
        } else {
          _silenceFramesDetected++;
          
          // Update silence state
          if (_isSpeechDetected) {
            _isSpeechDetected = false;
            _speechEndTime = DateTime.now();
            if (_speechStartTime != null) {
              _speechDuration = _speechEndTime!.millisecondsSinceEpoch - _speechStartTime!.millisecondsSinceEpoch;
              _speechDurationController.add(Duration(milliseconds: _speechDuration));
            }
            _speechDetectionController.add(false);
            debugPrint('SherpaVadService: Speech ended, duration: $_speechDuration');
          }
        }
        
        _totalFramesProcessed++;
      }
      
      return speechDetected;
      
    } catch (e) {
      debugPrint('SherpaVadService: Error processing audio frame: $e');
      return false;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }
  
  /// Process a complete audio buffer for VAD
  /// 
  /// [pcmData] - Complete PCM audio buffer
  /// Returns list of speech segments detected
  List<VadSpeechSegment> processAudioBuffer(Uint8List pcmData) {
    if (!_isInitialized || _vad == null) {
      debugPrint('SherpaVadService: Cannot process - VAD not initialized');
      return [];
    }
    
    try {
      // Reset VAD for new buffer
      _vad!.clear();
      
      // Process the entire buffer frame by frame
      final segments = <VadSpeechSegment>[];
      int offset = 0;
      
      while (offset < pcmData.length) {
        final frameSize = (_frameSize * 2).clamp(0, pcmData.length - offset);
        final frameData = pcmData.sublist(offset, offset + frameSize);
        
        if (frameData.length == _frameSize * 2) {
          final speechDetected = processAudioFrame(frameData);
          
          if (speechDetected && segments.isEmpty) {
            // Start of new speech segment
            segments.add(VadSpeechSegment(
              startTime: Duration(milliseconds: (offset / 2 / _sampleRate * 1000).round()),
              endTime: Duration(milliseconds: ((offset + frameSize) / 2 / _sampleRate * 1000).round()),
            ));
          } else if (speechDetected && segments.isNotEmpty) {
            // Extend current speech segment
            final lastSegment = segments.last;
            segments[segments.length - 1] = lastSegment.copyWith(
              endTime: Duration(milliseconds: ((offset + frameSize) / 2 / _sampleRate * 1000).round()),
            );
          }
        }
        
        offset += frameSize;
      }
      
      return segments;
      
    } catch (e) {
      debugPrint('SherpaVadService: Error processing audio buffer: $e');
      return [];
    }
  }
  
  /// Convert PCM data to Float32List for VAD processing
  Float32List _convertPcmToFloat32(List<int> pcmData) {
    final floatData = Float32List(pcmData.length ~/ 2);
    
    for (int i = 0; i < floatData.length; i++) {
      final sample = (pcmData[i * 2] | (pcmData[i * 2 + 1] << 8));
      // Convert 16-bit signed integer to float32 (-1.0 to 1.0)
      floatData[i] = sample / 32768.0;
    }
    
    return floatData;
  }
  
  /// Copy the VAD model file from assets to a temporary directory
  Future<String?> _copyModelFile() async {
    try {
      // Get the temporary directory
      final tempDir = await getTemporaryDirectory();
      final modelDir = Directory('${tempDir.path}/sherpa_onnx_models');
      
      // Create the directory if it doesn't exist
      if (!await modelDir.exists()) {
        await modelDir.create(recursive: true);
      }
      
      final modelPath = '${modelDir.path}/silero_vad_v5.onnx';
      
      // Check if the model file already exists
      if (await File(modelPath).exists()) {
        debugPrint('SherpaVadService: Model file already exists at: $modelPath');
        return modelPath;
      }
      
      // Copy the model file from assets
      debugPrint('SherpaVadService: Copying model file from assets...');
      debugPrint('SherpaVadService: Attempting to load asset: assets/onnx/vad/silero_vad_v5.onnx');
      
      // First, let's check if we can list the assets
      try {
        final manifestContent = await rootBundle.loadString('AssetManifest.json');
        debugPrint('SherpaVadService: Asset manifest loaded, length: ${manifestContent.length}');
        if (manifestContent.contains('assets/onnx/vad/silero_vad_v5.onnx')) {
          debugPrint('SherpaVadService: Asset found in manifest');
        } else {
          debugPrint('SherpaVadService: Asset NOT found in manifest');
        }
      } catch (e) {
        debugPrint('SherpaVadService: Failed to load asset manifest: $e');
      }
      
      final modelData = await rootBundle.load('assets/onnx/vad/silero_vad_v5.onnx');
      debugPrint('SherpaVadService: Model data loaded, size: ${modelData.lengthInBytes} bytes');
      
      final modelFile = File(modelPath);
      await modelFile.writeAsBytes(modelData.buffer.asUint8List());
      
      debugPrint('SherpaVadService: Model file copied to: $modelPath');
      return modelPath;
      
    } catch (e) {
      debugPrint('SherpaVadService: Failed to copy model file: $e');
      return null;
    }
  }
  

  
  /// Get current VAD statistics
  Map<String, dynamic> getStats() {
    return {
      'isInitialized': _isInitialized,
      'isProcessing': _isProcessing,
      'isSpeechDetected': _isSpeechDetected,
      'speechDuration': _speechDuration,
      'totalFramesProcessed': _totalFramesProcessed,
      'speechFramesDetected': _speechFramesDetected,
      'silenceFramesDetected': _silenceFramesDetected,
      'speechRatio': speechRatio,
      'audioBufferSize': _audioBuffer.length,
      'sampleRate': _sampleRate,
      'channels': _channels,
      'frameSize': _frameSize,
    };
  }
  
  /// Dispose of resources
  @override
  void dispose() {
    _vad?.free();
    _speechDetectionController.close();
    _speechDurationController.close();
    super.dispose();
  }
}

/// Represents a speech segment detected by VAD
class VadSpeechSegment {
  final Duration startTime;
  final Duration endTime;
  
  const VadSpeechSegment({
    required this.startTime,
    required this.endTime,
  });
  
  Duration get duration => Duration(milliseconds: endTime.inMilliseconds - startTime.inMilliseconds);
  
  VadSpeechSegment copyWith({
    Duration? startTime,
    Duration? endTime,
  }) {
    return VadSpeechSegment(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
  
  @override
  String toString() {
    return 'VadSpeechSegment(start: ${startTime.inMilliseconds}ms, end: ${endTime.inMilliseconds}ms, duration: ${duration.inMilliseconds}ms)';
  }
}
