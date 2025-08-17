import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// iOS Background Audio Manager
/// 
/// This service manages iOS audio sessions to enable background audio processing
/// and keep the app alive during background audio streaming
/// 
/// Features:
/// - Background task scheduling and management
/// - Audio session configuration and activation
/// - Continuous background processing during hardware streaming
/// - Integration with native iOS background task scheduler
class IosBackgroundAudioManager extends ChangeNotifier {
  
  // Method channel for native iOS communication
  static const MethodChannel _channel = MethodChannel('com.nirva/backgroundTask');
  
  // Audio session state
  bool _isAudioSessionActive = false;
  bool _isBackgroundAudioEnabled = false;
  bool _isAudioSessionConfigured = false;
  bool _isBackgroundTaskActive = false;
  
  // Background task management
  Timer? _backgroundTaskTimer;
  Timer? _keepAliveTimer;
  

  
  // Background task settings
  static const Duration _backgroundTaskInterval = Duration(seconds: 30);
  static const Duration _keepAliveInterval = Duration(seconds: 10);
  
  // Getters
  bool get isAudioSessionActive => _isAudioSessionActive;
  bool get isBackgroundAudioEnabled => _isBackgroundAudioEnabled;
  bool get isAudioSessionConfigured => _isAudioSessionConfigured;
  bool get isBackgroundTaskActive => _isBackgroundTaskActive;
  bool get isIos => Platform.isIOS;
  
  IosBackgroundAudioManager() {
    if (isIos) {
      _setupMethodChannel();
    }
  }
  
  /// Setup method channel for native iOS communication
  void _setupMethodChannel() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }
  
  /// Handle method calls from native iOS
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onBackgroundTaskExpiring':
        _handleBackgroundTaskExpiring();
        break;
      default:
        debugPrint('IosBackgroundAudioManager: Unknown method call: ${call.method}');
    }
  }
  
  /// Handle background task expiring from native iOS
  void _handleBackgroundTaskExpiring() {
    debugPrint('IosBackgroundAudioManager: Background task expiring, scheduling next task...');
    
    if (_isBackgroundAudioEnabled) {
      // Schedule next background task immediately
      _scheduleNextBackgroundTask();
      
      // Notify listeners
      notifyListeners();
    }
  }
  
  /// Configure iOS audio session for background processing
  Future<bool> configureAudioSession() async {
    if (!isIos) {
      debugPrint('IosBackgroundAudioManager: Not iOS platform, skipping audio session configuration');
      return false;
    }
    
    try {
      debugPrint('IosBackgroundAudioManager: Configuring iOS audio session...');
      
      // Configure audio session through native iOS
      final result = await _channel.invokeMethod('configureAudioSession');
      final success = result == true;
      
      if (success) {
        _isAudioSessionConfigured = true;
        debugPrint('IosBackgroundAudioManager: iOS audio session configured successfully');
        notifyListeners();
      } else {
        debugPrint('IosBackgroundAudioManager: Failed to configure iOS audio session');
      }
      
      return success;
    } catch (e) {
      debugPrint('IosBackgroundAudioManager: Error configuring iOS audio session: $e');
      return false;
    }
  }
  
  /// Activate audio session for background processing
  Future<bool> activateAudioSession() async {
    if (!isIos || !_isAudioSessionConfigured) {
      debugPrint('IosBackgroundAudioManager: Cannot activate - not iOS or not configured');
      return false;
    }
    
    try {
      debugPrint('IosBackgroundAudioManager: Activating iOS audio session...');
      
      // Activate audio session through native iOS
      final result = await _channel.invokeMethod('activateAudioSession');
      final success = result == true;
      
      if (success) {
        _isAudioSessionActive = true;
        debugPrint('IosBackgroundAudioManager: iOS audio session activated successfully');
        notifyListeners();
      } else {
        debugPrint('IosBackgroundAudioManager: Failed to activate iOS audio session');
      }
      
      return success;
    } catch (e) {
      debugPrint('IosBackgroundAudioManager: Error activating iOS audio session: $e');
      return false;
    }
  }
  
  /// Deactivate audio session
  Future<bool> deactivateAudioSession() async {
    if (!isIos) {
      return false;
    }
    
    try {
      debugPrint('IosBackgroundAudioManager: Deactivating iOS audio session...');
      
      // Deactivate audio session through native iOS
      final result = await _channel.invokeMethod('deactivateAudioSession');
      final success = result == true;
      
      if (success) {
        _isAudioSessionActive = false;
        debugPrint('IosBackgroundAudioManager: iOS audio session deactivated successfully');
        notifyListeners();
      } else {
        debugPrint('IosBackgroundAudioManager: Failed to deactivate iOS audio session');
      }
      
      return success;
    } catch (e) {
      debugPrint('IosBackgroundAudioManager: Error deactivating iOS audio session: $e');
      return false;
    }
  }
  
  /// Start background audio processing
  Future<bool> startBackgroundAudio() async {
    if (!isIos || !_isAudioSessionActive) {
      debugPrint('IosBackgroundAudioManager: Cannot start background audio - not iOS or audio session not active');
      return false;
    }
    
    try {
      debugPrint('IosBackgroundAudioManager: Starting iOS background audio processing...');
      
      // Start background task scheduling
      _isBackgroundAudioEnabled = true;
      _startBackgroundTaskMonitoring();
      _startKeepAliveMonitoring();
      
      // Schedule initial background task
      _scheduleNextBackgroundTask();
      
      debugPrint('IosBackgroundAudioManager: iOS background audio started successfully');
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('IosBackgroundAudioManager: Error starting iOS background audio: $e');
      return false;
    }
  }
  
  /// Stop background audio processing
  Future<bool> stopBackgroundAudio() async {
    if (!isIos) {
      return false;
    }
    
    try {
      debugPrint('IosBackgroundAudioManager: Stopping iOS background audio processing...');
      
      // Stop background task monitoring
      _isBackgroundAudioEnabled = false;
      _stopBackgroundTaskMonitoring();
      _stopKeepAliveMonitoring();
      
      // Cancel all background tasks
      await _cancelAllBackgroundTasks();
      
      debugPrint('IosBackgroundAudioManager: iOS background audio stopped successfully');
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('IosBackgroundAudioManager: Error stopping iOS background audio: $e');
      return false;
    }
  }
  
  /// Start background task monitoring
  void _startBackgroundTaskMonitoring() {
    _stopBackgroundTaskMonitoring();
    
    // Monitor background tasks every 30 seconds
    _backgroundTaskTimer = Timer.periodic(_backgroundTaskInterval, (timer) {
      if (_isBackgroundAudioEnabled) {
        _scheduleNextBackgroundTask();
      } else {
        timer.cancel();
      }
    });
    
    debugPrint('IosBackgroundAudioManager: Background task monitoring started');
  }
  
  /// Stop background task monitoring
  void _stopBackgroundTaskMonitoring() {
    _backgroundTaskTimer?.cancel();
    _backgroundTaskTimer = null;
    debugPrint('IosBackgroundAudioManager: Background task monitoring stopped');
  }
  
  /// Start keep-alive monitoring
  void _startKeepAliveMonitoring() {
    _stopKeepAliveMonitoring();
    
    // Send keep-alive signals every 10 seconds to prevent app termination
    _keepAliveTimer = Timer.periodic(_keepAliveInterval, (timer) {
      if (_isBackgroundAudioEnabled) {
        _sendKeepAliveSignal();
      } else {
        timer.cancel();
      }
    });
    
    debugPrint('IosBackgroundAudioManager: Keep-alive monitoring started');
  }
  
  /// Stop keep-alive monitoring
  void _stopKeepAliveMonitoring() {
    _keepAliveTimer?.cancel();
    _keepAliveTimer = null;
    debugPrint('IosBackgroundAudioManager: Keep-alive monitoring stopped');
  }
  
  /// Schedule next background task
  Future<void> _scheduleNextBackgroundTask() async {
    if (!isIos || !_isBackgroundAudioEnabled) {
      return;
    }
    
    try {
      final result = await _channel.invokeMethod('scheduleBackgroundTask');
      final success = result == true;
      
      if (success) {
        _isBackgroundTaskActive = true;
        debugPrint('IosBackgroundAudioManager: Background task scheduled successfully');
      } else {
        debugPrint('IosBackgroundAudioManager: Failed to schedule background task');
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('IosBackgroundAudioManager: Error scheduling background task: $e');
    }
  }
  
  /// Cancel all background tasks
  Future<void> _cancelAllBackgroundTasks() async {
    if (!isIos) {
      return;
    }
    
    try {
      final result = await _channel.invokeMethod('cancelAllBackgroundTasks');
      final success = result == true;
      
      if (success) {
        _isBackgroundTaskActive = false;
        debugPrint('IosBackgroundAudioManager: All background tasks cancelled successfully');
      } else {
        debugPrint('IosBackgroundAudioManager: Failed to cancel background tasks');
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('IosBackgroundAudioManager: Error cancelling background tasks: $e');
    }
  }
  
  /// Send keep-alive signal to prevent app termination
  Future<void> _sendKeepAliveSignal() async {
    if (!isIos || !_isBackgroundAudioEnabled) {
      return;
    }
    
    try {
      // Send a lightweight signal to keep the background task alive
      await _channel.invokeMethod('sendKeepAliveSignal');
      debugPrint('IosBackgroundAudioManager: Keep-alive signal sent');
    } catch (e) {
      debugPrint('IosBackgroundAudioManager: Error sending keep-alive signal: $e');
    }
  }
  

  
  @override
  void dispose() {
    _stopBackgroundTaskMonitoring();
    _stopKeepAliveMonitoring();
    
    if (isIos) {
      // Clean up audio session when disposing
      deactivateAudioSession();
    }
    
    super.dispose();
  }
}

