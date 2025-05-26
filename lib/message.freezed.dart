// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BaseMessage _$BaseMessageFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'aiMessage':
      return AIMessage.fromJson(json);
    case 'userMessage':
      return UserMessage.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'BaseMessage',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$BaseMessage {
  String get role => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String role, String content) aiMessage,
    required TResult Function(String role, String content) userMessage,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String role, String content)? aiMessage,
    TResult? Function(String role, String content)? userMessage,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String role, String content)? aiMessage,
    TResult Function(String role, String content)? userMessage,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AIMessage value) aiMessage,
    required TResult Function(UserMessage value) userMessage,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AIMessage value)? aiMessage,
    TResult? Function(UserMessage value)? userMessage,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AIMessage value)? aiMessage,
    TResult Function(UserMessage value)? userMessage,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this BaseMessage to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BaseMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BaseMessageCopyWith<BaseMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BaseMessageCopyWith<$Res> {
  factory $BaseMessageCopyWith(
          BaseMessage value, $Res Function(BaseMessage) then) =
      _$BaseMessageCopyWithImpl<$Res, BaseMessage>;
  @useResult
  $Res call({String role, String content});
}

/// @nodoc
class _$BaseMessageCopyWithImpl<$Res, $Val extends BaseMessage>
    implements $BaseMessageCopyWith<$Res> {
  _$BaseMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BaseMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? role = null,
    Object? content = null,
  }) {
    return _then(_value.copyWith(
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AIMessageImplCopyWith<$Res>
    implements $BaseMessageCopyWith<$Res> {
  factory _$$AIMessageImplCopyWith(
          _$AIMessageImpl value, $Res Function(_$AIMessageImpl) then) =
      __$$AIMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String role, String content});
}

/// @nodoc
class __$$AIMessageImplCopyWithImpl<$Res>
    extends _$BaseMessageCopyWithImpl<$Res, _$AIMessageImpl>
    implements _$$AIMessageImplCopyWith<$Res> {
  __$$AIMessageImplCopyWithImpl(
      _$AIMessageImpl _value, $Res Function(_$AIMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of BaseMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? role = null,
    Object? content = null,
  }) {
    return _then(_$AIMessageImpl(
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
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
class _$AIMessageImpl implements AIMessage {
  const _$AIMessageImpl(
      {this.role = ChatRole.ai, required this.content, final String? $type})
      : $type = $type ?? 'aiMessage';

  factory _$AIMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIMessageImplFromJson(json);

  @override
  @JsonKey()
  final String role;
  @override
  final String content;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'BaseMessage.aiMessage(role: $role, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIMessageImpl &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, role, content);

  /// Create a copy of BaseMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIMessageImplCopyWith<_$AIMessageImpl> get copyWith =>
      __$$AIMessageImplCopyWithImpl<_$AIMessageImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String role, String content) aiMessage,
    required TResult Function(String role, String content) userMessage,
  }) {
    return aiMessage(role, content);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String role, String content)? aiMessage,
    TResult? Function(String role, String content)? userMessage,
  }) {
    return aiMessage?.call(role, content);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String role, String content)? aiMessage,
    TResult Function(String role, String content)? userMessage,
    required TResult orElse(),
  }) {
    if (aiMessage != null) {
      return aiMessage(role, content);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AIMessage value) aiMessage,
    required TResult Function(UserMessage value) userMessage,
  }) {
    return aiMessage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AIMessage value)? aiMessage,
    TResult? Function(UserMessage value)? userMessage,
  }) {
    return aiMessage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AIMessage value)? aiMessage,
    TResult Function(UserMessage value)? userMessage,
    required TResult orElse(),
  }) {
    if (aiMessage != null) {
      return aiMessage(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$AIMessageImplToJson(
      this,
    );
  }
}

abstract class AIMessage implements BaseMessage {
  const factory AIMessage({final String role, required final String content}) =
      _$AIMessageImpl;

  factory AIMessage.fromJson(Map<String, dynamic> json) =
      _$AIMessageImpl.fromJson;

  @override
  String get role;
  @override
  String get content;

  /// Create a copy of BaseMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIMessageImplCopyWith<_$AIMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UserMessageImplCopyWith<$Res>
    implements $BaseMessageCopyWith<$Res> {
  factory _$$UserMessageImplCopyWith(
          _$UserMessageImpl value, $Res Function(_$UserMessageImpl) then) =
      __$$UserMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String role, String content});
}

/// @nodoc
class __$$UserMessageImplCopyWithImpl<$Res>
    extends _$BaseMessageCopyWithImpl<$Res, _$UserMessageImpl>
    implements _$$UserMessageImplCopyWith<$Res> {
  __$$UserMessageImplCopyWithImpl(
      _$UserMessageImpl _value, $Res Function(_$UserMessageImpl) _then)
      : super(_value, _then);

  /// Create a copy of BaseMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? role = null,
    Object? content = null,
  }) {
    return _then(_$UserMessageImpl(
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
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
class _$UserMessageImpl implements UserMessage {
  const _$UserMessageImpl(
      {this.role = ChatRole.user, required this.content, final String? $type})
      : $type = $type ?? 'userMessage';

  factory _$UserMessageImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserMessageImplFromJson(json);

  @override
  @JsonKey()
  final String role;
  @override
  final String content;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'BaseMessage.userMessage(role: $role, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserMessageImpl &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, role, content);

  /// Create a copy of BaseMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserMessageImplCopyWith<_$UserMessageImpl> get copyWith =>
      __$$UserMessageImplCopyWithImpl<_$UserMessageImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String role, String content) aiMessage,
    required TResult Function(String role, String content) userMessage,
  }) {
    return userMessage(role, content);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String role, String content)? aiMessage,
    TResult? Function(String role, String content)? userMessage,
  }) {
    return userMessage?.call(role, content);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String role, String content)? aiMessage,
    TResult Function(String role, String content)? userMessage,
    required TResult orElse(),
  }) {
    if (userMessage != null) {
      return userMessage(role, content);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(AIMessage value) aiMessage,
    required TResult Function(UserMessage value) userMessage,
  }) {
    return userMessage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(AIMessage value)? aiMessage,
    TResult? Function(UserMessage value)? userMessage,
  }) {
    return userMessage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(AIMessage value)? aiMessage,
    TResult Function(UserMessage value)? userMessage,
    required TResult orElse(),
  }) {
    if (userMessage != null) {
      return userMessage(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$UserMessageImplToJson(
      this,
    );
  }
}

abstract class UserMessage implements BaseMessage {
  const factory UserMessage(
      {final String role, required final String content}) = _$UserMessageImpl;

  factory UserMessage.fromJson(Map<String, dynamic> json) =
      _$UserMessageImpl.fromJson;

  @override
  String get role;
  @override
  String get content;

  /// Create a copy of BaseMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserMessageImplCopyWith<_$UserMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
