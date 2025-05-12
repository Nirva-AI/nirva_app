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

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as int,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
    _$UserImpl value,
    $Res Function(_$UserImpl) then,
  ) = __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name});
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
    : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _$UserImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as int,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  const _$UserImpl({required this.id, required this.name});

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final int id;
  @override
  final String name;

  @override
  String toString() {
    return 'User(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(this);
  }
}

abstract class _User implements User {
  const factory _User({required final int id, required final String name}) =
      _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  int get id;
  @override
  String get name;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

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
