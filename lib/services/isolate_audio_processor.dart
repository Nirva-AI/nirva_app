import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'sherpa_vad_service.dart';
import 'sherpa_asr_service.dart';
import '../models/processed_audio_result.dart';

/// Isolate-based audio processor that runs VAD and ASR in background
/// 
/// This service prevents UI blocking by running heavy computational work
/// in a separate isolate while maintaining the existing VAD and ASR services.
class IsolateAudioProcessor extends ChangeNotifier {
  // Isolate management
  Isolate? _isolate;
  SendPort? _sendPort;
  ReceivePort? _receivePort;
  
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
  
  // Stream subscriptions
  StreamSubscription<dynamic>? _isolateMessageSubscription;
  
  // Getters
  bool get isInitialized => _isInitialized;
  bool get isProcessing => _isProcessing;
  bool get isEnabled => _isEnabled;
  bool get isSpeechActive => _isSpeechActive;
  List<ProcessedAudioResult> get processingResults => List.unmodifiable(_processingResults);
  Stream<ProcessedAudioResult> get resultStream => _resultController.stream;
  Stream<bool> get speechStateStream => _speechStateController.stream;
  
  /// Initialize the isolate-based audio processor
  Future<bool> initialize() async {
    if (_isInitialized) {
      debugPrint('IsolateAudioProcessor: Already initialized');
      return true;
    }
    
    try {
      debugPrint('IsolateAudioProcessor: Initializing isolate-based audio processor...');
      
      // Create receive port for communication
      _receivePort = ReceivePort();
      
      // Create isolate
      _isolate = await Isolate.spawn(
        _isolateEntryPoint,
        _receivePort!.sendPort,
        debugName: 'IsolateAudioProcessor',
      );
      
      // Set up message handling
      _isolateMessageSubscription = _receivePort!.listen(_handleIsolateMessage);
      
      // Wait for isolate to be ready
      final completer = Completer<bool>();
      Timer(const Duration(seconds: 10), () {
        if (!completer.isCompleted) {
          completer.complete(false);
        }
      });
      
      // Get send port from isolate
      _sendPort = await _receivePort!.first as SendPort;
      
      // Send initialization message
      _sendPort!.send(IsolateMessage.initialize());
      
      // Wait for initialization response
      _receivePort!.listen((message) {
        if (message is IsolateResponse && message.type == IsolateResponseType.initialized) {
          if (!completer.isCompleted) {
            completer.complete(true);
          }
        }
      });
      
      final success = await completer.future;
      if (success) {
        _isInitialized = true;
        debugPrint('IsolateAudioProcessor: Isolate-based audio processor initialized successfully');
      } else {
        debugPrint('IsolateAudioProcessor: Failed to initialize isolate within timeout');
      }
      
      return success;
      
    } catch (e) {
      debugPrint('IsolateAudioProcessor: Failed to initialize: $e');
      return false;
    }
  }
  
  /// Enable audio processing
  void enable() {
    if (!_isInitialized) {
      debugPrint('IsolateAudioProcessor: Cannot enable - not initialized');
      return;
    }
    
    _isEnabled = true;
    debugPrint('IsolateAudioProcessor: Audio processing enabled');
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
    
    debugPrint('IsolateAudioProcessor: Audio processing disabled');
    notifyListeners();
  }
  
  /// Process PCM audio data from hardware
  /// 
  /// [pcmData] - Raw PCM audio data (16-bit, little-endian)
  /// [isFinal] - Whether this is the final chunk of audio
  void processAudioData(Uint8List pcmData, {bool isFinal = false}) {
    if (!_isEnabled || !_isInitialized || _sendPort == null) {
      return;
    }
    
    // Add audio data to buffer immediately (lightweight operation)
    _audioBuffer.addAll(pcmData);
    
    // Send audio data to isolate for processing
    _sendPort!.send(IsolateMessage.processAudio(pcmData, isFinal));
    
    // Process final audio chunk if requested
    if (isFinal) {
      _processFinalAudioInBackground();
    }
  }
  
  /// Process final audio chunk in background
  Future<void> _processFinalAudioInBackground() async {
    if (_audioBuffer.isEmpty || _sendPort == null) {
      return;
    }
    
    try {
      // Send final processing message to isolate
      _sendPort!.send(IsolateMessage.processFinal(Uint8List.fromList(_audioBuffer)));
      
      // Clear buffer after sending
      _audioBuffer.clear();
      
    } catch (e) {
      debugPrint('IsolateAudioProcessor: Error processing final audio: $e');
    }
  }
  
  /// Handle messages from the isolate
  void _handleIsolateMessage(dynamic message) {
    if (message is IsolateResponse) {
      switch (message.type) {
        case IsolateResponseType.vadResult:
          if (message.data is VadResult) {
            _handleVadResult(message.data as VadResult);
          }
          break;
        case IsolateResponseType.asrResult:
          if (message.data is AsrResult) {
            _handleAsrResult(message.data as AsrResult);
          }
          break;
        case IsolateResponseType.speechState:
          if (message.data is bool) {
            _handleSpeechStateChange(message.data as bool);
          }
          break;
        case IsolateResponseType.error:
          debugPrint('IsolateAudioProcessor: Isolate error: ${message.data}');
          break;
        case IsolateResponseType.initialized:
          debugPrint('IsolateAudioProcessor: Isolate initialization confirmed');
          break;
      }
    }
  }
  
  /// Handle VAD result from isolate
  void _handleVadResult(VadResult result) {
    if (result.isSpeech && !_isSpeechActive) {
      // Speech started
      _isSpeechActive = true;
      _speechStartTime = result.timestamp;
      _speechStateController.add(true);
      debugPrint('IsolateAudioProcessor: Speech activity started');
    } else if (!result.isSpeech && _isSpeechActive) {
      // Speech ended
      _isSpeechActive = false;
      if (_speechStartTime != null) {
        final speechDuration = result.timestamp.difference(_speechStartTime!);
        
        // Create speech segment
        final segment = VadSpeechSegment(
          startTime: Duration(milliseconds: _speechStartTime!.millisecondsSinceEpoch),
          endTime: Duration(milliseconds: result.timestamp.millisecondsSinceEpoch),
        );
        
        _detectedSegments.add(segment);
        
        debugPrint('IsolateAudioProcessor: Speech activity ended, duration: $speechDuration');
      }
      
      _speechStateController.add(false);
      _speechStartTime = null;
    }
    
    notifyListeners();
  }
  
  /// Handle ASR result from isolate
  void _handleAsrResult(AsrResult result) {
    if (result.text.isNotEmpty) {
      // Create processed result
      final processedResult = ProcessedAudioResult(
        speechSegment: _detectedSegments.isNotEmpty ? _detectedSegments.last : null,
        transcription: TranscriptionResult(
          text: result.text,
          language: result.language,
          languageName: _getLanguageName(result.language),
          timestamp: result.timestamp,
          confidence: result.confidence,
          isFinal: true,
        ),
        processingTime: result.timestamp,
        audioDataSize: 0, // Will be updated when we have segment audio
      );
      
      // Add to results history
      _addToResultsHistory(processedResult);
      
      // Broadcast result
      _resultController.add(processedResult);
      
      debugPrint('IsolateAudioProcessor: Speech transcribed successfully: "${result.text}"');
    }
    
    notifyListeners();
  }
  
  /// Handle speech state change from isolate
  void _handleSpeechStateChange(bool isSpeech) {
    _isSpeechActive = isSpeech;
    _speechStateController.add(isSpeech);
    notifyListeners();
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
    debugPrint('IsolateAudioProcessor: Processing results cleared');
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
    };
  }
  
  /// Dispose the isolate and clean up resources
  void dispose() {
    debugPrint('IsolateAudioProcessor: Disposing isolate-based audio processor...');
    
    // Send dispose message to isolate
    if (_sendPort != null) {
      try {
        _sendPort!.send(IsolateMessage.dispose());
      } catch (e) {
        debugPrint('IsolateAudioProcessor: Error sending dispose message: $e');
      }
    }
    
    // Kill isolate
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    
    // Close receive port
    _isolateMessageSubscription?.cancel();
    _receivePort?.close();
    _receivePort = null;
    
    // Close stream controllers
    _resultController.close();
    _speechStateController.close();
    
    _isInitialized = false;
    _isProcessing = false;
    _isEnabled = false;
    
    debugPrint('IsolateAudioProcessor: Isolate-based audio processor disposed');
  }
}

/// Isolate entry point - runs in background isolate
void _isolateEntryPoint(SendPort sendPort) {
  debugPrint('IsolateAudioProcessor: Background isolate started');
  
  // Create receive port for this isolate
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  
  // Initialize VAD and ASR services in isolate
  late final SherpaVadService _vadService;
  late final SherpaAsrService _asrService;
  
  // Audio processing state
  bool _isSpeechActive = false;
  DateTime? _speechStartTime;
  final List<int> _audioBuffer = [];
  
  // Handle messages from main isolate
  receivePort.listen((message) async {
    if (message is IsolateMessage) {
      try {
        switch (message.type) {
          case IsolateMessageType.initialize:
            // Initialize VAD and ASR services
            _vadService = SherpaVadService();
            _asrService = SherpaAsrService();
            
            final vadInitialized = await _vadService.initialize();
            final asrInitialized = await _asrService.initialize();
            
            if (vadInitialized && asrInitialized) {
              sendPort.send(IsolateResponse.initialized());
              debugPrint('IsolateAudioProcessor: Services initialized successfully in isolate');
            } else {
              sendPort.send(IsolateResponse.error('Failed to initialize services in isolate'));
            }
            break;
            
          case IsolateMessageType.processAudio:
            if (message.data is Map<String, dynamic>) {
              final data = message.data as Map<String, dynamic>;
              final pcmData = data['pcmData'] as Uint8List;
              final isFinal = data['isFinal'] as bool;
              
              // Add audio data to buffer
              _audioBuffer.addAll(pcmData);
              
              // Process VAD
              final speechDetected = _vadService.processAudioFrame(pcmData);
              
              // Send VAD result
              sendPort.send(IsolateResponse.vadResult(VadResult(
                isSpeech: speechDetected,
                confidence: 0.8, // Placeholder
                timestamp: DateTime.now(),
              )));
              
              // Handle speech state changes
              if (speechDetected && !_isSpeechActive) {
                _isSpeechActive = true;
                _speechStartTime = DateTime.now();
                sendPort.send(IsolateResponse.speechState(true));
              } else if (!speechDetected && _isSpeechActive) {
                _isSpeechActive = false;
                sendPort.send(IsolateResponse.speechState(false));
                
                // Process speech segment with ASR if we have enough audio
                if (_audioBuffer.isNotEmpty) {
                  final transcription = await _asrService.transcribeAudioBuffer(
                    Uint8List.fromList(_audioBuffer),
                  );
                  
                  if (transcription != null && transcription.text.isNotEmpty) {
                    sendPort.send(IsolateResponse.asrResult(AsrResult(
                      text: transcription.text,
                      confidence: transcription.confidence,
                      language: transcription.language,
                      timestamp: DateTime.now(),
                    )));
                  }
                  
                  // Clear buffer after processing
                  _audioBuffer.clear();
                }
              }
            }
            break;
            
          case IsolateMessageType.processFinal:
            if (message.data is Uint8List) {
              final pcmData = message.data as Uint8List;
              
              // Process final audio with ASR
              final transcription = await _asrService.transcribeAudioBuffer(pcmData);
              
              if (transcription != null && transcription.text.isNotEmpty) {
                sendPort.send(IsolateResponse.asrResult(AsrResult(
                  text: transcription.text,
                  confidence: transcription.confidence,
                  language: transcription.language,
                  timestamp: DateTime.now(),
                )));
              }
            }
            break;
            
          case IsolateMessageType.dispose:
            _vadService.dispose();
            _asrService.dispose();
            receivePort.close();
            debugPrint('IsolateAudioProcessor: Background isolate shutting down');
            break;
        }
      } catch (e) {
        sendPort.send(IsolateResponse.error('Error processing message in isolate: $e'));
      }
    }
  });
}

/// Message types for isolate communication
enum IsolateMessageType {
  initialize,
  processAudio,
  processFinal,
  dispose,
}

/// Messages sent to isolate
class IsolateMessage {
  final IsolateMessageType type;
  final dynamic data;
  
  IsolateMessage(this.type, this.data);
  
  factory IsolateMessage.initialize() => IsolateMessage(IsolateMessageType.initialize, null);
  factory IsolateMessage.processAudio(Uint8List pcmData, bool isFinal) => 
      IsolateMessage(IsolateMessageType.processAudio, {'pcmData': pcmData, 'isFinal': isFinal});
  factory IsolateMessage.processFinal(Uint8List pcmData) => 
      IsolateMessage(IsolateMessageType.processFinal, pcmData);
  factory IsolateMessage.dispose() => IsolateMessage(IsolateMessageType.dispose, null);
}

/// Response types from isolate
enum IsolateResponseType {
  vadResult,
  asrResult,
  speechState,
  error,
  initialized,
}

/// Responses from isolate
class IsolateResponse {
  final IsolateResponseType type;
  final dynamic data;
  
  IsolateResponse(this.type, this.data);
  
  factory IsolateResponse.vadResult(VadResult result) => IsolateResponse(IsolateResponseType.vadResult, result);
  factory IsolateResponse.asrResult(AsrResult result) => IsolateResponse(IsolateResponseType.asrResult, result);
  factory IsolateResponse.speechState(bool isSpeech) => IsolateResponse(IsolateResponseType.speechState, isSpeech);
  factory IsolateResponse.error(String error) => IsolateResponse(IsolateResponseType.error, error);
  factory IsolateResponse.initialized() => IsolateResponse(IsolateResponseType.initialized, null);
}

/// VAD result from isolate
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

/// ASR result from isolate
class AsrResult {
  final String text;
  final double confidence;
  final String language;
  final DateTime timestamp;
  
  AsrResult({
    required this.text,
    required this.confidence,
    required this.language,
    required this.timestamp,
  });
}
