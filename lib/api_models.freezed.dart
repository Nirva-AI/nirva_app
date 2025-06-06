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
