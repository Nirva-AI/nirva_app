// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

URLConfigurationResponse _$URLConfigurationResponseFromJson(
    Map<String, dynamic> json) {
  return _URLConfigurationResponse.fromJson(json);
}

/// @nodoc
mixin _$URLConfigurationResponse {
  String get api_version => throw _privateConstructorUsedError;
  Map<String, String> get endpoints => throw _privateConstructorUsedError;
  bool get deprecated => throw _privateConstructorUsedError;
  String get notice => throw _privateConstructorUsedError;

  /// Serializes this URLConfigurationResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of URLConfigurationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $URLConfigurationResponseCopyWith<URLConfigurationResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $URLConfigurationResponseCopyWith<$Res> {
  factory $URLConfigurationResponseCopyWith(URLConfigurationResponse value,
          $Res Function(URLConfigurationResponse) then) =
      _$URLConfigurationResponseCopyWithImpl<$Res, URLConfigurationResponse>;
  @useResult
  $Res call(
      {String api_version,
      Map<String, String> endpoints,
      bool deprecated,
      String notice});
}

/// @nodoc
class _$URLConfigurationResponseCopyWithImpl<$Res,
        $Val extends URLConfigurationResponse>
    implements $URLConfigurationResponseCopyWith<$Res> {
  _$URLConfigurationResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of URLConfigurationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? api_version = null,
    Object? endpoints = null,
    Object? deprecated = null,
    Object? notice = null,
  }) {
    return _then(_value.copyWith(
      api_version: null == api_version
          ? _value.api_version
          : api_version // ignore: cast_nullable_to_non_nullable
              as String,
      endpoints: null == endpoints
          ? _value.endpoints
          : endpoints // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      deprecated: null == deprecated
          ? _value.deprecated
          : deprecated // ignore: cast_nullable_to_non_nullable
              as bool,
      notice: null == notice
          ? _value.notice
          : notice // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$URLConfigurationResponseImplCopyWith<$Res>
    implements $URLConfigurationResponseCopyWith<$Res> {
  factory _$$URLConfigurationResponseImplCopyWith(
          _$URLConfigurationResponseImpl value,
          $Res Function(_$URLConfigurationResponseImpl) then) =
      __$$URLConfigurationResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String api_version,
      Map<String, String> endpoints,
      bool deprecated,
      String notice});
}

/// @nodoc
class __$$URLConfigurationResponseImplCopyWithImpl<$Res>
    extends _$URLConfigurationResponseCopyWithImpl<$Res,
        _$URLConfigurationResponseImpl>
    implements _$$URLConfigurationResponseImplCopyWith<$Res> {
  __$$URLConfigurationResponseImplCopyWithImpl(
      _$URLConfigurationResponseImpl _value,
      $Res Function(_$URLConfigurationResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of URLConfigurationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? api_version = null,
    Object? endpoints = null,
    Object? deprecated = null,
    Object? notice = null,
  }) {
    return _then(_$URLConfigurationResponseImpl(
      api_version: null == api_version
          ? _value.api_version
          : api_version // ignore: cast_nullable_to_non_nullable
              as String,
      endpoints: null == endpoints
          ? _value._endpoints
          : endpoints // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      deprecated: null == deprecated
          ? _value.deprecated
          : deprecated // ignore: cast_nullable_to_non_nullable
              as bool,
      notice: null == notice
          ? _value.notice
          : notice // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$URLConfigurationResponseImpl implements _URLConfigurationResponse {
  const _$URLConfigurationResponseImpl(
      {required this.api_version,
      required final Map<String, String> endpoints,
      required this.deprecated,
      required this.notice})
      : _endpoints = endpoints;

  factory _$URLConfigurationResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$URLConfigurationResponseImplFromJson(json);

  @override
  final String api_version;
  final Map<String, String> _endpoints;
  @override
  Map<String, String> get endpoints {
    if (_endpoints is EqualUnmodifiableMapView) return _endpoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_endpoints);
  }

  @override
  final bool deprecated;
  @override
  final String notice;

  @override
  String toString() {
    return 'URLConfigurationResponse(api_version: $api_version, endpoints: $endpoints, deprecated: $deprecated, notice: $notice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$URLConfigurationResponseImpl &&
            (identical(other.api_version, api_version) ||
                other.api_version == api_version) &&
            const DeepCollectionEquality()
                .equals(other._endpoints, _endpoints) &&
            (identical(other.deprecated, deprecated) ||
                other.deprecated == deprecated) &&
            (identical(other.notice, notice) || other.notice == notice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, api_version,
      const DeepCollectionEquality().hash(_endpoints), deprecated, notice);

  /// Create a copy of URLConfigurationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$URLConfigurationResponseImplCopyWith<_$URLConfigurationResponseImpl>
      get copyWith => __$$URLConfigurationResponseImplCopyWithImpl<
          _$URLConfigurationResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$URLConfigurationResponseImplToJson(
      this,
    );
  }
}

abstract class _URLConfigurationResponse implements URLConfigurationResponse {
  const factory _URLConfigurationResponse(
      {required final String api_version,
      required final Map<String, String> endpoints,
      required final bool deprecated,
      required final String notice}) = _$URLConfigurationResponseImpl;

  factory _URLConfigurationResponse.fromJson(Map<String, dynamic> json) =
      _$URLConfigurationResponseImpl.fromJson;

  @override
  String get api_version;
  @override
  Map<String, String> get endpoints;
  @override
  bool get deprecated;
  @override
  String get notice;

  /// Create a copy of URLConfigurationResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$URLConfigurationResponseImplCopyWith<_$URLConfigurationResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) {
  return _LoginRequest.fromJson(json);
}

/// @nodoc
mixin _$LoginRequest {
  String get user_name => throw _privateConstructorUsedError;

  /// Serializes this LoginRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginRequestCopyWith<LoginRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginRequestCopyWith<$Res> {
  factory $LoginRequestCopyWith(
          LoginRequest value, $Res Function(LoginRequest) then) =
      _$LoginRequestCopyWithImpl<$Res, LoginRequest>;
  @useResult
  $Res call({String user_name});
}

/// @nodoc
class _$LoginRequestCopyWithImpl<$Res, $Val extends LoginRequest>
    implements $LoginRequestCopyWith<$Res> {
  _$LoginRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user_name = null,
  }) {
    return _then(_value.copyWith(
      user_name: null == user_name
          ? _value.user_name
          : user_name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoginRequestImplCopyWith<$Res>
    implements $LoginRequestCopyWith<$Res> {
  factory _$$LoginRequestImplCopyWith(
          _$LoginRequestImpl value, $Res Function(_$LoginRequestImpl) then) =
      __$$LoginRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String user_name});
}

/// @nodoc
class __$$LoginRequestImplCopyWithImpl<$Res>
    extends _$LoginRequestCopyWithImpl<$Res, _$LoginRequestImpl>
    implements _$$LoginRequestImplCopyWith<$Res> {
  __$$LoginRequestImplCopyWithImpl(
      _$LoginRequestImpl _value, $Res Function(_$LoginRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user_name = null,
  }) {
    return _then(_$LoginRequestImpl(
      user_name: null == user_name
          ? _value.user_name
          : user_name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginRequestImpl implements _LoginRequest {
  const _$LoginRequestImpl({required this.user_name});

  factory _$LoginRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginRequestImplFromJson(json);

  @override
  final String user_name;

  @override
  String toString() {
    return 'LoginRequest(user_name: $user_name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginRequestImpl &&
            (identical(other.user_name, user_name) ||
                other.user_name == user_name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, user_name);

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginRequestImplCopyWith<_$LoginRequestImpl> get copyWith =>
      __$$LoginRequestImplCopyWithImpl<_$LoginRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginRequestImplToJson(
      this,
    );
  }
}

abstract class _LoginRequest implements LoginRequest {
  const factory _LoginRequest({required final String user_name}) =
      _$LoginRequestImpl;

  factory _LoginRequest.fromJson(Map<String, dynamic> json) =
      _$LoginRequestImpl.fromJson;

  @override
  String get user_name;

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginRequestImplCopyWith<_$LoginRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) {
  return _LoginResponse.fromJson(json);
}

/// @nodoc
mixin _$LoginResponse {
  int get error => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  /// Serializes this LoginResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginResponseCopyWith<LoginResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginResponseCopyWith<$Res> {
  factory $LoginResponseCopyWith(
          LoginResponse value, $Res Function(LoginResponse) then) =
      _$LoginResponseCopyWithImpl<$Res, LoginResponse>;
  @useResult
  $Res call({int error, String message});
}

/// @nodoc
class _$LoginResponseCopyWithImpl<$Res, $Val extends LoginResponse>
    implements $LoginResponseCopyWith<$Res> {
  _$LoginResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LoginResponseImplCopyWith<$Res>
    implements $LoginResponseCopyWith<$Res> {
  factory _$$LoginResponseImplCopyWith(
          _$LoginResponseImpl value, $Res Function(_$LoginResponseImpl) then) =
      __$$LoginResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int error, String message});
}

/// @nodoc
class __$$LoginResponseImplCopyWithImpl<$Res>
    extends _$LoginResponseCopyWithImpl<$Res, _$LoginResponseImpl>
    implements _$$LoginResponseImplCopyWith<$Res> {
  __$$LoginResponseImplCopyWithImpl(
      _$LoginResponseImpl _value, $Res Function(_$LoginResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? message = null,
  }) {
    return _then(_$LoginResponseImpl(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginResponseImpl implements _LoginResponse {
  const _$LoginResponseImpl({required this.error, required this.message});

  factory _$LoginResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginResponseImplFromJson(json);

  @override
  final int error;
  @override
  final String message;

  @override
  String toString() {
    return 'LoginResponse(error: $error, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginResponseImpl &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, error, message);

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginResponseImplCopyWith<_$LoginResponseImpl> get copyWith =>
      __$$LoginResponseImplCopyWithImpl<_$LoginResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginResponseImplToJson(
      this,
    );
  }
}

abstract class _LoginResponse implements LoginResponse {
  const factory _LoginResponse(
      {required final int error,
      required final String message}) = _$LoginResponseImpl;

  factory _LoginResponse.fromJson(Map<String, dynamic> json) =
      _$LoginResponseImpl.fromJson;

  @override
  int get error;
  @override
  String get message;

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginResponseImplCopyWith<_$LoginResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LogoutRequest _$LogoutRequestFromJson(Map<String, dynamic> json) {
  return _LogoutRequest.fromJson(json);
}

/// @nodoc
mixin _$LogoutRequest {
  String get user_name => throw _privateConstructorUsedError;

  /// Serializes this LogoutRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LogoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LogoutRequestCopyWith<LogoutRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogoutRequestCopyWith<$Res> {
  factory $LogoutRequestCopyWith(
          LogoutRequest value, $Res Function(LogoutRequest) then) =
      _$LogoutRequestCopyWithImpl<$Res, LogoutRequest>;
  @useResult
  $Res call({String user_name});
}

/// @nodoc
class _$LogoutRequestCopyWithImpl<$Res, $Val extends LogoutRequest>
    implements $LogoutRequestCopyWith<$Res> {
  _$LogoutRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LogoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user_name = null,
  }) {
    return _then(_value.copyWith(
      user_name: null == user_name
          ? _value.user_name
          : user_name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LogoutRequestImplCopyWith<$Res>
    implements $LogoutRequestCopyWith<$Res> {
  factory _$$LogoutRequestImplCopyWith(
          _$LogoutRequestImpl value, $Res Function(_$LogoutRequestImpl) then) =
      __$$LogoutRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String user_name});
}

/// @nodoc
class __$$LogoutRequestImplCopyWithImpl<$Res>
    extends _$LogoutRequestCopyWithImpl<$Res, _$LogoutRequestImpl>
    implements _$$LogoutRequestImplCopyWith<$Res> {
  __$$LogoutRequestImplCopyWithImpl(
      _$LogoutRequestImpl _value, $Res Function(_$LogoutRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of LogoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user_name = null,
  }) {
    return _then(_$LogoutRequestImpl(
      user_name: null == user_name
          ? _value.user_name
          : user_name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LogoutRequestImpl implements _LogoutRequest {
  const _$LogoutRequestImpl({required this.user_name});

  factory _$LogoutRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$LogoutRequestImplFromJson(json);

  @override
  final String user_name;

  @override
  String toString() {
    return 'LogoutRequest(user_name: $user_name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LogoutRequestImpl &&
            (identical(other.user_name, user_name) ||
                other.user_name == user_name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, user_name);

  /// Create a copy of LogoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LogoutRequestImplCopyWith<_$LogoutRequestImpl> get copyWith =>
      __$$LogoutRequestImplCopyWithImpl<_$LogoutRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LogoutRequestImplToJson(
      this,
    );
  }
}

abstract class _LogoutRequest implements LogoutRequest {
  const factory _LogoutRequest({required final String user_name}) =
      _$LogoutRequestImpl;

  factory _LogoutRequest.fromJson(Map<String, dynamic> json) =
      _$LogoutRequestImpl.fromJson;

  @override
  String get user_name;

  /// Create a copy of LogoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LogoutRequestImplCopyWith<_$LogoutRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LogoutResponse _$LogoutResponseFromJson(Map<String, dynamic> json) {
  return _LogoutResponse.fromJson(json);
}

/// @nodoc
mixin _$LogoutResponse {
  int get error => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  /// Serializes this LogoutResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LogoutResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LogoutResponseCopyWith<LogoutResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LogoutResponseCopyWith<$Res> {
  factory $LogoutResponseCopyWith(
          LogoutResponse value, $Res Function(LogoutResponse) then) =
      _$LogoutResponseCopyWithImpl<$Res, LogoutResponse>;
  @useResult
  $Res call({int error, String message});
}

/// @nodoc
class _$LogoutResponseCopyWithImpl<$Res, $Val extends LogoutResponse>
    implements $LogoutResponseCopyWith<$Res> {
  _$LogoutResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LogoutResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LogoutResponseImplCopyWith<$Res>
    implements $LogoutResponseCopyWith<$Res> {
  factory _$$LogoutResponseImplCopyWith(_$LogoutResponseImpl value,
          $Res Function(_$LogoutResponseImpl) then) =
      __$$LogoutResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int error, String message});
}

/// @nodoc
class __$$LogoutResponseImplCopyWithImpl<$Res>
    extends _$LogoutResponseCopyWithImpl<$Res, _$LogoutResponseImpl>
    implements _$$LogoutResponseImplCopyWith<$Res> {
  __$$LogoutResponseImplCopyWithImpl(
      _$LogoutResponseImpl _value, $Res Function(_$LogoutResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of LogoutResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? message = null,
  }) {
    return _then(_$LogoutResponseImpl(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LogoutResponseImpl implements _LogoutResponse {
  const _$LogoutResponseImpl({required this.error, required this.message});

  factory _$LogoutResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$LogoutResponseImplFromJson(json);

  @override
  final int error;
  @override
  final String message;

  @override
  String toString() {
    return 'LogoutResponse(error: $error, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LogoutResponseImpl &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, error, message);

  /// Create a copy of LogoutResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LogoutResponseImplCopyWith<_$LogoutResponseImpl> get copyWith =>
      __$$LogoutResponseImplCopyWithImpl<_$LogoutResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LogoutResponseImplToJson(
      this,
    );
  }
}

abstract class _LogoutResponse implements LogoutResponse {
  const factory _LogoutResponse(
      {required final int error,
      required final String message}) = _$LogoutResponseImpl;

  factory _LogoutResponse.fromJson(Map<String, dynamic> json) =
      _$LogoutResponseImpl.fromJson;

  @override
  int get error;
  @override
  String get message;

  /// Create a copy of LogoutResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LogoutResponseImplCopyWith<_$LogoutResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatActionRequest _$ChatActionRequestFromJson(Map<String, dynamic> json) {
  return _ChatActionRequest.fromJson(json);
}

/// @nodoc
mixin _$ChatActionRequest {
  String get user_name => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;

  /// Serializes this ChatActionRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatActionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatActionRequestCopyWith<ChatActionRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatActionRequestCopyWith<$Res> {
  factory $ChatActionRequestCopyWith(
          ChatActionRequest value, $Res Function(ChatActionRequest) then) =
      _$ChatActionRequestCopyWithImpl<$Res, ChatActionRequest>;
  @useResult
  $Res call({String user_name, String content});
}

/// @nodoc
class _$ChatActionRequestCopyWithImpl<$Res, $Val extends ChatActionRequest>
    implements $ChatActionRequestCopyWith<$Res> {
  _$ChatActionRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatActionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user_name = null,
    Object? content = null,
  }) {
    return _then(_value.copyWith(
      user_name: null == user_name
          ? _value.user_name
          : user_name // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatActionRequestImplCopyWith<$Res>
    implements $ChatActionRequestCopyWith<$Res> {
  factory _$$ChatActionRequestImplCopyWith(_$ChatActionRequestImpl value,
          $Res Function(_$ChatActionRequestImpl) then) =
      __$$ChatActionRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String user_name, String content});
}

/// @nodoc
class __$$ChatActionRequestImplCopyWithImpl<$Res>
    extends _$ChatActionRequestCopyWithImpl<$Res, _$ChatActionRequestImpl>
    implements _$$ChatActionRequestImplCopyWith<$Res> {
  __$$ChatActionRequestImplCopyWithImpl(_$ChatActionRequestImpl _value,
      $Res Function(_$ChatActionRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatActionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user_name = null,
    Object? content = null,
  }) {
    return _then(_$ChatActionRequestImpl(
      user_name: null == user_name
          ? _value.user_name
          : user_name // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatActionRequestImpl implements _ChatActionRequest {
  const _$ChatActionRequestImpl(
      {required this.user_name, required this.content});

  factory _$ChatActionRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatActionRequestImplFromJson(json);

  @override
  final String user_name;
  @override
  final String content;

  @override
  String toString() {
    return 'ChatActionRequest(user_name: $user_name, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatActionRequestImpl &&
            (identical(other.user_name, user_name) ||
                other.user_name == user_name) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, user_name, content);

  /// Create a copy of ChatActionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatActionRequestImplCopyWith<_$ChatActionRequestImpl> get copyWith =>
      __$$ChatActionRequestImplCopyWithImpl<_$ChatActionRequestImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatActionRequestImplToJson(
      this,
    );
  }
}

abstract class _ChatActionRequest implements ChatActionRequest {
  const factory _ChatActionRequest(
      {required final String user_name,
      required final String content}) = _$ChatActionRequestImpl;

  factory _ChatActionRequest.fromJson(Map<String, dynamic> json) =
      _$ChatActionRequestImpl.fromJson;

  @override
  String get user_name;
  @override
  String get content;

  /// Create a copy of ChatActionRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatActionRequestImplCopyWith<_$ChatActionRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatActionResponse _$ChatActionResponseFromJson(Map<String, dynamic> json) {
  return _ChatActionResponse.fromJson(json);
}

/// @nodoc
mixin _$ChatActionResponse {
  int get error => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  /// Serializes this ChatActionResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatActionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatActionResponseCopyWith<ChatActionResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatActionResponseCopyWith<$Res> {
  factory $ChatActionResponseCopyWith(
          ChatActionResponse value, $Res Function(ChatActionResponse) then) =
      _$ChatActionResponseCopyWithImpl<$Res, ChatActionResponse>;
  @useResult
  $Res call({int error, String message});
}

/// @nodoc
class _$ChatActionResponseCopyWithImpl<$Res, $Val extends ChatActionResponse>
    implements $ChatActionResponseCopyWith<$Res> {
  _$ChatActionResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatActionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatActionResponseImplCopyWith<$Res>
    implements $ChatActionResponseCopyWith<$Res> {
  factory _$$ChatActionResponseImplCopyWith(_$ChatActionResponseImpl value,
          $Res Function(_$ChatActionResponseImpl) then) =
      __$$ChatActionResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int error, String message});
}

/// @nodoc
class __$$ChatActionResponseImplCopyWithImpl<$Res>
    extends _$ChatActionResponseCopyWithImpl<$Res, _$ChatActionResponseImpl>
    implements _$$ChatActionResponseImplCopyWith<$Res> {
  __$$ChatActionResponseImplCopyWithImpl(_$ChatActionResponseImpl _value,
      $Res Function(_$ChatActionResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatActionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? message = null,
  }) {
    return _then(_$ChatActionResponseImpl(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatActionResponseImpl implements _ChatActionResponse {
  const _$ChatActionResponseImpl({required this.error, required this.message});

  factory _$ChatActionResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatActionResponseImplFromJson(json);

  @override
  final int error;
  @override
  final String message;

  @override
  String toString() {
    return 'ChatActionResponse(error: $error, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatActionResponseImpl &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, error, message);

  /// Create a copy of ChatActionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatActionResponseImplCopyWith<_$ChatActionResponseImpl> get copyWith =>
      __$$ChatActionResponseImplCopyWithImpl<_$ChatActionResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatActionResponseImplToJson(
      this,
    );
  }
}

abstract class _ChatActionResponse implements ChatActionResponse {
  const factory _ChatActionResponse(
      {required final int error,
      required final String message}) = _$ChatActionResponseImpl;

  factory _ChatActionResponse.fromJson(Map<String, dynamic> json) =
      _$ChatActionResponseImpl.fromJson;

  @override
  int get error;
  @override
  String get message;

  /// Create a copy of ChatActionResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatActionResponseImplCopyWith<_$ChatActionResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
