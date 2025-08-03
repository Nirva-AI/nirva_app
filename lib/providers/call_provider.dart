import 'package:flutter/material.dart';
import 'dart:async';

enum CallState {
  idle,
  ringing,
  connected,
  ended,
}

class CallProvider extends ChangeNotifier {
  CallState _callState = CallState.idle;
  bool _isMinimized = false;
  int _callDuration = 0;
  bool _isMuted = false;
  bool _isSpeakerOn = false;
  Timer? _callTimer;

  CallState get callState => _callState;
  bool get isMinimized => _isMinimized;
  int get callDuration => _callDuration;
  bool get isMuted => _isMuted;
  bool get isSpeakerOn => _isSpeakerOn;
  bool get isInCall => _callState == CallState.ringing || _callState == CallState.connected;

  void startCall() {
    _callState = CallState.ringing;
    _callDuration = 0;
    _isMinimized = false;
    notifyListeners();
  }

  void connectCall() {
    _callState = CallState.connected;
    _startCallTimer();
    notifyListeners();
  }

  void endCall() {
    _callState = CallState.ended;
    _isMinimized = false;
    _stopCallTimer();
    notifyListeners();
  }

  void resetCall() {
    _callState = CallState.idle;
    _callDuration = 0;
    _isMinimized = false;
    _isMuted = false;
    _isSpeakerOn = false;
    _stopCallTimer();
    notifyListeners();
  }

  void toggleMinimize() {
    _isMinimized = !_isMinimized;
    notifyListeners();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    notifyListeners();
  }

  void toggleSpeaker() {
    _isSpeakerOn = !_isSpeakerOn;
    notifyListeners();
  }

  void _startCallTimer() {
    _stopCallTimer(); // Stop any existing timer
    _callTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _callDuration++;
      notifyListeners();
    });
  }

  void _stopCallTimer() {
    _callTimer?.cancel();
    _callTimer = null;
  }

  @override
  void dispose() {
    _stopCallTimer();
    super.dispose();
  }
} 