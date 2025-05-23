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

ArchivedHighlights _$ArchivedHighlightsFromJson(Map<String, dynamic> json) {
  return _ArchivedHighlights.fromJson(json);
}

/// @nodoc
mixin _$ArchivedHighlights {
  DateTime get beginTime => throw _privateConstructorUsedError;
  DateTime get endTime => throw _privateConstructorUsedError;
  List<Highlight> get highlights => throw _privateConstructorUsedError;

  /// Serializes this ArchivedHighlights to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ArchivedHighlights
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ArchivedHighlightsCopyWith<ArchivedHighlights> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArchivedHighlightsCopyWith<$Res> {
  factory $ArchivedHighlightsCopyWith(
    ArchivedHighlights value,
    $Res Function(ArchivedHighlights) then,
  ) = _$ArchivedHighlightsCopyWithImpl<$Res, ArchivedHighlights>;
  @useResult
  $Res call({DateTime beginTime, DateTime endTime, List<Highlight> highlights});
}

/// @nodoc
class _$ArchivedHighlightsCopyWithImpl<$Res, $Val extends ArchivedHighlights>
    implements $ArchivedHighlightsCopyWith<$Res> {
  _$ArchivedHighlightsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ArchivedHighlights
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
abstract class _$$ArchivedHighlightsImplCopyWith<$Res>
    implements $ArchivedHighlightsCopyWith<$Res> {
  factory _$$ArchivedHighlightsImplCopyWith(
    _$ArchivedHighlightsImpl value,
    $Res Function(_$ArchivedHighlightsImpl) then,
  ) = __$$ArchivedHighlightsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime beginTime, DateTime endTime, List<Highlight> highlights});
}

/// @nodoc
class __$$ArchivedHighlightsImplCopyWithImpl<$Res>
    extends _$ArchivedHighlightsCopyWithImpl<$Res, _$ArchivedHighlightsImpl>
    implements _$$ArchivedHighlightsImplCopyWith<$Res> {
  __$$ArchivedHighlightsImplCopyWithImpl(
    _$ArchivedHighlightsImpl _value,
    $Res Function(_$ArchivedHighlightsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ArchivedHighlights
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? beginTime = null,
    Object? endTime = null,
    Object? highlights = null,
  }) {
    return _then(
      _$ArchivedHighlightsImpl(
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
class _$ArchivedHighlightsImpl implements _ArchivedHighlights {
  const _$ArchivedHighlightsImpl({
    required this.beginTime,
    required this.endTime,
    required final List<Highlight> highlights,
  }) : _highlights = highlights;

  factory _$ArchivedHighlightsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArchivedHighlightsImplFromJson(json);

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
    return 'ArchivedHighlights(beginTime: $beginTime, endTime: $endTime, highlights: $highlights)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArchivedHighlightsImpl &&
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

  /// Create a copy of ArchivedHighlights
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArchivedHighlightsImplCopyWith<_$ArchivedHighlightsImpl> get copyWith =>
      __$$ArchivedHighlightsImplCopyWithImpl<_$ArchivedHighlightsImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ArchivedHighlightsImplToJson(this);
  }
}

abstract class _ArchivedHighlights implements ArchivedHighlights {
  const factory _ArchivedHighlights({
    required final DateTime beginTime,
    required final DateTime endTime,
    required final List<Highlight> highlights,
  }) = _$ArchivedHighlightsImpl;

  factory _ArchivedHighlights.fromJson(Map<String, dynamic> json) =
      _$ArchivedHighlightsImpl.fromJson;

  @override
  DateTime get beginTime;
  @override
  DateTime get endTime;
  @override
  List<Highlight> get highlights;

  /// Create a copy of ArchivedHighlights
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ArchivedHighlightsImplCopyWith<_$ArchivedHighlightsImpl> get copyWith =>
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

EnergyLevel _$EnergyLevelFromJson(Map<String, dynamic> json) {
  return _EnergyLevel.fromJson(json);
}

/// @nodoc
mixin _$EnergyLevel {
  DateTime get dateTime => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;

  /// Serializes this EnergyLevel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EnergyLevel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EnergyLevelCopyWith<EnergyLevel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnergyLevelCopyWith<$Res> {
  factory $EnergyLevelCopyWith(
    EnergyLevel value,
    $Res Function(EnergyLevel) then,
  ) = _$EnergyLevelCopyWithImpl<$Res, EnergyLevel>;
  @useResult
  $Res call({DateTime dateTime, double value});
}

/// @nodoc
class _$EnergyLevelCopyWithImpl<$Res, $Val extends EnergyLevel>
    implements $EnergyLevelCopyWith<$Res> {
  _$EnergyLevelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EnergyLevel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? dateTime = null, Object? value = null}) {
    return _then(
      _value.copyWith(
            dateTime:
                null == dateTime
                    ? _value.dateTime
                    : dateTime // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            value:
                null == value
                    ? _value.value
                    : value // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$EnergyLevelImplCopyWith<$Res>
    implements $EnergyLevelCopyWith<$Res> {
  factory _$$EnergyLevelImplCopyWith(
    _$EnergyLevelImpl value,
    $Res Function(_$EnergyLevelImpl) then,
  ) = __$$EnergyLevelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime dateTime, double value});
}

/// @nodoc
class __$$EnergyLevelImplCopyWithImpl<$Res>
    extends _$EnergyLevelCopyWithImpl<$Res, _$EnergyLevelImpl>
    implements _$$EnergyLevelImplCopyWith<$Res> {
  __$$EnergyLevelImplCopyWithImpl(
    _$EnergyLevelImpl _value,
    $Res Function(_$EnergyLevelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EnergyLevel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? dateTime = null, Object? value = null}) {
    return _then(
      _$EnergyLevelImpl(
        dateTime:
            null == dateTime
                ? _value.dateTime
                : dateTime // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        value:
            null == value
                ? _value.value
                : value // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$EnergyLevelImpl implements _EnergyLevel {
  const _$EnergyLevelImpl({required this.dateTime, required this.value});

  factory _$EnergyLevelImpl.fromJson(Map<String, dynamic> json) =>
      _$$EnergyLevelImplFromJson(json);

  @override
  final DateTime dateTime;
  @override
  final double value;

  @override
  String toString() {
    return 'EnergyLevel(dateTime: $dateTime, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EnergyLevelImpl &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, dateTime, value);

  /// Create a copy of EnergyLevel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EnergyLevelImplCopyWith<_$EnergyLevelImpl> get copyWith =>
      __$$EnergyLevelImplCopyWithImpl<_$EnergyLevelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EnergyLevelImplToJson(this);
  }
}

abstract class _EnergyLevel implements EnergyLevel {
  const factory _EnergyLevel({
    required final DateTime dateTime,
    required final double value,
  }) = _$EnergyLevelImpl;

  factory _EnergyLevel.fromJson(Map<String, dynamic> json) =
      _$EnergyLevelImpl.fromJson;

  @override
  DateTime get dateTime;
  @override
  double get value;

  /// Create a copy of EnergyLevel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EnergyLevelImplCopyWith<_$EnergyLevelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MoodTracking _$MoodTrackingFromJson(Map<String, dynamic> json) {
  return _MoodTracking.fromJson(json);
}

/// @nodoc
mixin _$MoodTracking {
  String get name => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  int get color => throw _privateConstructorUsedError;

  /// Serializes this MoodTracking to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MoodTracking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MoodTrackingCopyWith<MoodTracking> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoodTrackingCopyWith<$Res> {
  factory $MoodTrackingCopyWith(
    MoodTracking value,
    $Res Function(MoodTracking) then,
  ) = _$MoodTrackingCopyWithImpl<$Res, MoodTracking>;
  @useResult
  $Res call({String name, double value, int color});
}

/// @nodoc
class _$MoodTrackingCopyWithImpl<$Res, $Val extends MoodTracking>
    implements $MoodTrackingCopyWith<$Res> {
  _$MoodTrackingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MoodTracking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? value = null, Object? color = null}) {
    return _then(
      _value.copyWith(
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
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
abstract class _$$MoodTrackingImplCopyWith<$Res>
    implements $MoodTrackingCopyWith<$Res> {
  factory _$$MoodTrackingImplCopyWith(
    _$MoodTrackingImpl value,
    $Res Function(_$MoodTrackingImpl) then,
  ) = __$$MoodTrackingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, double value, int color});
}

/// @nodoc
class __$$MoodTrackingImplCopyWithImpl<$Res>
    extends _$MoodTrackingCopyWithImpl<$Res, _$MoodTrackingImpl>
    implements _$$MoodTrackingImplCopyWith<$Res> {
  __$$MoodTrackingImplCopyWithImpl(
    _$MoodTrackingImpl _value,
    $Res Function(_$MoodTrackingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MoodTracking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? name = null, Object? value = null, Object? color = null}) {
    return _then(
      _$MoodTrackingImpl(
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
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
class _$MoodTrackingImpl implements _MoodTracking {
  const _$MoodTrackingImpl({
    required this.name,
    required this.value,
    this.color = 0xFF000000,
  });

  factory _$MoodTrackingImpl.fromJson(Map<String, dynamic> json) =>
      _$$MoodTrackingImplFromJson(json);

  @override
  final String name;
  @override
  final double value;
  @override
  @JsonKey()
  final int color;

  @override
  String toString() {
    return 'MoodTracking(name: $name, value: $value, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoodTrackingImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, value, color);

  /// Create a copy of MoodTracking
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MoodTrackingImplCopyWith<_$MoodTrackingImpl> get copyWith =>
      __$$MoodTrackingImplCopyWithImpl<_$MoodTrackingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MoodTrackingImplToJson(this);
  }
}

abstract class _MoodTracking implements MoodTracking {
  const factory _MoodTracking({
    required final String name,
    required final double value,
    final int color,
  }) = _$MoodTrackingImpl;

  factory _MoodTracking.fromJson(Map<String, dynamic> json) =
      _$MoodTrackingImpl.fromJson;

  @override
  String get name;
  @override
  double get value;
  @override
  int get color;

  /// Create a copy of MoodTracking
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MoodTrackingImplCopyWith<_$MoodTrackingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AwakeTimeAllocation _$AwakeTimeAllocationFromJson(Map<String, dynamic> json) {
  return _AwakeTimeAllocation.fromJson(json);
}

/// @nodoc
mixin _$AwakeTimeAllocation {
  String get label => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  int get color => throw _privateConstructorUsedError;

  /// Serializes this AwakeTimeAllocation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AwakeTimeAllocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AwakeTimeAllocationCopyWith<AwakeTimeAllocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AwakeTimeAllocationCopyWith<$Res> {
  factory $AwakeTimeAllocationCopyWith(
    AwakeTimeAllocation value,
    $Res Function(AwakeTimeAllocation) then,
  ) = _$AwakeTimeAllocationCopyWithImpl<$Res, AwakeTimeAllocation>;
  @useResult
  $Res call({String label, double value, int color});
}

/// @nodoc
class _$AwakeTimeAllocationCopyWithImpl<$Res, $Val extends AwakeTimeAllocation>
    implements $AwakeTimeAllocationCopyWith<$Res> {
  _$AwakeTimeAllocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AwakeTimeAllocation
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
abstract class _$$AwakeTimeAllocationImplCopyWith<$Res>
    implements $AwakeTimeAllocationCopyWith<$Res> {
  factory _$$AwakeTimeAllocationImplCopyWith(
    _$AwakeTimeAllocationImpl value,
    $Res Function(_$AwakeTimeAllocationImpl) then,
  ) = __$$AwakeTimeAllocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String label, double value, int color});
}

/// @nodoc
class __$$AwakeTimeAllocationImplCopyWithImpl<$Res>
    extends _$AwakeTimeAllocationCopyWithImpl<$Res, _$AwakeTimeAllocationImpl>
    implements _$$AwakeTimeAllocationImplCopyWith<$Res> {
  __$$AwakeTimeAllocationImplCopyWithImpl(
    _$AwakeTimeAllocationImpl _value,
    $Res Function(_$AwakeTimeAllocationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AwakeTimeAllocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? value = null,
    Object? color = null,
  }) {
    return _then(
      _$AwakeTimeAllocationImpl(
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
class _$AwakeTimeAllocationImpl implements _AwakeTimeAllocation {
  const _$AwakeTimeAllocationImpl({
    required this.label,
    required this.value,
    this.color = 0xFF00FF00,
  });

  factory _$AwakeTimeAllocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$AwakeTimeAllocationImplFromJson(json);

  @override
  final String label;
  @override
  final double value;
  @override
  @JsonKey()
  final int color;

  @override
  String toString() {
    return 'AwakeTimeAllocation(label: $label, value: $value, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AwakeTimeAllocationImpl &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, label, value, color);

  /// Create a copy of AwakeTimeAllocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AwakeTimeAllocationImplCopyWith<_$AwakeTimeAllocationImpl> get copyWith =>
      __$$AwakeTimeAllocationImplCopyWithImpl<_$AwakeTimeAllocationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AwakeTimeAllocationImplToJson(this);
  }
}

abstract class _AwakeTimeAllocation implements AwakeTimeAllocation {
  const factory _AwakeTimeAllocation({
    required final String label,
    required final double value,
    final int color,
  }) = _$AwakeTimeAllocationImpl;

  factory _AwakeTimeAllocation.fromJson(Map<String, dynamic> json) =
      _$AwakeTimeAllocationImpl.fromJson;

  @override
  String get label;
  @override
  double get value;
  @override
  int get color;

  /// Create a copy of AwakeTimeAllocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AwakeTimeAllocationImplCopyWith<_$AwakeTimeAllocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SocialEntity _$SocialEntityFromJson(Map<String, dynamic> json) {
  return _SocialEntity.fromJson(json);
}

/// @nodoc
mixin _$SocialEntity {
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<String> get tips => throw _privateConstructorUsedError;
  double get hours => throw _privateConstructorUsedError;
  String get impact => throw _privateConstructorUsedError;

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
  $Res call({
    String name,
    String description,
    List<String> tips,
    double hours,
    String impact,
  });
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
    Object? description = null,
    Object? tips = null,
    Object? hours = null,
    Object? impact = null,
  }) {
    return _then(
      _value.copyWith(
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                null == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String,
            tips:
                null == tips
                    ? _value.tips
                    : tips // ignore: cast_nullable_to_non_nullable
                        as List<String>,
            hours:
                null == hours
                    ? _value.hours
                    : hours // ignore: cast_nullable_to_non_nullable
                        as double,
            impact:
                null == impact
                    ? _value.impact
                    : impact // ignore: cast_nullable_to_non_nullable
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
  $Res call({
    String name,
    String description,
    List<String> tips,
    double hours,
    String impact,
  });
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
    Object? description = null,
    Object? tips = null,
    Object? hours = null,
    Object? impact = null,
  }) {
    return _then(
      _$SocialEntityImpl(
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String,
        tips:
            null == tips
                ? _value._tips
                : tips // ignore: cast_nullable_to_non_nullable
                    as List<String>,
        hours:
            null == hours
                ? _value.hours
                : hours // ignore: cast_nullable_to_non_nullable
                    as double,
        impact:
            null == impact
                ? _value.impact
                : impact // ignore: cast_nullable_to_non_nullable
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
    required this.description,
    required final List<String> tips,
    required this.hours,
    this.impact = '',
  }) : _tips = tips;

  factory _$SocialEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocialEntityImplFromJson(json);

  @override
  final String name;
  @override
  final String description;
  final List<String> _tips;
  @override
  List<String> get tips {
    if (_tips is EqualUnmodifiableListView) return _tips;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tips);
  }

  @override
  final double hours;
  @override
  @JsonKey()
  final String impact;

  @override
  String toString() {
    return 'SocialEntity(name: $name, description: $description, tips: $tips, hours: $hours, impact: $impact)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialEntityImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._tips, _tips) &&
            (identical(other.hours, hours) || other.hours == hours) &&
            (identical(other.impact, impact) || other.impact == impact));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    name,
    description,
    const DeepCollectionEquality().hash(_tips),
    hours,
    impact,
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
    required final String description,
    required final List<String> tips,
    required final double hours,
    final String impact,
  }) = _$SocialEntityImpl;

  factory _SocialEntity.fromJson(Map<String, dynamic> json) =
      _$SocialEntityImpl.fromJson;

  @override
  String get name;
  @override
  String get description;
  @override
  List<String> get tips;
  @override
  double get hours;
  @override
  String get impact;

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
  List<EnergyLevel> get energyLevels => throw _privateConstructorUsedError;
  List<MoodTracking> get moodTrackings => throw _privateConstructorUsedError;
  List<AwakeTimeAllocation> get awakeTimeActions =>
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
    List<EnergyLevel> energyLevels,
    List<MoodTracking> moodTrackings,
    List<AwakeTimeAllocation> awakeTimeActions,
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
    Object? energyLevels = null,
    Object? moodTrackings = null,
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
            energyLevels:
                null == energyLevels
                    ? _value.energyLevels
                    : energyLevels // ignore: cast_nullable_to_non_nullable
                        as List<EnergyLevel>,
            moodTrackings:
                null == moodTrackings
                    ? _value.moodTrackings
                    : moodTrackings // ignore: cast_nullable_to_non_nullable
                        as List<MoodTracking>,
            awakeTimeActions:
                null == awakeTimeActions
                    ? _value.awakeTimeActions
                    : awakeTimeActions // ignore: cast_nullable_to_non_nullable
                        as List<AwakeTimeAllocation>,
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
    List<EnergyLevel> energyLevels,
    List<MoodTracking> moodTrackings,
    List<AwakeTimeAllocation> awakeTimeActions,
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
    Object? energyLevels = null,
    Object? moodTrackings = null,
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
        energyLevels:
            null == energyLevels
                ? _value._energyLevels
                : energyLevels // ignore: cast_nullable_to_non_nullable
                    as List<EnergyLevel>,
        moodTrackings:
            null == moodTrackings
                ? _value._moodTrackings
                : moodTrackings // ignore: cast_nullable_to_non_nullable
                    as List<MoodTracking>,
        awakeTimeActions:
            null == awakeTimeActions
                ? _value._awakeTimeActions
                : awakeTimeActions // ignore: cast_nullable_to_non_nullable
                    as List<AwakeTimeAllocation>,
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
    required final List<EnergyLevel> energyLevels,
    required final List<MoodTracking> moodTrackings,
    required final List<AwakeTimeAllocation> awakeTimeActions,
    required this.socialMap,
  }) : _diaryEntries = diaryEntries,
       _quotes = quotes,
       _selfReflections = selfReflections,
       _detailedInsights = detailedInsights,
       _goals = goals,
       _highlights = highlights,
       _energyLevels = energyLevels,
       _moodTrackings = moodTrackings,
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

  final List<EnergyLevel> _energyLevels;
  @override
  List<EnergyLevel> get energyLevels {
    if (_energyLevels is EqualUnmodifiableListView) return _energyLevels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_energyLevels);
  }

  final List<MoodTracking> _moodTrackings;
  @override
  List<MoodTracking> get moodTrackings {
    if (_moodTrackings is EqualUnmodifiableListView) return _moodTrackings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_moodTrackings);
  }

  final List<AwakeTimeAllocation> _awakeTimeActions;
  @override
  List<AwakeTimeAllocation> get awakeTimeActions {
    if (_awakeTimeActions is EqualUnmodifiableListView)
      return _awakeTimeActions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_awakeTimeActions);
  }

  @override
  final SocialMap socialMap;

  @override
  String toString() {
    return 'Journal(dateTime: $dateTime, summary: $summary, diaryEntries: $diaryEntries, quotes: $quotes, selfReflections: $selfReflections, detailedInsights: $detailedInsights, goals: $goals, moodScore: $moodScore, stressLevel: $stressLevel, highlights: $highlights, energyLevels: $energyLevels, moodTrackings: $moodTrackings, awakeTimeActions: $awakeTimeActions, socialMap: $socialMap)';
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
              other._energyLevels,
              _energyLevels,
            ) &&
            const DeepCollectionEquality().equals(
              other._moodTrackings,
              _moodTrackings,
            ) &&
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
    const DeepCollectionEquality().hash(_energyLevels),
    const DeepCollectionEquality().hash(_moodTrackings),
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
    required final List<EnergyLevel> energyLevels,
    required final List<MoodTracking> moodTrackings,
    required final List<AwakeTimeAllocation> awakeTimeActions,
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
  List<EnergyLevel> get energyLevels;
  @override
  List<MoodTracking> get moodTrackings;
  @override
  List<AwakeTimeAllocation> get awakeTimeActions;
  @override
  SocialMap get socialMap;

  /// Create a copy of Journal
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JournalImplCopyWith<_$JournalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MoodScoreDashboard _$MoodScoreDashboardFromJson(Map<String, dynamic> json) {
  return _MoodScoreDashboard.fromJson(json);
}

/// @nodoc
mixin _$MoodScoreDashboard {
  DateTime get dateTime => throw _privateConstructorUsedError;
  List<String> get insights => throw _privateConstructorUsedError;

  /// Serializes this MoodScoreDashboard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MoodScoreDashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MoodScoreDashboardCopyWith<MoodScoreDashboard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoodScoreDashboardCopyWith<$Res> {
  factory $MoodScoreDashboardCopyWith(
    MoodScoreDashboard value,
    $Res Function(MoodScoreDashboard) then,
  ) = _$MoodScoreDashboardCopyWithImpl<$Res, MoodScoreDashboard>;
  @useResult
  $Res call({DateTime dateTime, List<String> insights});
}

/// @nodoc
class _$MoodScoreDashboardCopyWithImpl<$Res, $Val extends MoodScoreDashboard>
    implements $MoodScoreDashboardCopyWith<$Res> {
  _$MoodScoreDashboardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MoodScoreDashboard
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
abstract class _$$MoodScoreDashboardImplCopyWith<$Res>
    implements $MoodScoreDashboardCopyWith<$Res> {
  factory _$$MoodScoreDashboardImplCopyWith(
    _$MoodScoreDashboardImpl value,
    $Res Function(_$MoodScoreDashboardImpl) then,
  ) = __$$MoodScoreDashboardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime dateTime, List<String> insights});
}

/// @nodoc
class __$$MoodScoreDashboardImplCopyWithImpl<$Res>
    extends _$MoodScoreDashboardCopyWithImpl<$Res, _$MoodScoreDashboardImpl>
    implements _$$MoodScoreDashboardImplCopyWith<$Res> {
  __$$MoodScoreDashboardImplCopyWithImpl(
    _$MoodScoreDashboardImpl _value,
    $Res Function(_$MoodScoreDashboardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MoodScoreDashboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? dateTime = null, Object? insights = null}) {
    return _then(
      _$MoodScoreDashboardImpl(
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
class _$MoodScoreDashboardImpl implements _MoodScoreDashboard {
  const _$MoodScoreDashboardImpl({
    required this.dateTime,
    required final List<String> insights,
  }) : _insights = insights;

  factory _$MoodScoreDashboardImpl.fromJson(Map<String, dynamic> json) =>
      _$$MoodScoreDashboardImplFromJson(json);

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
    return 'MoodScoreDashboard(dateTime: $dateTime, insights: $insights)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoodScoreDashboardImpl &&
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

  /// Create a copy of MoodScoreDashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MoodScoreDashboardImplCopyWith<_$MoodScoreDashboardImpl> get copyWith =>
      __$$MoodScoreDashboardImplCopyWithImpl<_$MoodScoreDashboardImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MoodScoreDashboardImplToJson(this);
  }
}

abstract class _MoodScoreDashboard implements MoodScoreDashboard {
  const factory _MoodScoreDashboard({
    required final DateTime dateTime,
    required final List<String> insights,
  }) = _$MoodScoreDashboardImpl;

  factory _MoodScoreDashboard.fromJson(Map<String, dynamic> json) =
      _$MoodScoreDashboardImpl.fromJson;

  @override
  DateTime get dateTime;
  @override
  List<String> get insights;

  /// Create a copy of MoodScoreDashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MoodScoreDashboardImplCopyWith<_$MoodScoreDashboardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StressLevelDashboard _$StressLevelDashboardFromJson(Map<String, dynamic> json) {
  return _StressLevelDashboard.fromJson(json);
}

/// @nodoc
mixin _$StressLevelDashboard {
  DateTime get dateTime => throw _privateConstructorUsedError;
  List<String> get insights => throw _privateConstructorUsedError;

  /// Serializes this StressLevelDashboard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StressLevelDashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StressLevelDashboardCopyWith<StressLevelDashboard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StressLevelDashboardCopyWith<$Res> {
  factory $StressLevelDashboardCopyWith(
    StressLevelDashboard value,
    $Res Function(StressLevelDashboard) then,
  ) = _$StressLevelDashboardCopyWithImpl<$Res, StressLevelDashboard>;
  @useResult
  $Res call({DateTime dateTime, List<String> insights});
}

/// @nodoc
class _$StressLevelDashboardCopyWithImpl<
  $Res,
  $Val extends StressLevelDashboard
>
    implements $StressLevelDashboardCopyWith<$Res> {
  _$StressLevelDashboardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StressLevelDashboard
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
abstract class _$$StressLevelDashboardImplCopyWith<$Res>
    implements $StressLevelDashboardCopyWith<$Res> {
  factory _$$StressLevelDashboardImplCopyWith(
    _$StressLevelDashboardImpl value,
    $Res Function(_$StressLevelDashboardImpl) then,
  ) = __$$StressLevelDashboardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime dateTime, List<String> insights});
}

/// @nodoc
class __$$StressLevelDashboardImplCopyWithImpl<$Res>
    extends _$StressLevelDashboardCopyWithImpl<$Res, _$StressLevelDashboardImpl>
    implements _$$StressLevelDashboardImplCopyWith<$Res> {
  __$$StressLevelDashboardImplCopyWithImpl(
    _$StressLevelDashboardImpl _value,
    $Res Function(_$StressLevelDashboardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StressLevelDashboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? dateTime = null, Object? insights = null}) {
    return _then(
      _$StressLevelDashboardImpl(
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
class _$StressLevelDashboardImpl implements _StressLevelDashboard {
  const _$StressLevelDashboardImpl({
    required this.dateTime,
    required final List<String> insights,
  }) : _insights = insights;

  factory _$StressLevelDashboardImpl.fromJson(Map<String, dynamic> json) =>
      _$$StressLevelDashboardImplFromJson(json);

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
    return 'StressLevelDashboard(dateTime: $dateTime, insights: $insights)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StressLevelDashboardImpl &&
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

  /// Create a copy of StressLevelDashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StressLevelDashboardImplCopyWith<_$StressLevelDashboardImpl>
  get copyWith =>
      __$$StressLevelDashboardImplCopyWithImpl<_$StressLevelDashboardImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$StressLevelDashboardImplToJson(this);
  }
}

abstract class _StressLevelDashboard implements StressLevelDashboard {
  const factory _StressLevelDashboard({
    required final DateTime dateTime,
    required final List<String> insights,
  }) = _$StressLevelDashboardImpl;

  factory _StressLevelDashboard.fromJson(Map<String, dynamic> json) =
      _$StressLevelDashboardImpl.fromJson;

  @override
  DateTime get dateTime;
  @override
  List<String> get insights;

  /// Create a copy of StressLevelDashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StressLevelDashboardImplCopyWith<_$StressLevelDashboardImpl>
  get copyWith => throw _privateConstructorUsedError;
}

EnergyLevelDashboard _$EnergyLevelDashboardFromJson(Map<String, dynamic> json) {
  return _EnergyLevelDashboard.fromJson(json);
}

/// @nodoc
mixin _$EnergyLevelDashboard {
  DateTime get dateTime => throw _privateConstructorUsedError;
  List<String> get insights => throw _privateConstructorUsedError;

  /// Serializes this EnergyLevelDashboard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EnergyLevelDashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EnergyLevelDashboardCopyWith<EnergyLevelDashboard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnergyLevelDashboardCopyWith<$Res> {
  factory $EnergyLevelDashboardCopyWith(
    EnergyLevelDashboard value,
    $Res Function(EnergyLevelDashboard) then,
  ) = _$EnergyLevelDashboardCopyWithImpl<$Res, EnergyLevelDashboard>;
  @useResult
  $Res call({DateTime dateTime, List<String> insights});
}

/// @nodoc
class _$EnergyLevelDashboardCopyWithImpl<
  $Res,
  $Val extends EnergyLevelDashboard
>
    implements $EnergyLevelDashboardCopyWith<$Res> {
  _$EnergyLevelDashboardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EnergyLevelDashboard
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
abstract class _$$EnergyLevelDashboardImplCopyWith<$Res>
    implements $EnergyLevelDashboardCopyWith<$Res> {
  factory _$$EnergyLevelDashboardImplCopyWith(
    _$EnergyLevelDashboardImpl value,
    $Res Function(_$EnergyLevelDashboardImpl) then,
  ) = __$$EnergyLevelDashboardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime dateTime, List<String> insights});
}

/// @nodoc
class __$$EnergyLevelDashboardImplCopyWithImpl<$Res>
    extends _$EnergyLevelDashboardCopyWithImpl<$Res, _$EnergyLevelDashboardImpl>
    implements _$$EnergyLevelDashboardImplCopyWith<$Res> {
  __$$EnergyLevelDashboardImplCopyWithImpl(
    _$EnergyLevelDashboardImpl _value,
    $Res Function(_$EnergyLevelDashboardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of EnergyLevelDashboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? dateTime = null, Object? insights = null}) {
    return _then(
      _$EnergyLevelDashboardImpl(
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
class _$EnergyLevelDashboardImpl implements _EnergyLevelDashboard {
  const _$EnergyLevelDashboardImpl({
    required this.dateTime,
    required final List<String> insights,
  }) : _insights = insights;

  factory _$EnergyLevelDashboardImpl.fromJson(Map<String, dynamic> json) =>
      _$$EnergyLevelDashboardImplFromJson(json);

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
    return 'EnergyLevelDashboard(dateTime: $dateTime, insights: $insights)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EnergyLevelDashboardImpl &&
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

  /// Create a copy of EnergyLevelDashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EnergyLevelDashboardImplCopyWith<_$EnergyLevelDashboardImpl>
  get copyWith =>
      __$$EnergyLevelDashboardImplCopyWithImpl<_$EnergyLevelDashboardImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$EnergyLevelDashboardImplToJson(this);
  }
}

abstract class _EnergyLevelDashboard implements EnergyLevelDashboard {
  const factory _EnergyLevelDashboard({
    required final DateTime dateTime,
    required final List<String> insights,
  }) = _$EnergyLevelDashboardImpl;

  factory _EnergyLevelDashboard.fromJson(Map<String, dynamic> json) =
      _$EnergyLevelDashboardImpl.fromJson;

  @override
  DateTime get dateTime;
  @override
  List<String> get insights;

  /// Create a copy of EnergyLevelDashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EnergyLevelDashboardImplCopyWith<_$EnergyLevelDashboardImpl>
  get copyWith => throw _privateConstructorUsedError;
}

MoodTrackingDashboard _$MoodTrackingDashboardFromJson(
  Map<String, dynamic> json,
) {
  return _MoodTrackingDashboard.fromJson(json);
}

/// @nodoc
mixin _$MoodTrackingDashboard {
  DateTime get dateTime => throw _privateConstructorUsedError;
  List<String> get insights => throw _privateConstructorUsedError;

  /// Serializes this MoodTrackingDashboard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MoodTrackingDashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MoodTrackingDashboardCopyWith<MoodTrackingDashboard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoodTrackingDashboardCopyWith<$Res> {
  factory $MoodTrackingDashboardCopyWith(
    MoodTrackingDashboard value,
    $Res Function(MoodTrackingDashboard) then,
  ) = _$MoodTrackingDashboardCopyWithImpl<$Res, MoodTrackingDashboard>;
  @useResult
  $Res call({DateTime dateTime, List<String> insights});
}

/// @nodoc
class _$MoodTrackingDashboardCopyWithImpl<
  $Res,
  $Val extends MoodTrackingDashboard
>
    implements $MoodTrackingDashboardCopyWith<$Res> {
  _$MoodTrackingDashboardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MoodTrackingDashboard
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
abstract class _$$MoodTrackingDashboardImplCopyWith<$Res>
    implements $MoodTrackingDashboardCopyWith<$Res> {
  factory _$$MoodTrackingDashboardImplCopyWith(
    _$MoodTrackingDashboardImpl value,
    $Res Function(_$MoodTrackingDashboardImpl) then,
  ) = __$$MoodTrackingDashboardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime dateTime, List<String> insights});
}

/// @nodoc
class __$$MoodTrackingDashboardImplCopyWithImpl<$Res>
    extends
        _$MoodTrackingDashboardCopyWithImpl<$Res, _$MoodTrackingDashboardImpl>
    implements _$$MoodTrackingDashboardImplCopyWith<$Res> {
  __$$MoodTrackingDashboardImplCopyWithImpl(
    _$MoodTrackingDashboardImpl _value,
    $Res Function(_$MoodTrackingDashboardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MoodTrackingDashboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? dateTime = null, Object? insights = null}) {
    return _then(
      _$MoodTrackingDashboardImpl(
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
class _$MoodTrackingDashboardImpl implements _MoodTrackingDashboard {
  const _$MoodTrackingDashboardImpl({
    required this.dateTime,
    required final List<String> insights,
  }) : _insights = insights;

  factory _$MoodTrackingDashboardImpl.fromJson(Map<String, dynamic> json) =>
      _$$MoodTrackingDashboardImplFromJson(json);

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
    return 'MoodTrackingDashboard(dateTime: $dateTime, insights: $insights)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoodTrackingDashboardImpl &&
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

  /// Create a copy of MoodTrackingDashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MoodTrackingDashboardImplCopyWith<_$MoodTrackingDashboardImpl>
  get copyWith =>
      __$$MoodTrackingDashboardImplCopyWithImpl<_$MoodTrackingDashboardImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MoodTrackingDashboardImplToJson(this);
  }
}

abstract class _MoodTrackingDashboard implements MoodTrackingDashboard {
  const factory _MoodTrackingDashboard({
    required final DateTime dateTime,
    required final List<String> insights,
  }) = _$MoodTrackingDashboardImpl;

  factory _MoodTrackingDashboard.fromJson(Map<String, dynamic> json) =
      _$MoodTrackingDashboardImpl.fromJson;

  @override
  DateTime get dateTime;
  @override
  List<String> get insights;

  /// Create a copy of MoodTrackingDashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MoodTrackingDashboardImplCopyWith<_$MoodTrackingDashboardImpl>
  get copyWith => throw _privateConstructorUsedError;
}

AwakeTimeAllocationDashboard _$AwakeTimeAllocationDashboardFromJson(
  Map<String, dynamic> json,
) {
  return _AwakeTimeAllocationDashboard.fromJson(json);
}

/// @nodoc
mixin _$AwakeTimeAllocationDashboard {
  DateTime get dateTime => throw _privateConstructorUsedError;
  List<String> get insights => throw _privateConstructorUsedError;

  /// Serializes this AwakeTimeAllocationDashboard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AwakeTimeAllocationDashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AwakeTimeAllocationDashboardCopyWith<AwakeTimeAllocationDashboard>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AwakeTimeAllocationDashboardCopyWith<$Res> {
  factory $AwakeTimeAllocationDashboardCopyWith(
    AwakeTimeAllocationDashboard value,
    $Res Function(AwakeTimeAllocationDashboard) then,
  ) =
      _$AwakeTimeAllocationDashboardCopyWithImpl<
        $Res,
        AwakeTimeAllocationDashboard
      >;
  @useResult
  $Res call({DateTime dateTime, List<String> insights});
}

/// @nodoc
class _$AwakeTimeAllocationDashboardCopyWithImpl<
  $Res,
  $Val extends AwakeTimeAllocationDashboard
>
    implements $AwakeTimeAllocationDashboardCopyWith<$Res> {
  _$AwakeTimeAllocationDashboardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AwakeTimeAllocationDashboard
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
abstract class _$$AwakeTimeAllocationDashboardImplCopyWith<$Res>
    implements $AwakeTimeAllocationDashboardCopyWith<$Res> {
  factory _$$AwakeTimeAllocationDashboardImplCopyWith(
    _$AwakeTimeAllocationDashboardImpl value,
    $Res Function(_$AwakeTimeAllocationDashboardImpl) then,
  ) = __$$AwakeTimeAllocationDashboardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime dateTime, List<String> insights});
}

/// @nodoc
class __$$AwakeTimeAllocationDashboardImplCopyWithImpl<$Res>
    extends
        _$AwakeTimeAllocationDashboardCopyWithImpl<
          $Res,
          _$AwakeTimeAllocationDashboardImpl
        >
    implements _$$AwakeTimeAllocationDashboardImplCopyWith<$Res> {
  __$$AwakeTimeAllocationDashboardImplCopyWithImpl(
    _$AwakeTimeAllocationDashboardImpl _value,
    $Res Function(_$AwakeTimeAllocationDashboardImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AwakeTimeAllocationDashboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? dateTime = null, Object? insights = null}) {
    return _then(
      _$AwakeTimeAllocationDashboardImpl(
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
class _$AwakeTimeAllocationDashboardImpl
    implements _AwakeTimeAllocationDashboard {
  const _$AwakeTimeAllocationDashboardImpl({
    required this.dateTime,
    required final List<String> insights,
  }) : _insights = insights;

  factory _$AwakeTimeAllocationDashboardImpl.fromJson(
    Map<String, dynamic> json,
  ) => _$$AwakeTimeAllocationDashboardImplFromJson(json);

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
    return 'AwakeTimeAllocationDashboard(dateTime: $dateTime, insights: $insights)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AwakeTimeAllocationDashboardImpl &&
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

  /// Create a copy of AwakeTimeAllocationDashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AwakeTimeAllocationDashboardImplCopyWith<
    _$AwakeTimeAllocationDashboardImpl
  >
  get copyWith => __$$AwakeTimeAllocationDashboardImplCopyWithImpl<
    _$AwakeTimeAllocationDashboardImpl
  >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AwakeTimeAllocationDashboardImplToJson(this);
  }
}

abstract class _AwakeTimeAllocationDashboard
    implements AwakeTimeAllocationDashboard {
  const factory _AwakeTimeAllocationDashboard({
    required final DateTime dateTime,
    required final List<String> insights,
  }) = _$AwakeTimeAllocationDashboardImpl;

  factory _AwakeTimeAllocationDashboard.fromJson(Map<String, dynamic> json) =
      _$AwakeTimeAllocationDashboardImpl.fromJson;

  @override
  DateTime get dateTime;
  @override
  List<String> get insights;

  /// Create a copy of AwakeTimeAllocationDashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AwakeTimeAllocationDashboardImplCopyWith<
    _$AwakeTimeAllocationDashboardImpl
  >
  get copyWith => throw _privateConstructorUsedError;
}
