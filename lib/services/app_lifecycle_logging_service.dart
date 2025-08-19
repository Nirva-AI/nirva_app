import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

/// App Lifecycle Logging Service
/// 
/// This service tracks app lifecycle events, including when the app gets killed
/// or closed by the OS. It logs to a file for debugging and analysis purposes.
class AppLifecycleLoggingService {
  static const String _logFileName = 'app_lifecycle_events.txt';
  File? _logFile;
  
  // App state tracking
  AppLifecycleState? _lastKnownState;
  DateTime? _lastStateChangeTime;
  int _stateChangeCount = 0;
  
  // System info
  String? _deviceInfo;
  String? _appVersion;
  
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
      
      // Get device info
      await _getDeviceInfo();
      
      // Log initialization
      await _logEvent(
        eventType: 'SERVICE_INITIALIZED',
        details: {
          'logFilePath': _logFile!.path,
          'deviceInfo': _deviceInfo,
          'appVersion': _appVersion,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      
      debugPrint('AppLifecycleLoggingService: Initialized. Log file: ${_logFile!.path}');
    } catch (e) {
      debugPrint('AppLifecycleLoggingService: Error initializing: $e');
    }
  }
  
  /// Get device information
  Future<void> _getDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        _deviceInfo = 'Android';
      } else if (Platform.isIOS) {
        _deviceInfo = 'iOS';
      } else {
        _deviceInfo = 'Unknown Platform';
      }
      
      // Get app version if available
      try {
        const platform = MethodChannel('app_info');
        final result = await platform.invokeMethod('getAppVersion');
        _appVersion = result.toString();
      } catch (e) {
        _appVersion = 'Unknown';
      }
    } catch (e) {
      _deviceInfo = 'Error getting device info: $e';
    }
  }
  
  /// Log app lifecycle state change
  Future<void> logAppLifecycleStateChange(AppLifecycleState newState) async {
    final now = DateTime.now();
    final previousState = _lastKnownState;
    final timeSinceLastChange = _lastStateChangeTime != null 
        ? now.difference(_lastStateChangeTime!).inMilliseconds 
        : 0;
    
    _lastKnownState = newState;
    _lastStateChangeTime = now;
    _stateChangeCount++;
    
    await _logEvent(
      eventType: 'LIFECYCLE_STATE_CHANGE',
      details: {
        'previousState': previousState?.toString() ?? 'UNKNOWN',
        'newState': newState.toString(),
        'timeSinceLastChange': timeSinceLastChange,
        'stateChangeCount': _stateChangeCount,
        'timestamp': now.toIso8601String(),
        'isCritical': _isCriticalStateChange(previousState, newState),
      },
    );
    
    // Log additional details for critical state changes
    if (_isCriticalStateChange(previousState, newState)) {
      await _logCriticalStateChange(previousState, newState, now);
    }
  }
  
  /// Check if this is a critical state change (app being killed/closed)
  bool _isCriticalStateChange(AppLifecycleState? previous, AppLifecycleState current) {
    // App going from active to detached (killed by OS)
    if (previous == AppLifecycleState.resumed && current == AppLifecycleState.detached) {
      return true;
    }
    
    // App going from paused to detached (killed while in background)
    if (previous == AppLifecycleState.paused && current == AppLifecycleState.detached) {
      return true;
    }
    
    // App going from inactive to detached (killed during task switching)
    if (previous == AppLifecycleState.inactive && current == AppLifecycleState.detached) {
      return true;
    }
    
    return false;
  }
  
  /// Log critical state change with additional details
  Future<void> _logCriticalStateChange(
    AppLifecycleState? previous, 
    AppLifecycleState current, 
    DateTime timestamp
  ) async {
    await _logEvent(
      eventType: 'CRITICAL_STATE_CHANGE',
      details: {
        'previousState': previous?.toString() ?? 'UNKNOWN',
        'newState': current.toString(),
        'timestamp': timestamp.toIso8601String(),
        'description': 'App appears to be killed or closed by OS',
        'possibleReasons': _getPossibleKillReasons(previous),
        'deviceInfo': _deviceInfo,
        'appVersion': _appVersion,
      },
    );
  }
  
  /// Get possible reasons why the app might have been killed
  List<String> _getPossibleKillReasons(AppLifecycleState? previousState) {
    final reasons = <String>[];
    
    if (previousState == AppLifecycleState.resumed) {
      reasons.addAll([
        'User force-closed the app',
        'OS killed app due to memory pressure',
        'App crashed or encountered fatal error',
        'System update or restart',
      ]);
    } else if (previousState == AppLifecycleState.paused) {
      reasons.addAll([
        'OS killed app while in background',
        'Background execution time limit exceeded',
        'Memory pressure while app was backgrounded',
        'User manually killed app from recent apps',
      ]);
    } else if (previousState == AppLifecycleState.inactive) {
      reasons.addAll([
        'App killed during task switching',
        'System interruption (call, notification, etc.)',
        'OS killed app during state transition',
      ]);
    }
    
    return reasons;
  }
  
  /// Log app resume event
  Future<void> logAppResumed() async {
    await _logEvent(
      eventType: 'APP_RESUMED',
      details: {
        'timestamp': DateTime.now().toIso8601String(),
        'description': 'App resumed from background or cold start',
        'lastKnownState': _lastKnownState?.toString() ?? 'UNKNOWN',
        'timeSinceLastStateChange': _lastStateChangeTime != null 
            ? DateTime.now().difference(_lastStateChangeTime!).inMilliseconds 
            : 0,
      },
    );
  }
  
  /// Log app pause event
  Future<void> logAppPaused() async {
    await _logEvent(
      eventType: 'APP_PAUSED',
      details: {
        'timestamp': DateTime.now().toIso8601String(),
        'description': 'App going to background',
        'lastKnownState': _lastKnownState?.toString() ?? 'UNKNOWN',
      },
    );
  }
  
  /// Log app inactive event
  Future<void> logAppInactive() async {
    await _logEvent(
      eventType: 'APP_INACTIVE',
      details: {
        'timestamp': DateTime.now().toIso8601String(),
        'description': 'App becoming inactive (task switching, lock screen, etc.)',
        'lastKnownState': _lastKnownState?.toString() ?? 'UNKNOWN',
      },
    );
  }
  
  /// Log app detached event (app killed)
  Future<void> logAppDetached() async {
    await _logEvent(
      eventType: 'APP_DETACHED',
      details: {
        'timestamp': DateTime.now().toIso8601String(),
        'description': 'App completely exited or killed by OS',
        'lastKnownState': _lastKnownState?.toString() ?? 'UNKNOWN',
        'warning': 'This event indicates the app was killed by the OS or user',
      },
    );
  }
  
  /// Log memory warning
  Future<void> logMemoryWarning() async {
    await _logEvent(
      eventType: 'MEMORY_WARNING',
      details: {
        'timestamp': DateTime.now().toIso8601String(),
        'description': 'System memory warning received',
        'warning': 'App may be killed soon due to memory pressure',
        'lastKnownState': _lastKnownState?.toString() ?? 'UNKNOWN',
      },
    );
  }
  
  /// Log low memory event
  Future<void> logLowMemory() async {
    await _logEvent(
      eventType: 'LOW_MEMORY',
      details: {
        'timestamp': DateTime.now().toIso8601String(),
        'description': 'Low memory condition detected',
        'warning': 'App is at high risk of being killed by OS',
        'lastKnownState': _lastKnownState?.toString() ?? 'UNKNOWN',
        'recommendation': 'Consider releasing non-essential resources',
      },
    );
  }
  
  /// Log system event
  Future<void> logSystemEvent(String eventType, Map<String, dynamic> details) async {
    await _logEvent(
      eventType: 'SYSTEM_EVENT',
      details: {
        'systemEventType': eventType,
        'timestamp': DateTime.now().toIso8601String(),
        ...details,
      },
    );
  }
  
  /// Log custom event
  Future<void> logCustomEvent(String eventType, Map<String, dynamic> details) async {
    await _logEvent(
      eventType: 'CUSTOM_EVENT',
      details: {
        'customEventType': eventType,
        'timestamp': DateTime.now().toIso8601String(),
        ...details,
      },
    );
  }
  
  /// Log app kill event (call this when you detect the app is being killed)
  Future<void> logAppKillEvent(String reason, Map<String, dynamic>? additionalDetails) async {
    await _logEvent(
      eventType: 'APP_KILL_EVENT',
      details: {
        'timestamp': DateTime.now().toIso8601String(),
        'reason': reason,
        'description': 'App detected kill event',
        'lastKnownState': _lastKnownState?.toString() ?? 'UNKNOWN',
        'stateChangeCount': _stateChangeCount,
        'deviceInfo': _deviceInfo,
        'appVersion': _appVersion,
        ...?additionalDetails,
      },
    );
  }
  
  /// Log background task expiration
  Future<void> logBackgroundTaskExpiration() async {
    await _logEvent(
      eventType: 'BACKGROUND_TASK_EXPIRED',
      details: {
        'timestamp': DateTime.now().toIso8601String(),
        'description': 'Background task execution time expired',
        'warning': 'App may be killed soon due to background time limit',
        'lastKnownState': _lastKnownState?.toString() ?? 'UNKNOWN',
      },
    );
  }
  
  /// Internal method to log events to file
  Future<void> _logEvent({
    required String eventType,
    required Map<String, dynamic> details,
  }) async {
    if (_logFile == null) return;
    
    try {
      final timestamp = DateTime.now().toString();
      final logEntry = '''=== APP LIFECYCLE EVENT ===
Event Type: $eventType
Timestamp: $timestamp
${details.entries.map((e) => '${e.key}: ${e.value}').join('\n')}
=== END EVENT ===

''';
      
      // Read existing content
      String existingContent = '';
      if (await _logFile!.exists()) {
        existingContent = await _logFile!.readAsString(encoding: utf8);
      }
      
      // Prepend new log entry (latest first)
      final newContent = logEntry + existingContent;
      await _logFile!.writeAsString(newContent, encoding: utf8);
      
      debugPrint('AppLifecycleLoggingService: Logged $eventType event');
    } catch (e) {
      debugPrint('AppLifecycleLoggingService: Error logging event: $e');
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
  
  /// Get current app state statistics
  Map<String, dynamic> getCurrentStats() {
    return {
      'lastKnownState': _lastKnownState?.toString() ?? 'UNKNOWN',
      'lastStateChangeTime': _lastStateChangeTime?.toIso8601String(),
      'stateChangeCount': _stateChangeCount,
      'deviceInfo': _deviceInfo,
      'appVersion': _appVersion,
      'logFilePath': logFilePath,
    };
  }
  
  /// Read and display log file contents
  Future<void> displayLogContents() async {
    if (_logFile == null) {
      debugPrint('AppLifecycleLoggingService: No log file available');
      return;
    }
    
    try {
      if (await _logFile!.exists()) {
        final contents = await _logFile!.readAsString(encoding: utf8);
        final lines = contents.split('\n').where((line) => line.isNotEmpty).length;
        debugPrint('AppLifecycleLoggingService: Log file exists with $lines entries');
        debugPrint('AppLifecycleLoggingService: Log file path: ${_logFile!.path}');
        
        if (contents.isNotEmpty) {
          debugPrint('AppLifecycleLoggingService: First few log entries:');
          final entries = contents.split('\n').where((line) => line.isNotEmpty && line.startsWith('===')).take(3);
          for (final entry in entries) {
            debugPrint('  - $entry');
          }
        }
      } else {
        debugPrint('AppLifecycleLoggingService: Log file does not exist at: ${_logFile!.path}');
      }
    } catch (e) {
      debugPrint('AppLifecycleLoggingService: Error reading log file: $e');
    }
  }
  
  /// Clear log file
  Future<void> clearLog() async {
    if (_logFile == null) return;
    
    try {
      await _logFile!.writeAsString('');
      debugPrint('AppLifecycleLoggingService: Log file cleared');
    } catch (e) {
      debugPrint('AppLifecycleLoggingService: Error clearing log file: $e');
    }
  }
}
