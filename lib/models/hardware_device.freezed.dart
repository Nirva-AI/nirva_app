// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hardware_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

HardwareDevice _$HardwareDeviceFromJson(Map<String, dynamic> json) {
  return _HardwareDevice.fromJson(json);
}

/// @nodoc
mixin _$HardwareDevice {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  int get rssi => throw _privateConstructorUsedError;
  bool get isConnected => throw _privateConstructorUsedError;
  DateTime get discoveredAt => throw _privateConstructorUsedError;
  DateTime? get connectedAt => throw _privateConstructorUsedError;
  DateTime? get lastSeenAt => throw _privateConstructorUsedError;
  int? get batteryLevel => throw _privateConstructorUsedError;
  String? get firmwareVersion => throw _privateConstructorUsedError;
  String? get hardwareVersion => throw _privateConstructorUsedError;
  String? get manufacturer => throw _privateConstructorUsedError;

  /// Serializes this HardwareDevice to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HardwareDevice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HardwareDeviceCopyWith<HardwareDevice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HardwareDeviceCopyWith<$Res> {
  factory $HardwareDeviceCopyWith(
          HardwareDevice value, $Res Function(HardwareDevice) then) =
      _$HardwareDeviceCopyWithImpl<$Res, HardwareDevice>;
  @useResult
  $Res call(
      {String id,
      String name,
      String address,
      int rssi,
      bool isConnected,
      DateTime discoveredAt,
      DateTime? connectedAt,
      DateTime? lastSeenAt,
      int? batteryLevel,
      String? firmwareVersion,
      String? hardwareVersion,
      String? manufacturer});
}

/// @nodoc
class _$HardwareDeviceCopyWithImpl<$Res, $Val extends HardwareDevice>
    implements $HardwareDeviceCopyWith<$Res> {
  _$HardwareDeviceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HardwareDevice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? rssi = null,
    Object? isConnected = null,
    Object? discoveredAt = null,
    Object? connectedAt = freezed,
    Object? lastSeenAt = freezed,
    Object? batteryLevel = freezed,
    Object? firmwareVersion = freezed,
    Object? hardwareVersion = freezed,
    Object? manufacturer = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      rssi: null == rssi
          ? _value.rssi
          : rssi // ignore: cast_nullable_to_non_nullable
              as int,
      isConnected: null == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      discoveredAt: null == discoveredAt
          ? _value.discoveredAt
          : discoveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      connectedAt: freezed == connectedAt
          ? _value.connectedAt
          : connectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSeenAt: freezed == lastSeenAt
          ? _value.lastSeenAt
          : lastSeenAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      batteryLevel: freezed == batteryLevel
          ? _value.batteryLevel
          : batteryLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      firmwareVersion: freezed == firmwareVersion
          ? _value.firmwareVersion
          : firmwareVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      hardwareVersion: freezed == hardwareVersion
          ? _value.hardwareVersion
          : hardwareVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      manufacturer: freezed == manufacturer
          ? _value.manufacturer
          : manufacturer // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HardwareDeviceImplCopyWith<$Res>
    implements $HardwareDeviceCopyWith<$Res> {
  factory _$$HardwareDeviceImplCopyWith(_$HardwareDeviceImpl value,
          $Res Function(_$HardwareDeviceImpl) then) =
      __$$HardwareDeviceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String address,
      int rssi,
      bool isConnected,
      DateTime discoveredAt,
      DateTime? connectedAt,
      DateTime? lastSeenAt,
      int? batteryLevel,
      String? firmwareVersion,
      String? hardwareVersion,
      String? manufacturer});
}

/// @nodoc
class __$$HardwareDeviceImplCopyWithImpl<$Res>
    extends _$HardwareDeviceCopyWithImpl<$Res, _$HardwareDeviceImpl>
    implements _$$HardwareDeviceImplCopyWith<$Res> {
  __$$HardwareDeviceImplCopyWithImpl(
      _$HardwareDeviceImpl _value, $Res Function(_$HardwareDeviceImpl) _then)
      : super(_value, _then);

  /// Create a copy of HardwareDevice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? rssi = null,
    Object? isConnected = null,
    Object? discoveredAt = null,
    Object? connectedAt = freezed,
    Object? lastSeenAt = freezed,
    Object? batteryLevel = freezed,
    Object? firmwareVersion = freezed,
    Object? hardwareVersion = freezed,
    Object? manufacturer = freezed,
  }) {
    return _then(_$HardwareDeviceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      rssi: null == rssi
          ? _value.rssi
          : rssi // ignore: cast_nullable_to_non_nullable
              as int,
      isConnected: null == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      discoveredAt: null == discoveredAt
          ? _value.discoveredAt
          : discoveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      connectedAt: freezed == connectedAt
          ? _value.connectedAt
          : connectedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastSeenAt: freezed == lastSeenAt
          ? _value.lastSeenAt
          : lastSeenAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      batteryLevel: freezed == batteryLevel
          ? _value.batteryLevel
          : batteryLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      firmwareVersion: freezed == firmwareVersion
          ? _value.firmwareVersion
          : firmwareVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      hardwareVersion: freezed == hardwareVersion
          ? _value.hardwareVersion
          : hardwareVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      manufacturer: freezed == manufacturer
          ? _value.manufacturer
          : manufacturer // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HardwareDeviceImpl
    with DiagnosticableTreeMixin
    implements _HardwareDevice {
  const _$HardwareDeviceImpl(
      {required this.id,
      required this.name,
      required this.address,
      required this.rssi,
      required this.isConnected,
      required this.discoveredAt,
      this.connectedAt,
      this.lastSeenAt,
      this.batteryLevel,
      this.firmwareVersion,
      this.hardwareVersion,
      this.manufacturer});

  factory _$HardwareDeviceImpl.fromJson(Map<String, dynamic> json) =>
      _$$HardwareDeviceImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String address;
  @override
  final int rssi;
  @override
  final bool isConnected;
  @override
  final DateTime discoveredAt;
  @override
  final DateTime? connectedAt;
  @override
  final DateTime? lastSeenAt;
  @override
  final int? batteryLevel;
  @override
  final String? firmwareVersion;
  @override
  final String? hardwareVersion;
  @override
  final String? manufacturer;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'HardwareDevice(id: $id, name: $name, address: $address, rssi: $rssi, isConnected: $isConnected, discoveredAt: $discoveredAt, connectedAt: $connectedAt, lastSeenAt: $lastSeenAt, batteryLevel: $batteryLevel, firmwareVersion: $firmwareVersion, hardwareVersion: $hardwareVersion, manufacturer: $manufacturer)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'HardwareDevice'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('address', address))
      ..add(DiagnosticsProperty('rssi', rssi))
      ..add(DiagnosticsProperty('isConnected', isConnected))
      ..add(DiagnosticsProperty('discoveredAt', discoveredAt))
      ..add(DiagnosticsProperty('connectedAt', connectedAt))
      ..add(DiagnosticsProperty('lastSeenAt', lastSeenAt))
      ..add(DiagnosticsProperty('batteryLevel', batteryLevel))
      ..add(DiagnosticsProperty('firmwareVersion', firmwareVersion))
      ..add(DiagnosticsProperty('hardwareVersion', hardwareVersion))
      ..add(DiagnosticsProperty('manufacturer', manufacturer));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HardwareDeviceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.rssi, rssi) || other.rssi == rssi) &&
            (identical(other.isConnected, isConnected) ||
                other.isConnected == isConnected) &&
            (identical(other.discoveredAt, discoveredAt) ||
                other.discoveredAt == discoveredAt) &&
            (identical(other.connectedAt, connectedAt) ||
                other.connectedAt == connectedAt) &&
            (identical(other.lastSeenAt, lastSeenAt) ||
                other.lastSeenAt == lastSeenAt) &&
            (identical(other.batteryLevel, batteryLevel) ||
                other.batteryLevel == batteryLevel) &&
            (identical(other.firmwareVersion, firmwareVersion) ||
                other.firmwareVersion == firmwareVersion) &&
            (identical(other.hardwareVersion, hardwareVersion) ||
                other.hardwareVersion == hardwareVersion) &&
            (identical(other.manufacturer, manufacturer) ||
                other.manufacturer == manufacturer));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      address,
      rssi,
      isConnected,
      discoveredAt,
      connectedAt,
      lastSeenAt,
      batteryLevel,
      firmwareVersion,
      hardwareVersion,
      manufacturer);

  /// Create a copy of HardwareDevice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HardwareDeviceImplCopyWith<_$HardwareDeviceImpl> get copyWith =>
      __$$HardwareDeviceImplCopyWithImpl<_$HardwareDeviceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HardwareDeviceImplToJson(
      this,
    );
  }
}

abstract class _HardwareDevice implements HardwareDevice {
  const factory _HardwareDevice(
      {required final String id,
      required final String name,
      required final String address,
      required final int rssi,
      required final bool isConnected,
      required final DateTime discoveredAt,
      final DateTime? connectedAt,
      final DateTime? lastSeenAt,
      final int? batteryLevel,
      final String? firmwareVersion,
      final String? hardwareVersion,
      final String? manufacturer}) = _$HardwareDeviceImpl;

  factory _HardwareDevice.fromJson(Map<String, dynamic> json) =
      _$HardwareDeviceImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get address;
  @override
  int get rssi;
  @override
  bool get isConnected;
  @override
  DateTime get discoveredAt;
  @override
  DateTime? get connectedAt;
  @override
  DateTime? get lastSeenAt;
  @override
  int? get batteryLevel;
  @override
  String? get firmwareVersion;
  @override
  String? get hardwareVersion;
  @override
  String? get manufacturer;

  /// Create a copy of HardwareDevice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HardwareDeviceImplCopyWith<_$HardwareDeviceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HardwareConnectionState _$HardwareConnectionStateFromJson(
    Map<String, dynamic> json) {
  return _HardwareConnectionState.fromJson(json);
}

/// @nodoc
mixin _$HardwareConnectionState {
  String get deviceId => throw _privateConstructorUsedError;
  HardwareConnectionStatus get status => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  DateTime? get timestamp => throw _privateConstructorUsedError;

  /// Serializes this HardwareConnectionState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HardwareConnectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HardwareConnectionStateCopyWith<HardwareConnectionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HardwareConnectionStateCopyWith<$Res> {
  factory $HardwareConnectionStateCopyWith(HardwareConnectionState value,
          $Res Function(HardwareConnectionState) then) =
      _$HardwareConnectionStateCopyWithImpl<$Res, HardwareConnectionState>;
  @useResult
  $Res call(
      {String deviceId,
      HardwareConnectionStatus status,
      String? errorMessage,
      DateTime? timestamp});
}

/// @nodoc
class _$HardwareConnectionStateCopyWithImpl<$Res,
        $Val extends HardwareConnectionState>
    implements $HardwareConnectionStateCopyWith<$Res> {
  _$HardwareConnectionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HardwareConnectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? status = null,
    Object? errorMessage = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_value.copyWith(
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as HardwareConnectionStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HardwareConnectionStateImplCopyWith<$Res>
    implements $HardwareConnectionStateCopyWith<$Res> {
  factory _$$HardwareConnectionStateImplCopyWith(
          _$HardwareConnectionStateImpl value,
          $Res Function(_$HardwareConnectionStateImpl) then) =
      __$$HardwareConnectionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String deviceId,
      HardwareConnectionStatus status,
      String? errorMessage,
      DateTime? timestamp});
}

/// @nodoc
class __$$HardwareConnectionStateImplCopyWithImpl<$Res>
    extends _$HardwareConnectionStateCopyWithImpl<$Res,
        _$HardwareConnectionStateImpl>
    implements _$$HardwareConnectionStateImplCopyWith<$Res> {
  __$$HardwareConnectionStateImplCopyWithImpl(
      _$HardwareConnectionStateImpl _value,
      $Res Function(_$HardwareConnectionStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of HardwareConnectionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? status = null,
    Object? errorMessage = freezed,
    Object? timestamp = freezed,
  }) {
    return _then(_$HardwareConnectionStateImpl(
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as HardwareConnectionStatus,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HardwareConnectionStateImpl
    with DiagnosticableTreeMixin
    implements _HardwareConnectionState {
  const _$HardwareConnectionStateImpl(
      {required this.deviceId,
      required this.status,
      this.errorMessage,
      this.timestamp});

  factory _$HardwareConnectionStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$HardwareConnectionStateImplFromJson(json);

  @override
  final String deviceId;
  @override
  final HardwareConnectionStatus status;
  @override
  final String? errorMessage;
  @override
  final DateTime? timestamp;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'HardwareConnectionState(deviceId: $deviceId, status: $status, errorMessage: $errorMessage, timestamp: $timestamp)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'HardwareConnectionState'))
      ..add(DiagnosticsProperty('deviceId', deviceId))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('errorMessage', errorMessage))
      ..add(DiagnosticsProperty('timestamp', timestamp));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HardwareConnectionStateImpl &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, deviceId, status, errorMessage, timestamp);

  /// Create a copy of HardwareConnectionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HardwareConnectionStateImplCopyWith<_$HardwareConnectionStateImpl>
      get copyWith => __$$HardwareConnectionStateImplCopyWithImpl<
          _$HardwareConnectionStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HardwareConnectionStateImplToJson(
      this,
    );
  }
}

abstract class _HardwareConnectionState implements HardwareConnectionState {
  const factory _HardwareConnectionState(
      {required final String deviceId,
      required final HardwareConnectionStatus status,
      final String? errorMessage,
      final DateTime? timestamp}) = _$HardwareConnectionStateImpl;

  factory _HardwareConnectionState.fromJson(Map<String, dynamic> json) =
      _$HardwareConnectionStateImpl.fromJson;

  @override
  String get deviceId;
  @override
  HardwareConnectionStatus get status;
  @override
  String? get errorMessage;
  @override
  DateTime? get timestamp;

  /// Create a copy of HardwareConnectionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HardwareConnectionStateImplCopyWith<_$HardwareConnectionStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

HardwareAudioPacket _$HardwareAudioPacketFromJson(Map<String, dynamic> json) {
  return _HardwareAudioPacket.fromJson(json);
}

/// @nodoc
mixin _$HardwareAudioPacket {
  String get deviceId => throw _privateConstructorUsedError;
  List<int> get audioData => throw _privateConstructorUsedError;
  HardwareAudioFormat get format => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  int get sequenceNumber => throw _privateConstructorUsedError;
  int? get sampleRate => throw _privateConstructorUsedError;
  int? get bitDepth => throw _privateConstructorUsedError;
  int? get channels => throw _privateConstructorUsedError;

  /// Serializes this HardwareAudioPacket to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HardwareAudioPacket
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HardwareAudioPacketCopyWith<HardwareAudioPacket> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HardwareAudioPacketCopyWith<$Res> {
  factory $HardwareAudioPacketCopyWith(
          HardwareAudioPacket value, $Res Function(HardwareAudioPacket) then) =
      _$HardwareAudioPacketCopyWithImpl<$Res, HardwareAudioPacket>;
  @useResult
  $Res call(
      {String deviceId,
      List<int> audioData,
      HardwareAudioFormat format,
      DateTime timestamp,
      int sequenceNumber,
      int? sampleRate,
      int? bitDepth,
      int? channels});
}

/// @nodoc
class _$HardwareAudioPacketCopyWithImpl<$Res, $Val extends HardwareAudioPacket>
    implements $HardwareAudioPacketCopyWith<$Res> {
  _$HardwareAudioPacketCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HardwareAudioPacket
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? audioData = null,
    Object? format = null,
    Object? timestamp = null,
    Object? sequenceNumber = null,
    Object? sampleRate = freezed,
    Object? bitDepth = freezed,
    Object? channels = freezed,
  }) {
    return _then(_value.copyWith(
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      audioData: null == audioData
          ? _value.audioData
          : audioData // ignore: cast_nullable_to_non_nullable
              as List<int>,
      format: null == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as HardwareAudioFormat,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sequenceNumber: null == sequenceNumber
          ? _value.sequenceNumber
          : sequenceNumber // ignore: cast_nullable_to_non_nullable
              as int,
      sampleRate: freezed == sampleRate
          ? _value.sampleRate
          : sampleRate // ignore: cast_nullable_to_non_nullable
              as int?,
      bitDepth: freezed == bitDepth
          ? _value.bitDepth
          : bitDepth // ignore: cast_nullable_to_non_nullable
              as int?,
      channels: freezed == channels
          ? _value.channels
          : channels // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HardwareAudioPacketImplCopyWith<$Res>
    implements $HardwareAudioPacketCopyWith<$Res> {
  factory _$$HardwareAudioPacketImplCopyWith(_$HardwareAudioPacketImpl value,
          $Res Function(_$HardwareAudioPacketImpl) then) =
      __$$HardwareAudioPacketImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String deviceId,
      List<int> audioData,
      HardwareAudioFormat format,
      DateTime timestamp,
      int sequenceNumber,
      int? sampleRate,
      int? bitDepth,
      int? channels});
}

/// @nodoc
class __$$HardwareAudioPacketImplCopyWithImpl<$Res>
    extends _$HardwareAudioPacketCopyWithImpl<$Res, _$HardwareAudioPacketImpl>
    implements _$$HardwareAudioPacketImplCopyWith<$Res> {
  __$$HardwareAudioPacketImplCopyWithImpl(_$HardwareAudioPacketImpl _value,
      $Res Function(_$HardwareAudioPacketImpl) _then)
      : super(_value, _then);

  /// Create a copy of HardwareAudioPacket
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? deviceId = null,
    Object? audioData = null,
    Object? format = null,
    Object? timestamp = null,
    Object? sequenceNumber = null,
    Object? sampleRate = freezed,
    Object? bitDepth = freezed,
    Object? channels = freezed,
  }) {
    return _then(_$HardwareAudioPacketImpl(
      deviceId: null == deviceId
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String,
      audioData: null == audioData
          ? _value._audioData
          : audioData // ignore: cast_nullable_to_non_nullable
              as List<int>,
      format: null == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as HardwareAudioFormat,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      sequenceNumber: null == sequenceNumber
          ? _value.sequenceNumber
          : sequenceNumber // ignore: cast_nullable_to_non_nullable
              as int,
      sampleRate: freezed == sampleRate
          ? _value.sampleRate
          : sampleRate // ignore: cast_nullable_to_non_nullable
              as int?,
      bitDepth: freezed == bitDepth
          ? _value.bitDepth
          : bitDepth // ignore: cast_nullable_to_non_nullable
              as int?,
      channels: freezed == channels
          ? _value.channels
          : channels // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HardwareAudioPacketImpl
    with DiagnosticableTreeMixin
    implements _HardwareAudioPacket {
  const _$HardwareAudioPacketImpl(
      {required this.deviceId,
      required final List<int> audioData,
      required this.format,
      required this.timestamp,
      required this.sequenceNumber,
      this.sampleRate,
      this.bitDepth,
      this.channels})
      : _audioData = audioData;

  factory _$HardwareAudioPacketImpl.fromJson(Map<String, dynamic> json) =>
      _$$HardwareAudioPacketImplFromJson(json);

  @override
  final String deviceId;
  final List<int> _audioData;
  @override
  List<int> get audioData {
    if (_audioData is EqualUnmodifiableListView) return _audioData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_audioData);
  }

  @override
  final HardwareAudioFormat format;
  @override
  final DateTime timestamp;
  @override
  final int sequenceNumber;
  @override
  final int? sampleRate;
  @override
  final int? bitDepth;
  @override
  final int? channels;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'HardwareAudioPacket(deviceId: $deviceId, audioData: $audioData, format: $format, timestamp: $timestamp, sequenceNumber: $sequenceNumber, sampleRate: $sampleRate, bitDepth: $bitDepth, channels: $channels)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'HardwareAudioPacket'))
      ..add(DiagnosticsProperty('deviceId', deviceId))
      ..add(DiagnosticsProperty('audioData', audioData))
      ..add(DiagnosticsProperty('format', format))
      ..add(DiagnosticsProperty('timestamp', timestamp))
      ..add(DiagnosticsProperty('sequenceNumber', sequenceNumber))
      ..add(DiagnosticsProperty('sampleRate', sampleRate))
      ..add(DiagnosticsProperty('bitDepth', bitDepth))
      ..add(DiagnosticsProperty('channels', channels));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HardwareAudioPacketImpl &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            const DeepCollectionEquality()
                .equals(other._audioData, _audioData) &&
            (identical(other.format, format) || other.format == format) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.sequenceNumber, sequenceNumber) ||
                other.sequenceNumber == sequenceNumber) &&
            (identical(other.sampleRate, sampleRate) ||
                other.sampleRate == sampleRate) &&
            (identical(other.bitDepth, bitDepth) ||
                other.bitDepth == bitDepth) &&
            (identical(other.channels, channels) ||
                other.channels == channels));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      deviceId,
      const DeepCollectionEquality().hash(_audioData),
      format,
      timestamp,
      sequenceNumber,
      sampleRate,
      bitDepth,
      channels);

  /// Create a copy of HardwareAudioPacket
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HardwareAudioPacketImplCopyWith<_$HardwareAudioPacketImpl> get copyWith =>
      __$$HardwareAudioPacketImplCopyWithImpl<_$HardwareAudioPacketImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HardwareAudioPacketImplToJson(
      this,
    );
  }
}

abstract class _HardwareAudioPacket implements HardwareAudioPacket {
  const factory _HardwareAudioPacket(
      {required final String deviceId,
      required final List<int> audioData,
      required final HardwareAudioFormat format,
      required final DateTime timestamp,
      required final int sequenceNumber,
      final int? sampleRate,
      final int? bitDepth,
      final int? channels}) = _$HardwareAudioPacketImpl;

  factory _HardwareAudioPacket.fromJson(Map<String, dynamic> json) =
      _$HardwareAudioPacketImpl.fromJson;

  @override
  String get deviceId;
  @override
  List<int> get audioData;
  @override
  HardwareAudioFormat get format;
  @override
  DateTime get timestamp;
  @override
  int get sequenceNumber;
  @override
  int? get sampleRate;
  @override
  int? get bitDepth;
  @override
  int? get channels;

  /// Create a copy of HardwareAudioPacket
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HardwareAudioPacketImplCopyWith<_$HardwareAudioPacketImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
