/// Centralized audio configuration constants
/// 
/// This file contains all audio processing, VAD, and segmentation configuration
/// values to ensure consistency across the entire audio pipeline.
/// 
/// BENEFITS:
/// ✅ Single source of truth for all audio constants
/// ✅ Automatic synchronization between VAD and processor
/// ✅ Easy maintenance - change one value, affects entire system
/// ✅ Configuration validation on startup
/// ✅ No more duplicate constants scattered across files
/// 
/// USAGE:
/// - Import this file in any service that needs audio configuration
/// - Use AudioConfig.constantName instead of local constants
/// - All timing values are automatically synchronized
class AudioConfig {
  // Private constructor to prevent instantiation
  AudioConfig._();
  
  // ===== VAD (Voice Activity Detection) Configuration =====
  
  /// VAD model configuration
  static const double vadThreshold = 0.6;
  static const double vadMinSilenceDuration = 3.0;
  static const double vadMinSpeechDuration = 0.5;
  static const double vadMaxSpeechDuration = 30.0;
  static const int vadWindowSize = 512;
  static const int vadNumThreads = 1;
  static const String vadProvider = 'cpu';
  static const bool vadDebug = false;
  
  /// VAD audio processing configuration
  static const int vadSampleRate = 16000;
  static const int vadChannels = 1;
  static const int vadFrameSize = 160; // 10ms frames (16000Hz / 160 = 100Hz)
  static const int vadProcessingInterval = 1; // Process every frame
  static const double vadBufferSizeInSeconds = 2.0;
  
  /// VAD audio quality thresholds
  static const double vadMinAmplitudeThreshold = 0.0001;
  static const double vadAmplificationFactor = 5.0;
  
  // ===== Audio Segmentation Configuration =====
  
  /// Segment timing configuration
  static const Duration segmentCloseDelay = Duration(seconds: 3);
  static const Duration minSegmentDuration = Duration(milliseconds: 500);
  static const Duration maxSegmentDuration = Duration(seconds: 30);
  static const Duration segmentOverlapThreshold = Duration(milliseconds: 500);
  
  /// Segment buffer configuration
  static const int maxSegmentBufferSize = 1024 * 1024; // 1MB per segment
  static const int maxResultsHistory = 100;
  
  // ===== Audio Processing Configuration =====
  
  /// Audio format configuration
  static const int audioSampleRate = 16000;
  static const int audioChannels = 1;
  static const int audioBitDepth = 16;
  
  /// File management configuration
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const Duration fileRotationInterval = Duration(minutes: 1);
  
  // ===== Validation Methods =====
  
  /// Validate that all timing constants are consistent
  static bool validateTimingConsistency() {
    final vadSilenceMs = (vadMinSilenceDuration * 1000).round();
    final processorDelayMs = segmentCloseDelay.inMilliseconds;
    final vadSpeechMs = (vadMinSpeechDuration * 1000).round();
    final processorMinMs = minSegmentDuration.inMilliseconds;
    
    final silenceMatch = vadSilenceMs == processorDelayMs;
    final speechMatch = vadSpeechMs == processorMinMs;
    
    return silenceMatch && speechMatch;
  }
  
  /// Get configuration summary for debugging
  static Map<String, dynamic> getConfigSummary() {
    return {
      'vad': {
        'threshold': vadThreshold,
        'minSilenceDuration': '${vadMinSilenceDuration}s',
        'minSpeechDuration': '${vadMinSpeechDuration}s',
        'maxSpeechDuration': '${vadMaxSpeechDuration}s',
        'sampleRate': '${vadSampleRate}Hz',
        'frameSize': '${vadFrameSize} samples',
        'processingInterval': '${vadProcessingInterval} frames',
      },
      'segmentation': {
        'segmentCloseDelay': '${segmentCloseDelay.inSeconds}s',
        'minSegmentDuration': '${minSegmentDuration.inMilliseconds}ms',
        'maxSegmentDuration': '${maxSegmentDuration.inSeconds}s',
        'overlapThreshold': '${segmentOverlapThreshold.inMilliseconds}ms',
      },
      'audio': {
        'sampleRate': '${audioSampleRate}Hz',
        'channels': audioChannels,
        'bitDepth': audioBitDepth,
        'maxBufferSize': '${maxSegmentBufferSize ~/ 1024}KB',
      },
      'consistency': {
        'timingValid': validateTimingConsistency(),
        'vadSilenceMatch': '${vadMinSilenceDuration}s == ${segmentCloseDelay.inSeconds}s',
        'vadSpeechMatch': '${vadMinSpeechDuration}s == ${minSegmentDuration.inMilliseconds / 1000}s',
      },
    };
  }
}
