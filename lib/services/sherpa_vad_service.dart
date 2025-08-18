import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sherpa_onnx/sherpa_onnx.dart';
import 'package:path_provider/path_provider.dart';
import 'audio_config.dart';

/// Voice Activity Detection (VAD) service using sherpa_onnx
/// 
/// This service processes audio streams to detect speech segments
/// and integrates with the existing hardware audio pipeline
class SherpaVadService extends ChangeNotifier {
  SherpaVadService() {
    debugPrint('SherpaVadService: Constructor called');
  }
  
  // Pending bytes to feed VAD in 2Hz batches
  final List<int> _pendingVadBytes = [];
  // VAD configuration - using centralized AudioConfig
  // All constants are now synchronized with CloudAudioProcessor
  
  // VAD processing frequency control - process every frame for better detection
  int _frameCounter = 0;
  DateTime? _lastVadProcessingTime;
  
  // VAD state
  bool _isInitialized = false;
  bool _isProcessing = false;
  bool _isSpeechDetected = false;
  
  // VAD instance
  VoiceActivityDetector? _vad;
  
  // Audio processing
  final List<int> _audioBuffer = [];
  final int _bufferThreshold = AudioConfig.vadSampleRate * 2; // 2 seconds of audio
  
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
    debugPrint('SherpaVadService: initialize() method called');
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
      
      // Verify the model file exists and has content
      final modelFile = File(modelPath);
      if (await modelFile.exists()) {
        final fileSize = await modelFile.length();
        debugPrint('SherpaVadService: Model file exists, size: ${fileSize} bytes');
      } else {
        debugPrint('SherpaVadService: ERROR - Model file does not exist at: $modelPath');
        return false;
      }
      
      // Create VAD configuration with optimized parameters for better segment management
      final config = VadModelConfig(
        sileroVad: SileroVadModelConfig(
          model: modelPath,
          threshold: AudioConfig.vadThreshold,
          minSilenceDuration: AudioConfig.vadMinSilenceDuration,
          minSpeechDuration: AudioConfig.vadMinSpeechDuration,
          windowSize: AudioConfig.vadWindowSize,
          maxSpeechDuration: AudioConfig.vadMaxSpeechDuration,
        ),
        sampleRate: AudioConfig.vadSampleRate,
        numThreads: AudioConfig.vadNumThreads,
        provider: AudioConfig.vadProvider,
        debug: AudioConfig.vadDebug,
      );
      
      debugPrint('SherpaVadService: VAD config created, attempting to create VAD instance...');
      
      try {
        // Create VAD instance
        _vad = VoiceActivityDetector(
          config: config,
          bufferSizeInSeconds: AudioConfig.vadBufferSizeInSeconds,
        );
        debugPrint('SherpaVadService: VAD instance created successfully');
        
        _isInitialized = true;
        debugPrint('SherpaVadService: VAD service initialized successfully');
        
        // Test VAD with a simple sample to verify it's working
        debugPrint('SherpaVadService: Testing VAD with sample audio...');
        final testResult = await testVadWithSample();
        debugPrint('SherpaVadService: VAD test result: $testResult');
        
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
       debugPrint('SherpaVadService: Cannot process - VAD not initialized: initialized=$_isInitialized, vad=${_vad != null}');
       return false;
     }
     
     if (pcmData.isEmpty) {
       debugPrint('SherpaVadService: Cannot process empty PCM data');
       return false;
     }
     
     try {
       _isProcessing = true;
       notifyListeners();
       
       // Add audio data to buffer
       _audioBuffer.addAll(pcmData);
       // Also accumulate into the 2Hz batch buffer
       _pendingVadBytes.addAll(pcmData);
       
       // Process frames when we have enough data
       bool speechDetected = false;
       int framesProcessed = 0;
       
       while (_audioBuffer.length >= AudioConfig.vadFrameSize * 2) { // 2 bytes per sample (16-bit)
         final frameData = _audioBuffer.take(AudioConfig.vadFrameSize * 2).toList();
         _audioBuffer.removeRange(0, AudioConfig.vadFrameSize * 2);
         
         // We still advance statistics for each 10ms frame
         framesProcessed++;
         _totalFramesProcessed++;

         // Only feed VAD every vadMinProcessingGap (2Hz) with the accumulated batch
         final now = DateTime.now();
         final shouldProcessBatch = _lastVadProcessingTime == null ||
             now.difference(_lastVadProcessingTime!).inMilliseconds >= AudioConfig.vadMinProcessingGap;

         if (shouldProcessBatch && _pendingVadBytes.isNotEmpty) {
           // Convert the entire pending batch to float32 and evaluate once
           final floatBatch = _convertPcmToFloat32(_pendingVadBytes);

           // Optional: skip batch if essentially silent
           if (AudioConfig.vadSkipSilentFrames) {
             final maxAmp = floatBatch.reduce((a, b) => a.abs() > b.abs() ? a : b).abs();
             if (maxAmp < AudioConfig.vadSilenceThreshold) {
               _silenceFramesDetected++;
               _lastVadProcessingTime = now;
               _pendingVadBytes.clear();
               continue;
             }
           }

           _vad!.acceptWaveform(floatBatch);
           _lastVadProcessingTime = now;

           final vadResult = _vad!.isDetected();
           
           if (vadResult) {
             speechDetected = true;
             _speechFramesDetected++;
            //  debugPrint('SherpaVadService: Speech detected! Batch size: ${_pendingVadBytes.length} bytes');
           } else {
             _silenceFramesDetected++;
           }

           // Clear batch after processing
           _pendingVadBytes.clear();
         }
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
        final frameSize = (AudioConfig.vadFrameSize * 2).clamp(0, pcmData.length - offset);
        final frameData = pcmData.sublist(offset, offset + frameSize);
        
        if (frameData.length == AudioConfig.vadFrameSize * 2) {
          final speechDetected = processAudioFrame(frameData);
          
          if (speechDetected && segments.isEmpty) {
            // Start of new speech segment
            segments.add(VadSpeechSegment(
              startTime: Duration(milliseconds: (offset / 2 / AudioConfig.vadSampleRate * 1000).round()),
              endTime: Duration(milliseconds: ((offset + frameSize) / 2 / AudioConfig.vadSampleRate * 1000).round()),
            ));
          } else if (speechDetected && segments.isNotEmpty) {
            // Extend current speech segment
            final lastSegment = segments.last;
            segments[segments.length - 1] = lastSegment.copyWith(
              endTime: Duration(milliseconds: ((offset + frameSize) / 2 / AudioConfig.vadSampleRate * 1000).round()),
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
    
    // Use moderate amplification since we increased the threshold
    const double amplificationFactor = AudioConfig.vadAmplificationFactor;
    
    for (int i = 0; i < floatData.length; i++) {
      // Convert 16-bit signed integer to float32 (-1.0 to 1.0)
      // Handle both little-endian and big-endian formats
      int sample;
      if (Endian.host == Endian.little) {
        sample = (pcmData[i * 2] | (pcmData[i * 2 + 1] << 8));
      } else {
        sample = ((pcmData[i * 2] << 8) | (pcmData[i * 2 + 1]));
      }
      
      // Handle signed 16-bit integer
      if (sample > 32767) {
        sample = sample - 65536;
      }
      
      // Convert to float and apply higher amplification
      floatData[i] = (sample / 32768.0) * amplificationFactor;
      
      // Clamp to prevent clipping
      if (floatData[i] > 1.0) floatData[i] = 1.0;
      if (floatData[i] < -1.0) floatData[i] = -1.0;
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
  
  /// Test VAD with a simple audio sample
  Future<bool> testVadWithSample() async {
    if (!_isInitialized || _vad == null) {
      debugPrint('SherpaVadService: Cannot test - VAD not initialized');
      return false;
    }
    
    try {
      debugPrint('SherpaVadService: Testing VAD with sample audio...');
      
      // Create a simple test audio sample (1 second of alternating tones)
      final testAudio = Float32List(AudioConfig.vadSampleRate);
      for (int i = 0; i < testAudio.length; i++) {
        // Create a simple tone pattern
        testAudio[i] = 0.1 * sin(2 * pi * 440 * i / AudioConfig.vadSampleRate); // 440Hz tone
      }
      
      // Process the test audio
      _vad!.acceptWaveform(testAudio);
      
      // Check if VAD detects anything
      final detected = _vad!.isDetected();
      debugPrint('SherpaVadService: VAD test result - detected: $detected');
      
      return true;
      
    } catch (e) {
      debugPrint('SherpaVadService: VAD test failed: $e');
      return false;
    }
  }
  
  /// Reset VAD state (useful for debugging and synchronization)
  void resetVadState() {
    if (_vad != null) {
      _vad!.clear();
      debugPrint('SherpaVadService: VAD instance cleared');
    }
    
    // Reset all state variables
    _isSpeechDetected = false;
    _speechStartTime = null;
    _speechEndTime = null;
    _speechDuration = 0;
    _frameCounter = 0;
    
    // Clear audio buffer completely
    _audioBuffer.clear();
    
    // Reset statistics for clean state
    _totalFramesProcessed = 0;
    _speechFramesDetected = 0;
    _silenceFramesDetected = 0;
    
    debugPrint('SherpaVadService: VAD state completely reset - ready for new audio stream');
    notifyListeners();
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
      'sampleRate': AudioConfig.vadSampleRate,
      'channels': AudioConfig.vadChannels,
      'frameSize': AudioConfig.vadFrameSize,
      'processingFrequency': '2Hz (time-based)',
      'frameCounter': _frameCounter,
      'minProcessingGap': '${AudioConfig.vadMinProcessingGap}ms',
    };
  }
  
  /// Check if VAD is ready to process new audio data without overlaps
  bool isReadyForNewAudio() {
    // Always ready for new audio - the processing queue handles overlaps
    return true;
  }
  
  /// Get current VAD processing state for debugging
  Map<String, dynamic> getProcessingState() {
    return {
      'isProcessing': _isProcessing,
      'isSpeechDetected': _isSpeechDetected,
      'speechStartTime': _speechStartTime?.toIso8601String(),
      'speechEndTime': _speechEndTime?.toIso8601String(),
      'speechDuration': _speechDuration,
      'audioBufferSize': _audioBuffer.length,
      'frameCounter': _frameCounter,
      'readyForNewAudio': isReadyForNewAudio(),
      // VAD optimization stats
      'lastVadProcessingTime': _lastVadProcessingTime?.toIso8601String(),
      'processingFrequency': '2Hz (time-based)',
      'minProcessingGap': '${AudioConfig.vadMinProcessingGap}ms',
      'skipSilentFrames': AudioConfig.vadSkipSilentFrames,
    };
  }
  
  /// Get current VAD processing frequency
  double getCurrentVadFrequency() {
    if (_lastVadProcessingTime == null) return 0.0;
    
    final now = DateTime.now();
    final timeSinceLastVad = now.difference(_lastVadProcessingTime!);
    
    if (timeSinceLastVad.inMilliseconds == 0) return 0.0;
    
    // Calculate frequency in Hz (calls per second)
    return 1000.0 / timeSinceLastVad.inMilliseconds;
  }
  
  /// Get VAD processing statistics
  Map<String, dynamic> getVadFrequencyStats() {
    return {
      'currentFrequency': '${getCurrentVadFrequency().toStringAsFixed(1)}Hz',
      'targetFrequency': '2Hz (time-based)',
      'minProcessingGap': '${AudioConfig.vadMinProcessingGap}ms',
      'lastProcessingTime': _lastVadProcessingTime?.toIso8601String(),
      'totalFramesProcessed': _totalFramesProcessed,
      'speechFramesDetected': _speechFramesDetected,
      'silenceFramesDetected': _silenceFramesDetected,
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
