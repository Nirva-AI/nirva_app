// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data.dart';

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
  $Res call({String name});
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
  $Res call({Object? name = null}) {
    return _then(
      _value.copyWith(
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
  $Res call({String name});
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
  $Res call({Object? name = null}) {
    return _then(
      _$UserImpl(
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
  const _$UserImpl({required this.name});

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String name;

  @override
  String toString() {
    return 'User(name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name);

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
  const factory _User({required final String name}) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get name;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Quote _$QuoteFromJson(Map<String, dynamic> json) {
  return _Quote.fromJson(json);
}

/// @nodoc
mixin _$Quote {
  String get text => throw _privateConstructorUsedError;
  String get mood => throw _privateConstructorUsedError;

  /// Serializes this Quote to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Quote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuoteCopyWith<Quote> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuoteCopyWith<$Res> {
  factory $QuoteCopyWith(Quote value, $Res Function(Quote) then) =
      _$QuoteCopyWithImpl<$Res, Quote>;
  @useResult
  $Res call({String text, String mood});
}

/// @nodoc
class _$QuoteCopyWithImpl<$Res, $Val extends Quote>
    implements $QuoteCopyWith<$Res> {
  _$QuoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Quote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = null, Object? mood = null}) {
    return _then(
      _value.copyWith(
            text:
                null == text
                    ? _value.text
                    : text // ignore: cast_nullable_to_non_nullable
                        as String,
            mood:
                null == mood
                    ? _value.mood
                    : mood // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$QuoteImplCopyWith<$Res> implements $QuoteCopyWith<$Res> {
  factory _$$QuoteImplCopyWith(
    _$QuoteImpl value,
    $Res Function(_$QuoteImpl) then,
  ) = __$$QuoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String text, String mood});
}

/// @nodoc
class __$$QuoteImplCopyWithImpl<$Res>
    extends _$QuoteCopyWithImpl<$Res, _$QuoteImpl>
    implements _$$QuoteImplCopyWith<$Res> {
  __$$QuoteImplCopyWithImpl(
    _$QuoteImpl _value,
    $Res Function(_$QuoteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Quote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = null, Object? mood = null}) {
    return _then(
      _$QuoteImpl(
        text:
            null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                    as String,
        mood:
            null == mood
                ? _value.mood
                : mood // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuoteImpl implements _Quote {
  const _$QuoteImpl({required this.text, required this.mood});

  factory _$QuoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuoteImplFromJson(json);

  @override
  final String text;
  @override
  final String mood;

  @override
  String toString() {
    return 'Quote(text: $text, mood: $mood)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuoteImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.mood, mood) || other.mood == mood));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, text, mood);

  /// Create a copy of Quote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuoteImplCopyWith<_$QuoteImpl> get copyWith =>
      __$$QuoteImplCopyWithImpl<_$QuoteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuoteImplToJson(this);
  }
}

abstract class _Quote implements Quote {
  const factory _Quote({
    required final String text,
    required final String mood,
  }) = _$QuoteImpl;

  factory _Quote.fromJson(Map<String, dynamic> json) = _$QuoteImpl.fromJson;

  @override
  String get text;
  @override
  String get mood;

  /// Create a copy of Quote
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuoteImplCopyWith<_$QuoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventTag _$EventTagFromJson(Map<String, dynamic> json) {
  return _EventTag.fromJson(json);
}

/// @nodoc
mixin _$EventTag {
  String get name => throw _privateConstructorUsedError;

  /// Serializes this EventTag to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventTag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventTagCopyWith<EventTag> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventTagCopyWith<$Res> {
  factory $EventTagCopyWith(EventTag value, $Res Function(EventTag) then) =
      _$EventTagCopyWithImpl<$Res, EventTag>;
  @useResult
  $Res call({String name});
}

/// @nodoc
class _$EventTagCopyWithImpl<$Res, $Val extends EventTag>
    implements $EventTagCopyWith<$Res> {
  _$EventTagCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventTag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null}) {
    return _then(
      _value.copyWith(
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
abstract class _$$EventTagImplCopyWith<$Res>
    implements $EventTagCopyWith<$Res> {
  factory _$$EventTagImplCopyWith(
    _$EventTagImpl value,
    $Res Function(_$EventTagImpl) then,
  ) = __$$EventTagImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name});
}

/// @nodoc
class __$$EventTagImplCopyWithImpl<$Res>
    extends _$EventTagCopyWithImpl<$Res, _$EventTagImpl>
    implements _$$EventTagImplCopyWith<$Res> {
  __$$EventTagImplCopyWithImpl(
    _$EventTagImpl _value,
    $Res Function(_$EventTagImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EventTag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null}) {
    return _then(
      _$EventTagImpl(
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
class _$EventTagImpl implements _EventTag {
  const _$EventTagImpl({required this.name});

  factory _$EventTagImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventTagImplFromJson(json);

  @override
  final String name;

  @override
  String toString() {
    return 'EventTag(name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventTagImpl &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name);

  /// Create a copy of EventTag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventTagImplCopyWith<_$EventTagImpl> get copyWith =>
      __$$EventTagImplCopyWithImpl<_$EventTagImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventTagImplToJson(this);
  }
}

abstract class _EventTag implements EventTag {
  const factory _EventTag({required final String name}) = _$EventTagImpl;

  factory _EventTag.fromJson(Map<String, dynamic> json) =
      _$EventTagImpl.fromJson;

  @override
  String get name;

  /// Create a copy of EventTag
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventTagImplCopyWith<_$EventTagImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventLocation _$EventLocationFromJson(Map<String, dynamic> json) {
  return _EventLocation.fromJson(json);
}

/// @nodoc
mixin _$EventLocation {
  String get name => throw _privateConstructorUsedError;

  /// Serializes this EventLocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventLocationCopyWith<EventLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventLocationCopyWith<$Res> {
  factory $EventLocationCopyWith(
    EventLocation value,
    $Res Function(EventLocation) then,
  ) = _$EventLocationCopyWithImpl<$Res, EventLocation>;
  @useResult
  $Res call({String name});
}

/// @nodoc
class _$EventLocationCopyWithImpl<$Res, $Val extends EventLocation>
    implements $EventLocationCopyWith<$Res> {
  _$EventLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null}) {
    return _then(
      _value.copyWith(
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
abstract class _$$EventLocationImplCopyWith<$Res>
    implements $EventLocationCopyWith<$Res> {
  factory _$$EventLocationImplCopyWith(
    _$EventLocationImpl value,
    $Res Function(_$EventLocationImpl) then,
  ) = __$$EventLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name});
}

/// @nodoc
class __$$EventLocationImplCopyWithImpl<$Res>
    extends _$EventLocationCopyWithImpl<$Res, _$EventLocationImpl>
    implements _$$EventLocationImplCopyWith<$Res> {
  __$$EventLocationImplCopyWithImpl(
    _$EventLocationImpl _value,
    $Res Function(_$EventLocationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EventLocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null}) {
    return _then(
      _$EventLocationImpl(
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
class _$EventLocationImpl implements _EventLocation {
  const _$EventLocationImpl({required this.name});

  factory _$EventLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventLocationImplFromJson(json);

  @override
  final String name;

  @override
  String toString() {
    return 'EventLocation(name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventLocationImpl &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name);

  /// Create a copy of EventLocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventLocationImplCopyWith<_$EventLocationImpl> get copyWith =>
      __$$EventLocationImplCopyWithImpl<_$EventLocationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventLocationImplToJson(this);
  }
}

abstract class _EventLocation implements EventLocation {
  const factory _EventLocation({required final String name}) =
      _$EventLocationImpl;

  factory _EventLocation.fromJson(Map<String, dynamic> json) =
      _$EventLocationImpl.fromJson;

  @override
  String get name;

  /// Create a copy of EventLocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventLocationImplCopyWith<_$EventLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DiaryEntry _$DiaryEntryFromJson(Map<String, dynamic> json) {
  return _DiaryEntry.fromJson(json);
}

/// @nodoc
mixin _$DiaryEntry {
  String get id => throw _privateConstructorUsedError;
  DateTime get beginTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get summary => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  List<EventTag> get tags => throw _privateConstructorUsedError;
  EventLocation get location => throw _privateConstructorUsedError;

  /// Serializes this DiaryEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DiaryEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiaryEntryCopyWith<DiaryEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiaryEntryCopyWith<$Res> {
  factory $DiaryEntryCopyWith(
    DiaryEntry value,
    $Res Function(DiaryEntry) then,
  ) = _$DiaryEntryCopyWithImpl<$Res, DiaryEntry>;
  @useResult
  $Res call({
    String id,
    DateTime beginTime,
    DateTime endTime,
    String title,
    String summary,
    String content,
    List<EventTag> tags,
    EventLocation location,
  });

  $EventLocationCopyWith<$Res> get location;
}

/// @nodoc
class _$DiaryEntryCopyWithImpl<$Res, $Val extends DiaryEntry>
    implements $DiaryEntryCopyWith<$Res> {
  _$DiaryEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiaryEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? beginTime = null,
    Object? endTime = null,
    Object? title = null,
    Object? summary = null,
    Object? content = null,
    Object? tags = null,
    Object? location = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            beginTime:
                null == beginTime
                    ? _value.beginTime
                    : beginTime // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            endTime:
                null == endTime
                    ? _value.endTime
                    : endTime // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            summary:
                null == summary
                    ? _value.summary
                    : summary // ignore: cast_nullable_to_non_nullable
                        as String,
            content:
                null == content
                    ? _value.content
                    : content // ignore: cast_nullable_to_non_nullable
                        as String,
            tags:
                null == tags
                    ? _value.tags
                    : tags // ignore: cast_nullable_to_non_nullable
                        as List<EventTag>,
            location:
                null == location
                    ? _value.location
                    : location // ignore: cast_nullable_to_non_nullable
                        as EventLocation,
          )
          as $Val,
    );
  }

  /// Create a copy of DiaryEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EventLocationCopyWith<$Res> get location {
    return $EventLocationCopyWith<$Res>(_value.location, (value) {
      return _then(_value.copyWith(location: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DiaryEntryImplCopyWith<$Res>
    implements $DiaryEntryCopyWith<$Res> {
  factory _$$DiaryEntryImplCopyWith(
    _$DiaryEntryImpl value,
    $Res Function(_$DiaryEntryImpl) then,
  ) = __$$DiaryEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    DateTime beginTime,
    DateTime endTime,
    String title,
    String summary,
    String content,
    List<EventTag> tags,
    EventLocation location,
  });

  @override
  $EventLocationCopyWith<$Res> get location;
}

/// @nodoc
class __$$DiaryEntryImplCopyWithImpl<$Res>
    extends _$DiaryEntryCopyWithImpl<$Res, _$DiaryEntryImpl>
    implements _$$DiaryEntryImplCopyWith<$Res> {
  __$$DiaryEntryImplCopyWithImpl(
    _$DiaryEntryImpl _value,
    $Res Function(_$DiaryEntryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DiaryEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? beginTime = null,
    Object? endTime = null,
    Object? title = null,
    Object? summary = null,
    Object? content = null,
    Object? tags = null,
    Object? location = null,
  }) {
    return _then(
      _$DiaryEntryImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        beginTime:
            null == beginTime
                ? _value.beginTime
                : beginTime // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        endTime:
            null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        summary:
            null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                    as String,
        content:
            null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                    as String,
        tags:
            null == tags
                ? _value._tags
                : tags // ignore: cast_nullable_to_non_nullable
                    as List<EventTag>,
        location:
            null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                    as EventLocation,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DiaryEntryImpl implements _DiaryEntry {
  const _$DiaryEntryImpl({
    required this.id,
    required this.beginTime,
    required this.endTime,
    required this.title,
    required this.summary,
    required this.content,
    required final List<EventTag> tags,
    required this.location,
  }) : _tags = tags;

  factory _$DiaryEntryImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiaryEntryImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime beginTime;
  @override
  final DateTime endTime;
  @override
  final String title;
  @override
  final String summary;
  @override
  final String content;
  final List<EventTag> _tags;
  @override
  List<EventTag> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final EventLocation location;

  @override
  String toString() {
    return 'DiaryEntry(id: $id, beginTime: $beginTime, endTime: $endTime, title: $title, summary: $summary, content: $content, tags: $tags, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiaryEntryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.beginTime, beginTime) ||
                other.beginTime == beginTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    beginTime,
    endTime,
    title,
    summary,
    content,
    const DeepCollectionEquality().hash(_tags),
    location,
  );

  /// Create a copy of DiaryEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiaryEntryImplCopyWith<_$DiaryEntryImpl> get copyWith =>
      __$$DiaryEntryImplCopyWithImpl<_$DiaryEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DiaryEntryImplToJson(this);
  }
}

abstract class _DiaryEntry implements DiaryEntry {
  const factory _DiaryEntry({
    required final String id,
    required final DateTime beginTime,
    required final DateTime endTime,
    required final String title,
    required final String summary,
    required final String content,
    required final List<EventTag> tags,
    required final EventLocation location,
  }) = _$DiaryEntryImpl;

  factory _DiaryEntry.fromJson(Map<String, dynamic> json) =
      _$DiaryEntryImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get beginTime;
  @override
  DateTime get endTime;
  @override
  String get title;
  @override
  String get summary;
  @override
  String get content;
  @override
  List<EventTag> get tags;
  @override
  EventLocation get location;

  /// Create a copy of DiaryEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiaryEntryImplCopyWith<_$DiaryEntryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DiaryEntryNote _$DiaryEntryNoteFromJson(Map<String, dynamic> json) {
  return _DiaryEntryNote.fromJson(json);
}

/// @nodoc
mixin _$DiaryEntryNote {
  String get id => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;

  /// Serializes this DiaryEntryNote to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DiaryEntryNote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiaryEntryNoteCopyWith<DiaryEntryNote> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiaryEntryNoteCopyWith<$Res> {
  factory $DiaryEntryNoteCopyWith(
    DiaryEntryNote value,
    $Res Function(DiaryEntryNote) then,
  ) = _$DiaryEntryNoteCopyWithImpl<$Res, DiaryEntryNote>;
  @useResult
  $Res call({String id, String content});
}

/// @nodoc
class _$DiaryEntryNoteCopyWithImpl<$Res, $Val extends DiaryEntryNote>
    implements $DiaryEntryNoteCopyWith<$Res> {
  _$DiaryEntryNoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiaryEntryNote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? content = null}) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
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
abstract class _$$DiaryEntryNoteImplCopyWith<$Res>
    implements $DiaryEntryNoteCopyWith<$Res> {
  factory _$$DiaryEntryNoteImplCopyWith(
    _$DiaryEntryNoteImpl value,
    $Res Function(_$DiaryEntryNoteImpl) then,
  ) = __$$DiaryEntryNoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String content});
}

/// @nodoc
class __$$DiaryEntryNoteImplCopyWithImpl<$Res>
    extends _$DiaryEntryNoteCopyWithImpl<$Res, _$DiaryEntryNoteImpl>
    implements _$$DiaryEntryNoteImplCopyWith<$Res> {
  __$$DiaryEntryNoteImplCopyWithImpl(
    _$DiaryEntryNoteImpl _value,
    $Res Function(_$DiaryEntryNoteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DiaryEntryNote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? content = null}) {
    return _then(
      _$DiaryEntryNoteImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
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
class _$DiaryEntryNoteImpl implements _DiaryEntryNote {
  const _$DiaryEntryNoteImpl({required this.id, required this.content});

  factory _$DiaryEntryNoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiaryEntryNoteImplFromJson(json);

  @override
  final String id;
  @override
  final String content;

  @override
  String toString() {
    return 'DiaryEntryNote(id: $id, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiaryEntryNoteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, content);

  /// Create a copy of DiaryEntryNote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiaryEntryNoteImplCopyWith<_$DiaryEntryNoteImpl> get copyWith =>
      __$$DiaryEntryNoteImplCopyWithImpl<_$DiaryEntryNoteImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DiaryEntryNoteImplToJson(this);
  }
}

abstract class _DiaryEntryNote implements DiaryEntryNote {
  const factory _DiaryEntryNote({
    required final String id,
    required final String content,
  }) = _$DiaryEntryNoteImpl;

  factory _DiaryEntryNote.fromJson(Map<String, dynamic> json) =
      _$DiaryEntryNoteImpl.fromJson;

  @override
  String get id;
  @override
  String get content;

  /// Create a copy of DiaryEntryNote
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiaryEntryNoteImplCopyWith<_$DiaryEntryNoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Reflection _$ReflectionFromJson(Map<String, dynamic> json) {
  return _Reflection.fromJson(json);
}

/// @nodoc
mixin _$Reflection {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  List<String> get items => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;

  /// Serializes this Reflection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Reflection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReflectionCopyWith<Reflection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReflectionCopyWith<$Res> {
  factory $ReflectionCopyWith(
    Reflection value,
    $Res Function(Reflection) then,
  ) = _$ReflectionCopyWithImpl<$Res, Reflection>;
  @useResult
  $Res call({String id, String title, List<String> items, String content});
}

/// @nodoc
class _$ReflectionCopyWithImpl<$Res, $Val extends Reflection>
    implements $ReflectionCopyWith<$Res> {
  _$ReflectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Reflection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? items = null,
    Object? content = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            items:
                null == items
                    ? _value.items
                    : items // ignore: cast_nullable_to_non_nullable
                        as List<String>,
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
abstract class _$$ReflectionImplCopyWith<$Res>
    implements $ReflectionCopyWith<$Res> {
  factory _$$ReflectionImplCopyWith(
    _$ReflectionImpl value,
    $Res Function(_$ReflectionImpl) then,
  ) = __$$ReflectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String title, List<String> items, String content});
}

/// @nodoc
class __$$ReflectionImplCopyWithImpl<$Res>
    extends _$ReflectionCopyWithImpl<$Res, _$ReflectionImpl>
    implements _$$ReflectionImplCopyWith<$Res> {
  __$$ReflectionImplCopyWithImpl(
    _$ReflectionImpl _value,
    $Res Function(_$ReflectionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Reflection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? items = null,
    Object? content = null,
  }) {
    return _then(
      _$ReflectionImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        items:
            null == items
                ? _value._items
                : items // ignore: cast_nullable_to_non_nullable
                    as List<String>,
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
class _$ReflectionImpl implements _Reflection {
  const _$ReflectionImpl({
    required this.id,
    required this.title,
    required final List<String> items,
    required this.content,
  }) : _items = items;

  factory _$ReflectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReflectionImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  final List<String> _items;
  @override
  List<String> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final String content;

  @override
  String toString() {
    return 'Reflection(id: $id, title: $title, items: $items, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReflectionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    const DeepCollectionEquality().hash(_items),
    content,
  );

  /// Create a copy of Reflection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReflectionImplCopyWith<_$ReflectionImpl> get copyWith =>
      __$$ReflectionImplCopyWithImpl<_$ReflectionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReflectionImplToJson(this);
  }
}

abstract class _Reflection implements Reflection {
  const factory _Reflection({
    required final String id,
    required final String title,
    required final List<String> items,
    required final String content,
  }) = _$ReflectionImpl;

  factory _Reflection.fromJson(Map<String, dynamic> json) =
      _$ReflectionImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  List<String> get items;
  @override
  String get content;

  /// Create a copy of Reflection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReflectionImplCopyWith<_$ReflectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MoodScore _$MoodScoreFromJson(Map<String, dynamic> json) {
  return _MoodScore.fromJson(json);
}

/// @nodoc
mixin _$MoodScore {
  double get value => throw _privateConstructorUsedError;
  double get change => throw _privateConstructorUsedError;

  /// Serializes this MoodScore to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MoodScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MoodScoreCopyWith<MoodScore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoodScoreCopyWith<$Res> {
  factory $MoodScoreCopyWith(MoodScore value, $Res Function(MoodScore) then) =
      _$MoodScoreCopyWithImpl<$Res, MoodScore>;
  @useResult
  $Res call({double value, double change});
}

/// @nodoc
class _$MoodScoreCopyWithImpl<$Res, $Val extends MoodScore>
    implements $MoodScoreCopyWith<$Res> {
  _$MoodScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MoodScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? value = null, Object? change = null}) {
    return _then(
      _value.copyWith(
            value:
                null == value
                    ? _value.value
                    : value // ignore: cast_nullable_to_non_nullable
                        as double,
            change:
                null == change
                    ? _value.change
                    : change // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MoodScoreImplCopyWith<$Res>
    implements $MoodScoreCopyWith<$Res> {
  factory _$$MoodScoreImplCopyWith(
    _$MoodScoreImpl value,
    $Res Function(_$MoodScoreImpl) then,
  ) = __$$MoodScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double value, double change});
}

/// @nodoc
class __$$MoodScoreImplCopyWithImpl<$Res>
    extends _$MoodScoreCopyWithImpl<$Res, _$MoodScoreImpl>
    implements _$$MoodScoreImplCopyWith<$Res> {
  __$$MoodScoreImplCopyWithImpl(
    _$MoodScoreImpl _value,
    $Res Function(_$MoodScoreImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MoodScore
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? value = null, Object? change = null}) {
    return _then(
      _$MoodScoreImpl(
        value:
            null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                    as double,
        change:
            null == change
                ? _value.change
                : change // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MoodScoreImpl implements _MoodScore {
  const _$MoodScoreImpl({required this.value, required this.change});

  factory _$MoodScoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$MoodScoreImplFromJson(json);

  @override
  final double value;
  @override
  final double change;

  @override
  String toString() {
    return 'MoodScore(value: $value, change: $change)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoodScoreImpl &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.change, change) || other.change == change));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, value, change);

  /// Create a copy of MoodScore
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MoodScoreImplCopyWith<_$MoodScoreImpl> get copyWith =>
      __$$MoodScoreImplCopyWithImpl<_$MoodScoreImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MoodScoreImplToJson(this);
  }
}

abstract class _MoodScore implements MoodScore {
  const factory _MoodScore({
    required final double value,
    required final double change,
  }) = _$MoodScoreImpl;

  factory _MoodScore.fromJson(Map<String, dynamic> json) =
      _$MoodScoreImpl.fromJson;

  @override
  double get value;
  @override
  double get change;

  /// Create a copy of MoodScore
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MoodScoreImplCopyWith<_$MoodScoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StressLevel _$StressLevelFromJson(Map<String, dynamic> json) {
  return _StressLevel.fromJson(json);
}

/// @nodoc
mixin _$StressLevel {
  double get value => throw _privateConstructorUsedError;
  double get change => throw _privateConstructorUsedError;

  /// Serializes this StressLevel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StressLevel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StressLevelCopyWith<StressLevel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StressLevelCopyWith<$Res> {
  factory $StressLevelCopyWith(
    StressLevel value,
    $Res Function(StressLevel) then,
  ) = _$StressLevelCopyWithImpl<$Res, StressLevel>;
  @useResult
  $Res call({double value, double change});
}

/// @nodoc
class _$StressLevelCopyWithImpl<$Res, $Val extends StressLevel>
    implements $StressLevelCopyWith<$Res> {
  _$StressLevelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StressLevel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? value = null, Object? change = null}) {
    return _then(
      _value.copyWith(
            value:
                null == value
                    ? _value.value
                    : value // ignore: cast_nullable_to_non_nullable
                        as double,
            change:
                null == change
                    ? _value.change
                    : change // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StressLevelImplCopyWith<$Res>
    implements $StressLevelCopyWith<$Res> {
  factory _$$StressLevelImplCopyWith(
    _$StressLevelImpl value,
    $Res Function(_$StressLevelImpl) then,
  ) = __$$StressLevelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double value, double change});
}

/// @nodoc
class __$$StressLevelImplCopyWithImpl<$Res>
    extends _$StressLevelCopyWithImpl<$Res, _$StressLevelImpl>
    implements _$$StressLevelImplCopyWith<$Res> {
  __$$StressLevelImplCopyWithImpl(
    _$StressLevelImpl _value,
    $Res Function(_$StressLevelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StressLevel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? value = null, Object? change = null}) {
    return _then(
      _$StressLevelImpl(
        value:
            null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                    as double,
        change:
            null == change
                ? _value.change
                : change // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$StressLevelImpl implements _StressLevel {
  const _$StressLevelImpl({required this.value, required this.change});

  factory _$StressLevelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StressLevelImplFromJson(json);

  @override
  final double value;
  @override
  final double change;

  @override
  String toString() {
    return 'StressLevel(value: $value, change: $change)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StressLevelImpl &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.change, change) || other.change == change));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, value, change);

  /// Create a copy of StressLevel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StressLevelImplCopyWith<_$StressLevelImpl> get copyWith =>
      __$$StressLevelImplCopyWithImpl<_$StressLevelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StressLevelImplToJson(this);
  }
}

abstract class _StressLevel implements StressLevel {
  const factory _StressLevel({
    required final double value,
    required final double change,
  }) = _$StressLevelImpl;

  factory _StressLevel.fromJson(Map<String, dynamic> json) =
      _$StressLevelImpl.fromJson;

  @override
  double get value;
  @override
  double get change;

  /// Create a copy of StressLevel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StressLevelImplCopyWith<_$StressLevelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Highlight _$HighlightFromJson(Map<String, dynamic> json) {
  return _Highlight.fromJson(json);
}

/// @nodoc
mixin _$Highlight {
  String get category => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  int get color => throw _privateConstructorUsedError;

  /// Serializes this Highlight to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Highlight
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HighlightCopyWith<Highlight> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HighlightCopyWith<$Res> {
  factory $HighlightCopyWith(Highlight value, $Res Function(Highlight) then) =
      _$HighlightCopyWithImpl<$Res, Highlight>;
  @useResult
  $Res call({String category, String content, int color});
}

/// @nodoc
class _$HighlightCopyWithImpl<$Res, $Val extends Highlight>
    implements $HighlightCopyWith<$Res> {
  _$HighlightCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Highlight
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? content = null,
    Object? color = null,
  }) {
    return _then(
      _value.copyWith(
            category:
                null == category
                    ? _value.category
                    : category // ignore: cast_nullable_to_non_nullable
                        as String,
            content:
                null == content
                    ? _value.content
                    : content // ignore: cast_nullable_to_non_nullable
                        as String,
            color:
                null == color
                    ? _value.color
                    : color // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HighlightImplCopyWith<$Res>
    implements $HighlightCopyWith<$Res> {
  factory _$$HighlightImplCopyWith(
    _$HighlightImpl value,
    $Res Function(_$HighlightImpl) then,
  ) = __$$HighlightImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String category, String content, int color});
}

/// @nodoc
class __$$HighlightImplCopyWithImpl<$Res>
    extends _$HighlightCopyWithImpl<$Res, _$HighlightImpl>
    implements _$$HighlightImplCopyWith<$Res> {
  __$$HighlightImplCopyWithImpl(
    _$HighlightImpl _value,
    $Res Function(_$HighlightImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Highlight
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? content = null,
    Object? color = null,
  }) {
    return _then(
      _$HighlightImpl(
        category:
            null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                    as String,
        content:
            null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                    as String,
        color:
            null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HighlightImpl implements _Highlight {
  const _$HighlightImpl({
    required this.category,
    required this.content,
    this.color = 0xFF00FF00,
  });

  factory _$HighlightImpl.fromJson(Map<String, dynamic> json) =>
      _$$HighlightImplFromJson(json);

  @override
  final String category;
  @override
  final String content;
  @override
  @JsonKey()
  final int color;

  @override
  String toString() {
    return 'Highlight(category: $category, content: $content, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HighlightImpl &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, category, content, color);

  /// Create a copy of Highlight
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HighlightImplCopyWith<_$HighlightImpl> get copyWith =>
      __$$HighlightImplCopyWithImpl<_$HighlightImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HighlightImplToJson(this);
  }
}

abstract class _Highlight implements Highlight {
  const factory _Highlight({
    required final String category,
    required final String content,
    final int color,
  }) = _$HighlightImpl;

  factory _Highlight.fromJson(Map<String, dynamic> json) =
      _$HighlightImpl.fromJson;

  @override
  String get category;
  @override
  String get content;
  @override
  int get color;

  /// Create a copy of Highlight
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HighlightImplCopyWith<_$HighlightImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HighlightGroup _$HighlightGroupFromJson(Map<String, dynamic> json) {
  return _HighlightGroup.fromJson(json);
}

/// @nodoc
mixin _$HighlightGroup {
  DateTime get beginTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  List<Highlight> get highlights => throw _privateConstructorUsedError;

  /// Serializes this HighlightGroup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HighlightGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HighlightGroupCopyWith<HighlightGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HighlightGroupCopyWith<$Res> {
  factory $HighlightGroupCopyWith(
    HighlightGroup value,
    $Res Function(HighlightGroup) then,
  ) = _$HighlightGroupCopyWithImpl<$Res, HighlightGroup>;
  @useResult
  $Res call({DateTime beginTime, DateTime endTime, List<Highlight> highlights});
}

/// @nodoc
class _$HighlightGroupCopyWithImpl<$Res, $Val extends HighlightGroup>
    implements $HighlightGroupCopyWith<$Res> {
  _$HighlightGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HighlightGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? beginTime = null,
    Object? endTime = null,
    Object? highlights = null,
  }) {
    return _then(
      _value.copyWith(
            beginTime:
                null == beginTime
                    ? _value.beginTime
                    : beginTime // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            endTime:
                null == endTime
                    ? _value.endTime
                    : endTime // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            highlights:
                null == highlights
                    ? _value.highlights
                    : highlights // ignore: cast_nullable_to_non_nullable
                        as List<Highlight>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HighlightGroupImplCopyWith<$Res>
    implements $HighlightGroupCopyWith<$Res> {
  factory _$$HighlightGroupImplCopyWith(
    _$HighlightGroupImpl value,
    $Res Function(_$HighlightGroupImpl) then,
  ) = __$$HighlightGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime beginTime, DateTime endTime, List<Highlight> highlights});
}

/// @nodoc
class __$$HighlightGroupImplCopyWithImpl<$Res>
    extends _$HighlightGroupCopyWithImpl<$Res, _$HighlightGroupImpl>
    implements _$$HighlightGroupImplCopyWith<$Res> {
  __$$HighlightGroupImplCopyWithImpl(
    _$HighlightGroupImpl _value,
    $Res Function(_$HighlightGroupImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HighlightGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? beginTime = null,
    Object? endTime = null,
    Object? highlights = null,
  }) {
    return _then(
      _$HighlightGroupImpl(
        beginTime:
            null == beginTime
                ? _value.beginTime
                : beginTime // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        endTime:
            null == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        highlights:
            null == highlights
                ? _value._highlights
                : highlights // ignore: cast_nullable_to_non_nullable
                    as List<Highlight>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$HighlightGroupImpl implements _HighlightGroup {
  const _$HighlightGroupImpl({
    required this.beginTime,
    required this.endTime,
    required final List<Highlight> highlights,
  }) : _highlights = highlights;

  factory _$HighlightGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$HighlightGroupImplFromJson(json);

  @override
  final DateTime beginTime;
  @override
  final DateTime endTime;
  final List<Highlight> _highlights;
  @override
  List<Highlight> get highlights {
    if (_highlights is EqualUnmodifiableListView) return _highlights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_highlights);
  }

  @override
  String toString() {
    return 'HighlightGroup(beginTime: $beginTime, endTime: $endTime, highlights: $highlights)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HighlightGroupImpl &&
            (identical(other.beginTime, beginTime) ||
                other.beginTime == beginTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            const DeepCollectionEquality().equals(
              other._highlights,
              _highlights,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    beginTime,
    endTime,
    const DeepCollectionEquality().hash(_highlights),
  );

  /// Create a copy of HighlightGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HighlightGroupImplCopyWith<_$HighlightGroupImpl> get copyWith =>
      __$$HighlightGroupImplCopyWithImpl<_$HighlightGroupImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$HighlightGroupImplToJson(this);
  }
}

abstract class _HighlightGroup implements HighlightGroup {
  const factory _HighlightGroup({
    required final DateTime beginTime,
    required final DateTime endTime,
    required final List<Highlight> highlights,
  }) = _$HighlightGroupImpl;

  factory _HighlightGroup.fromJson(Map<String, dynamic> json) =
      _$HighlightGroupImpl.fromJson;

  @override
  DateTime get beginTime;
  @override
  DateTime get endTime;
  @override
  List<Highlight> get highlights;

  /// Create a copy of HighlightGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HighlightGroupImplCopyWith<_$HighlightGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Task _$TaskFromJson(Map<String, dynamic> json) {
  return _Task.fromJson(json);
}

/// @nodoc
mixin _$Task {
  String get tag => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;

  /// Serializes this Task to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskCopyWith<Task> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskCopyWith<$Res> {
  factory $TaskCopyWith(Task value, $Res Function(Task) then) =
      _$TaskCopyWithImpl<$Res, Task>;
  @useResult
  $Res call({String tag, String description, bool isCompleted});
}

/// @nodoc
class _$TaskCopyWithImpl<$Res, $Val extends Task>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tag = null,
    Object? description = null,
    Object? isCompleted = null,
  }) {
    return _then(
      _value.copyWith(
            tag:
                null == tag
                    ? _value.tag
                    : tag // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                null == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String,
            isCompleted:
                null == isCompleted
                    ? _value.isCompleted
                    : isCompleted // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskImplCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$$TaskImplCopyWith(
    _$TaskImpl value,
    $Res Function(_$TaskImpl) then,
  ) = __$$TaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String tag, String description, bool isCompleted});
}

/// @nodoc
class __$$TaskImplCopyWithImpl<$Res>
    extends _$TaskCopyWithImpl<$Res, _$TaskImpl>
    implements _$$TaskImplCopyWith<$Res> {
  __$$TaskImplCopyWithImpl(_$TaskImpl _value, $Res Function(_$TaskImpl) _then)
    : super(_value, _then);

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tag = null,
    Object? description = null,
    Object? isCompleted = null,
  }) {
    return _then(
      _$TaskImpl(
        tag:
            null == tag
                ? _value.tag
                : tag // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String,
        isCompleted:
            null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskImpl implements _Task {
  const _$TaskImpl({
    required this.tag,
    required this.description,
    this.isCompleted = false,
  });

  factory _$TaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskImplFromJson(json);

  @override
  final String tag;
  @override
  final String description;
  @override
  @JsonKey()
  final bool isCompleted;

  @override
  String toString() {
    return 'Task(tag: $tag, description: $description, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskImpl &&
            (identical(other.tag, tag) || other.tag == tag) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, tag, description, isCompleted);

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      __$$TaskImplCopyWithImpl<_$TaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskImplToJson(this);
  }
}

abstract class _Task implements Task {
  const factory _Task({
    required final String tag,
    required final String description,
    final bool isCompleted,
  }) = _$TaskImpl;

  factory _Task.fromJson(Map<String, dynamic> json) = _$TaskImpl.fromJson;

  @override
  String get tag;
  @override
  String get description;
  @override
  bool get isCompleted;

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EnergyLabel _$EnergyLabelFromJson(Map<String, dynamic> json) {
  return _EnergyLabel.fromJson(json);
}

/// @nodoc
mixin _$EnergyLabel {
  String get label => throw _privateConstructorUsedError;
  double get measurementValue => throw _privateConstructorUsedError;

  /// Serializes this EnergyLabel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EnergyLabel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EnergyLabelCopyWith<EnergyLabel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnergyLabelCopyWith<$Res> {
  factory $EnergyLabelCopyWith(
    EnergyLabel value,
    $Res Function(EnergyLabel) then,
  ) = _$EnergyLabelCopyWithImpl<$Res, EnergyLabel>;
  @useResult
  $Res call({String label, double measurementValue});
}

/// @nodoc
class _$EnergyLabelCopyWithImpl<$Res, $Val extends EnergyLabel>
    implements $EnergyLabelCopyWith<$Res> {
  _$EnergyLabelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EnergyLabel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? label = null, Object? measurementValue = null}) {
    return _then(
      _value.copyWith(
            label:
                null == label
                    ? _value.label
                    : label // ignore: cast_nullable_to_non_nullable
                        as String,
            measurementValue:
                null == measurementValue
                    ? _value.measurementValue
                    : measurementValue // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EnergyLabelImplCopyWith<$Res>
    implements $EnergyLabelCopyWith<$Res> {
  factory _$$EnergyLabelImplCopyWith(
    _$EnergyLabelImpl value,
    $Res Function(_$EnergyLabelImpl) then,
  ) = __$$EnergyLabelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String label, double measurementValue});
}

/// @nodoc
class __$$EnergyLabelImplCopyWithImpl<$Res>
    extends _$EnergyLabelCopyWithImpl<$Res, _$EnergyLabelImpl>
    implements _$$EnergyLabelImplCopyWith<$Res> {
  __$$EnergyLabelImplCopyWithImpl(
    _$EnergyLabelImpl _value,
    $Res Function(_$EnergyLabelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EnergyLabel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? label = null, Object? measurementValue = null}) {
    return _then(
      _$EnergyLabelImpl(
        label:
            null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                    as String,
        measurementValue:
            null == measurementValue
                ? _value.measurementValue
                : measurementValue // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EnergyLabelImpl implements _EnergyLabel {
  const _$EnergyLabelImpl({
    required this.label,
    required this.measurementValue,
  });

  factory _$EnergyLabelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EnergyLabelImplFromJson(json);

  @override
  final String label;
  @override
  final double measurementValue;

  @override
  String toString() {
    return 'EnergyLabel(label: $label, measurementValue: $measurementValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EnergyLabelImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.measurementValue, measurementValue) ||
                other.measurementValue == measurementValue));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, label, measurementValue);

  /// Create a copy of EnergyLabel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EnergyLabelImplCopyWith<_$EnergyLabelImpl> get copyWith =>
      __$$EnergyLabelImplCopyWithImpl<_$EnergyLabelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EnergyLabelImplToJson(this);
  }
}

abstract class _EnergyLabel implements EnergyLabel {
  const factory _EnergyLabel({
    required final String label,
    required final double measurementValue,
  }) = _$EnergyLabelImpl;

  factory _EnergyLabel.fromJson(Map<String, dynamic> json) =
      _$EnergyLabelImpl.fromJson;

  @override
  String get label;
  @override
  double get measurementValue;

  /// Create a copy of EnergyLabel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EnergyLabelImplCopyWith<_$EnergyLabelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Energy _$EnergyFromJson(Map<String, dynamic> json) {
  return _Energy.fromJson(json);
}

/// @nodoc
mixin _$Energy {
  DateTime get dateTime => throw _privateConstructorUsedError;
  double get energyLevel => throw _privateConstructorUsedError;

  /// Serializes this Energy to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Energy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EnergyCopyWith<Energy> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnergyCopyWith<$Res> {
  factory $EnergyCopyWith(Energy value, $Res Function(Energy) then) =
      _$EnergyCopyWithImpl<$Res, Energy>;
  @useResult
  $Res call({DateTime dateTime, double energyLevel});
}

/// @nodoc
class _$EnergyCopyWithImpl<$Res, $Val extends Energy>
    implements $EnergyCopyWith<$Res> {
  _$EnergyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Energy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? dateTime = null, Object? energyLevel = null}) {
    return _then(
      _value.copyWith(
            dateTime:
                null == dateTime
                    ? _value.dateTime
                    : dateTime // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            energyLevel:
                null == energyLevel
                    ? _value.energyLevel
                    : energyLevel // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EnergyImplCopyWith<$Res> implements $EnergyCopyWith<$Res> {
  factory _$$EnergyImplCopyWith(
    _$EnergyImpl value,
    $Res Function(_$EnergyImpl) then,
  ) = __$$EnergyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime dateTime, double energyLevel});
}

/// @nodoc
class __$$EnergyImplCopyWithImpl<$Res>
    extends _$EnergyCopyWithImpl<$Res, _$EnergyImpl>
    implements _$$EnergyImplCopyWith<$Res> {
  __$$EnergyImplCopyWithImpl(
    _$EnergyImpl _value,
    $Res Function(_$EnergyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Energy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? dateTime = null, Object? energyLevel = null}) {
    return _then(
      _$EnergyImpl(
        dateTime:
            null == dateTime
                ? _value.dateTime
                : dateTime // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        energyLevel:
            null == energyLevel
                ? _value.energyLevel
                : energyLevel // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EnergyImpl implements _Energy {
  const _$EnergyImpl({required this.dateTime, required this.energyLevel});

  factory _$EnergyImpl.fromJson(Map<String, dynamic> json) =>
      _$$EnergyImplFromJson(json);

  @override
  final DateTime dateTime;
  @override
  final double energyLevel;

  @override
  String toString() {
    return 'Energy(dateTime: $dateTime, energyLevel: $energyLevel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EnergyImpl &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime) &&
            (identical(other.energyLevel, energyLevel) ||
                other.energyLevel == energyLevel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, dateTime, energyLevel);

  /// Create a copy of Energy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EnergyImplCopyWith<_$EnergyImpl> get copyWith =>
      __$$EnergyImplCopyWithImpl<_$EnergyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EnergyImplToJson(this);
  }
}

abstract class _Energy implements Energy {
  const factory _Energy({
    required final DateTime dateTime,
    required final double energyLevel,
  }) = _$EnergyImpl;

  factory _Energy.fromJson(Map<String, dynamic> json) = _$EnergyImpl.fromJson;

  @override
  DateTime get dateTime;
  @override
  double get energyLevel;

  /// Create a copy of Energy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EnergyImplCopyWith<_$EnergyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Mood _$MoodFromJson(Map<String, dynamic> json) {
  return _Mood.fromJson(json);
}

/// @nodoc
mixin _$Mood {
  String get name => throw _privateConstructorUsedError;
  double get moodValue => throw _privateConstructorUsedError;
  double get moodPercentage => throw _privateConstructorUsedError;
  int get color => throw _privateConstructorUsedError;

  /// Serializes this Mood to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Mood
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MoodCopyWith<Mood> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoodCopyWith<$Res> {
  factory $MoodCopyWith(Mood value, $Res Function(Mood) then) =
      _$MoodCopyWithImpl<$Res, Mood>;
  @useResult
  $Res call({String name, double moodValue, double moodPercentage, int color});
}

/// @nodoc
class _$MoodCopyWithImpl<$Res, $Val extends Mood>
    implements $MoodCopyWith<$Res> {
  _$MoodCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Mood
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? moodValue = null,
    Object? moodPercentage = null,
    Object? color = null,
  }) {
    return _then(
      _value.copyWith(
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            moodValue:
                null == moodValue
                    ? _value.moodValue
                    : moodValue // ignore: cast_nullable_to_non_nullable
                        as double,
            moodPercentage:
                null == moodPercentage
                    ? _value.moodPercentage
                    : moodPercentage // ignore: cast_nullable_to_non_nullable
                        as double,
            color:
                null == color
                    ? _value.color
                    : color // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MoodImplCopyWith<$Res> implements $MoodCopyWith<$Res> {
  factory _$$MoodImplCopyWith(
    _$MoodImpl value,
    $Res Function(_$MoodImpl) then,
  ) = __$$MoodImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, double moodValue, double moodPercentage, int color});
}

/// @nodoc
class __$$MoodImplCopyWithImpl<$Res>
    extends _$MoodCopyWithImpl<$Res, _$MoodImpl>
    implements _$$MoodImplCopyWith<$Res> {
  __$$MoodImplCopyWithImpl(_$MoodImpl _value, $Res Function(_$MoodImpl) _then)
    : super(_value, _then);

  /// Create a copy of Mood
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? moodValue = null,
    Object? moodPercentage = null,
    Object? color = null,
  }) {
    return _then(
      _$MoodImpl(
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        moodValue:
            null == moodValue
                ? _value.moodValue
                : moodValue // ignore: cast_nullable_to_non_nullable
                    as double,
        moodPercentage:
            null == moodPercentage
                ? _value.moodPercentage
                : moodPercentage // ignore: cast_nullable_to_non_nullable
                    as double,
        color:
            null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MoodImpl implements _Mood {
  const _$MoodImpl({
    required this.name,
    required this.moodValue,
    required this.moodPercentage,
    this.color = 0xFF00FF00,
  });

  factory _$MoodImpl.fromJson(Map<String, dynamic> json) =>
      _$$MoodImplFromJson(json);

  @override
  final String name;
  @override
  final double moodValue;
  @override
  final double moodPercentage;
  @override
  @JsonKey()
  final int color;

  @override
  String toString() {
    return 'Mood(name: $name, moodValue: $moodValue, moodPercentage: $moodPercentage, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoodImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.moodValue, moodValue) ||
                other.moodValue == moodValue) &&
            (identical(other.moodPercentage, moodPercentage) ||
                other.moodPercentage == moodPercentage) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, moodValue, moodPercentage, color);

  /// Create a copy of Mood
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MoodImplCopyWith<_$MoodImpl> get copyWith =>
      __$$MoodImplCopyWithImpl<_$MoodImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MoodImplToJson(this);
  }
}

abstract class _Mood implements Mood {
  const factory _Mood({
    required final String name,
    required final double moodValue,
    required final double moodPercentage,
    final int color,
  }) = _$MoodImpl;

  factory _Mood.fromJson(Map<String, dynamic> json) = _$MoodImpl.fromJson;

  @override
  String get name;
  @override
  double get moodValue;
  @override
  double get moodPercentage;
  @override
  int get color;

  /// Create a copy of Mood
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MoodImplCopyWith<_$MoodImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AwakeTimeAction _$AwakeTimeActionFromJson(Map<String, dynamic> json) {
  return _AwakeTimeAction.fromJson(json);
}

/// @nodoc
mixin _$AwakeTimeAction {
  String get label => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  int get color => throw _privateConstructorUsedError;

  /// Serializes this AwakeTimeAction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AwakeTimeAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AwakeTimeActionCopyWith<AwakeTimeAction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AwakeTimeActionCopyWith<$Res> {
  factory $AwakeTimeActionCopyWith(
    AwakeTimeAction value,
    $Res Function(AwakeTimeAction) then,
  ) = _$AwakeTimeActionCopyWithImpl<$Res, AwakeTimeAction>;
  @useResult
  $Res call({String label, double value, int color});
}

/// @nodoc
class _$AwakeTimeActionCopyWithImpl<$Res, $Val extends AwakeTimeAction>
    implements $AwakeTimeActionCopyWith<$Res> {
  _$AwakeTimeActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AwakeTimeAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? value = null,
    Object? color = null,
  }) {
    return _then(
      _value.copyWith(
            label:
                null == label
                    ? _value.label
                    : label // ignore: cast_nullable_to_non_nullable
                        as String,
            value:
                null == value
                    ? _value.value
                    : value // ignore: cast_nullable_to_non_nullable
                        as double,
            color:
                null == color
                    ? _value.color
                    : color // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AwakeTimeActionImplCopyWith<$Res>
    implements $AwakeTimeActionCopyWith<$Res> {
  factory _$$AwakeTimeActionImplCopyWith(
    _$AwakeTimeActionImpl value,
    $Res Function(_$AwakeTimeActionImpl) then,
  ) = __$$AwakeTimeActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String label, double value, int color});
}

/// @nodoc
class __$$AwakeTimeActionImplCopyWithImpl<$Res>
    extends _$AwakeTimeActionCopyWithImpl<$Res, _$AwakeTimeActionImpl>
    implements _$$AwakeTimeActionImplCopyWith<$Res> {
  __$$AwakeTimeActionImplCopyWithImpl(
    _$AwakeTimeActionImpl _value,
    $Res Function(_$AwakeTimeActionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AwakeTimeAction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? value = null,
    Object? color = null,
  }) {
    return _then(
      _$AwakeTimeActionImpl(
        label:
            null == label
                ? _value.label
                : label // ignore: cast_nullable_to_non_nullable
                    as String,
        value:
            null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                    as double,
        color:
            null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AwakeTimeActionImpl implements _AwakeTimeAction {
  const _$AwakeTimeActionImpl({
    required this.label,
    required this.value,
    this.color = 0xFF00FF00,
  });

  factory _$AwakeTimeActionImpl.fromJson(Map<String, dynamic> json) =>
      _$$AwakeTimeActionImplFromJson(json);

  @override
  final String label;
  @override
  final double value;
  @override
  @JsonKey()
  final int color;

  @override
  String toString() {
    return 'AwakeTimeAction(label: $label, value: $value, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AwakeTimeActionImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, label, value, color);

  /// Create a copy of AwakeTimeAction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AwakeTimeActionImplCopyWith<_$AwakeTimeActionImpl> get copyWith =>
      __$$AwakeTimeActionImplCopyWithImpl<_$AwakeTimeActionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AwakeTimeActionImplToJson(this);
  }
}

abstract class _AwakeTimeAction implements AwakeTimeAction {
  const factory _AwakeTimeAction({
    required final String label,
    required final double value,
    final int color,
  }) = _$AwakeTimeActionImpl;

  factory _AwakeTimeAction.fromJson(Map<String, dynamic> json) =
      _$AwakeTimeActionImpl.fromJson;

  @override
  String get label;
  @override
  double get value;
  @override
  int get color;

  /// Create a copy of AwakeTimeAction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AwakeTimeActionImplCopyWith<_$AwakeTimeActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SocialEntity _$SocialEntityFromJson(Map<String, dynamic> json) {
  return _SocialEntity.fromJson(json);
}

/// @nodoc
mixin _$SocialEntity {
  String get name => throw _privateConstructorUsedError;
  String get details => throw _privateConstructorUsedError;
  List<String> get tips => throw _privateConstructorUsedError;
  String get timeSpent => throw _privateConstructorUsedError;

  /// Serializes this SocialEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SocialEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SocialEntityCopyWith<SocialEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocialEntityCopyWith<$Res> {
  factory $SocialEntityCopyWith(
    SocialEntity value,
    $Res Function(SocialEntity) then,
  ) = _$SocialEntityCopyWithImpl<$Res, SocialEntity>;
  @useResult
  $Res call({String name, String details, List<String> tips, String timeSpent});
}

/// @nodoc
class _$SocialEntityCopyWithImpl<$Res, $Val extends SocialEntity>
    implements $SocialEntityCopyWith<$Res> {
  _$SocialEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SocialEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? details = null,
    Object? tips = null,
    Object? timeSpent = null,
  }) {
    return _then(
      _value.copyWith(
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            details:
                null == details
                    ? _value.details
                    : details // ignore: cast_nullable_to_non_nullable
                        as String,
            tips:
                null == tips
                    ? _value.tips
                    : tips // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            timeSpent:
                null == timeSpent
                    ? _value.timeSpent
                    : timeSpent // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SocialEntityImplCopyWith<$Res>
    implements $SocialEntityCopyWith<$Res> {
  factory _$$SocialEntityImplCopyWith(
    _$SocialEntityImpl value,
    $Res Function(_$SocialEntityImpl) then,
  ) = __$$SocialEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String details, List<String> tips, String timeSpent});
}

/// @nodoc
class __$$SocialEntityImplCopyWithImpl<$Res>
    extends _$SocialEntityCopyWithImpl<$Res, _$SocialEntityImpl>
    implements _$$SocialEntityImplCopyWith<$Res> {
  __$$SocialEntityImplCopyWithImpl(
    _$SocialEntityImpl _value,
    $Res Function(_$SocialEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SocialEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? details = null,
    Object? tips = null,
    Object? timeSpent = null,
  }) {
    return _then(
      _$SocialEntityImpl(
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        details:
            null == details
                ? _value.details
                : details // ignore: cast_nullable_to_non_nullable
                    as String,
        tips:
            null == tips
                ? _value._tips
                : tips // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        timeSpent:
            null == timeSpent
                ? _value.timeSpent
                : timeSpent // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SocialEntityImpl implements _SocialEntity {
  const _$SocialEntityImpl({
    required this.name,
    required this.details,
    required final List<String> tips,
    required this.timeSpent,
  }) : _tips = tips;

  factory _$SocialEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocialEntityImplFromJson(json);

  @override
  final String name;
  @override
  final String details;
  final List<String> _tips;
  @override
  List<String> get tips {
    if (_tips is EqualUnmodifiableListView) return _tips;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tips);
  }

  @override
  final String timeSpent;

  @override
  String toString() {
    return 'SocialEntity(name: $name, details: $details, tips: $tips, timeSpent: $timeSpent)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialEntityImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.details, details) || other.details == details) &&
            const DeepCollectionEquality().equals(other._tips, _tips) &&
            (identical(other.timeSpent, timeSpent) ||
                other.timeSpent == timeSpent));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    details,
    const DeepCollectionEquality().hash(_tips),
    timeSpent,
  );

  /// Create a copy of SocialEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SocialEntityImplCopyWith<_$SocialEntityImpl> get copyWith =>
      __$$SocialEntityImplCopyWithImpl<_$SocialEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SocialEntityImplToJson(this);
  }
}

abstract class _SocialEntity implements SocialEntity {
  const factory _SocialEntity({
    required final String name,
    required final String details,
    required final List<String> tips,
    required final String timeSpent,
  }) = _$SocialEntityImpl;

  factory _SocialEntity.fromJson(Map<String, dynamic> json) =
      _$SocialEntityImpl.fromJson;

  @override
  String get name;
  @override
  String get details;
  @override
  List<String> get tips;
  @override
  String get timeSpent;

  /// Create a copy of SocialEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SocialEntityImplCopyWith<_$SocialEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SocialMap _$SocialMapFromJson(Map<String, dynamic> json) {
  return _SocialMap.fromJson(json);
}

/// @nodoc
mixin _$SocialMap {
  List<SocialEntity> get socialEntities => throw _privateConstructorUsedError;

  /// Serializes this SocialMap to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SocialMap
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SocialMapCopyWith<SocialMap> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocialMapCopyWith<$Res> {
  factory $SocialMapCopyWith(SocialMap value, $Res Function(SocialMap) then) =
      _$SocialMapCopyWithImpl<$Res, SocialMap>;
  @useResult
  $Res call({List<SocialEntity> socialEntities});
}

/// @nodoc
class _$SocialMapCopyWithImpl<$Res, $Val extends SocialMap>
    implements $SocialMapCopyWith<$Res> {
  _$SocialMapCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SocialMap
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? socialEntities = null}) {
    return _then(
      _value.copyWith(
            socialEntities:
                null == socialEntities
                    ? _value.socialEntities
                    : socialEntities // ignore: cast_nullable_to_non_nullable
                        as List<SocialEntity>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SocialMapImplCopyWith<$Res>
    implements $SocialMapCopyWith<$Res> {
  factory _$$SocialMapImplCopyWith(
    _$SocialMapImpl value,
    $Res Function(_$SocialMapImpl) then,
  ) = __$$SocialMapImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<SocialEntity> socialEntities});
}

/// @nodoc
class __$$SocialMapImplCopyWithImpl<$Res>
    extends _$SocialMapCopyWithImpl<$Res, _$SocialMapImpl>
    implements _$$SocialMapImplCopyWith<$Res> {
  __$$SocialMapImplCopyWithImpl(
    _$SocialMapImpl _value,
    $Res Function(_$SocialMapImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SocialMap
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? socialEntities = null}) {
    return _then(
      _$SocialMapImpl(
        socialEntities:
            null == socialEntities
                ? _value._socialEntities
                : socialEntities // ignore: cast_nullable_to_non_nullable
                    as List<SocialEntity>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SocialMapImpl implements _SocialMap {
  const _$SocialMapImpl({required final List<SocialEntity> socialEntities})
    : _socialEntities = socialEntities;

  factory _$SocialMapImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocialMapImplFromJson(json);

  final List<SocialEntity> _socialEntities;
  @override
  List<SocialEntity> get socialEntities {
    if (_socialEntities is EqualUnmodifiableListView) return _socialEntities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_socialEntities);
  }

  @override
  String toString() {
    return 'SocialMap(socialEntities: $socialEntities)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialMapImpl &&
            const DeepCollectionEquality().equals(
              other._socialEntities,
              _socialEntities,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_socialEntities),
  );

  /// Create a copy of SocialMap
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SocialMapImplCopyWith<_$SocialMapImpl> get copyWith =>
      __$$SocialMapImplCopyWithImpl<_$SocialMapImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SocialMapImplToJson(this);
  }
}

abstract class _SocialMap implements SocialMap {
  const factory _SocialMap({required final List<SocialEntity> socialEntities}) =
      _$SocialMapImpl;

  factory _SocialMap.fromJson(Map<String, dynamic> json) =
      _$SocialMapImpl.fromJson;

  @override
  List<SocialEntity> get socialEntities;

  /// Create a copy of SocialMap
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SocialMapImplCopyWith<_$SocialMapImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Journal _$JournalFromJson(Map<String, dynamic> json) {
  return _Journal.fromJson(json);
}

/// @nodoc
mixin _$Journal {
  DateTime get dateTime => throw _privateConstructorUsedError;
  String get summary => throw _privateConstructorUsedError;
  List<DiaryEntry> get diaryEntries => throw _privateConstructorUsedError;
  List<Quote> get quotes => throw _privateConstructorUsedError;
  List<Reflection> get selfReflections => throw _privateConstructorUsedError;
  List<Reflection> get detailedInsights => throw _privateConstructorUsedError;
  List<Reflection> get goals => throw _privateConstructorUsedError;
  MoodScore get moodScore => throw _privateConstructorUsedError;
  StressLevel get stressLevel => throw _privateConstructorUsedError;
  List<Highlight> get highlights => throw _privateConstructorUsedError;
  List<Energy> get energyRecords => throw _privateConstructorUsedError;
  List<Mood> get moods => throw _privateConstructorUsedError;
  List<AwakeTimeAction> get awakeTimeActions =>
      throw _privateConstructorUsedError;
  SocialMap get socialMap => throw _privateConstructorUsedError;

  /// Serializes this Journal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Journal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JournalCopyWith<Journal> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JournalCopyWith<$Res> {
  factory $JournalCopyWith(Journal value, $Res Function(Journal) then) =
      _$JournalCopyWithImpl<$Res, Journal>;
  @useResult
  $Res call({
    DateTime dateTime,
    String summary,
    List<DiaryEntry> diaryEntries,
    List<Quote> quotes,
    List<Reflection> selfReflections,
    List<Reflection> detailedInsights,
    List<Reflection> goals,
    MoodScore moodScore,
    StressLevel stressLevel,
    List<Highlight> highlights,
    List<Energy> energyRecords,
    List<Mood> moods,
    List<AwakeTimeAction> awakeTimeActions,
    SocialMap socialMap,
  });

  $MoodScoreCopyWith<$Res> get moodScore;
  $StressLevelCopyWith<$Res> get stressLevel;
  $SocialMapCopyWith<$Res> get socialMap;
}

/// @nodoc
class _$JournalCopyWithImpl<$Res, $Val extends Journal>
    implements $JournalCopyWith<$Res> {
  _$JournalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Journal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dateTime = null,
    Object? summary = null,
    Object? diaryEntries = null,
    Object? quotes = null,
    Object? selfReflections = null,
    Object? detailedInsights = null,
    Object? goals = null,
    Object? moodScore = null,
    Object? stressLevel = null,
    Object? highlights = null,
    Object? energyRecords = null,
    Object? moods = null,
    Object? awakeTimeActions = null,
    Object? socialMap = null,
  }) {
    return _then(
      _value.copyWith(
            dateTime:
                null == dateTime
                    ? _value.dateTime
                    : dateTime // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            summary:
                null == summary
                    ? _value.summary
                    : summary // ignore: cast_nullable_to_non_nullable
                        as String,
            diaryEntries:
                null == diaryEntries
                    ? _value.diaryEntries
                    : diaryEntries // ignore: cast_nullable_to_non_nullable
                        as List<DiaryEntry>,
            quotes:
                null == quotes
                    ? _value.quotes
                    : quotes // ignore: cast_nullable_to_non_nullable
                        as List<Quote>,
            selfReflections:
                null == selfReflections
                    ? _value.selfReflections
                    : selfReflections // ignore: cast_nullable_to_non_nullable
                        as List<Reflection>,
            detailedInsights:
                null == detailedInsights
                    ? _value.detailedInsights
                    : detailedInsights // ignore: cast_nullable_to_non_nullable
                        as List<Reflection>,
            goals:
                null == goals
                    ? _value.goals
                    : goals // ignore: cast_nullable_to_non_nullable
                        as List<Reflection>,
            moodScore:
                null == moodScore
                    ? _value.moodScore
                    : moodScore // ignore: cast_nullable_to_non_nullable
                        as MoodScore,
            stressLevel:
                null == stressLevel
                    ? _value.stressLevel
                    : stressLevel // ignore: cast_nullable_to_non_nullable
                        as StressLevel,
            highlights:
                null == highlights
                    ? _value.highlights
                    : highlights // ignore: cast_nullable_to_non_nullable
                        as List<Highlight>,
            energyRecords:
                null == energyRecords
                    ? _value.energyRecords
                    : energyRecords // ignore: cast_nullable_to_non_nullable
                        as List<Energy>,
            moods:
                null == moods
                    ? _value.moods
                    : moods // ignore: cast_nullable_to_non_nullable
                        as List<Mood>,
            awakeTimeActions:
                null == awakeTimeActions
                    ? _value.awakeTimeActions
                    : awakeTimeActions // ignore: cast_nullable_to_non_nullable
                        as List<AwakeTimeAction>,
            socialMap:
                null == socialMap
                    ? _value.socialMap
                    : socialMap // ignore: cast_nullable_to_non_nullable
                        as SocialMap,
          )
          as $Val,
    );
  }

  /// Create a copy of Journal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MoodScoreCopyWith<$Res> get moodScore {
    return $MoodScoreCopyWith<$Res>(_value.moodScore, (value) {
      return _then(_value.copyWith(moodScore: value) as $Val);
    });
  }

  /// Create a copy of Journal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StressLevelCopyWith<$Res> get stressLevel {
    return $StressLevelCopyWith<$Res>(_value.stressLevel, (value) {
      return _then(_value.copyWith(stressLevel: value) as $Val);
    });
  }

  /// Create a copy of Journal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SocialMapCopyWith<$Res> get socialMap {
    return $SocialMapCopyWith<$Res>(_value.socialMap, (value) {
      return _then(_value.copyWith(socialMap: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$JournalImplCopyWith<$Res> implements $JournalCopyWith<$Res> {
  factory _$$JournalImplCopyWith(
    _$JournalImpl value,
    $Res Function(_$JournalImpl) then,
  ) = __$$JournalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    DateTime dateTime,
    String summary,
    List<DiaryEntry> diaryEntries,
    List<Quote> quotes,
    List<Reflection> selfReflections,
    List<Reflection> detailedInsights,
    List<Reflection> goals,
    MoodScore moodScore,
    StressLevel stressLevel,
    List<Highlight> highlights,
    List<Energy> energyRecords,
    List<Mood> moods,
    List<AwakeTimeAction> awakeTimeActions,
    SocialMap socialMap,
  });

  @override
  $MoodScoreCopyWith<$Res> get moodScore;
  @override
  $StressLevelCopyWith<$Res> get stressLevel;
  @override
  $SocialMapCopyWith<$Res> get socialMap;
}

/// @nodoc
class __$$JournalImplCopyWithImpl<$Res>
    extends _$JournalCopyWithImpl<$Res, _$JournalImpl>
    implements _$$JournalImplCopyWith<$Res> {
  __$$JournalImplCopyWithImpl(
    _$JournalImpl _value,
    $Res Function(_$JournalImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Journal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dateTime = null,
    Object? summary = null,
    Object? diaryEntries = null,
    Object? quotes = null,
    Object? selfReflections = null,
    Object? detailedInsights = null,
    Object? goals = null,
    Object? moodScore = null,
    Object? stressLevel = null,
    Object? highlights = null,
    Object? energyRecords = null,
    Object? moods = null,
    Object? awakeTimeActions = null,
    Object? socialMap = null,
  }) {
    return _then(
      _$JournalImpl(
        dateTime:
            null == dateTime
                ? _value.dateTime
                : dateTime // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        summary:
            null == summary
                ? _value.summary
                : summary // ignore: cast_nullable_to_non_nullable
                    as String,
        diaryEntries:
            null == diaryEntries
                ? _value._diaryEntries
                : diaryEntries // ignore: cast_nullable_to_non_nullable
                    as List<DiaryEntry>,
        quotes:
            null == quotes
                ? _value._quotes
                : quotes // ignore: cast_nullable_to_non_nullable
                    as List<Quote>,
        selfReflections:
            null == selfReflections
                ? _value._selfReflections
                : selfReflections // ignore: cast_nullable_to_non_nullable
                    as List<Reflection>,
        detailedInsights:
            null == detailedInsights
                ? _value._detailedInsights
                : detailedInsights // ignore: cast_nullable_to_non_nullable
                    as List<Reflection>,
        goals:
            null == goals
                ? _value._goals
                : goals // ignore: cast_nullable_to_non_nullable
                    as List<Reflection>,
        moodScore:
            null == moodScore
                ? _value.moodScore
                : moodScore // ignore: cast_nullable_to_non_nullable
                    as MoodScore,
        stressLevel:
            null == stressLevel
                ? _value.stressLevel
                : stressLevel // ignore: cast_nullable_to_non_nullable
                    as StressLevel,
        highlights:
            null == highlights
                ? _value._highlights
                : highlights // ignore: cast_nullable_to_non_nullable
                    as List<Highlight>,
        energyRecords:
            null == energyRecords
                ? _value._energyRecords
                : energyRecords // ignore: cast_nullable_to_non_nullable
                    as List<Energy>,
        moods:
            null == moods
                ? _value._moods
                : moods // ignore: cast_nullable_to_non_nullable
                    as List<Mood>,
        awakeTimeActions:
            null == awakeTimeActions
                ? _value._awakeTimeActions
                : awakeTimeActions // ignore: cast_nullable_to_non_nullable
                    as List<AwakeTimeAction>,
        socialMap:
            null == socialMap
                ? _value.socialMap
                : socialMap // ignore: cast_nullable_to_non_nullable
                    as SocialMap,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$JournalImpl implements _Journal {
  const _$JournalImpl({
    required this.dateTime,
    required this.summary,
    required final List<DiaryEntry> diaryEntries,
    required final List<Quote> quotes,
    required final List<Reflection> selfReflections,
    required final List<Reflection> detailedInsights,
    required final List<Reflection> goals,
    required this.moodScore,
    required this.stressLevel,
    required final List<Highlight> highlights,
    required final List<Energy> energyRecords,
    required final List<Mood> moods,
    required final List<AwakeTimeAction> awakeTimeActions,
    required this.socialMap,
  }) : _diaryEntries = diaryEntries,
       _quotes = quotes,
       _selfReflections = selfReflections,
       _detailedInsights = detailedInsights,
       _goals = goals,
       _highlights = highlights,
       _energyRecords = energyRecords,
       _moods = moods,
       _awakeTimeActions = awakeTimeActions;

  factory _$JournalImpl.fromJson(Map<String, dynamic> json) =>
      _$$JournalImplFromJson(json);

  @override
  final DateTime dateTime;
  @override
  final String summary;
  final List<DiaryEntry> _diaryEntries;
  @override
  List<DiaryEntry> get diaryEntries {
    if (_diaryEntries is EqualUnmodifiableListView) return _diaryEntries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_diaryEntries);
  }

  final List<Quote> _quotes;
  @override
  List<Quote> get quotes {
    if (_quotes is EqualUnmodifiableListView) return _quotes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_quotes);
  }

  final List<Reflection> _selfReflections;
  @override
  List<Reflection> get selfReflections {
    if (_selfReflections is EqualUnmodifiableListView) return _selfReflections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selfReflections);
  }

  final List<Reflection> _detailedInsights;
  @override
  List<Reflection> get detailedInsights {
    if (_detailedInsights is EqualUnmodifiableListView)
      return _detailedInsights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_detailedInsights);
  }

  final List<Reflection> _goals;
  @override
  List<Reflection> get goals {
    if (_goals is EqualUnmodifiableListView) return _goals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_goals);
  }

  @override
  final MoodScore moodScore;
  @override
  final StressLevel stressLevel;
  final List<Highlight> _highlights;
  @override
  List<Highlight> get highlights {
    if (_highlights is EqualUnmodifiableListView) return _highlights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_highlights);
  }

  final List<Energy> _energyRecords;
  @override
  List<Energy> get energyRecords {
    if (_energyRecords is EqualUnmodifiableListView) return _energyRecords;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_energyRecords);
  }

  final List<Mood> _moods;
  @override
  List<Mood> get moods {
    if (_moods is EqualUnmodifiableListView) return _moods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_moods);
  }

  final List<AwakeTimeAction> _awakeTimeActions;
  @override
  List<AwakeTimeAction> get awakeTimeActions {
    if (_awakeTimeActions is EqualUnmodifiableListView)
      return _awakeTimeActions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_awakeTimeActions);
  }

  @override
  final SocialMap socialMap;

  @override
  String toString() {
    return 'Journal(dateTime: $dateTime, summary: $summary, diaryEntries: $diaryEntries, quotes: $quotes, selfReflections: $selfReflections, detailedInsights: $detailedInsights, goals: $goals, moodScore: $moodScore, stressLevel: $stressLevel, highlights: $highlights, energyRecords: $energyRecords, moods: $moods, awakeTimeActions: $awakeTimeActions, socialMap: $socialMap)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JournalImpl &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime) &&
            (identical(other.summary, summary) || other.summary == summary) &&
            const DeepCollectionEquality().equals(
              other._diaryEntries,
              _diaryEntries,
            ) &&
            const DeepCollectionEquality().equals(other._quotes, _quotes) &&
            const DeepCollectionEquality().equals(
              other._selfReflections,
              _selfReflections,
            ) &&
            const DeepCollectionEquality().equals(
              other._detailedInsights,
              _detailedInsights,
            ) &&
            const DeepCollectionEquality().equals(other._goals, _goals) &&
            (identical(other.moodScore, moodScore) ||
                other.moodScore == moodScore) &&
            (identical(other.stressLevel, stressLevel) ||
                other.stressLevel == stressLevel) &&
            const DeepCollectionEquality().equals(
              other._highlights,
              _highlights,
            ) &&
            const DeepCollectionEquality().equals(
              other._energyRecords,
              _energyRecords,
            ) &&
            const DeepCollectionEquality().equals(other._moods, _moods) &&
            const DeepCollectionEquality().equals(
              other._awakeTimeActions,
              _awakeTimeActions,
            ) &&
            (identical(other.socialMap, socialMap) ||
                other.socialMap == socialMap));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    dateTime,
    summary,
    const DeepCollectionEquality().hash(_diaryEntries),
    const DeepCollectionEquality().hash(_quotes),
    const DeepCollectionEquality().hash(_selfReflections),
    const DeepCollectionEquality().hash(_detailedInsights),
    const DeepCollectionEquality().hash(_goals),
    moodScore,
    stressLevel,
    const DeepCollectionEquality().hash(_highlights),
    const DeepCollectionEquality().hash(_energyRecords),
    const DeepCollectionEquality().hash(_moods),
    const DeepCollectionEquality().hash(_awakeTimeActions),
    socialMap,
  );

  /// Create a copy of Journal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JournalImplCopyWith<_$JournalImpl> get copyWith =>
      __$$JournalImplCopyWithImpl<_$JournalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JournalImplToJson(this);
  }
}

abstract class _Journal implements Journal {
  const factory _Journal({
    required final DateTime dateTime,
    required final String summary,
    required final List<DiaryEntry> diaryEntries,
    required final List<Quote> quotes,
    required final List<Reflection> selfReflections,
    required final List<Reflection> detailedInsights,
    required final List<Reflection> goals,
    required final MoodScore moodScore,
    required final StressLevel stressLevel,
    required final List<Highlight> highlights,
    required final List<Energy> energyRecords,
    required final List<Mood> moods,
    required final List<AwakeTimeAction> awakeTimeActions,
    required final SocialMap socialMap,
  }) = _$JournalImpl;

  factory _Journal.fromJson(Map<String, dynamic> json) = _$JournalImpl.fromJson;

  @override
  DateTime get dateTime;
  @override
  String get summary;
  @override
  List<DiaryEntry> get diaryEntries;
  @override
  List<Quote> get quotes;
  @override
  List<Reflection> get selfReflections;
  @override
  List<Reflection> get detailedInsights;
  @override
  List<Reflection> get goals;
  @override
  MoodScore get moodScore;
  @override
  StressLevel get stressLevel;
  @override
  List<Highlight> get highlights;
  @override
  List<Energy> get energyRecords;
  @override
  List<Mood> get moods;
  @override
  List<AwakeTimeAction> get awakeTimeActions;
  @override
  SocialMap get socialMap;

  /// Create a copy of Journal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JournalImplCopyWith<_$JournalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MoodScoreDashborad _$MoodScoreDashboradFromJson(Map<String, dynamic> json) {
  return _MoodScoreDashborad.fromJson(json);
}

/// @nodoc
mixin _$MoodScoreDashborad {
  DateTime get dateTime => throw _privateConstructorUsedError;
  List<String> get insights => throw _privateConstructorUsedError;

  /// Serializes this MoodScoreDashborad to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MoodScoreDashborad
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MoodScoreDashboradCopyWith<MoodScoreDashborad> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoodScoreDashboradCopyWith<$Res> {
  factory $MoodScoreDashboradCopyWith(
    MoodScoreDashborad value,
    $Res Function(MoodScoreDashborad) then,
  ) = _$MoodScoreDashboradCopyWithImpl<$Res, MoodScoreDashborad>;
  @useResult
  $Res call({DateTime dateTime, List<String> insights});
}

/// @nodoc
class _$MoodScoreDashboradCopyWithImpl<$Res, $Val extends MoodScoreDashborad>
    implements $MoodScoreDashboradCopyWith<$Res> {
  _$MoodScoreDashboradCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MoodScoreDashborad
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? dateTime = null, Object? insights = null}) {
    return _then(
      _value.copyWith(
            dateTime:
                null == dateTime
                    ? _value.dateTime
                    : dateTime // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            insights:
                null == insights
                    ? _value.insights
                    : insights // ignore: cast_nullable_to_non_nullable
                        as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MoodScoreDashboradImplCopyWith<$Res>
    implements $MoodScoreDashboradCopyWith<$Res> {
  factory _$$MoodScoreDashboradImplCopyWith(
    _$MoodScoreDashboradImpl value,
    $Res Function(_$MoodScoreDashboradImpl) then,
  ) = __$$MoodScoreDashboradImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime dateTime, List<String> insights});
}

/// @nodoc
class __$$MoodScoreDashboradImplCopyWithImpl<$Res>
    extends _$MoodScoreDashboradCopyWithImpl<$Res, _$MoodScoreDashboradImpl>
    implements _$$MoodScoreDashboradImplCopyWith<$Res> {
  __$$MoodScoreDashboradImplCopyWithImpl(
    _$MoodScoreDashboradImpl _value,
    $Res Function(_$MoodScoreDashboradImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MoodScoreDashborad
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? dateTime = null, Object? insights = null}) {
    return _then(
      _$MoodScoreDashboradImpl(
        dateTime:
            null == dateTime
                ? _value.dateTime
                : dateTime // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        insights:
            null == insights
                ? _value._insights
                : insights // ignore: cast_nullable_to_non_nullable
                    as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MoodScoreDashboradImpl implements _MoodScoreDashborad {
  const _$MoodScoreDashboradImpl({
    required this.dateTime,
    required final List<String> insights,
  }) : _insights = insights;

  factory _$MoodScoreDashboradImpl.fromJson(Map<String, dynamic> json) =>
      _$$MoodScoreDashboradImplFromJson(json);

  @override
  final DateTime dateTime;
  final List<String> _insights;
  @override
  List<String> get insights {
    if (_insights is EqualUnmodifiableListView) return _insights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_insights);
  }

  @override
  String toString() {
    return 'MoodScoreDashborad(dateTime: $dateTime, insights: $insights)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoodScoreDashboradImpl &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime) &&
            const DeepCollectionEquality().equals(other._insights, _insights));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    dateTime,
    const DeepCollectionEquality().hash(_insights),
  );

  /// Create a copy of MoodScoreDashborad
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MoodScoreDashboradImplCopyWith<_$MoodScoreDashboradImpl> get copyWith =>
      __$$MoodScoreDashboradImplCopyWithImpl<_$MoodScoreDashboradImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MoodScoreDashboradImplToJson(this);
  }
}

abstract class _MoodScoreDashborad implements MoodScoreDashborad {
  const factory _MoodScoreDashborad({
    required final DateTime dateTime,
    required final List<String> insights,
  }) = _$MoodScoreDashboradImpl;

  factory _MoodScoreDashborad.fromJson(Map<String, dynamic> json) =
      _$MoodScoreDashboradImpl.fromJson;

  @override
  DateTime get dateTime;
  @override
  List<String> get insights;

  /// Create a copy of MoodScoreDashborad
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MoodScoreDashboradImplCopyWith<_$MoodScoreDashboradImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
