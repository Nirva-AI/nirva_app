// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_models.dart';

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

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) {
  return _ChatMessage.fromJson(json);
}

/// @nodoc
mixin _$ChatMessage {
  String get id => throw _privateConstructorUsedError;
  int get role => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  String get time_stamp => throw _privateConstructorUsedError;
  List<String>? get tags => throw _privateConstructorUsedError;

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChatMessageCopyWith<ChatMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatMessageCopyWith<$Res> {
  factory $ChatMessageCopyWith(
          ChatMessage value, $Res Function(ChatMessage) then) =
      _$ChatMessageCopyWithImpl<$Res, ChatMessage>;
  @useResult
  $Res call(
      {String id,
      int role,
      String content,
      String time_stamp,
      List<String>? tags});
}

/// @nodoc
class _$ChatMessageCopyWithImpl<$Res, $Val extends ChatMessage>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? content = null,
    Object? time_stamp = null,
    Object? tags = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as int,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      time_stamp: null == time_stamp
          ? _value.time_stamp
          : time_stamp // ignore: cast_nullable_to_non_nullable
              as String,
      tags: freezed == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatMessageImplCopyWith<$Res>
    implements $ChatMessageCopyWith<$Res> {
  factory _$$ChatMessageImplCopyWith(
          _$ChatMessageImpl value, $Res Function(_$ChatMessageImpl) then) =
      __$$ChatMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      int role,
      String content,
      String time_stamp,
      List<String>? tags});
}

/// @nodoc
class __$$ChatMessageImplCopyWithImpl<$Res>
    extends _$ChatMessageCopyWithImpl<$Res, _$ChatMessageImpl>
    implements _$$ChatMessageImplCopyWith<$Res> {
  __$$ChatMessageImplCopyWithImpl(
      _$ChatMessageImpl _value, $Res Function(_$ChatMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? role = null,
    Object? content = null,
    Object? time_stamp = null,
    Object? tags = freezed,
  }) {
    return _then(_$ChatMessageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as int,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      time_stamp: null == time_stamp
          ? _value.time_stamp
          : time_stamp // ignore: cast_nullable_to_non_nullable
              as String,
      tags: freezed == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatMessageImpl implements _ChatMessage {
  const _$ChatMessageImpl(
      {required this.id,
      required this.role,
      required this.content,
      required this.time_stamp,
      final List<String>? tags})
      : _tags = tags;

  factory _$ChatMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatMessageImplFromJson(json);

  @override
  final String id;
  @override
  final int role;
  @override
  final String content;
  @override
  final String time_stamp;
  final List<String>? _tags;
  @override
  List<String>? get tags {
    final value = _tags;
    if (value == null) return null;
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ChatMessage(id: $id, role: $role, content: $content, time_stamp: $time_stamp, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.time_stamp, time_stamp) ||
                other.time_stamp == time_stamp) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, role, content, time_stamp,
      const DeepCollectionEquality().hash(_tags));

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      __$$ChatMessageImplCopyWithImpl<_$ChatMessageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatMessageImplToJson(
      this,
    );
  }
}

abstract class _ChatMessage implements ChatMessage {
  const factory _ChatMessage(
      {required final String id,
      required final int role,
      required final String content,
      required final String time_stamp,
      final List<String>? tags}) = _$ChatMessageImpl;

  factory _ChatMessage.fromJson(Map<String, dynamic> json) =
      _$ChatMessageImpl.fromJson;

  @override
  String get id;
  @override
  int get role;
  @override
  String get content;
  @override
  String get time_stamp;
  @override
  List<String>? get tags;

  /// Create a copy of ChatMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatMessageImplCopyWith<_$ChatMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatActionRequest _$ChatActionRequestFromJson(Map<String, dynamic> json) {
  return _ChatActionRequest.fromJson(json);
}

/// @nodoc
mixin _$ChatActionRequest {
  ChatMessage get human_message => throw _privateConstructorUsedError;
  List<ChatMessage> get chat_history => throw _privateConstructorUsedError;

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
  $Res call({ChatMessage human_message, List<ChatMessage> chat_history});

  $ChatMessageCopyWith<$Res> get human_message;
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
    Object? human_message = null,
    Object? chat_history = null,
  }) {
    return _then(_value.copyWith(
      human_message: null == human_message
          ? _value.human_message
          : human_message // ignore: cast_nullable_to_non_nullable
              as ChatMessage,
      chat_history: null == chat_history
          ? _value.chat_history
          : chat_history // ignore: cast_nullable_to_non_nullable
              as List<ChatMessage>,
    ) as $Val);
  }

  /// Create a copy of ChatActionRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatMessageCopyWith<$Res> get human_message {
    return $ChatMessageCopyWith<$Res>(_value.human_message, (value) {
      return _then(_value.copyWith(human_message: value) as $Val);
    });
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
  $Res call({ChatMessage human_message, List<ChatMessage> chat_history});

  @override
  $ChatMessageCopyWith<$Res> get human_message;
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
    Object? human_message = null,
    Object? chat_history = null,
  }) {
    return _then(_$ChatActionRequestImpl(
      human_message: null == human_message
          ? _value.human_message
          : human_message // ignore: cast_nullable_to_non_nullable
              as ChatMessage,
      chat_history: null == chat_history
          ? _value._chat_history
          : chat_history // ignore: cast_nullable_to_non_nullable
              as List<ChatMessage>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatActionRequestImpl implements _ChatActionRequest {
  const _$ChatActionRequestImpl(
      {required this.human_message,
      required final List<ChatMessage> chat_history})
      : _chat_history = chat_history;

  factory _$ChatActionRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatActionRequestImplFromJson(json);

  @override
  final ChatMessage human_message;
  final List<ChatMessage> _chat_history;
  @override
  List<ChatMessage> get chat_history {
    if (_chat_history is EqualUnmodifiableListView) return _chat_history;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_chat_history);
  }

  @override
  String toString() {
    return 'ChatActionRequest(human_message: $human_message, chat_history: $chat_history)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatActionRequestImpl &&
            (identical(other.human_message, human_message) ||
                other.human_message == human_message) &&
            const DeepCollectionEquality()
                .equals(other._chat_history, _chat_history));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, human_message,
      const DeepCollectionEquality().hash(_chat_history));

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
      {required final ChatMessage human_message,
      required final List<ChatMessage> chat_history}) = _$ChatActionRequestImpl;

  factory _ChatActionRequest.fromJson(Map<String, dynamic> json) =
      _$ChatActionRequestImpl.fromJson;

  @override
  ChatMessage get human_message;
  @override
  List<ChatMessage> get chat_history;

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
  ChatMessage get ai_message => throw _privateConstructorUsedError;

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
  $Res call({ChatMessage ai_message});

  $ChatMessageCopyWith<$Res> get ai_message;
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
    Object? ai_message = null,
  }) {
    return _then(_value.copyWith(
      ai_message: null == ai_message
          ? _value.ai_message
          : ai_message // ignore: cast_nullable_to_non_nullable
              as ChatMessage,
    ) as $Val);
  }

  /// Create a copy of ChatActionResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatMessageCopyWith<$Res> get ai_message {
    return $ChatMessageCopyWith<$Res>(_value.ai_message, (value) {
      return _then(_value.copyWith(ai_message: value) as $Val);
    });
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
  $Res call({ChatMessage ai_message});

  @override
  $ChatMessageCopyWith<$Res> get ai_message;
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
    Object? ai_message = null,
  }) {
    return _then(_$ChatActionResponseImpl(
      ai_message: null == ai_message
          ? _value.ai_message
          : ai_message // ignore: cast_nullable_to_non_nullable
              as ChatMessage,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatActionResponseImpl implements _ChatActionResponse {
  const _$ChatActionResponseImpl({required this.ai_message});

  factory _$ChatActionResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatActionResponseImplFromJson(json);

  @override
  final ChatMessage ai_message;

  @override
  String toString() {
    return 'ChatActionResponse(ai_message: $ai_message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatActionResponseImpl &&
            (identical(other.ai_message, ai_message) ||
                other.ai_message == ai_message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, ai_message);

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
  const factory _ChatActionResponse({required final ChatMessage ai_message}) =
      _$ChatActionResponseImpl;

  factory _ChatActionResponse.fromJson(Map<String, dynamic> json) =
      _$ChatActionResponseImpl.fromJson;

  @override
  ChatMessage get ai_message;

  /// Create a copy of ChatActionResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChatActionResponseImplCopyWith<_$ChatActionResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AnalyzeActionRequest _$AnalyzeActionRequestFromJson(Map<String, dynamic> json) {
  return _AnalyzeActionRequest.fromJson(json);
}

/// @nodoc
mixin _$AnalyzeActionRequest {
  String get time_stamp => throw _privateConstructorUsedError;
  int get file_number => throw _privateConstructorUsedError;

  /// Serializes this AnalyzeActionRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnalyzeActionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnalyzeActionRequestCopyWith<AnalyzeActionRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnalyzeActionRequestCopyWith<$Res> {
  factory $AnalyzeActionRequestCopyWith(AnalyzeActionRequest value,
          $Res Function(AnalyzeActionRequest) then) =
      _$AnalyzeActionRequestCopyWithImpl<$Res, AnalyzeActionRequest>;
  @useResult
  $Res call({String time_stamp, int file_number});
}

/// @nodoc
class _$AnalyzeActionRequestCopyWithImpl<$Res,
        $Val extends AnalyzeActionRequest>
    implements $AnalyzeActionRequestCopyWith<$Res> {
  _$AnalyzeActionRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnalyzeActionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time_stamp = null,
    Object? file_number = null,
  }) {
    return _then(_value.copyWith(
      time_stamp: null == time_stamp
          ? _value.time_stamp
          : time_stamp // ignore: cast_nullable_to_non_nullable
              as String,
      file_number: null == file_number
          ? _value.file_number
          : file_number // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AnalyzeActionRequestImplCopyWith<$Res>
    implements $AnalyzeActionRequestCopyWith<$Res> {
  factory _$$AnalyzeActionRequestImplCopyWith(_$AnalyzeActionRequestImpl value,
          $Res Function(_$AnalyzeActionRequestImpl) then) =
      __$$AnalyzeActionRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String time_stamp, int file_number});
}

/// @nodoc
class __$$AnalyzeActionRequestImplCopyWithImpl<$Res>
    extends _$AnalyzeActionRequestCopyWithImpl<$Res, _$AnalyzeActionRequestImpl>
    implements _$$AnalyzeActionRequestImplCopyWith<$Res> {
  __$$AnalyzeActionRequestImplCopyWithImpl(_$AnalyzeActionRequestImpl _value,
      $Res Function(_$AnalyzeActionRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of AnalyzeActionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time_stamp = null,
    Object? file_number = null,
  }) {
    return _then(_$AnalyzeActionRequestImpl(
      time_stamp: null == time_stamp
          ? _value.time_stamp
          : time_stamp // ignore: cast_nullable_to_non_nullable
              as String,
      file_number: null == file_number
          ? _value.file_number
          : file_number // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AnalyzeActionRequestImpl implements _AnalyzeActionRequest {
  const _$AnalyzeActionRequestImpl(
      {required this.time_stamp, required this.file_number});

  factory _$AnalyzeActionRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnalyzeActionRequestImplFromJson(json);

  @override
  final String time_stamp;
  @override
  final int file_number;

  @override
  String toString() {
    return 'AnalyzeActionRequest(time_stamp: $time_stamp, file_number: $file_number)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnalyzeActionRequestImpl &&
            (identical(other.time_stamp, time_stamp) ||
                other.time_stamp == time_stamp) &&
            (identical(other.file_number, file_number) ||
                other.file_number == file_number));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, time_stamp, file_number);

  /// Create a copy of AnalyzeActionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnalyzeActionRequestImplCopyWith<_$AnalyzeActionRequestImpl>
      get copyWith =>
          __$$AnalyzeActionRequestImplCopyWithImpl<_$AnalyzeActionRequestImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnalyzeActionRequestImplToJson(
      this,
    );
  }
}

abstract class _AnalyzeActionRequest implements AnalyzeActionRequest {
  const factory _AnalyzeActionRequest(
      {required final String time_stamp,
      required final int file_number}) = _$AnalyzeActionRequestImpl;

  factory _AnalyzeActionRequest.fromJson(Map<String, dynamic> json) =
      _$AnalyzeActionRequestImpl.fromJson;

  @override
  String get time_stamp;
  @override
  int get file_number;

  /// Create a copy of AnalyzeActionRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnalyzeActionRequestImplCopyWith<_$AnalyzeActionRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UploadTranscriptActionRequest _$UploadTranscriptActionRequestFromJson(
    Map<String, dynamic> json) {
  return _UploadTranscriptActionRequest.fromJson(json);
}

/// @nodoc
mixin _$UploadTranscriptActionRequest {
  String get transcript_content => throw _privateConstructorUsedError;
  String get time_stamp => throw _privateConstructorUsedError;
  int get file_number => throw _privateConstructorUsedError;
  String get file_suffix => throw _privateConstructorUsedError;

  /// Serializes this UploadTranscriptActionRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UploadTranscriptActionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UploadTranscriptActionRequestCopyWith<UploadTranscriptActionRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UploadTranscriptActionRequestCopyWith<$Res> {
  factory $UploadTranscriptActionRequestCopyWith(
          UploadTranscriptActionRequest value,
          $Res Function(UploadTranscriptActionRequest) then) =
      _$UploadTranscriptActionRequestCopyWithImpl<$Res,
          UploadTranscriptActionRequest>;
  @useResult
  $Res call(
      {String transcript_content,
      String time_stamp,
      int file_number,
      String file_suffix});
}

/// @nodoc
class _$UploadTranscriptActionRequestCopyWithImpl<$Res,
        $Val extends UploadTranscriptActionRequest>
    implements $UploadTranscriptActionRequestCopyWith<$Res> {
  _$UploadTranscriptActionRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UploadTranscriptActionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transcript_content = null,
    Object? time_stamp = null,
    Object? file_number = null,
    Object? file_suffix = null,
  }) {
    return _then(_value.copyWith(
      transcript_content: null == transcript_content
          ? _value.transcript_content
          : transcript_content // ignore: cast_nullable_to_non_nullable
              as String,
      time_stamp: null == time_stamp
          ? _value.time_stamp
          : time_stamp // ignore: cast_nullable_to_non_nullable
              as String,
      file_number: null == file_number
          ? _value.file_number
          : file_number // ignore: cast_nullable_to_non_nullable
              as int,
      file_suffix: null == file_suffix
          ? _value.file_suffix
          : file_suffix // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UploadTranscriptActionRequestImplCopyWith<$Res>
    implements $UploadTranscriptActionRequestCopyWith<$Res> {
  factory _$$UploadTranscriptActionRequestImplCopyWith(
          _$UploadTranscriptActionRequestImpl value,
          $Res Function(_$UploadTranscriptActionRequestImpl) then) =
      __$$UploadTranscriptActionRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String transcript_content,
      String time_stamp,
      int file_number,
      String file_suffix});
}

/// @nodoc
class __$$UploadTranscriptActionRequestImplCopyWithImpl<$Res>
    extends _$UploadTranscriptActionRequestCopyWithImpl<$Res,
        _$UploadTranscriptActionRequestImpl>
    implements _$$UploadTranscriptActionRequestImplCopyWith<$Res> {
  __$$UploadTranscriptActionRequestImplCopyWithImpl(
      _$UploadTranscriptActionRequestImpl _value,
      $Res Function(_$UploadTranscriptActionRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of UploadTranscriptActionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transcript_content = null,
    Object? time_stamp = null,
    Object? file_number = null,
    Object? file_suffix = null,
  }) {
    return _then(_$UploadTranscriptActionRequestImpl(
      transcript_content: null == transcript_content
          ? _value.transcript_content
          : transcript_content // ignore: cast_nullable_to_non_nullable
              as String,
      time_stamp: null == time_stamp
          ? _value.time_stamp
          : time_stamp // ignore: cast_nullable_to_non_nullable
              as String,
      file_number: null == file_number
          ? _value.file_number
          : file_number // ignore: cast_nullable_to_non_nullable
              as int,
      file_suffix: null == file_suffix
          ? _value.file_suffix
          : file_suffix // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UploadTranscriptActionRequestImpl
    implements _UploadTranscriptActionRequest {
  const _$UploadTranscriptActionRequestImpl(
      {required this.transcript_content,
      required this.time_stamp,
      required this.file_number,
      required this.file_suffix});

  factory _$UploadTranscriptActionRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$UploadTranscriptActionRequestImplFromJson(json);

  @override
  final String transcript_content;
  @override
  final String time_stamp;
  @override
  final int file_number;
  @override
  final String file_suffix;

  @override
  String toString() {
    return 'UploadTranscriptActionRequest(transcript_content: $transcript_content, time_stamp: $time_stamp, file_number: $file_number, file_suffix: $file_suffix)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadTranscriptActionRequestImpl &&
            (identical(other.transcript_content, transcript_content) ||
                other.transcript_content == transcript_content) &&
            (identical(other.time_stamp, time_stamp) ||
                other.time_stamp == time_stamp) &&
            (identical(other.file_number, file_number) ||
                other.file_number == file_number) &&
            (identical(other.file_suffix, file_suffix) ||
                other.file_suffix == file_suffix));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, transcript_content, time_stamp, file_number, file_suffix);

  /// Create a copy of UploadTranscriptActionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadTranscriptActionRequestImplCopyWith<
          _$UploadTranscriptActionRequestImpl>
      get copyWith => __$$UploadTranscriptActionRequestImplCopyWithImpl<
          _$UploadTranscriptActionRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UploadTranscriptActionRequestImplToJson(
      this,
    );
  }
}

abstract class _UploadTranscriptActionRequest
    implements UploadTranscriptActionRequest {
  const factory _UploadTranscriptActionRequest(
      {required final String transcript_content,
      required final String time_stamp,
      required final int file_number,
      required final String file_suffix}) = _$UploadTranscriptActionRequestImpl;

  factory _UploadTranscriptActionRequest.fromJson(Map<String, dynamic> json) =
      _$UploadTranscriptActionRequestImpl.fromJson;

  @override
  String get transcript_content;
  @override
  String get time_stamp;
  @override
  int get file_number;
  @override
  String get file_suffix;

  /// Create a copy of UploadTranscriptActionRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadTranscriptActionRequestImplCopyWith<
          _$UploadTranscriptActionRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}

UploadTranscriptActionResponse _$UploadTranscriptActionResponseFromJson(
    Map<String, dynamic> json) {
  return _UploadTranscriptActionResponse.fromJson(json);
}

/// @nodoc
mixin _$UploadTranscriptActionResponse {
  String get message => throw _privateConstructorUsedError;

  /// Serializes this UploadTranscriptActionResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UploadTranscriptActionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UploadTranscriptActionResponseCopyWith<UploadTranscriptActionResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UploadTranscriptActionResponseCopyWith<$Res> {
  factory $UploadTranscriptActionResponseCopyWith(
          UploadTranscriptActionResponse value,
          $Res Function(UploadTranscriptActionResponse) then) =
      _$UploadTranscriptActionResponseCopyWithImpl<$Res,
          UploadTranscriptActionResponse>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$UploadTranscriptActionResponseCopyWithImpl<$Res,
        $Val extends UploadTranscriptActionResponse>
    implements $UploadTranscriptActionResponseCopyWith<$Res> {
  _$UploadTranscriptActionResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UploadTranscriptActionResponse
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
abstract class _$$UploadTranscriptActionResponseImplCopyWith<$Res>
    implements $UploadTranscriptActionResponseCopyWith<$Res> {
  factory _$$UploadTranscriptActionResponseImplCopyWith(
          _$UploadTranscriptActionResponseImpl value,
          $Res Function(_$UploadTranscriptActionResponseImpl) then) =
      __$$UploadTranscriptActionResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$UploadTranscriptActionResponseImplCopyWithImpl<$Res>
    extends _$UploadTranscriptActionResponseCopyWithImpl<$Res,
        _$UploadTranscriptActionResponseImpl>
    implements _$$UploadTranscriptActionResponseImplCopyWith<$Res> {
  __$$UploadTranscriptActionResponseImplCopyWithImpl(
      _$UploadTranscriptActionResponseImpl _value,
      $Res Function(_$UploadTranscriptActionResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of UploadTranscriptActionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$UploadTranscriptActionResponseImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UploadTranscriptActionResponseImpl
    implements _UploadTranscriptActionResponse {
  const _$UploadTranscriptActionResponseImpl({this.message = ''});

  factory _$UploadTranscriptActionResponseImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$UploadTranscriptActionResponseImplFromJson(json);

  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'UploadTranscriptActionResponse(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UploadTranscriptActionResponseImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of UploadTranscriptActionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UploadTranscriptActionResponseImplCopyWith<
          _$UploadTranscriptActionResponseImpl>
      get copyWith => __$$UploadTranscriptActionResponseImplCopyWithImpl<
          _$UploadTranscriptActionResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UploadTranscriptActionResponseImplToJson(
      this,
    );
  }
}

abstract class _UploadTranscriptActionResponse
    implements UploadTranscriptActionResponse {
  const factory _UploadTranscriptActionResponse({final String message}) =
      _$UploadTranscriptActionResponseImpl;

  factory _UploadTranscriptActionResponse.fromJson(Map<String, dynamic> json) =
      _$UploadTranscriptActionResponseImpl.fromJson;

  @override
  String get message;

  /// Create a copy of UploadTranscriptActionResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UploadTranscriptActionResponseImplCopyWith<
          _$UploadTranscriptActionResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

BackgroundTaskResponse _$BackgroundTaskResponseFromJson(
    Map<String, dynamic> json) {
  return _BackgroundTaskResponse.fromJson(json);
}

/// @nodoc
mixin _$BackgroundTaskResponse {
  String get task_id => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  /// Serializes this BackgroundTaskResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BackgroundTaskResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BackgroundTaskResponseCopyWith<BackgroundTaskResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BackgroundTaskResponseCopyWith<$Res> {
  factory $BackgroundTaskResponseCopyWith(BackgroundTaskResponse value,
          $Res Function(BackgroundTaskResponse) then) =
      _$BackgroundTaskResponseCopyWithImpl<$Res, BackgroundTaskResponse>;
  @useResult
  $Res call({String task_id, String message});
}

/// @nodoc
class _$BackgroundTaskResponseCopyWithImpl<$Res,
        $Val extends BackgroundTaskResponse>
    implements $BackgroundTaskResponseCopyWith<$Res> {
  _$BackgroundTaskResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BackgroundTaskResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? task_id = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      task_id: null == task_id
          ? _value.task_id
          : task_id // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BackgroundTaskResponseImplCopyWith<$Res>
    implements $BackgroundTaskResponseCopyWith<$Res> {
  factory _$$BackgroundTaskResponseImplCopyWith(
          _$BackgroundTaskResponseImpl value,
          $Res Function(_$BackgroundTaskResponseImpl) then) =
      __$$BackgroundTaskResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String task_id, String message});
}

/// @nodoc
class __$$BackgroundTaskResponseImplCopyWithImpl<$Res>
    extends _$BackgroundTaskResponseCopyWithImpl<$Res,
        _$BackgroundTaskResponseImpl>
    implements _$$BackgroundTaskResponseImplCopyWith<$Res> {
  __$$BackgroundTaskResponseImplCopyWithImpl(
      _$BackgroundTaskResponseImpl _value,
      $Res Function(_$BackgroundTaskResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of BackgroundTaskResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? task_id = null,
    Object? message = null,
  }) {
    return _then(_$BackgroundTaskResponseImpl(
      task_id: null == task_id
          ? _value.task_id
          : task_id // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BackgroundTaskResponseImpl implements _BackgroundTaskResponse {
  const _$BackgroundTaskResponseImpl(
      {required this.task_id, required this.message});

  factory _$BackgroundTaskResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$BackgroundTaskResponseImplFromJson(json);

  @override
  final String task_id;
  @override
  final String message;

  @override
  String toString() {
    return 'BackgroundTaskResponse(task_id: $task_id, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BackgroundTaskResponseImpl &&
            (identical(other.task_id, task_id) || other.task_id == task_id) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, task_id, message);

  /// Create a copy of BackgroundTaskResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BackgroundTaskResponseImplCopyWith<_$BackgroundTaskResponseImpl>
      get copyWith => __$$BackgroundTaskResponseImplCopyWithImpl<
          _$BackgroundTaskResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BackgroundTaskResponseImplToJson(
      this,
    );
  }
}

abstract class _BackgroundTaskResponse implements BackgroundTaskResponse {
  const factory _BackgroundTaskResponse(
      {required final String task_id,
      required final String message}) = _$BackgroundTaskResponseImpl;

  factory _BackgroundTaskResponse.fromJson(Map<String, dynamic> json) =
      _$BackgroundTaskResponseImpl.fromJson;

  @override
  String get task_id;
  @override
  String get message;

  /// Create a copy of BackgroundTaskResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BackgroundTaskResponseImplCopyWith<_$BackgroundTaskResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TranscriptionItem _$TranscriptionItemFromJson(Map<String, dynamic> json) {
  return _TranscriptionItem.fromJson(json);
}

/// @nodoc
mixin _$TranscriptionItem {
  String? get id => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  String get start_time =>
      throw _privateConstructorUsedError; // ISO format timestamp from server
  String get end_time => throw _privateConstructorUsedError;

  /// Serializes this TranscriptionItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TranscriptionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TranscriptionItemCopyWith<TranscriptionItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TranscriptionItemCopyWith<$Res> {
  factory $TranscriptionItemCopyWith(
          TranscriptionItem value, $Res Function(TranscriptionItem) then) =
      _$TranscriptionItemCopyWithImpl<$Res, TranscriptionItem>;
  @useResult
  $Res call({String? id, String text, String start_time, String end_time});
}

/// @nodoc
class _$TranscriptionItemCopyWithImpl<$Res, $Val extends TranscriptionItem>
    implements $TranscriptionItemCopyWith<$Res> {
  _$TranscriptionItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TranscriptionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? text = null,
    Object? start_time = null,
    Object? end_time = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      start_time: null == start_time
          ? _value.start_time
          : start_time // ignore: cast_nullable_to_non_nullable
              as String,
      end_time: null == end_time
          ? _value.end_time
          : end_time // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TranscriptionItemImplCopyWith<$Res>
    implements $TranscriptionItemCopyWith<$Res> {
  factory _$$TranscriptionItemImplCopyWith(_$TranscriptionItemImpl value,
          $Res Function(_$TranscriptionItemImpl) then) =
      __$$TranscriptionItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? id, String text, String start_time, String end_time});
}

/// @nodoc
class __$$TranscriptionItemImplCopyWithImpl<$Res>
    extends _$TranscriptionItemCopyWithImpl<$Res, _$TranscriptionItemImpl>
    implements _$$TranscriptionItemImplCopyWith<$Res> {
  __$$TranscriptionItemImplCopyWithImpl(_$TranscriptionItemImpl _value,
      $Res Function(_$TranscriptionItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of TranscriptionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? text = null,
    Object? start_time = null,
    Object? end_time = null,
  }) {
    return _then(_$TranscriptionItemImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      start_time: null == start_time
          ? _value.start_time
          : start_time // ignore: cast_nullable_to_non_nullable
              as String,
      end_time: null == end_time
          ? _value.end_time
          : end_time // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TranscriptionItemImpl implements _TranscriptionItem {
  const _$TranscriptionItemImpl(
      {this.id,
      required this.text,
      required this.start_time,
      required this.end_time});

  factory _$TranscriptionItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$TranscriptionItemImplFromJson(json);

  @override
  final String? id;
  @override
  final String text;
  @override
  final String start_time;
// ISO format timestamp from server
  @override
  final String end_time;

  @override
  String toString() {
    return 'TranscriptionItem(id: $id, text: $text, start_time: $start_time, end_time: $end_time)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TranscriptionItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.start_time, start_time) ||
                other.start_time == start_time) &&
            (identical(other.end_time, end_time) ||
                other.end_time == end_time));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, text, start_time, end_time);

  /// Create a copy of TranscriptionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TranscriptionItemImplCopyWith<_$TranscriptionItemImpl> get copyWith =>
      __$$TranscriptionItemImplCopyWithImpl<_$TranscriptionItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TranscriptionItemImplToJson(
      this,
    );
  }
}

abstract class _TranscriptionItem implements TranscriptionItem {
  const factory _TranscriptionItem(
      {final String? id,
      required final String text,
      required final String start_time,
      required final String end_time}) = _$TranscriptionItemImpl;

  factory _TranscriptionItem.fromJson(Map<String, dynamic> json) =
      _$TranscriptionItemImpl.fromJson;

  @override
  String? get id;
  @override
  String get text;
  @override
  String get start_time; // ISO format timestamp from server
  @override
  String get end_time;

  /// Create a copy of TranscriptionItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TranscriptionItemImplCopyWith<_$TranscriptionItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TranscriptionsResponse _$TranscriptionsResponseFromJson(
    Map<String, dynamic> json) {
  return _TranscriptionsResponse.fromJson(json);
}

/// @nodoc
mixin _$TranscriptionsResponse {
  @JsonKey(name: 'transcriptions')
  List<TranscriptionItem> get items => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get page_size => throw _privateConstructorUsedError;
  bool get has_more => throw _privateConstructorUsedError;

  /// Serializes this TranscriptionsResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TranscriptionsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TranscriptionsResponseCopyWith<TranscriptionsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TranscriptionsResponseCopyWith<$Res> {
  factory $TranscriptionsResponseCopyWith(TranscriptionsResponse value,
          $Res Function(TranscriptionsResponse) then) =
      _$TranscriptionsResponseCopyWithImpl<$Res, TranscriptionsResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'transcriptions') List<TranscriptionItem> items,
      int total,
      int page,
      int page_size,
      bool has_more});
}

/// @nodoc
class _$TranscriptionsResponseCopyWithImpl<$Res,
        $Val extends TranscriptionsResponse>
    implements $TranscriptionsResponseCopyWith<$Res> {
  _$TranscriptionsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TranscriptionsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? total = null,
    Object? page = null,
    Object? page_size = null,
    Object? has_more = null,
  }) {
    return _then(_value.copyWith(
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TranscriptionItem>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      page_size: null == page_size
          ? _value.page_size
          : page_size // ignore: cast_nullable_to_non_nullable
              as int,
      has_more: null == has_more
          ? _value.has_more
          : has_more // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TranscriptionsResponseImplCopyWith<$Res>
    implements $TranscriptionsResponseCopyWith<$Res> {
  factory _$$TranscriptionsResponseImplCopyWith(
          _$TranscriptionsResponseImpl value,
          $Res Function(_$TranscriptionsResponseImpl) then) =
      __$$TranscriptionsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'transcriptions') List<TranscriptionItem> items,
      int total,
      int page,
      int page_size,
      bool has_more});
}

/// @nodoc
class __$$TranscriptionsResponseImplCopyWithImpl<$Res>
    extends _$TranscriptionsResponseCopyWithImpl<$Res,
        _$TranscriptionsResponseImpl>
    implements _$$TranscriptionsResponseImplCopyWith<$Res> {
  __$$TranscriptionsResponseImplCopyWithImpl(
      _$TranscriptionsResponseImpl _value,
      $Res Function(_$TranscriptionsResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of TranscriptionsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? total = null,
    Object? page = null,
    Object? page_size = null,
    Object? has_more = null,
  }) {
    return _then(_$TranscriptionsResponseImpl(
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<TranscriptionItem>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      page_size: null == page_size
          ? _value.page_size
          : page_size // ignore: cast_nullable_to_non_nullable
              as int,
      has_more: null == has_more
          ? _value.has_more
          : has_more // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TranscriptionsResponseImpl implements _TranscriptionsResponse {
  const _$TranscriptionsResponseImpl(
      {@JsonKey(name: 'transcriptions')
      required final List<TranscriptionItem> items,
      required this.total,
      required this.page,
      required this.page_size,
      required this.has_more})
      : _items = items;

  factory _$TranscriptionsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TranscriptionsResponseImplFromJson(json);

  final List<TranscriptionItem> _items;
  @override
  @JsonKey(name: 'transcriptions')
  List<TranscriptionItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final int total;
  @override
  final int page;
  @override
  final int page_size;
  @override
  final bool has_more;

  @override
  String toString() {
    return 'TranscriptionsResponse(items: $items, total: $total, page: $page, page_size: $page_size, has_more: $has_more)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TranscriptionsResponseImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.page_size, page_size) ||
                other.page_size == page_size) &&
            (identical(other.has_more, has_more) ||
                other.has_more == has_more));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_items),
      total,
      page,
      page_size,
      has_more);

  /// Create a copy of TranscriptionsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TranscriptionsResponseImplCopyWith<_$TranscriptionsResponseImpl>
      get copyWith => __$$TranscriptionsResponseImplCopyWithImpl<
          _$TranscriptionsResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TranscriptionsResponseImplToJson(
      this,
    );
  }
}

abstract class _TranscriptionsResponse implements TranscriptionsResponse {
  const factory _TranscriptionsResponse(
      {@JsonKey(name: 'transcriptions')
      required final List<TranscriptionItem> items,
      required final int total,
      required final int page,
      required final int page_size,
      required final bool has_more}) = _$TranscriptionsResponseImpl;

  factory _TranscriptionsResponse.fromJson(Map<String, dynamic> json) =
      _$TranscriptionsResponseImpl.fromJson;

  @override
  @JsonKey(name: 'transcriptions')
  List<TranscriptionItem> get items;
  @override
  int get total;
  @override
  int get page;
  @override
  int get page_size;
  @override
  bool get has_more;

  /// Create a copy of TranscriptionsResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TranscriptionsResponseImplCopyWith<_$TranscriptionsResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
