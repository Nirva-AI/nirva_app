// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hardware_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HardwareDeviceImpl _$$HardwareDeviceImplFromJson(Map<String, dynamic> json) =>
    _$HardwareDeviceImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      rssi: (json['rssi'] as num).toInt(),
      isConnected: json['isConnected'] as bool,
      discoveredAt: DateTime.parse(json['discoveredAt'] as String),
      connectedAt: json['connectedAt'] == null
          ? null
          : DateTime.parse(json['connectedAt'] as String),
      lastSeenAt: json['lastSeenAt'] == null
          ? null
          : DateTime.parse(json['lastSeenAt'] as String),
      batteryLevel: (json['batteryLevel'] as num?)?.toInt(),
      firmwareVersion: json['firmwareVersion'] as String?,
      hardwareVersion: json['hardwareVersion'] as String?,
      manufacturer: json['manufacturer'] as String?,
    );

Map<String, dynamic> _$$HardwareDeviceImplToJson(
        _$HardwareDeviceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'rssi': instance.rssi,
      'isConnected': instance.isConnected,
      'discoveredAt': instance.discoveredAt.toIso8601String(),
      'connectedAt': instance.connectedAt?.toIso8601String(),
      'lastSeenAt': instance.lastSeenAt?.toIso8601String(),
      'batteryLevel': instance.batteryLevel,
      'firmwareVersion': instance.firmwareVersion,
      'hardwareVersion': instance.hardwareVersion,
      'manufacturer': instance.manufacturer,
    };

_$HardwareConnectionStateImpl _$$HardwareConnectionStateImplFromJson(
        Map<String, dynamic> json) =>
    _$HardwareConnectionStateImpl(
      deviceId: json['deviceId'] as String,
      status: $enumDecode(_$HardwareConnectionStatusEnumMap, json['status']),
      errorMessage: json['errorMessage'] as String?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$HardwareConnectionStateImplToJson(
        _$HardwareConnectionStateImpl instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'status': _$HardwareConnectionStatusEnumMap[instance.status]!,
      'errorMessage': instance.errorMessage,
      'timestamp': instance.timestamp?.toIso8601String(),
    };

const _$HardwareConnectionStatusEnumMap = {
  HardwareConnectionStatus.disconnected: 'disconnected',
  HardwareConnectionStatus.connecting: 'connecting',
  HardwareConnectionStatus.connected: 'connected',
  HardwareConnectionStatus.error: 'error',
};

_$HardwareAudioPacketImpl _$$HardwareAudioPacketImplFromJson(
        Map<String, dynamic> json) =>
    _$HardwareAudioPacketImpl(
      deviceId: json['deviceId'] as String,
      audioData: (json['audioData'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      format: $enumDecode(_$HardwareAudioFormatEnumMap, json['format']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      sequenceNumber: (json['sequenceNumber'] as num).toInt(),
      sampleRate: (json['sampleRate'] as num?)?.toInt(),
      bitDepth: (json['bitDepth'] as num?)?.toInt(),
      channels: (json['channels'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$HardwareAudioPacketImplToJson(
        _$HardwareAudioPacketImpl instance) =>
    <String, dynamic>{
      'deviceId': instance.deviceId,
      'audioData': instance.audioData,
      'format': _$HardwareAudioFormatEnumMap[instance.format]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'sequenceNumber': instance.sequenceNumber,
      'sampleRate': instance.sampleRate,
      'bitDepth': instance.bitDepth,
      'channels': instance.channels,
    };

const _$HardwareAudioFormatEnumMap = {
  HardwareAudioFormat.opus: 'opus',
  HardwareAudioFormat.pcm: 'pcm',
  HardwareAudioFormat.wav: 'wav',
};
