import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

/// Audio processing isolate for handling VAD and ASR in background
/// 
/// This isolate runs VAD and ASR processing completely off the main thread
/// to prevent UI freezing during heavy computational work.
class AudioProcessingIsolate {
  static const String _isolateName = 'AudioProcessingIsolate';
  
  // Isolate management
  Isolate? _isolate;
  SendPort? _sendPort;
  ReceivePort? _receivePort;
  
  // State
  bool _isInitialized = false;
  bool _isProcessing = false;
  
  // Stream controllers for results
  final StreamController<VadResult> _vadResultController = 
      StreamController<VadResult>.broadcast();
  final StreamController<AsrResult> _asrResultController = 
      StreamController<AsrResult>.broadcast();
  
  // Getters
  bool get isInitialized => _isInitialized;
  bool get isProcessing => _isProcessing;
  Stream<VadResult> get vadResultStream => _vadResultController.stream;
  Stream<AsrResult> get asrResultStream => _asrResultController.stream;
  
  /// Initialize the audio processing isolate
  Future<bool> initialize() async {
    if (_isInitialized) {
      debugPrint('AudioProcessingIsolate: Already initialized');
      return true;
    }
    
    try {
      debugPrint('AudioProcessingIsolate: Initializing audio processing isolate...');
      
      // Create receive port for communication
      _receivePort = ReceivePort();
      
      // Create isolate
      _isolate = await Isolate.spawn(
        _isolateEntryPoint,
        _receivePort!.sendPort,
        debugName: _isolateName,
      );
      
      // Set up message handling
      _receivePort!.listen(_handleIsolateMessage);
      
      // Wait for isolate to be ready
      final completer = Completer<bool>();
      Timer(const Duration(seconds: 5), () {
        if (!completer.isCompleted) {
          completer.complete(false);
        }
      });
      
      // Send initialization message
      _sendPort = await _receivePort!.first as SendPort;
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
        debugPrint('AudioProcessingIsolate: Audio processing isolate initialized successfully');
      } else {
        debugPrint('AudioProcessingIsolate: Failed to initialize isolate within timeout');
      }
      
      return success;
      
    } catch (e) {
      debugPrint('AudioProcessingIsolate: Failed to initialize isolate: $e');
      return false;
    }
  }
  
  /// Process VAD in background isolate
  Future<void> processVad(Uint8List pcmData) async {
    if (!_isInitialized || _sendPort == null) {
      debugPrint('AudioProcessingIsolate: Cannot process VAD - not initialized');
      return;
    }
    
    try {
      _isProcessing = true;
      
      // Send VAD processing message to isolate
      _sendPort!.send(IsolateMessage.processVad(pcmData));
      
    } catch (e) {
      debugPrint('AudioProcessingIsolate: Error sending VAD processing message: $e');
    } finally {
      _isProcessing = false;
    }
  }
  
  /// Process ASR in background isolate
  Future<void> processAsr(Uint8List pcmData) async {
    if (!_isInitialized || _sendPort == null) {
      debugPrint('AudioProcessingIsolate: Cannot process ASR - not initialized');
      return;
    }
    
    try {
      _isProcessing = true;
      
      // Send ASR processing message to isolate
      _sendPort!.send(IsolateMessage.processAsr(pcmData));
      
    } catch (e) {
      debugPrint('AudioProcessingIsolate: Error sending ASR processing message: $e');
    } finally {
      _isProcessing = false;
    }
  }
  
  /// Handle messages from the isolate
  void _handleIsolateMessage(dynamic message) {
    if (message is IsolateResponse) {
      switch (message.type) {
        case IsolateResponseType.vadResult:
          if (message.data is VadResult) {
            _vadResultController.add(message.data as VadResult);
          }
          break;
        case IsolateResponseType.asrResult:
          if (message.data is AsrResult) {
            _asrResultController.add(message.data as AsrResult);
          }
          break;
        case IsolateResponseType.error:
          debugPrint('AudioProcessingIsolate: Isolate error: ${message.data}');
          break;
        case IsolateResponseType.initialized:
          debugPrint('AudioProcessingIsolate: Isolate initialization confirmed');
          break;
      }
    }
  }
  
  /// Dispose the isolate and clean up resources
  void dispose() {
    debugPrint('AudioProcessingIsolate: Disposing audio processing isolate...');
    
    // Send dispose message to isolate
    if (_sendPort != null) {
      try {
        _sendPort!.send(IsolateMessage.dispose());
      } catch (e) {
        debugPrint('AudioProcessingIsolate: Error sending dispose message: $e');
      }
    }
    
    // Kill isolate
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    
    // Close receive port
    _receivePort?.close();
    _receivePort = null;
    
    // Close stream controllers
    _vadResultController.close();
    _asrResultController.close();
    
    _isInitialized = false;
    _isProcessing = false;
    
    debugPrint('AudioProcessingIsolate: Audio processing isolate disposed');
  }
}

/// Isolate entry point - runs in background isolate
void _isolateEntryPoint(SendPort sendPort) {
  debugPrint('AudioProcessingIsolate: Background isolate started');
  
  // Create receive port for this isolate
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  
  // Initialize VAD and ASR services in isolate
  late final VadIsolateService _vadService;
  late final AsrIsolateService _asrService;
  
  // Handle messages from main isolate
  receivePort.listen((message) async {
    if (message is IsolateMessage) {
      try {
        switch (message.type) {
          case IsolateMessageType.initialize:
            // Initialize VAD and ASR services
            _vadService = VadIsolateService();
            _asrService = AsrIsolateService();
            
            final vadInitialized = await _vadService.initialize();
            final asrInitialized = await _asrService.initialize();
            
            if (vadInitialized && asrInitialized) {
              sendPort.send(IsolateResponse.initialized());
              debugPrint('AudioProcessingIsolate: Services initialized successfully');
            } else {
              sendPort.send(IsolateResponse.error('Failed to initialize services'));
            }
            break;
            
          case IsolateMessageType.processVad:
            if (message.data is Uint8List) {
              final result = await _vadService.processAudio(message.data as Uint8List);
              sendPort.send(IsolateResponse.vadResult(result));
            }
            break;
            
          case IsolateMessageType.processAsr:
            if (message.data is Uint8List) {
              final result = await _asrService.transcribe(message.data as Uint8List);
              sendPort.send(IsolateResponse.asrResult(result));
            }
            break;
            
          case IsolateMessageType.dispose:
            _vadService.dispose();
            _asrService.dispose();
            receivePort.close();
            debugPrint('AudioProcessingIsolate: Background isolate shutting down');
            break;
        }
      } catch (e) {
        sendPort.send(IsolateResponse.error('Error processing message: $e'));
      }
    }
  });
}

/// VAD service that runs in the isolate
class VadIsolateService {
  bool _isInitialized = false;
  
  Future<bool> initialize() async {
    // Initialize VAD service in isolate
    // This would contain the actual VAD initialization code
    _isInitialized = true;
    return true;
  }
  
  Future<VadResult> processAudio(Uint8List pcmData) async {
    // Process VAD in isolate
    // This would contain the actual VAD processing code
    return VadResult(
      isSpeech: true, // Placeholder
      confidence: 0.8, // Placeholder
      timestamp: DateTime.now(),
    );
  }
  
  void dispose() {
    _isInitialized = false;
  }
}

/// ASR service that runs in the isolate
class AsrIsolateService {
  bool _isInitialized = false;
  
  Future<bool> initialize() async {
    // Initialize ASR service in isolate
    // This would contain the actual ASR initialization code
    _isInitialized = true;
    return true;
  }
  
  Future<AsrResult> transcribe(Uint8List pcmData) async {
    // Process ASR in isolate
    // This would contain the actual ASR processing code
    return AsrResult(
      text: 'Transcribed text', // Placeholder
      confidence: 0.9, // Placeholder
      language: 'en',
      timestamp: DateTime.now(),
    );
  }
  
  void dispose() {
    _isInitialized = false;
  }
}

/// Message types for isolate communication
enum IsolateMessageType {
  initialize,
  processVad,
  processAsr,
  dispose,
}

/// Messages sent to isolate
class IsolateMessage {
  final IsolateMessageType type;
  final dynamic data;
  
  IsolateMessage(this.type, this.data);
  
  factory IsolateMessage.initialize() => IsolateMessage(IsolateMessageType.initialize, null);
  factory IsolateMessage.processVad(Uint8List pcmData) => IsolateMessage(IsolateMessageType.processVad, pcmData);
  factory IsolateMessage.processAsr(Uint8List pcmData) => IsolateMessage(IsolateMessageType.processAsr, pcmData);
  factory IsolateMessage.dispose() => IsolateMessage(IsolateMessageType.dispose, null);
}

/// Response types from isolate
enum IsolateResponseType {
  vadResult,
  asrResult,
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
