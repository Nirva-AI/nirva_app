import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Deepgram service for cloud-based audio transcription
/// 
/// This service handles asynchronous transcription of audio files
/// using the Deepgram API without blocking the main thread
class DeepgramService extends ChangeNotifier {
  // Deepgram API configuration
  static const String _baseUrl = 'https://api.deepgram.com/v1/listen';
  
  /// Get the API key from environment variables
  String? get _apiKey {
    try {
      // Check if dotenv is initialized before accessing
      if (!dotenv.isInitialized) {
        debugPrint('DeepgramService: dotenv not initialized yet');
        return null;
      }
      return dotenv.env['DEEPGRAM_API_KEY'];
    } catch (e) {
      debugPrint('DeepgramService: Error reading API key from environment: $e');
      return null;
    }
  }
  
  // Service state
  bool _isInitialized = false;
  bool _isProcessing = false;
  
  // Transcription results
  final List<DeepgramTranscriptionResult> _transcriptionResults = [];
  final int _maxResultsHistory = 100;
  
  // Stream controllers
  final StreamController<DeepgramTranscriptionResult> _resultController = 
      StreamController<DeepgramTranscriptionResult>.broadcast();
  final StreamController<bool> _processingStateController = 
      StreamController<bool>.broadcast();
  
  // Getters
  bool get isInitialized => _isInitialized;
  bool get isProcessing => _isProcessing;
  List<DeepgramTranscriptionResult> get transcriptionResults => List.unmodifiable(_transcriptionResults);
  Stream<DeepgramTranscriptionResult> get resultStream => _resultController.stream;
  Stream<bool> get processingStateStream => _processingStateController.stream;
  
  /// Initialize the Deepgram service
  Future<bool> initialize() async {
    if (_isInitialized) {
      debugPrint('DeepgramService: Already initialized');
      return true;
    }
    
    try {
      debugPrint('DeepgramService: Initializing Deepgram service...');
      
      // Check if API key is configured
      if (_apiKey == null || _apiKey!.isEmpty) {
        debugPrint('DeepgramService: Warning - API key not configured');
        debugPrint('DeepgramService: Please set DEEPGRAM_API_KEY in your .env file');
        // For now, allow initialization without API key for testing
        // In production, this should return false
      } else {
        debugPrint('DeepgramService: API key configured successfully');
      }
      
      _isInitialized = true;
      debugPrint('DeepgramService: Deepgram service initialized successfully');
      notifyListeners();
      return true;
      
    } catch (e) {
      debugPrint('DeepgramService: Failed to initialize: $e');
      _isInitialized = false;
      notifyListeners();
      return false;
    }
  }
  
  /// Transcribe an audio file using Deepgram API
  /// 
  /// [audioFilePath] - Path to the audio file to transcribe
  /// [startTime] - Start time of the audio segment
  /// [endTime] - End time of the audio segment
  /// Returns the transcription result
  Future<DeepgramTranscriptionResult?> transcribeAudioFile(
    String audioFilePath, {
    DateTime? startTime,
    DateTime? endTime,
  }) async {
    if (!_isInitialized) {
      debugPrint('DeepgramService: Cannot transcribe - service not initialized');
      return null;
    }
    
    if (_apiKey == null || _apiKey!.isEmpty) {
      debugPrint('DeepgramService: Cannot transcribe - API key not configured');
      debugPrint('DeepgramService: Please set DEEPGRAM_API_KEY in your .env file');
      return null;
    }
    
    try {
      _isProcessing = true;
      _processingStateController.add(true);
      notifyListeners();
      
      debugPrint('DeepgramService: Starting transcription of: $audioFilePath');
      
      // Read the audio file
      final audioFile = File(audioFilePath);
      if (!await audioFile.exists()) {
        throw Exception('Audio file not found: $audioFilePath');
      }
      
      final audioBytes = await audioFile.readAsBytes();
      debugPrint('DeepgramService: Audio file size: ${audioBytes.length} bytes');
      debugPrint('DeepgramService: Audio file path: $audioFilePath');
      
      // Verify file size
      final fileSize = await audioFile.length();
      debugPrint('DeepgramService: File size from file system: $fileSize bytes');
      if (fileSize != audioBytes.length) {
        debugPrint('DeepgramService: Warning - File size mismatch: expected $fileSize, got ${audioBytes.length}');
      }
      
      // Validate WAV file format
      if (audioBytes.length < 44) {
        throw Exception('Audio file too small to be a valid WAV file');
      }
      
      // Check WAV header magic bytes
      final riffHeader = String.fromCharCodes(audioBytes.take(4));
      final waveHeader = String.fromCharCodes(audioBytes.skip(8).take(4));
      debugPrint('DeepgramService: WAV header validation - RIFF: "$riffHeader", WAVE: "$waveHeader"');
      
      if (riffHeader != 'RIFF' || waveHeader != 'WAVE') {
        throw Exception('Invalid WAV file format - RIFF: "$riffHeader", WAVE: "$waveHeader"');
      }
      
      // Check audio format (should be PCM = 1)
      final audioFormat = audioBytes[20] | (audioBytes[21] << 8);
      debugPrint('DeepgramService: WAV audio format: $audioFormat (should be 1 for PCM)');
      
      if (audioFormat != 1) {
        throw Exception('WAV file is not PCM format: $audioFormat');
      }
      
      debugPrint('DeepgramService: WAV file validation complete - ready for Deepgram API');
      
      // Try sending audio data directly in request body instead of multipart
      // This might fix the 400 error from Deepgram
      
      // Build URI with query parameters
      final uri = Uri.parse(_baseUrl).replace(queryParameters: {
        'model': 'nova-2', // Use the standard nova-2 model
        'detect_language': 'true', // Enable automatic language detection
      });
      
      final request = http.Request('POST', uri);
      
      // Add headers
      request.headers['Authorization'] = 'Token $_apiKey';
      request.headers['Content-Type'] = 'audio/wav'; // Specify WAV content type
      debugPrint('DeepgramService: Request headers: ${request.headers}');
      
      // Send the WAV file directly in the request body
      final filename = audioFile.path.split('/').last;
      debugPrint('DeepgramService: Sending WAV file in body: $filename (${audioBytes.length} bytes)');
      
      // Set the request body directly
      request.bodyBytes = audioBytes;
      
      debugPrint('DeepgramService: Sending request to Deepgram...');
      debugPrint('DeepgramService: Request URL: ${request.url}');
      debugPrint('DeepgramService: Request body size: ${request.bodyBytes?.length ?? 0} bytes');
      
      // Send request asynchronously to avoid blocking main thread
      final response = await request.send().timeout(
        const Duration(minutes: 5), // 5 minute timeout
        onTimeout: () {
          throw TimeoutException('Transcription request timed out', const Duration(minutes: 5));
        },
      );
      
      final responseBody = await response.stream.bytesToString();
      debugPrint('DeepgramService: Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseBody);
        debugPrint('DeepgramService: Transcription successful');
        
        // Parse the response
        final result = _parseDeepgramResponse(jsonResponse, startTime, endTime);
        
        if (result != null) {
          // Add to results history
          _addToResultsHistory(result);
          
          // Broadcast result
          _resultController.add(result);
          
          debugPrint('DeepgramService: Transcription result: "${result.transcription}"');
        }
        
        return result;
        
      } else {
        debugPrint('DeepgramService: Transcription failed with status: ${response.statusCode}');
        debugPrint('DeepgramService: Response body: $responseBody');
        throw Exception('Transcription failed: ${response.statusCode} - $responseBody');
      }
      
    } catch (e) {
      debugPrint('DeepgramService: Error during transcription: $e');
      
      // Create error result
      final errorResult = DeepgramTranscriptionResult(
        transcription: 'Transcription failed: $e',
        confidence: 0.0,
        language: 'en',
        startTime: startTime,
        endTime: endTime,
        processingTime: DateTime.now(),
        isError: true,
        errorMessage: e.toString(),
      );
      
      // Add to results history
      _addToResultsHistory(errorResult);
      
      // Broadcast error result
      _resultController.add(errorResult);
      
      return errorResult;
      
    } finally {
      _isProcessing = false;
      _processingStateController.add(false);
      notifyListeners();
    }
  }
  
  /// Parse Deepgram API response
  DeepgramTranscriptionResult? _parseDeepgramResponse(
    Map<String, dynamic> jsonResponse,
    DateTime? startTime,
    DateTime? endTime,
  ) {
    try {
      final results = jsonResponse['results'] as Map<String, dynamic>?;
      if (results == null) return null;
      
      final channels = results['channels'] as List<dynamic>?;
      if (channels == null || channels.isEmpty) return null;
      
      final channel = channels.first as Map<String, dynamic>;
      final alternatives = channel['alternatives'] as List<dynamic>?;
      if (alternatives == null || alternatives.isEmpty) return null;
      
      final alternative = alternatives.first as Map<String, dynamic>;
      final transcript = alternative['transcript'] as String? ?? '';
      final confidence = (alternative['confidence'] as num?)?.toDouble() ?? 0.0;
      
      // Extract language if available
      final language = jsonResponse['metadata']?['language'] as String? ?? 'en';
      
      return DeepgramTranscriptionResult(
        transcription: transcript.trim(),
        confidence: confidence,
        language: language,
        startTime: startTime,
        endTime: endTime,
        processingTime: DateTime.now(),
        isError: false,
        errorMessage: null,
      );
      
    } catch (e) {
      debugPrint('DeepgramService: Error parsing response: $e');
      return null;
    }
  }
  
  /// Add result to history with size limit
  void _addToResultsHistory(DeepgramTranscriptionResult result) {
    _transcriptionResults.add(result);
    
    // Keep only the latest results
    if (_transcriptionResults.length > _maxResultsHistory) {
      _transcriptionResults.removeRange(0, _transcriptionResults.length - _maxResultsHistory);
    }
  }
  
  /// Clear all transcription results
  void clearResults() {
    _transcriptionResults.clear();
    debugPrint('DeepgramService: Transcription results cleared');
    notifyListeners();
  }
  
  /// Get the latest transcription result
  DeepgramTranscriptionResult? get latestResult {
    return _transcriptionResults.isNotEmpty ? _transcriptionResults.last : null;
  }
  
  /// Get results for a specific time range
  List<DeepgramTranscriptionResult> getResultsInRange(DateTime start, DateTime end) {
    return _transcriptionResults.where((result) {
      return result.processingTime.isAfter(start) && result.processingTime.isBefore(end);
    }).toList();
  }
  
  /// Get current service statistics
  Map<String, dynamic> getStats() {
    return {
      'isInitialized': _isInitialized,
      'isProcessing': _isProcessing,
      'transcriptionResultsCount': _transcriptionResults.length,
      'apiKeyConfigured': _apiKey != null && _apiKey!.isNotEmpty && _apiKey != '',
      'maxResultsHistory': _maxResultsHistory,
    };
  }
  
  @override
  void dispose() {
    _resultController.close();
    _processingStateController.close();
    super.dispose();
  }
}

/// Represents a transcription result from Deepgram
class DeepgramTranscriptionResult {
  final String transcription;
  final double confidence;
  final String language;
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime processingTime;
  final bool isError;
  final String? errorMessage;
  
  const DeepgramTranscriptionResult({
    required this.transcription,
    required this.confidence,
    required this.language,
    this.startTime,
    this.endTime,
    required this.processingTime,
    required this.isError,
    this.errorMessage,
  });
  
  /// Get the duration of the audio segment
  Duration? get duration {
    if (startTime != null && endTime != null) {
      return endTime!.difference(startTime!);
    }
    return null;
  }
  
  /// Check if this is a successful transcription
  bool get isSuccess => !isError && transcription.isNotEmpty;
  
  @override
  String toString() {
    return 'DeepgramTranscriptionResult(transcription: "$transcription", confidence: $confidence, language: $language, isError: $isError)';
  }
}
