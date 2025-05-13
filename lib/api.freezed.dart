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
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

APIEndpointConfiguration _$APIEndpointConfigurationFromJson(
  Map<String, dynamic> json,
) {
  return _APIEndpointConfiguration.fromJson(json);
}

/// @nodoc
mixin _$APIEndpointConfiguration {
  String get LOGIN_URL => throw _privateConstructorUsedError;
  String get LOGOUT_URL => throw _privateConstructorUsedError;
  String get CHAT_ACTION_URL => throw _privateConstructorUsedError;

  /// Serializes this APIEndpointConfiguration to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of APIEndpointConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $APIEndpointConfigurationCopyWith<APIEndpointConfiguration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $APIEndpointConfigurationCopyWith<$Res> {
  factory $APIEndpointConfigurationCopyWith(
    APIEndpointConfiguration value,
    $Res Function(APIEndpointConfiguration) then,
  ) = _$APIEndpointConfigurationCopyWithImpl<$Res, APIEndpointConfiguration>;
  @useResult
  $Res call({String LOGIN_URL, String LOGOUT_URL, String CHAT_ACTION_URL});
}

/// @nodoc
class _$APIEndpointConfigurationCopyWithImpl<
  $Res,
  $Val extends APIEndpointConfiguration
>
    implements $APIEndpointConfigurationCopyWith<$Res> {
  _$APIEndpointConfigurationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of APIEndpointConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? LOGIN_URL = null,
    Object? LOGOUT_URL = null,
    Object? CHAT_ACTION_URL = null,
  }) {
    return _then(
      _value.copyWith(
            LOGIN_URL:
                null == LOGIN_URL
                    ? _value.LOGIN_URL
                    : LOGIN_URL // ignore: cast_nullable_to_non_nullable
                        as String,
            LOGOUT_URL:
                null == LOGOUT_URL
                    ? _value.LOGOUT_URL
                    : LOGOUT_URL // ignore: cast_nullable_to_non_nullable
                        as String,
            CHAT_ACTION_URL:
                null == CHAT_ACTION_URL
                    ? _value.CHAT_ACTION_URL
                    : CHAT_ACTION_URL // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$APIEndpointConfigurationImplCopyWith<$Res>
    implements $APIEndpointConfigurationCopyWith<$Res> {
  factory _$$APIEndpointConfigurationImplCopyWith(
    _$APIEndpointConfigurationImpl value,
    $Res Function(_$APIEndpointConfigurationImpl) then,
  ) = __$$APIEndpointConfigurationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String LOGIN_URL, String LOGOUT_URL, String CHAT_ACTION_URL});
}

/// @nodoc
class __$$APIEndpointConfigurationImplCopyWithImpl<$Res>
    extends
        _$APIEndpointConfigurationCopyWithImpl<
          $Res,
          _$APIEndpointConfigurationImpl
        >
    implements _$$APIEndpointConfigurationImplCopyWith<$Res> {
  __$$APIEndpointConfigurationImplCopyWithImpl(
    _$APIEndpointConfigurationImpl _value,
    $Res Function(_$APIEndpointConfigurationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of APIEndpointConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? LOGIN_URL = null,
    Object? LOGOUT_URL = null,
    Object? CHAT_ACTION_URL = null,
  }) {
    return _then(
      _$APIEndpointConfigurationImpl(
        LOGIN_URL:
            null == LOGIN_URL
                ? _value.LOGIN_URL
                : LOGIN_URL // ignore: cast_nullable_to_non_nullable
                    as String,
        LOGOUT_URL:
            null == LOGOUT_URL
                ? _value.LOGOUT_URL
                : LOGOUT_URL // ignore: cast_nullable_to_non_nullable
                    as String,
        CHAT_ACTION_URL:
            null == CHAT_ACTION_URL
                ? _value.CHAT_ACTION_URL
                : CHAT_ACTION_URL // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$APIEndpointConfigurationImpl implements _APIEndpointConfiguration {
  const _$APIEndpointConfigurationImpl({
    required this.LOGIN_URL,
    required this.LOGOUT_URL,
    required this.CHAT_ACTION_URL,
  });

  factory _$APIEndpointConfigurationImpl.fromJson(Map<String, dynamic> json) =>
      _$$APIEndpointConfigurationImplFromJson(json);

  @override
  final String LOGIN_URL;
  @override
  final String LOGOUT_URL;
  @override
  final String CHAT_ACTION_URL;

  @override
  String toString() {
    return 'APIEndpointConfiguration(LOGIN_URL: $LOGIN_URL, LOGOUT_URL: $LOGOUT_URL, CHAT_ACTION_URL: $CHAT_ACTION_URL)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$APIEndpointConfigurationImpl &&
            (identical(other.LOGIN_URL, LOGIN_URL) ||
                other.LOGIN_URL == LOGIN_URL) &&
            (identical(other.LOGOUT_URL, LOGOUT_URL) ||
                other.LOGOUT_URL == LOGOUT_URL) &&
            (identical(other.CHAT_ACTION_URL, CHAT_ACTION_URL) ||
                other.CHAT_ACTION_URL == CHAT_ACTION_URL));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, LOGIN_URL, LOGOUT_URL, CHAT_ACTION_URL);

  /// Create a copy of APIEndpointConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$APIEndpointConfigurationImplCopyWith<_$APIEndpointConfigurationImpl>
  get copyWith => __$$APIEndpointConfigurationImplCopyWithImpl<
    _$APIEndpointConfigurationImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$APIEndpointConfigurationImplToJson(this);
  }
}

abstract class _APIEndpointConfiguration implements APIEndpointConfiguration {
  const factory _APIEndpointConfiguration({
    required final String LOGIN_URL,
    required final String LOGOUT_URL,
    required final String CHAT_ACTION_URL,
  }) = _$APIEndpointConfigurationImpl;

  factory _APIEndpointConfiguration.fromJson(Map<String, dynamic> json) =
      _$APIEndpointConfigurationImpl.fromJson;

  @override
  String get LOGIN_URL;
  @override
  String get LOGOUT_URL;
  @override
  String get CHAT_ACTION_URL;

  /// Create a copy of APIEndpointConfiguration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$APIEndpointConfigurationImplCopyWith<_$APIEndpointConfigurationImpl>
  get copyWith => throw _privateConstructorUsedError;
}

APIEndpointConfigurationResponse _$APIEndpointConfigurationResponseFromJson(
  Map<String, dynamic> json,
) {
  return _APIEndpointConfigurationResponse.fromJson(json);
}

/// @nodoc
mixin _$APIEndpointConfigurationResponse {
  APIEndpointConfiguration get api_endpoints =>
      throw _privateConstructorUsedError;
  int get error => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  /// Serializes this APIEndpointConfigurationResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of APIEndpointConfigurationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $APIEndpointConfigurationResponseCopyWith<APIEndpointConfigurationResponse>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $APIEndpointConfigurationResponseCopyWith<$Res> {
  factory $APIEndpointConfigurationResponseCopyWith(
    APIEndpointConfigurationResponse value,
    $Res Function(APIEndpointConfigurationResponse) then,
  ) =
      _$APIEndpointConfigurationResponseCopyWithImpl<
        $Res,
        APIEndpointConfigurationResponse
      >;
  @useResult
  $Res call({
    APIEndpointConfiguration api_endpoints,
    int error,
    String message,
  });

  $APIEndpointConfigurationCopyWith<$Res> get api_endpoints;
}

/// @nodoc
class _$APIEndpointConfigurationResponseCopyWithImpl<
  $Res,
  $Val extends APIEndpointConfigurationResponse
>
    implements $APIEndpointConfigurationResponseCopyWith<$Res> {
  _$APIEndpointConfigurationResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of APIEndpointConfigurationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? api_endpoints = null,
    Object? error = null,
    Object? message = null,
  }) {
    return _then(
      _value.copyWith(
            api_endpoints:
                null == api_endpoints
                    ? _value.api_endpoints
                    : api_endpoints // ignore: cast_nullable_to_non_nullable
                        as APIEndpointConfiguration,
            error:
                null == error
                    ? _value.error
                    : error // ignore: cast_nullable_to_non_nullable
                        as int,
            message:
                null == message
                    ? _value.message
                    : message // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }

  /// Create a copy of APIEndpointConfigurationResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $APIEndpointConfigurationCopyWith<$Res> get api_endpoints {
    return $APIEndpointConfigurationCopyWith<$Res>(_value.api_endpoints, (
      value,
    ) {
      return _then(_value.copyWith(api_endpoints: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$APIEndpointConfigurationResponseImplCopyWith<$Res>
    implements $APIEndpointConfigurationResponseCopyWith<$Res> {
  factory _$$APIEndpointConfigurationResponseImplCopyWith(
    _$APIEndpointConfigurationResponseImpl value,
    $Res Function(_$APIEndpointConfigurationResponseImpl) then,
  ) = __$$APIEndpointConfigurationResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    APIEndpointConfiguration api_endpoints,
    int error,
    String message,
  });

  @override
  $APIEndpointConfigurationCopyWith<$Res> get api_endpoints;
}

/// @nodoc
class __$$APIEndpointConfigurationResponseImplCopyWithImpl<$Res>
    extends
        _$APIEndpointConfigurationResponseCopyWithImpl<
          $Res,
          _$APIEndpointConfigurationResponseImpl
        >
    implements _$$APIEndpointConfigurationResponseImplCopyWith<$Res> {
  __$$APIEndpointConfigurationResponseImplCopyWithImpl(
    _$APIEndpointConfigurationResponseImpl _value,
    $Res Function(_$APIEndpointConfigurationResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of APIEndpointConfigurationResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? api_endpoints = null,
    Object? error = null,
    Object? message = null,
  }) {
    return _then(
      _$APIEndpointConfigurationResponseImpl(
        api_endpoints:
            null == api_endpoints
                ? _value.api_endpoints
                : api_endpoints // ignore: cast_nullable_to_non_nullable
                    as APIEndpointConfiguration,
        error:
            null == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                    as int,
        message:
            null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$APIEndpointConfigurationResponseImpl
    implements _APIEndpointConfigurationResponse {
  const _$APIEndpointConfigurationResponseImpl({
    required this.api_endpoints,
    required this.error,
    required this.message,
  });

  factory _$APIEndpointConfigurationResponseImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$APIEndpointConfigurationResponseImplFromJson(json);

  @override
  final APIEndpointConfiguration api_endpoints;
  @override
  final int error;
  @override
  final String message;

  @override
  String toString() {
    return 'APIEndpointConfigurationResponse(api_endpoints: $api_endpoints, error: $error, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$APIEndpointConfigurationResponseImpl &&
            (identical(other.api_endpoints, api_endpoints) ||
                other.api_endpoints == api_endpoints) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, api_endpoints, error, message);

  /// Create a copy of APIEndpointConfigurationResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$APIEndpointConfigurationResponseImplCopyWith<
    _$APIEndpointConfigurationResponseImpl
  >
  get copyWith => __$$APIEndpointConfigurationResponseImplCopyWithImpl<
    _$APIEndpointConfigurationResponseImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$APIEndpointConfigurationResponseImplToJson(this);
  }
}

abstract class _APIEndpointConfigurationResponse
    implements APIEndpointConfigurationResponse {
  const factory _APIEndpointConfigurationResponse({
    required final APIEndpointConfiguration api_endpoints,
    required final int error,
    required final String message,
  }) = _$APIEndpointConfigurationResponseImpl;

  factory _APIEndpointConfigurationResponse.fromJson(
    Map<String, dynamic> json,
  ) = _$APIEndpointConfigurationResponseImpl.fromJson;

  @override
  APIEndpointConfiguration get api_endpoints;
  @override
  int get error;
  @override
  String get message;

  /// Create a copy of APIEndpointConfigurationResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$APIEndpointConfigurationResponseImplCopyWith<
    _$APIEndpointConfigurationResponseImpl
  >
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
    LoginRequest value,
    $Res Function(LoginRequest) then,
  ) = _$LoginRequestCopyWithImpl<$Res, LoginRequest>;
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
  $Res call({Object? user_name = null}) {
    return _then(
      _value.copyWith(
            user_name:
                null == user_name
                    ? _value.user_name
                    : user_name // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoginRequestImplCopyWith<$Res>
    implements $LoginRequestCopyWith<$Res> {
  factory _$$LoginRequestImplCopyWith(
    _$LoginRequestImpl value,
    $Res Function(_$LoginRequestImpl) then,
  ) = __$$LoginRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String user_name});
}

/// @nodoc
class __$$LoginRequestImplCopyWithImpl<$Res>
    extends _$LoginRequestCopyWithImpl<$Res, _$LoginRequestImpl>
    implements _$$LoginRequestImplCopyWith<$Res> {
  __$$LoginRequestImplCopyWithImpl(
    _$LoginRequestImpl _value,
    $Res Function(_$LoginRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user_name = null}) {
    return _then(
      _$LoginRequestImpl(
        user_name:
            null == user_name
                ? _value.user_name
                : user_name // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
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
    return _$$LoginRequestImplToJson(this);
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
    LoginResponse value,
    $Res Function(LoginResponse) then,
  ) = _$LoginResponseCopyWithImpl<$Res, LoginResponse>;
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
  $Res call({Object? error = null, Object? message = null}) {
    return _then(
      _value.copyWith(
            error:
                null == error
                    ? _value.error
                    : error // ignore: cast_nullable_to_non_nullable
                        as int,
            message:
                null == message
                    ? _value.message
                    : message // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoginResponseImplCopyWith<$Res>
    implements $LoginResponseCopyWith<$Res> {
  factory _$$LoginResponseImplCopyWith(
    _$LoginResponseImpl value,
    $Res Function(_$LoginResponseImpl) then,
  ) = __$$LoginResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int error, String message});
}

/// @nodoc
class __$$LoginResponseImplCopyWithImpl<$Res>
    extends _$LoginResponseCopyWithImpl<$Res, _$LoginResponseImpl>
    implements _$$LoginResponseImplCopyWith<$Res> {
  __$$LoginResponseImplCopyWithImpl(
    _$LoginResponseImpl _value,
    $Res Function(_$LoginResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? error = null, Object? message = null}) {
    return _then(
      _$LoginResponseImpl(
        error:
            null == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                    as int,
        message:
            null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
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
    return _$$LoginResponseImplToJson(this);
  }
}

abstract class _LoginResponse implements LoginResponse {
  const factory _LoginResponse({
    required final int error,
    required final String message,
  }) = _$LoginResponseImpl;

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
    LogoutRequest value,
    $Res Function(LogoutRequest) then,
  ) = _$LogoutRequestCopyWithImpl<$Res, LogoutRequest>;
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
  $Res call({Object? user_name = null}) {
    return _then(
      _value.copyWith(
            user_name:
                null == user_name
                    ? _value.user_name
                    : user_name // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LogoutRequestImplCopyWith<$Res>
    implements $LogoutRequestCopyWith<$Res> {
  factory _$$LogoutRequestImplCopyWith(
    _$LogoutRequestImpl value,
    $Res Function(_$LogoutRequestImpl) then,
  ) = __$$LogoutRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String user_name});
}

/// @nodoc
class __$$LogoutRequestImplCopyWithImpl<$Res>
    extends _$LogoutRequestCopyWithImpl<$Res, _$LogoutRequestImpl>
    implements _$$LogoutRequestImplCopyWith<$Res> {
  __$$LogoutRequestImplCopyWithImpl(
    _$LogoutRequestImpl _value,
    $Res Function(_$LogoutRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LogoutRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user_name = null}) {
    return _then(
      _$LogoutRequestImpl(
        user_name:
            null == user_name
                ? _value.user_name
                : user_name // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
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
    return _$$LogoutRequestImplToJson(this);
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
    LogoutResponse value,
    $Res Function(LogoutResponse) then,
  ) = _$LogoutResponseCopyWithImpl<$Res, LogoutResponse>;
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
  $Res call({Object? error = null, Object? message = null}) {
    return _then(
      _value.copyWith(
            error:
                null == error
                    ? _value.error
                    : error // ignore: cast_nullable_to_non_nullable
                        as int,
            message:
                null == message
                    ? _value.message
                    : message // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LogoutResponseImplCopyWith<$Res>
    implements $LogoutResponseCopyWith<$Res> {
  factory _$$LogoutResponseImplCopyWith(
    _$LogoutResponseImpl value,
    $Res Function(_$LogoutResponseImpl) then,
  ) = __$$LogoutResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int error, String message});
}

/// @nodoc
class __$$LogoutResponseImplCopyWithImpl<$Res>
    extends _$LogoutResponseCopyWithImpl<$Res, _$LogoutResponseImpl>
    implements _$$LogoutResponseImplCopyWith<$Res> {
  __$$LogoutResponseImplCopyWithImpl(
    _$LogoutResponseImpl _value,
    $Res Function(_$LogoutResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LogoutResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? error = null, Object? message = null}) {
    return _then(
      _$LogoutResponseImpl(
        error:
            null == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                    as int,
        message:
            null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
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
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$LogoutResponseImplToJson(this);
  }
}

abstract class _LogoutResponse implements LogoutResponse {
  const factory _LogoutResponse({
    required final int error,
    required final String message,
  }) = _$LogoutResponseImpl;

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
    ChatActionRequest value,
    $Res Function(ChatActionRequest) then,
  ) = _$ChatActionRequestCopyWithImpl<$Res, ChatActionRequest>;
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
  $Res call({Object? user_name = null, Object? content = null}) {
    return _then(
      _value.copyWith(
            user_name:
                null == user_name
                    ? _value.user_name
                    : user_name // ignore: cast_nullable_to_non_nullable
                        as String,
            content:
                null == content
                    ? _value.content
                    : content // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatActionRequestImplCopyWith<$Res>
    implements $ChatActionRequestCopyWith<$Res> {
  factory _$$ChatActionRequestImplCopyWith(
    _$ChatActionRequestImpl value,
    $Res Function(_$ChatActionRequestImpl) then,
  ) = __$$ChatActionRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String user_name, String content});
}

/// @nodoc
class __$$ChatActionRequestImplCopyWithImpl<$Res>
    extends _$ChatActionRequestCopyWithImpl<$Res, _$ChatActionRequestImpl>
    implements _$$ChatActionRequestImplCopyWith<$Res> {
  __$$ChatActionRequestImplCopyWithImpl(
    _$ChatActionRequestImpl _value,
    $Res Function(_$ChatActionRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatActionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? user_name = null, Object? content = null}) {
    return _then(
      _$ChatActionRequestImpl(
        user_name:
            null == user_name
                ? _value.user_name
                : user_name // ignore: cast_nullable_to_non_nullable
                    as String,
        content:
            null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatActionRequestImpl implements _ChatActionRequest {
  const _$ChatActionRequestImpl({
    required this.user_name,
    required this.content,
  });

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
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatActionRequestImplToJson(this);
  }
}

abstract class _ChatActionRequest implements ChatActionRequest {
  const factory _ChatActionRequest({
    required final String user_name,
    required final String content,
  }) = _$ChatActionRequestImpl;

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
    ChatActionResponse value,
    $Res Function(ChatActionResponse) then,
  ) = _$ChatActionResponseCopyWithImpl<$Res, ChatActionResponse>;
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
  $Res call({Object? error = null, Object? message = null}) {
    return _then(
      _value.copyWith(
            error:
                null == error
                    ? _value.error
                    : error // ignore: cast_nullable_to_non_nullable
                        as int,
            message:
                null == message
                    ? _value.message
                    : message // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChatActionResponseImplCopyWith<$Res>
    implements $ChatActionResponseCopyWith<$Res> {
  factory _$$ChatActionResponseImplCopyWith(
    _$ChatActionResponseImpl value,
    $Res Function(_$ChatActionResponseImpl) then,
  ) = __$$ChatActionResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int error, String message});
}

/// @nodoc
class __$$ChatActionResponseImplCopyWithImpl<$Res>
    extends _$ChatActionResponseCopyWithImpl<$Res, _$ChatActionResponseImpl>
    implements _$$ChatActionResponseImplCopyWith<$Res> {
  __$$ChatActionResponseImplCopyWithImpl(
    _$ChatActionResponseImpl _value,
    $Res Function(_$ChatActionResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChatActionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? error = null, Object? message = null}) {
    return _then(
      _$ChatActionResponseImpl(
        error:
            null == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                    as int,
        message:
            null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
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
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatActionResponseImplToJson(this);
  }
}

abstract class _ChatActionResponse implements ChatActionResponse {
  const factory _ChatActionResponse({
    required final int error,
    required final String message,
  }) = _$ChatActionResponseImpl;

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
