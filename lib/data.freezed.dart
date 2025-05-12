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

Quote _$QuoteFromJson(Map<String, dynamic> json) {
  return _Quote.fromJson(json);
}

/// @nodoc
mixin _$Quote {
  String get text => throw _privateConstructorUsedError;

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
  $Res call({String text});
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
  $Res call({Object? text = null}) {
    return _then(
      _value.copyWith(
            text:
                null == text
                    ? _value.text
                    : text // ignore: cast_nullable_to_non_nullable
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
  $Res call({String text});
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
  $Res call({Object? text = null}) {
    return _then(
      _$QuoteImpl(
        text:
            null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$QuoteImpl implements _Quote {
  const _$QuoteImpl({required this.text});

  factory _$QuoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuoteImplFromJson(json);

  @override
  final String text;

  @override
  String toString() {
    return 'Quote(text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuoteImpl &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, text);

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
  const factory _Quote({required final String text}) = _$QuoteImpl;

  factory _Quote.fromJson(Map<String, dynamic> json) = _$QuoteImpl.fromJson;

  @override
  String get text;

  /// Create a copy of Quote
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuoteImplCopyWith<_$QuoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Diary _$DiaryFromJson(Map<String, dynamic> json) {
  return _Diary.fromJson(json);
}

/// @nodoc
mixin _$Diary {
  String get time => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get summary => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;

  /// Serializes this Diary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Diary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiaryCopyWith<Diary> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiaryCopyWith<$Res> {
  factory $DiaryCopyWith(Diary value, $Res Function(Diary) then) =
      _$DiaryCopyWithImpl<$Res, Diary>;
  @useResult
  $Res call({
    String time,
    String title,
    String summary,
    String content,
    List<String> tags,
    String location,
  });
}

/// @nodoc
class _$DiaryCopyWithImpl<$Res, $Val extends Diary>
    implements $DiaryCopyWith<$Res> {
  _$DiaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Diary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
    Object? title = null,
    Object? summary = null,
    Object? content = null,
    Object? tags = null,
    Object? location = null,
  }) {
    return _then(
      _value.copyWith(
            time:
                null == time
                    ? _value.time
                    : time // ignore: cast_nullable_to_non_nullable
                        as String,
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
                        as List<String>,
            location:
                null == location
                    ? _value.location
                    : location // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DiaryImplCopyWith<$Res> implements $DiaryCopyWith<$Res> {
  factory _$$DiaryImplCopyWith(
    _$DiaryImpl value,
    $Res Function(_$DiaryImpl) then,
  ) = __$$DiaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String time,
    String title,
    String summary,
    String content,
    List<String> tags,
    String location,
  });
}

/// @nodoc
class __$$DiaryImplCopyWithImpl<$Res>
    extends _$DiaryCopyWithImpl<$Res, _$DiaryImpl>
    implements _$$DiaryImplCopyWith<$Res> {
  __$$DiaryImplCopyWithImpl(
    _$DiaryImpl _value,
    $Res Function(_$DiaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Diary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? time = null,
    Object? title = null,
    Object? summary = null,
    Object? content = null,
    Object? tags = null,
    Object? location = null,
  }) {
    return _then(
      _$DiaryImpl(
        time:
            null == time
                ? _value.time
                : time // ignore: cast_nullable_to_non_nullable
                    as String,
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
                    as List<String>,
        location:
            null == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DiaryImpl implements _Diary {
  const _$DiaryImpl({
    required this.time,
    required this.title,
    required this.summary,
    required this.content,
    required final List<String> tags,
    required this.location,
  }) : _tags = tags;

  factory _$DiaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiaryImplFromJson(json);

  @override
  final String time;
  @override
  final String title;
  @override
  final String summary;
  @override
  final String content;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final String location;

  @override
  String toString() {
    return 'Diary(time: $time, title: $title, summary: $summary, content: $content, tags: $tags, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiaryImpl &&
            (identical(other.time, time) || other.time == time) &&
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
    time,
    title,
    summary,
    content,
    const DeepCollectionEquality().hash(_tags),
    location,
  );

  /// Create a copy of Diary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiaryImplCopyWith<_$DiaryImpl> get copyWith =>
      __$$DiaryImplCopyWithImpl<_$DiaryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DiaryImplToJson(this);
  }
}

abstract class _Diary implements Diary {
  const factory _Diary({
    required final String time,
    required final String title,
    required final String summary,
    required final String content,
    required final List<String> tags,
    required final String location,
  }) = _$DiaryImpl;

  factory _Diary.fromJson(Map<String, dynamic> json) = _$DiaryImpl.fromJson;

  @override
  String get time;
  @override
  String get title;
  @override
  String get summary;
  @override
  String get content;
  @override
  List<String> get tags;
  @override
  String get location;

  /// Create a copy of Diary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiaryImplCopyWith<_$DiaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Reflection _$ReflectionFromJson(Map<String, dynamic> json) {
  return _Reflection.fromJson(json);
}

/// @nodoc
mixin _$Reflection {
  String get title => throw _privateConstructorUsedError;
  List<String> get items => throw _privateConstructorUsedError;

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
  $Res call({String title, List<String> items});
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
  $Res call({Object? title = null, Object? items = null}) {
    return _then(
      _value.copyWith(
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
  $Res call({String title, List<String> items});
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
  $Res call({Object? title = null, Object? items = null}) {
    return _then(
      _$ReflectionImpl(
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReflectionImpl implements _Reflection {
  const _$ReflectionImpl({
    required this.title,
    required final List<String> items,
  }) : _items = items;

  factory _$ReflectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReflectionImplFromJson(json);

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
  String toString() {
    return 'Reflection(title: $title, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReflectionImpl &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    title,
    const DeepCollectionEquality().hash(_items),
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
    required final String title,
    required final List<String> items,
  }) = _$ReflectionImpl;

  factory _Reflection.fromJson(Map<String, dynamic> json) =
      _$ReflectionImpl.fromJson;

  @override
  String get title;
  @override
  List<String> get items;

  /// Create a copy of Reflection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReflectionImplCopyWith<_$ReflectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Score _$ScoreFromJson(Map<String, dynamic> json) {
  return _Score.fromJson(json);
}

/// @nodoc
mixin _$Score {
  String get title => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  double get change => throw _privateConstructorUsedError;

  /// Serializes this Score to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Score
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScoreCopyWith<Score> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScoreCopyWith<$Res> {
  factory $ScoreCopyWith(Score value, $Res Function(Score) then) =
      _$ScoreCopyWithImpl<$Res, Score>;
  @useResult
  $Res call({String title, double value, double change});
}

/// @nodoc
class _$ScoreCopyWithImpl<$Res, $Val extends Score>
    implements $ScoreCopyWith<$Res> {
  _$ScoreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Score
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? value = null,
    Object? change = null,
  }) {
    return _then(
      _value.copyWith(
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
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
abstract class _$$ScoreImplCopyWith<$Res> implements $ScoreCopyWith<$Res> {
  factory _$$ScoreImplCopyWith(
    _$ScoreImpl value,
    $Res Function(_$ScoreImpl) then,
  ) = __$$ScoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, double value, double change});
}

/// @nodoc
class __$$ScoreImplCopyWithImpl<$Res>
    extends _$ScoreCopyWithImpl<$Res, _$ScoreImpl>
    implements _$$ScoreImplCopyWith<$Res> {
  __$$ScoreImplCopyWithImpl(
    _$ScoreImpl _value,
    $Res Function(_$ScoreImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Score
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? value = null,
    Object? change = null,
  }) {
    return _then(
      _$ScoreImpl(
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
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
class _$ScoreImpl implements _Score {
  const _$ScoreImpl({
    required this.title,
    required this.value,
    required this.change,
  });

  factory _$ScoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScoreImplFromJson(json);

  @override
  final String title;
  @override
  final double value;
  @override
  final double change;

  @override
  String toString() {
    return 'Score(title: $title, value: $value, change: $change)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScoreImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.change, change) || other.change == change));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, value, change);

  /// Create a copy of Score
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScoreImplCopyWith<_$ScoreImpl> get copyWith =>
      __$$ScoreImplCopyWithImpl<_$ScoreImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScoreImplToJson(this);
  }
}

abstract class _Score implements Score {
  const factory _Score({
    required final String title,
    required final double value,
    required final double change,
  }) = _$ScoreImpl;

  factory _Score.fromJson(Map<String, dynamic> json) = _$ScoreImpl.fromJson;

  @override
  String get title;
  @override
  double get value;
  @override
  double get change;

  /// Create a copy of Score
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScoreImplCopyWith<_$ScoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Highlight _$HighlightFromJson(Map<String, dynamic> json) {
  return _Highlight.fromJson(json);
}

/// @nodoc
mixin _$Highlight {
  String get title => throw _privateConstructorUsedError;
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
  $Res call({String title, String content, int color});
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
    Object? title = null,
    Object? content = null,
    Object? color = null,
  }) {
    return _then(
      _value.copyWith(
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
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
  $Res call({String title, String content, int color});
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
    Object? title = null,
    Object? content = null,
    Object? color = null,
  }) {
    return _then(
      _$HighlightImpl(
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
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
    required this.title,
    required this.content,
    this.color = 0xFF00FF00,
  });

  factory _$HighlightImpl.fromJson(Map<String, dynamic> json) =>
      _$$HighlightImplFromJson(json);

  @override
  final String title;
  @override
  final String content;
  @override
  @JsonKey()
  final int color;

  @override
  String toString() {
    return 'Highlight(title: $title, content: $content, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HighlightImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, content, color);

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
    required final String title,
    required final String content,
    final int color,
  }) = _$HighlightImpl;

  factory _Highlight.fromJson(Map<String, dynamic> json) =
      _$HighlightImpl.fromJson;

  @override
  String get title;
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

TodoList _$TodoListFromJson(Map<String, dynamic> json) {
  return _TodoList.fromJson(json);
}

/// @nodoc
mixin _$TodoList {
  List<Task> get tasks => throw _privateConstructorUsedError;

  /// Serializes this TodoList to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TodoList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TodoListCopyWith<TodoList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TodoListCopyWith<$Res> {
  factory $TodoListCopyWith(TodoList value, $Res Function(TodoList) then) =
      _$TodoListCopyWithImpl<$Res, TodoList>;
  @useResult
  $Res call({List<Task> tasks});
}

/// @nodoc
class _$TodoListCopyWithImpl<$Res, $Val extends TodoList>
    implements $TodoListCopyWith<$Res> {
  _$TodoListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TodoList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? tasks = null}) {
    return _then(
      _value.copyWith(
            tasks:
                null == tasks
                    ? _value.tasks
                    : tasks // ignore: cast_nullable_to_non_nullable
                        as List<Task>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TodoListImplCopyWith<$Res>
    implements $TodoListCopyWith<$Res> {
  factory _$$TodoListImplCopyWith(
    _$TodoListImpl value,
    $Res Function(_$TodoListImpl) then,
  ) = __$$TodoListImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Task> tasks});
}

/// @nodoc
class __$$TodoListImplCopyWithImpl<$Res>
    extends _$TodoListCopyWithImpl<$Res, _$TodoListImpl>
    implements _$$TodoListImplCopyWith<$Res> {
  __$$TodoListImplCopyWithImpl(
    _$TodoListImpl _value,
    $Res Function(_$TodoListImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TodoList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? tasks = null}) {
    return _then(
      _$TodoListImpl(
        tasks:
            null == tasks
                ? _value._tasks
                : tasks // ignore: cast_nullable_to_non_nullable
                    as List<Task>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TodoListImpl implements _TodoList {
  const _$TodoListImpl({required final List<Task> tasks}) : _tasks = tasks;

  factory _$TodoListImpl.fromJson(Map<String, dynamic> json) =>
      _$$TodoListImplFromJson(json);

  final List<Task> _tasks;
  @override
  List<Task> get tasks {
    if (_tasks is EqualUnmodifiableListView) return _tasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tasks);
  }

  @override
  String toString() {
    return 'TodoList(tasks: $tasks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TodoListImpl &&
            const DeepCollectionEquality().equals(other._tasks, _tasks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_tasks));

  /// Create a copy of TodoList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TodoListImplCopyWith<_$TodoListImpl> get copyWith =>
      __$$TodoListImplCopyWithImpl<_$TodoListImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TodoListImplToJson(this);
  }
}

abstract class _TodoList implements TodoList {
  const factory _TodoList({required final List<Task> tasks}) = _$TodoListImpl;

  factory _TodoList.fromJson(Map<String, dynamic> json) =
      _$TodoListImpl.fromJson;

  @override
  List<Task> get tasks;

  /// Create a copy of TodoList
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TodoListImplCopyWith<_$TodoListImpl> get copyWith =>
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
