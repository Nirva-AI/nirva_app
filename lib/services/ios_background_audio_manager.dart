import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// iOS Background Audio Manager (Enhanced for BT Wake Events)
/// 
/// This service handles BT wake events and provides enhanced method channel interface
/// 
/// Features:
/// - BT wake event handling with detailed logging
/// - Background app refresh support
/// - Wake event state tracking
/// - No keep-alive mechanisms (let iOS handle wake events naturally)
class IosBackgroundAudioManager extends ChangeNotifier {
  
  // Method channel for native iOS communication
  static const MethodChannel _channel = MethodChannel('com.nirva/backgroundTask');
  
  // Enhanced state tracking
  bool _isInitialized = false;
  bool _wasWokenFromBackground = false;
  DateTime? _lastWakeEvent;
  int _wakeEventCount = 0;
  
  // Getters
  bool get isIos => Platform.isIOS;
  bool get isInitialized => _isInitialized;
  bool get wasWokenFromBackground => _wasWokenFromBackground;
  DateTime? get lastWakeEvent => _lastWakeEvent;
  int get wakeEventCount => _wakeEventCount;
  
  IosBackgroundAudioManager() {
    if (isIos) {
      _setupMethodChannel();
      _isInitialized = true;
      debugPrint('IosBackgroundAudioManager: Initialized for enhanced BT wake events');
    }
  }
  
  /// Setup method channel for native iOS communication
  void _setupMethodChannel() {
    _channel.setMethodCallHandler(_handleMethodCall);
  }
  
  /// Handle method calls from native iOS
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onBtWakeEvent':
        _handleBtWakeEvent();
        break;
      default:
        debugPrint('IosBackgroundAudioManager: Unknown method call: ${call.method}');
    }
  }
  
  /// Handle Bluetooth wake event from native iOS
  void _handleBtWakeEvent() {
    _wakeEventCount++;
    _lastWakeEvent = DateTime.now();
    _wasWokenFromBackground = true;
    
    debugPrint('IosBackgroundAudioManager: 🚨 BT WAKE EVENT RECEIVED!');
    debugPrint('IosBackgroundAudioManager: Wake event #$_wakeEventCount at ${_lastWakeEvent!.toIso8601String()}');
    debugPrint('IosBackgroundAudioManager: App was successfully woken from background by iOS');
    
    // Reset the flag after a short delay to allow processing
    Timer(Duration(seconds: 2), () {
      _wasWokenFromBackground = false;
      notifyListeners();
    });
    
    notifyListeners();
  }
  
  /// Get wake event statistics for debugging
  Map<String, dynamic> getWakeEventStats() {
    return {
      'totalWakeEvents': _wakeEventCount,
      'lastWakeEvent': _lastWakeEvent?.toIso8601String(),
      'wasWokenFromBackground': _wasWokenFromBackground,
      'isInitialized': _isInitialized,
    };
  }
  
  /// Reset wake event statistics
  void resetWakeEventStats() {
    _wakeEventCount = 0;
    _lastWakeEvent = null;
    _wasWokenFromBackground = false;
    debugPrint('IosBackgroundAudioManager: Wake event statistics reset');
    notifyListeners();
  }
  
  @override
  void dispose() {
    debugPrint('IosBackgroundAudioManager: Disposed');
    super.dispose();
  }
}