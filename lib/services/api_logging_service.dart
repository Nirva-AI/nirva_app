import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Simple API Response Logging Service
/// 
/// This service only logs API responses from Deepgram transcription
/// to a file for debugging and analysis purposes
class ApiLoggingService {
  static const String _logFileName = 'api_responses.txt';
  File? _logFile;
  
  /// Initialize the logging service
  Future<void> initialize() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final logDir = Directory('${appDir.path}/logs');
      
      if (!await logDir.exists()) {
        await logDir.create(recursive: true);
      }
      
      _logFile = File('${logDir.path}/$_logFileName');
      
      // Create log file if it doesn't exist
      if (!await _logFile!.exists()) {
        await _logFile!.writeAsString('');
      }
      
      debugPrint('ApiLoggingService: Initialized. Log file: ${_logFile!.path}');
      debugPrint('ApiLoggingService: App documents directory: ${appDir.path}');
      debugPrint('ApiLoggingService: Logs directory: ${logDir.path}');
    } catch (e) {
      debugPrint('ApiLoggingService: Error initializing: $e');
    }
  }
  
  /// Log Deepgram transcription API response
  Future<void> logTranscriptionResponse({
    required String audioSegmentPath,
    required String transcription,
    double? confidence,
    String? language,
    Duration? processingTime,
    Map<String, dynamic>? rawResponse,
    String? error,
  }) async {
    if (_logFile == null) return;
    
    try {
      final timestamp = DateTime.now().toString();
      final logLine = '''=== DEEPGRAM TRANSCRIPTION RESPONSE ===
Timestamp: $timestamp
Audio File: $audioSegmentPath
Transcription: $transcription
Confidence: ${confidence ?? 'N/A'}
Language: ${language ?? 'N/A'}
Processing Time: ${processingTime?.inMilliseconds ?? 'N/A'}ms
Error: ${error ?? 'None'}

=== COMPLETE RAW API RESPONSE ===
${rawResponse != null ? jsonEncode(rawResponse) : 'No raw response available'}

=== END RESPONSE ===

''';
      // Read existing content
      String existingContent = '';
      if (await _logFile!.exists()) {
        existingContent = await _logFile!.readAsString(encoding: utf8);
      }
      
      // Prepend new log entry (latest first)
      final newContent = logLine + existingContent;
      await _logFile!.writeAsString(newContent, encoding: utf8);
      
      debugPrint('ApiLoggingService: Logged transcription response for: $audioSegmentPath');
      
      // Display log contents after writing (for debugging)
      await displayLogContents();
    } catch (e) {
      debugPrint('ApiLoggingService: Error logging transcription response: $e');
    }
  }
  
  /// Get log file path
  String? get logFilePath => _logFile?.path;
  
  /// Get log file size
  Future<int> get logFileSize async {
    if (_logFile == null) return 0;
    try {
      return await _logFile!.length();
    } catch (e) {
      return 0;
    }
  }
  
  /// Get log statistics
  Map<String, dynamic> getLogStats() {
    return {
      'logFilePath': logFilePath,
      'logFileName': _logFileName,
    };
  }
  
  /// Read and display log file contents
  Future<void> displayLogContents() async {
    if (_logFile == null) {
      debugPrint('ApiLoggingService: No log file available');
      return;
    }
    
    try {
      if (await _logFile!.exists()) {
        final contents = await _logFile!.readAsString(encoding: utf8);
        final lines = contents.split('\n').where((line) => line.isNotEmpty).length;
        debugPrint('ApiLoggingService: Log file exists with $lines entries');
        debugPrint('ApiLoggingService: Log file path: ${_logFile!.path}');
        
        if (contents.isNotEmpty) {
          debugPrint('ApiLoggingService: First few log entries:');
          final entries = contents.split('\n').where((line) => line.isNotEmpty && line.startsWith('===')).take(3);
          for (final entry in entries) {
            debugPrint('  - $entry');
          }
        }
      } else {
        debugPrint('ApiLoggingService: Log file does not exist at: ${_logFile!.path}');
      }
    } catch (e) {
      debugPrint('ApiLoggingService: Error reading log file: $e');
    }
  }
}
