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

ChatActionRequest _$ChatActionRequestFromJson(Map<String, dynamic> json) {
  return _ChatActionRequest.fromJson(json);
}

/// @nodoc
mixin _$ChatActionRequest {
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
  $Res call({String content});
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
    Object? content = null,
  }) {
    return _then(_value.copyWith(
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
  $Res call({String content});
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
    Object? content = null,
  }) {
    return _then(_$ChatActionRequestImpl(
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
  const _$ChatActionRequestImpl({required this.content});

  factory _$ChatActionRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatActionRequestImplFromJson(json);

  @override
  final String content;

  @override
  String toString() {
    return 'ChatActionRequest(content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatActionRequestImpl &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, content);

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
  const factory _ChatActionRequest({required final String content}) =
      _$ChatActionRequestImpl;

  factory _ChatActionRequest.fromJson(Map<String, dynamic> json) =
      _$ChatActionRequestImpl.fromJson;

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
  $Res call({String message});
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
    Object? message = null,
  }) {
    return _then(_value.copyWith(
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
  $Res call({String message});
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
    Object? message = null,
  }) {
    return _then(_$ChatActionResponseImpl(
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
  const _$ChatActionResponseImpl({required this.message});

  factory _$ChatActionResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatActionResponseImplFromJson(json);

  @override
  final String message;

  @override
  String toString() {
    return 'ChatActionResponse(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatActionResponseImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message);

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
  const factory _ChatActionResponse({required final String message}) =
      _$ChatActionResponseImpl;

  factory _ChatActionResponse.fromJson(Map<String, dynamic> json) =
      _$ChatActionResponseImpl.fromJson;

  @override
  String get message;

  /// Create a copy of ChatActionResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatActionResponseImplCopyWith<_$ChatActionResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
