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
        
        // Debug: Log the complete API response
        debugPrint('DeepgramService: === FULL DEEPGRAM API RESPONSE ===');
        debugPrint('DeepgramService: Response body length: ${responseBody.length} characters');
        debugPrint('DeepgramService: Raw response body:');
        debugPrint(responseBody);
        debugPrint('DeepgramService: Response JSON keys: ${jsonResponse.keys.toList()}');
        
        // Log the complete response structure
        _logCompleteApiResponse(jsonResponse);
        
        debugPrint('DeepgramService: === END FULL RESPONSE ===');
        
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
  
  /// Log the complete API response structure for debugging
  void _logCompleteApiResponse(Map<String, dynamic> jsonResponse) {
    try {
      debugPrint('DeepgramService: Root level fields:');
      for (final entry in jsonResponse.entries) {
        final key = entry.key;
        final value = entry.value;
        
        if (value is Map) {
          debugPrint('  $key: Map with ${value.length} keys: ${value.keys.toList()}');
        } else if (value is List) {
          debugPrint('  $key: List with ${value.length} items');
        } else {
          debugPrint('  $key: $value');
        }
      }
      
      // Log results section in detail
      if (jsonResponse.containsKey('results')) {
        final results = jsonResponse['results'] as Map<String, dynamic>?;
        if (results != null) {
          debugPrint('DeepgramService: Results section fields: ${results.keys.toList()}');
          
          // Check for transcription fields directly in results section
          for (final entry in results.entries) {
            final key = entry.key;
            final value = entry.value;
            
            if (value is String && (key.toLowerCase().contains('transcript') || 
                                   key.toLowerCase().contains('text') || 
                                   key.toLowerCase().contains('content'))) {
              debugPrint('DeepgramService: Found transcription-like field "$key" in results section with length: ${value.length}');
              debugPrint('DeepgramService: Results "$key" content: "$value"');
            }
          }
          
          // Log channels
          if (results.containsKey('channels')) {
            final channels = results['channels'] as List<dynamic>?;
            if (channels != null && channels.isNotEmpty) {
              debugPrint('DeepgramService: Found ${channels.length} channels');
              
              for (int i = 0; i < channels.length; i++) {
                final channel = channels[i] as Map<String, dynamic>;
                debugPrint('DeepgramService: Channel $i fields: ${channel.keys.toList()}');
                
                // Check for transcription fields directly in channel section
                for (final entry in channel.entries) {
                  final key = entry.key;
                  final value = entry.value;
                  
                  if (value is String && (key.toLowerCase().contains('transcript') || 
                                         key.toLowerCase().contains('text') || 
                                         key.toLowerCase().contains('content'))) {
                    debugPrint('DeepgramService: Found transcription-like field "$key" in channel $i with length: ${value.length}');
                    debugPrint('DeepgramService: Channel $i "$key" content: "$value"');
                  }
                }
                
                // Log alternatives
                if (channel.containsKey('alternatives')) {
                  final alternatives = channel['alternatives'] as List<dynamic>?;
                  if (alternatives != null && alternatives.isNotEmpty) {
                    debugPrint('DeepgramService: Channel $i has ${alternatives.length} alternatives');
                    
                    for (int j = 0; j < alternatives.length; j++) {
                      final alternative = alternatives[j] as Map<String, dynamic>;
                      debugPrint('DeepgramService: Alternative $j fields: ${alternative.keys.toList()}');
                      
                      // Check for transcription fields directly in alternative section
                      for (final entry in alternative.entries) {
                        final key = entry.key;
                        final value = entry.value;
                        
                        if (value is String && (key.toLowerCase().contains('transcript') || 
                                               key.toLowerCase().contains('text') || 
                                               key.toLowerCase().contains('content'))) {
                          debugPrint('DeepgramService: Found transcription-like field "$key" in alternative $j with length: ${value.length}');
                          debugPrint('DeepgramService: Alternative $j "$key" content: "$value"');
                        }
                      }
                      
                      // Log transcript details
                      if (alternative.containsKey('transcript')) {
                        final transcript = alternative['transcript'] as String? ?? '';
                        debugPrint('DeepgramService: Alternative $j transcript length: ${transcript.length}');
                        debugPrint('DeepgramService: Alternative $j transcript: "$transcript"');
                        
                        // Show first and last 100 characters for long transcripts
                        if (transcript.length > 200) {
                          debugPrint('DeepgramService: Alternative $j transcript preview (first 100): "${transcript.substring(0, 100)}..."');
                          debugPrint('DeepgramService: Alternative $j transcript preview (last 100): "...${transcript.substring(transcript.length - 100)}"');
                        }
                      }
                      
                      // Log confidence
                      if (alternative.containsKey('confidence')) {
                        final confidence = alternative['confidence'];
                        debugPrint('DeepgramService: Alternative $j confidence: $confidence');
                      }
                      
                      // Check for additional transcription fields
                      for (final field in alternative.keys) {
                        if (field.toLowerCase().contains('transcript') || 
                            field.toLowerCase().contains('text') || 
                            field.toLowerCase().contains('content')) {
                          final value = alternative[field];
                          if (value is String && value.isNotEmpty) {
                            debugPrint('DeepgramService: Alternative $j has transcription-like field "$field" with length: ${value.length}');
                            if (value.length > 100) {
                              debugPrint('DeepgramService: Alternative $j "$field" preview (first 100): "${value.substring(0, 100)}..."');
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
      
      // Log metadata section
      if (jsonResponse.containsKey('metadata')) {
        final metadata = jsonResponse['metadata'] as Map<String, dynamic>?;
        if (metadata != null) {
          debugPrint('DeepgramService: Metadata section fields: ${metadata.keys.toList()}');
          for (final entry in metadata.entries) {
            debugPrint('  ${entry.key}: ${entry.value}');
          }
          
          // Check for transcription fields in metadata section
          for (final entry in metadata.entries) {
            final key = entry.key;
            final value = entry.value;
            
            if (value is String && (key.toLowerCase().contains('transcript') || 
                                   key.toLowerCase().contains('text') || 
                                   key.toLowerCase().contains('content'))) {
              debugPrint('DeepgramService: Found transcription-like field "$key" in metadata with length: ${value.length}');
              debugPrint('DeepgramService: Metadata "$key" content: "$value"');
            }
          }
        }
      }
      
      // Log any other sections
      for (final entry in jsonResponse.entries) {
        final key = entry.key;
        final value = entry.value;
        
        if (key != 'results' && key != 'metadata' && value is Map) {
          debugPrint('DeepgramService: Additional section "$key" with fields: ${value.keys.toList()}');
          for (final subEntry in value.entries) {
            debugPrint('  ${subEntry.key}: ${subEntry.value}');
          }
          
          // Check for transcription fields in additional sections
          for (final subEntry in value.entries) {
            final subKey = subEntry.key;
            final subValue = subEntry.value;
            
            if (subValue is String && (subKey.toLowerCase().contains('transcript') || 
                                      subKey.toLowerCase().contains('text') || 
                                      subKey.toLowerCase().contains('content'))) {
              debugPrint('DeepgramService: Found transcription-like field "$subKey" in section "$key" with length: ${subValue.length}');
              debugPrint('DeepgramService: Section "$key" "$subKey" content: "$subValue"');
            }
          }
        }
      }
      
      // Check for any transcription-related fields in the root response
      debugPrint('DeepgramService: Checking for transcription fields in root response...');
      for (final entry in jsonResponse.entries) {
        final key = entry.key;
        final value = entry.value;
        
        if (value is String && (key.toLowerCase().contains('transcript') || 
                               key.toLowerCase().contains('text') || 
                               key.toLowerCase().contains('content'))) {
          debugPrint('DeepgramService: Found transcription-like field "$key" with length: ${value.length}');
          debugPrint('DeepgramService: "$key" content: "$value"');
        }
      }
      
      // Recursively check for transcription fields in nested structures
      debugPrint('DeepgramService: Recursively checking for transcription fields in nested structures...');
      _checkNestedTranscriptionFields(jsonResponse, 'root');
      
    } catch (e) {
      debugPrint('DeepgramService: Error logging API response: $e');
    }
  }

  /// Recursively check for transcription fields in nested structures
  void _checkNestedTranscriptionFields(dynamic data, String path, {int maxDepth = 5, int currentDepth = 0}) {
    if (currentDepth >= maxDepth) return;
    
    try {
      if (data is Map) {
        for (final entry in data.entries) {
          final key = entry.key;
          final value = entry.value;
          final currentPath = '$path.$key';
          
          if (value is String && (key.toLowerCase().contains('transcript') || 
                                 key.toLowerCase().contains('text') || 
                                 key.toLowerCase().contains('content'))) {
            debugPrint('DeepgramService: Found transcription-like field "$currentPath" with length: ${value.length}');
            debugPrint('DeepgramService: "$currentPath" content: "$value"');
          }
          
          // Recursively check nested structures
          _checkNestedTranscriptionFields(value, currentPath, maxDepth: maxDepth, currentDepth: currentDepth + 1);
        }
      } else if (data is List) {
        for (int i = 0; i < data.length; i++) {
          final value = data[i];
          final currentPath = '$path[$i]';
          
          // Recursively check nested structures
          _checkNestedTranscriptionFields(value, currentPath, maxDepth: maxDepth, currentDepth: currentDepth + 1);
        }
      }
    } catch (e) {
      debugPrint('DeepgramService: Error checking nested transcription fields at path $path: $e');
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
      if (results == null) {
        debugPrint('DeepgramService: No results section found in response');
        return null;
      }
      
      final channels = results['channels'] as List<dynamic>?;
      if (channels == null || channels.isEmpty) {
        debugPrint('DeepgramService: No channels found in results');
        return null;
      }
      
      final channel = channels.first as Map<String, dynamic>;
      debugPrint('DeepgramService: Processing channel with fields: ${channel.keys.toList()}');
      
      final alternatives = channel['alternatives'] as List<dynamic>?;
      if (alternatives == null || alternatives.isEmpty) {
        debugPrint('DeepgramService: No alternatives found in channel');
        return null;
      }
      
      final alternative = alternatives.first as Map<String, dynamic>;
      debugPrint('DeepgramService: Processing alternative with fields: ${alternative.keys.toList()}');
      
      // Look for transcript in various possible fields
      String? transcript;
      if (alternative.containsKey('transcript')) {
        transcript = alternative['transcript'] as String? ?? '';
        debugPrint('DeepgramService: Found transcript in "transcript" field');
      } else if (alternative.containsKey('text')) {
        transcript = alternative['text'] as String? ?? '';
        debugPrint('DeepgramService: Found transcript in "text" field');
      } else if (alternative.containsKey('content')) {
        transcript = alternative['content'] as String? ?? '';
        debugPrint('DeepgramService: Found transcript in "content" field');
      } else {
        debugPrint('DeepgramService: No transcript field found in alternative');
        debugPrint('DeepgramService: Available fields: ${alternative.keys.toList()}');
        return null;
      }
      
      final confidence = (alternative['confidence'] as num?)?.toDouble() ?? 0.0;
      
      // Debug: Log full transcript details
      debugPrint('DeepgramService: Raw transcript length: ${transcript.length}');
      debugPrint('DeepgramService: Raw transcript: "$transcript"');
      
      // Check for additional transcript fields that might contain longer content
      for (final field in alternative.keys) {
        if (field.toLowerCase().contains('transcript') || 
            field.toLowerCase().contains('text') || 
            field.toLowerCase().contains('content')) {
          final value = alternative[field];
          if (value is String && value.isNotEmpty) {
            debugPrint('DeepgramService: Found transcript-like field "$field" with length: ${value.length}');
            if (value.length > transcript.length) {
              debugPrint('DeepgramService: Field "$field" has longer content than main transcript');
              debugPrint('DeepgramService: "$field" content: "$value"');
            }
          }
        }
      }
      
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
      debugPrint('DeepgramService: Stack trace: ${StackTrace.current}');
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
