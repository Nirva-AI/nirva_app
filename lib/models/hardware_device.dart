import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'hardware_device.freezed.dart';
part 'hardware_device.g.dart';

@freezed
class HardwareDevice with _$HardwareDevice {
  const factory HardwareDevice({
    required String id,
    required String name,
    required String address,
    required int rssi,
    required bool isConnected,
    required DateTime discoveredAt,
    DateTime? connectedAt,
    DateTime? lastSeenAt,
    int? batteryLevel,
    String? firmwareVersion,
    String? hardwareVersion,
    String? manufacturer,
  }) = _HardwareDevice;

  factory HardwareDevice.fromJson(Map<String, dynamic> json) =>
      _$HardwareDeviceFromJson(json);
}

@freezed
class HardwareConnectionState with _$HardwareConnectionState {
  const factory HardwareConnectionState({
    required String deviceId,
    required HardwareConnectionStatus status,
    String? errorMessage,
    DateTime? timestamp,
  }) = _HardwareConnectionState;

  factory HardwareConnectionState.fromJson(Map<String, dynamic> json) =>
      _$HardwareConnectionStateFromJson(json);
}

enum HardwareConnectionStatus {
  disconnected,
  connecting,
  connected,
  error,
}

enum HardwareAudioFormat {
  opus,
  pcm,
  wav,
}

@freezed
class HardwareAudioPacket with _$HardwareAudioPacket {
  const factory HardwareAudioPacket({
    required String deviceId,
    required List<int> audioData,
    required HardwareAudioFormat format,
    required DateTime timestamp,
    required int sequenceNumber,
    int? sampleRate,
    int? bitDepth,
    int? channels,
  }) = _HardwareAudioPacket;

  factory HardwareAudioPacket.fromJson(Map<String, dynamic> json) =>
      _$HardwareAudioPacketFromJson(json);
}
