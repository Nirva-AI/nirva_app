import 'package:flutter/foundation.dart';
import '../services/sherpa_vad_service.dart';
import '../services/sherpa_asr_service.dart';

/// Result of processing audio with VAD and ASR
class ProcessedAudioResult {
  /// Speech segment detected by VAD (null for final results)
  final VadSpeechSegment? speechSegment;
  
  /// Transcription result from ASR
  final TranscriptionResult transcription;
  
  /// When the processing was completed
  final DateTime processingTime;
  
  /// Size of the audio data processed (in bytes)
  final int audioDataSize;
  
  /// Whether this is a final result (processed after recording stops)
  final bool isFinalResult;
  
  const ProcessedAudioResult({
    required this.speechSegment,
    required this.transcription,
    required this.processingTime,
    required this.audioDataSize,
    this.isFinalResult = false,
  });
  
  @override
  String toString() {
    return 'ProcessedAudioResult(text: "${transcription.text}", language: ${transcription.language}, processingTime: $processingTime, isFinal: $isFinalResult)';
  }
}
