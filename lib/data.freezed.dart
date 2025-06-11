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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get username => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;

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
  $Res call({String username, String password, String displayName});
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
  $Res call({
    Object? username = null,
    Object? password = null,
    Object? displayName = null,
  }) {
    return _then(_value.copyWith(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String username, String password, String displayName});
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
  $Res call({
    Object? username = null,
    Object? password = null,
    Object? displayName = null,
  }) {
    return _then(_$UserImpl(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  const _$UserImpl(
      {required this.username,
      required this.password,
      required this.displayName});

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String username;
  @override
  final String password;
  @override
  final String displayName;

  @override
  String toString() {
    return 'User(username: $username, password: $password, displayName: $displayName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, username, password, displayName);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User implements User {
  const factory _User(
      {required final String username,
      required final String password,
      required final String displayName}) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get username;
  @override
  String get password;
  @override
  String get displayName;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

EventAnalysis _$EventAnalysisFromJson(Map<String, dynamic> json) {
  return _EventAnalysis.fromJson(json);
}

/// @nodoc
mixin _$EventAnalysis {
  String get event_id => throw _privateConstructorUsedError;
  String get event_title => throw _privateConstructorUsedError;
  String get time_range => throw _privateConstructorUsedError;
  int get duration_minutes => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  List<String> get mood_labels => throw _privateConstructorUsedError;
  int get mood_score => throw _privateConstructorUsedError;
  int get stress_level => throw _privateConstructorUsedError;
  int get energy_level => throw _privateConstructorUsedError;
  String get activity_type => throw _privateConstructorUsedError;
  List<String> get people_involved => throw _privateConstructorUsedError;
  String get interaction_dynamic => throw _privateConstructorUsedError;
  String get inferred_impact_on_user_name => throw _privateConstructorUsedError;
  List<String> get topic_labels => throw _privateConstructorUsedError;
  String get one_sentence_summary => throw _privateConstructorUsedError;
  String get first_person_narrative => throw _privateConstructorUsedError;
  String get action_item => throw _privateConstructorUsedError;

  /// Serializes this EventAnalysis to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of EventAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EventAnalysisCopyWith<EventAnalysis> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventAnalysisCopyWith<$Res> {
  factory $EventAnalysisCopyWith(
          EventAnalysis value, $Res Function(EventAnalysis) then) =
      _$EventAnalysisCopyWithImpl<$Res, EventAnalysis>;
  @useResult
  $Res call(
      {String event_id,
      String event_title,
      String time_range,
      int duration_minutes,
      String location,
      List<String> mood_labels,
      int mood_score,
      int stress_level,
      int energy_level,
      String activity_type,
      List<String> people_involved,
      String interaction_dynamic,
      String inferred_impact_on_user_name,
      List<String> topic_labels,
      String one_sentence_summary,
      String first_person_narrative,
      String action_item});
}

/// @nodoc
class _$EventAnalysisCopyWithImpl<$Res, $Val extends EventAnalysis>
    implements $EventAnalysisCopyWith<$Res> {
  _$EventAnalysisCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of EventAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event_id = null,
    Object? event_title = null,
    Object? time_range = null,
    Object? duration_minutes = null,
    Object? location = null,
    Object? mood_labels = null,
    Object? mood_score = null,
    Object? stress_level = null,
    Object? energy_level = null,
    Object? activity_type = null,
    Object? people_involved = null,
    Object? interaction_dynamic = null,
    Object? inferred_impact_on_user_name = null,
    Object? topic_labels = null,
    Object? one_sentence_summary = null,
    Object? first_person_narrative = null,
    Object? action_item = null,
  }) {
    return _then(_value.copyWith(
      event_id: null == event_id
          ? _value.event_id
          : event_id // ignore: cast_nullable_to_non_nullable
              as String,
      event_title: null == event_title
          ? _value.event_title
          : event_title // ignore: cast_nullable_to_non_nullable
              as String,
      time_range: null == time_range
          ? _value.time_range
          : time_range // ignore: cast_nullable_to_non_nullable
              as String,
      duration_minutes: null == duration_minutes
          ? _value.duration_minutes
          : duration_minutes // ignore: cast_nullable_to_non_nullable
              as int,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      mood_labels: null == mood_labels
          ? _value.mood_labels
          : mood_labels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      mood_score: null == mood_score
          ? _value.mood_score
          : mood_score // ignore: cast_nullable_to_non_nullable
              as int,
      stress_level: null == stress_level
          ? _value.stress_level
          : stress_level // ignore: cast_nullable_to_non_nullable
              as int,
      energy_level: null == energy_level
          ? _value.energy_level
          : energy_level // ignore: cast_nullable_to_non_nullable
              as int,
      activity_type: null == activity_type
          ? _value.activity_type
          : activity_type // ignore: cast_nullable_to_non_nullable
              as String,
      people_involved: null == people_involved
          ? _value.people_involved
          : people_involved // ignore: cast_nullable_to_non_nullable
              as List<String>,
      interaction_dynamic: null == interaction_dynamic
          ? _value.interaction_dynamic
          : interaction_dynamic // ignore: cast_nullable_to_non_nullable
              as String,
      inferred_impact_on_user_name: null == inferred_impact_on_user_name
          ? _value.inferred_impact_on_user_name
          : inferred_impact_on_user_name // ignore: cast_nullable_to_non_nullable
              as String,
      topic_labels: null == topic_labels
          ? _value.topic_labels
          : topic_labels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      one_sentence_summary: null == one_sentence_summary
          ? _value.one_sentence_summary
          : one_sentence_summary // ignore: cast_nullable_to_non_nullable
              as String,
      first_person_narrative: null == first_person_narrative
          ? _value.first_person_narrative
          : first_person_narrative // ignore: cast_nullable_to_non_nullable
              as String,
      action_item: null == action_item
          ? _value.action_item
          : action_item // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EventAnalysisImplCopyWith<$Res>
    implements $EventAnalysisCopyWith<$Res> {
  factory _$$EventAnalysisImplCopyWith(
          _$EventAnalysisImpl value, $Res Function(_$EventAnalysisImpl) then) =
      __$$EventAnalysisImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String event_id,
      String event_title,
      String time_range,
      int duration_minutes,
      String location,
      List<String> mood_labels,
      int mood_score,
      int stress_level,
      int energy_level,
      String activity_type,
      List<String> people_involved,
      String interaction_dynamic,
      String inferred_impact_on_user_name,
      List<String> topic_labels,
      String one_sentence_summary,
      String first_person_narrative,
      String action_item});
}

/// @nodoc
class __$$EventAnalysisImplCopyWithImpl<$Res>
    extends _$EventAnalysisCopyWithImpl<$Res, _$EventAnalysisImpl>
    implements _$$EventAnalysisImplCopyWith<$Res> {
  __$$EventAnalysisImplCopyWithImpl(
      _$EventAnalysisImpl _value, $Res Function(_$EventAnalysisImpl) _then)
      : super(_value, _then);

  /// Create a copy of EventAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? event_id = null,
    Object? event_title = null,
    Object? time_range = null,
    Object? duration_minutes = null,
    Object? location = null,
    Object? mood_labels = null,
    Object? mood_score = null,
    Object? stress_level = null,
    Object? energy_level = null,
    Object? activity_type = null,
    Object? people_involved = null,
    Object? interaction_dynamic = null,
    Object? inferred_impact_on_user_name = null,
    Object? topic_labels = null,
    Object? one_sentence_summary = null,
    Object? first_person_narrative = null,
    Object? action_item = null,
  }) {
    return _then(_$EventAnalysisImpl(
      event_id: null == event_id
          ? _value.event_id
          : event_id // ignore: cast_nullable_to_non_nullable
              as String,
      event_title: null == event_title
          ? _value.event_title
          : event_title // ignore: cast_nullable_to_non_nullable
              as String,
      time_range: null == time_range
          ? _value.time_range
          : time_range // ignore: cast_nullable_to_non_nullable
              as String,
      duration_minutes: null == duration_minutes
          ? _value.duration_minutes
          : duration_minutes // ignore: cast_nullable_to_non_nullable
              as int,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      mood_labels: null == mood_labels
          ? _value._mood_labels
          : mood_labels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      mood_score: null == mood_score
          ? _value.mood_score
          : mood_score // ignore: cast_nullable_to_non_nullable
              as int,
      stress_level: null == stress_level
          ? _value.stress_level
          : stress_level // ignore: cast_nullable_to_non_nullable
              as int,
      energy_level: null == energy_level
          ? _value.energy_level
          : energy_level // ignore: cast_nullable_to_non_nullable
              as int,
      activity_type: null == activity_type
          ? _value.activity_type
          : activity_type // ignore: cast_nullable_to_non_nullable
              as String,
      people_involved: null == people_involved
          ? _value._people_involved
          : people_involved // ignore: cast_nullable_to_non_nullable
              as List<String>,
      interaction_dynamic: null == interaction_dynamic
          ? _value.interaction_dynamic
          : interaction_dynamic // ignore: cast_nullable_to_non_nullable
              as String,
      inferred_impact_on_user_name: null == inferred_impact_on_user_name
          ? _value.inferred_impact_on_user_name
          : inferred_impact_on_user_name // ignore: cast_nullable_to_non_nullable
              as String,
      topic_labels: null == topic_labels
          ? _value._topic_labels
          : topic_labels // ignore: cast_nullable_to_non_nullable
              as List<String>,
      one_sentence_summary: null == one_sentence_summary
          ? _value.one_sentence_summary
          : one_sentence_summary // ignore: cast_nullable_to_non_nullable
              as String,
      first_person_narrative: null == first_person_narrative
          ? _value.first_person_narrative
          : first_person_narrative // ignore: cast_nullable_to_non_nullable
              as String,
      action_item: null == action_item
          ? _value.action_item
          : action_item // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EventAnalysisImpl implements _EventAnalysis {
  const _$EventAnalysisImpl(
      {required this.event_id,
      required this.event_title,
      required this.time_range,
      required this.duration_minutes,
      required this.location,
      required final List<String> mood_labels,
      required this.mood_score,
      required this.stress_level,
      required this.energy_level,
      required this.activity_type,
      required final List<String> people_involved,
      required this.interaction_dynamic,
      required this.inferred_impact_on_user_name,
      required final List<String> topic_labels,
      required this.one_sentence_summary,
      required this.first_person_narrative,
      required this.action_item})
      : _mood_labels = mood_labels,
        _people_involved = people_involved,
        _topic_labels = topic_labels;

  factory _$EventAnalysisImpl.fromJson(Map<String, dynamic> json) =>
      _$$EventAnalysisImplFromJson(json);

  @override
  final String event_id;
  @override
  final String event_title;
  @override
  final String time_range;
  @override
  final int duration_minutes;
  @override
  final String location;
  final List<String> _mood_labels;
  @override
  List<String> get mood_labels {
    if (_mood_labels is EqualUnmodifiableListView) return _mood_labels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mood_labels);
  }

  @override
  final int mood_score;
  @override
  final int stress_level;
  @override
  final int energy_level;
  @override
  final String activity_type;
  final List<String> _people_involved;
  @override
  List<String> get people_involved {
    if (_people_involved is EqualUnmodifiableListView) return _people_involved;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_people_involved);
  }

  @override
  final String interaction_dynamic;
  @override
  final String inferred_impact_on_user_name;
  final List<String> _topic_labels;
  @override
  List<String> get topic_labels {
    if (_topic_labels is EqualUnmodifiableListView) return _topic_labels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topic_labels);
  }

  @override
  final String one_sentence_summary;
  @override
  final String first_person_narrative;
  @override
  final String action_item;

  @override
  String toString() {
    return 'EventAnalysis(event_id: $event_id, event_title: $event_title, time_range: $time_range, duration_minutes: $duration_minutes, location: $location, mood_labels: $mood_labels, mood_score: $mood_score, stress_level: $stress_level, energy_level: $energy_level, activity_type: $activity_type, people_involved: $people_involved, interaction_dynamic: $interaction_dynamic, inferred_impact_on_user_name: $inferred_impact_on_user_name, topic_labels: $topic_labels, one_sentence_summary: $one_sentence_summary, first_person_narrative: $first_person_narrative, action_item: $action_item)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EventAnalysisImpl &&
            (identical(other.event_id, event_id) ||
                other.event_id == event_id) &&
            (identical(other.event_title, event_title) ||
                other.event_title == event_title) &&
            (identical(other.time_range, time_range) ||
                other.time_range == time_range) &&
            (identical(other.duration_minutes, duration_minutes) ||
                other.duration_minutes == duration_minutes) &&
            (identical(other.location, location) ||
                other.location == location) &&
            const DeepCollectionEquality()
                .equals(other._mood_labels, _mood_labels) &&
            (identical(other.mood_score, mood_score) ||
                other.mood_score == mood_score) &&
            (identical(other.stress_level, stress_level) ||
                other.stress_level == stress_level) &&
            (identical(other.energy_level, energy_level) ||
                other.energy_level == energy_level) &&
            (identical(other.activity_type, activity_type) ||
                other.activity_type == activity_type) &&
            const DeepCollectionEquality()
                .equals(other._people_involved, _people_involved) &&
            (identical(other.interaction_dynamic, interaction_dynamic) ||
                other.interaction_dynamic == interaction_dynamic) &&
            (identical(other.inferred_impact_on_user_name,
                    inferred_impact_on_user_name) ||
                other.inferred_impact_on_user_name ==
                    inferred_impact_on_user_name) &&
            const DeepCollectionEquality()
                .equals(other._topic_labels, _topic_labels) &&
            (identical(other.one_sentence_summary, one_sentence_summary) ||
                other.one_sentence_summary == one_sentence_summary) &&
            (identical(other.first_person_narrative, first_person_narrative) ||
                other.first_person_narrative == first_person_narrative) &&
            (identical(other.action_item, action_item) ||
                other.action_item == action_item));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      event_id,
      event_title,
      time_range,
      duration_minutes,
      location,
      const DeepCollectionEquality().hash(_mood_labels),
      mood_score,
      stress_level,
      energy_level,
      activity_type,
      const DeepCollectionEquality().hash(_people_involved),
      interaction_dynamic,
      inferred_impact_on_user_name,
      const DeepCollectionEquality().hash(_topic_labels),
      one_sentence_summary,
      first_person_narrative,
      action_item);

  /// Create a copy of EventAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EventAnalysisImplCopyWith<_$EventAnalysisImpl> get copyWith =>
      __$$EventAnalysisImplCopyWithImpl<_$EventAnalysisImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EventAnalysisImplToJson(
      this,
    );
  }
}

abstract class _EventAnalysis implements EventAnalysis {
  const factory _EventAnalysis(
      {required final String event_id,
      required final String event_title,
      required final String time_range,
      required final int duration_minutes,
      required final String location,
      required final List<String> mood_labels,
      required final int mood_score,
      required final int stress_level,
      required final int energy_level,
      required final String activity_type,
      required final List<String> people_involved,
      required final String interaction_dynamic,
      required final String inferred_impact_on_user_name,
      required final List<String> topic_labels,
      required final String one_sentence_summary,
      required final String first_person_narrative,
      required final String action_item}) = _$EventAnalysisImpl;

  factory _EventAnalysis.fromJson(Map<String, dynamic> json) =
      _$EventAnalysisImpl.fromJson;

  @override
  String get event_id;
  @override
  String get event_title;
  @override
  String get time_range;
  @override
  int get duration_minutes;
  @override
  String get location;
  @override
  List<String> get mood_labels;
  @override
  int get mood_score;
  @override
  int get stress_level;
  @override
  int get energy_level;
  @override
  String get activity_type;
  @override
  List<String> get people_involved;
  @override
  String get interaction_dynamic;
  @override
  String get inferred_impact_on_user_name;
  @override
  List<String> get topic_labels;
  @override
  String get one_sentence_summary;
  @override
  String get first_person_narrative;
  @override
  String get action_item;

  /// Create a copy of EventAnalysis
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EventAnalysisImplCopyWith<_$EventAnalysisImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Gratitude _$GratitudeFromJson(Map<String, dynamic> json) {
  return _Gratitude.fromJson(json);
}

/// @nodoc
mixin _$Gratitude {
  List<String> get gratitude_summary => throw _privateConstructorUsedError;
  String get gratitude_details => throw _privateConstructorUsedError;
  List<String> get win_summary => throw _privateConstructorUsedError;
  String get win_details => throw _privateConstructorUsedError;
  String get feel_alive_moments => throw _privateConstructorUsedError;

  /// Serializes this Gratitude to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Gratitude
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GratitudeCopyWith<Gratitude> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GratitudeCopyWith<$Res> {
  factory $GratitudeCopyWith(Gratitude value, $Res Function(Gratitude) then) =
      _$GratitudeCopyWithImpl<$Res, Gratitude>;
  @useResult
  $Res call(
      {List<String> gratitude_summary,
      String gratitude_details,
      List<String> win_summary,
      String win_details,
      String feel_alive_moments});
}

/// @nodoc
class _$GratitudeCopyWithImpl<$Res, $Val extends Gratitude>
    implements $GratitudeCopyWith<$Res> {
  _$GratitudeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Gratitude
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gratitude_summary = null,
    Object? gratitude_details = null,
    Object? win_summary = null,
    Object? win_details = null,
    Object? feel_alive_moments = null,
  }) {
    return _then(_value.copyWith(
      gratitude_summary: null == gratitude_summary
          ? _value.gratitude_summary
          : gratitude_summary // ignore: cast_nullable_to_non_nullable
              as List<String>,
      gratitude_details: null == gratitude_details
          ? _value.gratitude_details
          : gratitude_details // ignore: cast_nullable_to_non_nullable
              as String,
      win_summary: null == win_summary
          ? _value.win_summary
          : win_summary // ignore: cast_nullable_to_non_nullable
              as List<String>,
      win_details: null == win_details
          ? _value.win_details
          : win_details // ignore: cast_nullable_to_non_nullable
              as String,
      feel_alive_moments: null == feel_alive_moments
          ? _value.feel_alive_moments
          : feel_alive_moments // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GratitudeImplCopyWith<$Res>
    implements $GratitudeCopyWith<$Res> {
  factory _$$GratitudeImplCopyWith(
          _$GratitudeImpl value, $Res Function(_$GratitudeImpl) then) =
      __$$GratitudeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> gratitude_summary,
      String gratitude_details,
      List<String> win_summary,
      String win_details,
      String feel_alive_moments});
}

/// @nodoc
class __$$GratitudeImplCopyWithImpl<$Res>
    extends _$GratitudeCopyWithImpl<$Res, _$GratitudeImpl>
    implements _$$GratitudeImplCopyWith<$Res> {
  __$$GratitudeImplCopyWithImpl(
      _$GratitudeImpl _value, $Res Function(_$GratitudeImpl) _then)
      : super(_value, _then);

  /// Create a copy of Gratitude
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gratitude_summary = null,
    Object? gratitude_details = null,
    Object? win_summary = null,
    Object? win_details = null,
    Object? feel_alive_moments = null,
  }) {
    return _then(_$GratitudeImpl(
      gratitude_summary: null == gratitude_summary
          ? _value._gratitude_summary
          : gratitude_summary // ignore: cast_nullable_to_non_nullable
              as List<String>,
      gratitude_details: null == gratitude_details
          ? _value.gratitude_details
          : gratitude_details // ignore: cast_nullable_to_non_nullable
              as String,
      win_summary: null == win_summary
          ? _value._win_summary
          : win_summary // ignore: cast_nullable_to_non_nullable
              as List<String>,
      win_details: null == win_details
          ? _value.win_details
          : win_details // ignore: cast_nullable_to_non_nullable
              as String,
      feel_alive_moments: null == feel_alive_moments
          ? _value.feel_alive_moments
          : feel_alive_moments // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GratitudeImpl implements _Gratitude {
  const _$GratitudeImpl(
      {required final List<String> gratitude_summary,
      required this.gratitude_details,
      required final List<String> win_summary,
      required this.win_details,
      required this.feel_alive_moments})
      : _gratitude_summary = gratitude_summary,
        _win_summary = win_summary;

  factory _$GratitudeImpl.fromJson(Map<String, dynamic> json) =>
      _$$GratitudeImplFromJson(json);

  final List<String> _gratitude_summary;
  @override
  List<String> get gratitude_summary {
    if (_gratitude_summary is EqualUnmodifiableListView)
      return _gratitude_summary;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_gratitude_summary);
  }

  @override
  final String gratitude_details;
  final List<String> _win_summary;
  @override
  List<String> get win_summary {
    if (_win_summary is EqualUnmodifiableListView) return _win_summary;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_win_summary);
  }

  @override
  final String win_details;
  @override
  final String feel_alive_moments;

  @override
  String toString() {
    return 'Gratitude(gratitude_summary: $gratitude_summary, gratitude_details: $gratitude_details, win_summary: $win_summary, win_details: $win_details, feel_alive_moments: $feel_alive_moments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GratitudeImpl &&
            const DeepCollectionEquality()
                .equals(other._gratitude_summary, _gratitude_summary) &&
            (identical(other.gratitude_details, gratitude_details) ||
                other.gratitude_details == gratitude_details) &&
            const DeepCollectionEquality()
                .equals(other._win_summary, _win_summary) &&
            (identical(other.win_details, win_details) ||
                other.win_details == win_details) &&
            (identical(other.feel_alive_moments, feel_alive_moments) ||
                other.feel_alive_moments == feel_alive_moments));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_gratitude_summary),
      gratitude_details,
      const DeepCollectionEquality().hash(_win_summary),
      win_details,
      feel_alive_moments);

  /// Create a copy of Gratitude
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GratitudeImplCopyWith<_$GratitudeImpl> get copyWith =>
      __$$GratitudeImplCopyWithImpl<_$GratitudeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GratitudeImplToJson(
      this,
    );
  }
}

abstract class _Gratitude implements Gratitude {
  const factory _Gratitude(
      {required final List<String> gratitude_summary,
      required final String gratitude_details,
      required final List<String> win_summary,
      required final String win_details,
      required final String feel_alive_moments}) = _$GratitudeImpl;

  factory _Gratitude.fromJson(Map<String, dynamic> json) =
      _$GratitudeImpl.fromJson;

  @override
  List<String> get gratitude_summary;
  @override
  String get gratitude_details;
  @override
  List<String> get win_summary;
  @override
  String get win_details;
  @override
  String get feel_alive_moments;

  /// Create a copy of Gratitude
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GratitudeImplCopyWith<_$GratitudeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChallengesAndGrowth _$ChallengesAndGrowthFromJson(Map<String, dynamic> json) {
  return _ChallengesAndGrowth.fromJson(json);
}

/// @nodoc
mixin _$ChallengesAndGrowth {
  List<String> get growth_summary => throw _privateConstructorUsedError;
  String get obstacles_faced => throw _privateConstructorUsedError;
  String get unfinished_intentions => throw _privateConstructorUsedError;
  String get contributing_factors => throw _privateConstructorUsedError;

  /// Serializes this ChallengesAndGrowth to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChallengesAndGrowth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChallengesAndGrowthCopyWith<ChallengesAndGrowth> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChallengesAndGrowthCopyWith<$Res> {
  factory $ChallengesAndGrowthCopyWith(
          ChallengesAndGrowth value, $Res Function(ChallengesAndGrowth) then) =
      _$ChallengesAndGrowthCopyWithImpl<$Res, ChallengesAndGrowth>;
  @useResult
  $Res call(
      {List<String> growth_summary,
      String obstacles_faced,
      String unfinished_intentions,
      String contributing_factors});
}

/// @nodoc
class _$ChallengesAndGrowthCopyWithImpl<$Res, $Val extends ChallengesAndGrowth>
    implements $ChallengesAndGrowthCopyWith<$Res> {
  _$ChallengesAndGrowthCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChallengesAndGrowth
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? growth_summary = null,
    Object? obstacles_faced = null,
    Object? unfinished_intentions = null,
    Object? contributing_factors = null,
  }) {
    return _then(_value.copyWith(
      growth_summary: null == growth_summary
          ? _value.growth_summary
          : growth_summary // ignore: cast_nullable_to_non_nullable
              as List<String>,
      obstacles_faced: null == obstacles_faced
          ? _value.obstacles_faced
          : obstacles_faced // ignore: cast_nullable_to_non_nullable
              as String,
      unfinished_intentions: null == unfinished_intentions
          ? _value.unfinished_intentions
          : unfinished_intentions // ignore: cast_nullable_to_non_nullable
              as String,
      contributing_factors: null == contributing_factors
          ? _value.contributing_factors
          : contributing_factors // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChallengesAndGrowthImplCopyWith<$Res>
    implements $ChallengesAndGrowthCopyWith<$Res> {
  factory _$$ChallengesAndGrowthImplCopyWith(_$ChallengesAndGrowthImpl value,
          $Res Function(_$ChallengesAndGrowthImpl) then) =
      __$$ChallengesAndGrowthImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> growth_summary,
      String obstacles_faced,
      String unfinished_intentions,
      String contributing_factors});
}

/// @nodoc
class __$$ChallengesAndGrowthImplCopyWithImpl<$Res>
    extends _$ChallengesAndGrowthCopyWithImpl<$Res, _$ChallengesAndGrowthImpl>
    implements _$$ChallengesAndGrowthImplCopyWith<$Res> {
  __$$ChallengesAndGrowthImplCopyWithImpl(_$ChallengesAndGrowthImpl _value,
      $Res Function(_$ChallengesAndGrowthImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChallengesAndGrowth
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? growth_summary = null,
    Object? obstacles_faced = null,
    Object? unfinished_intentions = null,
    Object? contributing_factors = null,
  }) {
    return _then(_$ChallengesAndGrowthImpl(
      growth_summary: null == growth_summary
          ? _value._growth_summary
          : growth_summary // ignore: cast_nullable_to_non_nullable
              as List<String>,
      obstacles_faced: null == obstacles_faced
          ? _value.obstacles_faced
          : obstacles_faced // ignore: cast_nullable_to_non_nullable
              as String,
      unfinished_intentions: null == unfinished_intentions
          ? _value.unfinished_intentions
          : unfinished_intentions // ignore: cast_nullable_to_non_nullable
              as String,
      contributing_factors: null == contributing_factors
          ? _value.contributing_factors
          : contributing_factors // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChallengesAndGrowthImpl implements _ChallengesAndGrowth {
  const _$ChallengesAndGrowthImpl(
      {required final List<String> growth_summary,
      required this.obstacles_faced,
      required this.unfinished_intentions,
      required this.contributing_factors})
      : _growth_summary = growth_summary;

  factory _$ChallengesAndGrowthImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChallengesAndGrowthImplFromJson(json);

  final List<String> _growth_summary;
  @override
  List<String> get growth_summary {
    if (_growth_summary is EqualUnmodifiableListView) return _growth_summary;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_growth_summary);
  }

  @override
  final String obstacles_faced;
  @override
  final String unfinished_intentions;
  @override
  final String contributing_factors;

  @override
  String toString() {
    return 'ChallengesAndGrowth(growth_summary: $growth_summary, obstacles_faced: $obstacles_faced, unfinished_intentions: $unfinished_intentions, contributing_factors: $contributing_factors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChallengesAndGrowthImpl &&
            const DeepCollectionEquality()
                .equals(other._growth_summary, _growth_summary) &&
            (identical(other.obstacles_faced, obstacles_faced) ||
                other.obstacles_faced == obstacles_faced) &&
            (identical(other.unfinished_intentions, unfinished_intentions) ||
                other.unfinished_intentions == unfinished_intentions) &&
            (identical(other.contributing_factors, contributing_factors) ||
                other.contributing_factors == contributing_factors));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_growth_summary),
      obstacles_faced,
      unfinished_intentions,
      contributing_factors);

  /// Create a copy of ChallengesAndGrowth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChallengesAndGrowthImplCopyWith<_$ChallengesAndGrowthImpl> get copyWith =>
      __$$ChallengesAndGrowthImplCopyWithImpl<_$ChallengesAndGrowthImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChallengesAndGrowthImplToJson(
      this,
    );
  }
}

abstract class _ChallengesAndGrowth implements ChallengesAndGrowth {
  const factory _ChallengesAndGrowth(
      {required final List<String> growth_summary,
      required final String obstacles_faced,
      required final String unfinished_intentions,
      required final String contributing_factors}) = _$ChallengesAndGrowthImpl;

  factory _ChallengesAndGrowth.fromJson(Map<String, dynamic> json) =
      _$ChallengesAndGrowthImpl.fromJson;

  @override
  List<String> get growth_summary;
  @override
  String get obstacles_faced;
  @override
  String get unfinished_intentions;
  @override
  String get contributing_factors;

  /// Create a copy of ChallengesAndGrowth
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChallengesAndGrowthImplCopyWith<_$ChallengesAndGrowthImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LearningAndInsights _$LearningAndInsightsFromJson(Map<String, dynamic> json) {
  return _LearningAndInsights.fromJson(json);
}

/// @nodoc
mixin _$LearningAndInsights {
  String get new_knowledge => throw _privateConstructorUsedError;
  String get self_discovery => throw _privateConstructorUsedError;
  String get insights_about_others => throw _privateConstructorUsedError;
  String get broader_lessons => throw _privateConstructorUsedError;

  /// Serializes this LearningAndInsights to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LearningAndInsights
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LearningAndInsightsCopyWith<LearningAndInsights> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningAndInsightsCopyWith<$Res> {
  factory $LearningAndInsightsCopyWith(
          LearningAndInsights value, $Res Function(LearningAndInsights) then) =
      _$LearningAndInsightsCopyWithImpl<$Res, LearningAndInsights>;
  @useResult
  $Res call(
      {String new_knowledge,
      String self_discovery,
      String insights_about_others,
      String broader_lessons});
}

/// @nodoc
class _$LearningAndInsightsCopyWithImpl<$Res, $Val extends LearningAndInsights>
    implements $LearningAndInsightsCopyWith<$Res> {
  _$LearningAndInsightsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LearningAndInsights
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? new_knowledge = null,
    Object? self_discovery = null,
    Object? insights_about_others = null,
    Object? broader_lessons = null,
  }) {
    return _then(_value.copyWith(
      new_knowledge: null == new_knowledge
          ? _value.new_knowledge
          : new_knowledge // ignore: cast_nullable_to_non_nullable
              as String,
      self_discovery: null == self_discovery
          ? _value.self_discovery
          : self_discovery // ignore: cast_nullable_to_non_nullable
              as String,
      insights_about_others: null == insights_about_others
          ? _value.insights_about_others
          : insights_about_others // ignore: cast_nullable_to_non_nullable
              as String,
      broader_lessons: null == broader_lessons
          ? _value.broader_lessons
          : broader_lessons // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LearningAndInsightsImplCopyWith<$Res>
    implements $LearningAndInsightsCopyWith<$Res> {
  factory _$$LearningAndInsightsImplCopyWith(_$LearningAndInsightsImpl value,
          $Res Function(_$LearningAndInsightsImpl) then) =
      __$$LearningAndInsightsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String new_knowledge,
      String self_discovery,
      String insights_about_others,
      String broader_lessons});
}

/// @nodoc
class __$$LearningAndInsightsImplCopyWithImpl<$Res>
    extends _$LearningAndInsightsCopyWithImpl<$Res, _$LearningAndInsightsImpl>
    implements _$$LearningAndInsightsImplCopyWith<$Res> {
  __$$LearningAndInsightsImplCopyWithImpl(_$LearningAndInsightsImpl _value,
      $Res Function(_$LearningAndInsightsImpl) _then)
      : super(_value, _then);

  /// Create a copy of LearningAndInsights
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? new_knowledge = null,
    Object? self_discovery = null,
    Object? insights_about_others = null,
    Object? broader_lessons = null,
  }) {
    return _then(_$LearningAndInsightsImpl(
      new_knowledge: null == new_knowledge
          ? _value.new_knowledge
          : new_knowledge // ignore: cast_nullable_to_non_nullable
              as String,
      self_discovery: null == self_discovery
          ? _value.self_discovery
          : self_discovery // ignore: cast_nullable_to_non_nullable
              as String,
      insights_about_others: null == insights_about_others
          ? _value.insights_about_others
          : insights_about_others // ignore: cast_nullable_to_non_nullable
              as String,
      broader_lessons: null == broader_lessons
          ? _value.broader_lessons
          : broader_lessons // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LearningAndInsightsImpl implements _LearningAndInsights {
  const _$LearningAndInsightsImpl(
      {required this.new_knowledge,
      required this.self_discovery,
      required this.insights_about_others,
      required this.broader_lessons});

  factory _$LearningAndInsightsImpl.fromJson(Map<String, dynamic> json) =>
      _$$LearningAndInsightsImplFromJson(json);

  @override
  final String new_knowledge;
  @override
  final String self_discovery;
  @override
  final String insights_about_others;
  @override
  final String broader_lessons;

  @override
  String toString() {
    return 'LearningAndInsights(new_knowledge: $new_knowledge, self_discovery: $self_discovery, insights_about_others: $insights_about_others, broader_lessons: $broader_lessons)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LearningAndInsightsImpl &&
            (identical(other.new_knowledge, new_knowledge) ||
                other.new_knowledge == new_knowledge) &&
            (identical(other.self_discovery, self_discovery) ||
                other.self_discovery == self_discovery) &&
            (identical(other.insights_about_others, insights_about_others) ||
                other.insights_about_others == insights_about_others) &&
            (identical(other.broader_lessons, broader_lessons) ||
                other.broader_lessons == broader_lessons));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, new_knowledge, self_discovery,
      insights_about_others, broader_lessons);

  /// Create a copy of LearningAndInsights
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LearningAndInsightsImplCopyWith<_$LearningAndInsightsImpl> get copyWith =>
      __$$LearningAndInsightsImplCopyWithImpl<_$LearningAndInsightsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LearningAndInsightsImplToJson(
      this,
    );
  }
}

abstract class _LearningAndInsights implements LearningAndInsights {
  const factory _LearningAndInsights(
      {required final String new_knowledge,
      required final String self_discovery,
      required final String insights_about_others,
      required final String broader_lessons}) = _$LearningAndInsightsImpl;

  factory _LearningAndInsights.fromJson(Map<String, dynamic> json) =
      _$LearningAndInsightsImpl.fromJson;

  @override
  String get new_knowledge;
  @override
  String get self_discovery;
  @override
  String get insights_about_others;
  @override
  String get broader_lessons;

  /// Create a copy of LearningAndInsights
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LearningAndInsightsImplCopyWith<_$LearningAndInsightsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ConnectionsAndRelationships _$ConnectionsAndRelationshipsFromJson(
    Map<String, dynamic> json) {
  return _ConnectionsAndRelationships.fromJson(json);
}

/// @nodoc
mixin _$ConnectionsAndRelationships {
  String get meaningful_interactions => throw _privateConstructorUsedError;
  String get notable_about_people => throw _privateConstructorUsedError;
  String get follow_up_needed => throw _privateConstructorUsedError;

  /// Serializes this ConnectionsAndRelationships to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConnectionsAndRelationships
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConnectionsAndRelationshipsCopyWith<ConnectionsAndRelationships>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConnectionsAndRelationshipsCopyWith<$Res> {
  factory $ConnectionsAndRelationshipsCopyWith(
          ConnectionsAndRelationships value,
          $Res Function(ConnectionsAndRelationships) then) =
      _$ConnectionsAndRelationshipsCopyWithImpl<$Res,
          ConnectionsAndRelationships>;
  @useResult
  $Res call(
      {String meaningful_interactions,
      String notable_about_people,
      String follow_up_needed});
}

/// @nodoc
class _$ConnectionsAndRelationshipsCopyWithImpl<$Res,
        $Val extends ConnectionsAndRelationships>
    implements $ConnectionsAndRelationshipsCopyWith<$Res> {
  _$ConnectionsAndRelationshipsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConnectionsAndRelationships
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? meaningful_interactions = null,
    Object? notable_about_people = null,
    Object? follow_up_needed = null,
  }) {
    return _then(_value.copyWith(
      meaningful_interactions: null == meaningful_interactions
          ? _value.meaningful_interactions
          : meaningful_interactions // ignore: cast_nullable_to_non_nullable
              as String,
      notable_about_people: null == notable_about_people
          ? _value.notable_about_people
          : notable_about_people // ignore: cast_nullable_to_non_nullable
              as String,
      follow_up_needed: null == follow_up_needed
          ? _value.follow_up_needed
          : follow_up_needed // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ConnectionsAndRelationshipsImplCopyWith<$Res>
    implements $ConnectionsAndRelationshipsCopyWith<$Res> {
  factory _$$ConnectionsAndRelationshipsImplCopyWith(
          _$ConnectionsAndRelationshipsImpl value,
          $Res Function(_$ConnectionsAndRelationshipsImpl) then) =
      __$$ConnectionsAndRelationshipsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String meaningful_interactions,
      String notable_about_people,
      String follow_up_needed});
}

/// @nodoc
class __$$ConnectionsAndRelationshipsImplCopyWithImpl<$Res>
    extends _$ConnectionsAndRelationshipsCopyWithImpl<$Res,
        _$ConnectionsAndRelationshipsImpl>
    implements _$$ConnectionsAndRelationshipsImplCopyWith<$Res> {
  __$$ConnectionsAndRelationshipsImplCopyWithImpl(
      _$ConnectionsAndRelationshipsImpl _value,
      $Res Function(_$ConnectionsAndRelationshipsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConnectionsAndRelationships
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? meaningful_interactions = null,
    Object? notable_about_people = null,
    Object? follow_up_needed = null,
  }) {
    return _then(_$ConnectionsAndRelationshipsImpl(
      meaningful_interactions: null == meaningful_interactions
          ? _value.meaningful_interactions
          : meaningful_interactions // ignore: cast_nullable_to_non_nullable
              as String,
      notable_about_people: null == notable_about_people
          ? _value.notable_about_people
          : notable_about_people // ignore: cast_nullable_to_non_nullable
              as String,
      follow_up_needed: null == follow_up_needed
          ? _value.follow_up_needed
          : follow_up_needed // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConnectionsAndRelationshipsImpl
    implements _ConnectionsAndRelationships {
  const _$ConnectionsAndRelationshipsImpl(
      {required this.meaningful_interactions,
      required this.notable_about_people,
      required this.follow_up_needed});

  factory _$ConnectionsAndRelationshipsImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ConnectionsAndRelationshipsImplFromJson(json);

  @override
  final String meaningful_interactions;
  @override
  final String notable_about_people;
  @override
  final String follow_up_needed;

  @override
  String toString() {
    return 'ConnectionsAndRelationships(meaningful_interactions: $meaningful_interactions, notable_about_people: $notable_about_people, follow_up_needed: $follow_up_needed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectionsAndRelationshipsImpl &&
            (identical(
                    other.meaningful_interactions, meaningful_interactions) ||
                other.meaningful_interactions == meaningful_interactions) &&
            (identical(other.notable_about_people, notable_about_people) ||
                other.notable_about_people == notable_about_people) &&
            (identical(other.follow_up_needed, follow_up_needed) ||
                other.follow_up_needed == follow_up_needed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, meaningful_interactions,
      notable_about_people, follow_up_needed);

  /// Create a copy of ConnectionsAndRelationships
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectionsAndRelationshipsImplCopyWith<_$ConnectionsAndRelationshipsImpl>
      get copyWith => __$$ConnectionsAndRelationshipsImplCopyWithImpl<
          _$ConnectionsAndRelationshipsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConnectionsAndRelationshipsImplToJson(
      this,
    );
  }
}

abstract class _ConnectionsAndRelationships
    implements ConnectionsAndRelationships {
  const factory _ConnectionsAndRelationships(
          {required final String meaningful_interactions,
          required final String notable_about_people,
          required final String follow_up_needed}) =
      _$ConnectionsAndRelationshipsImpl;

  factory _ConnectionsAndRelationships.fromJson(Map<String, dynamic> json) =
      _$ConnectionsAndRelationshipsImpl.fromJson;

  @override
  String get meaningful_interactions;
  @override
  String get notable_about_people;
  @override
  String get follow_up_needed;

  /// Create a copy of ConnectionsAndRelationships
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConnectionsAndRelationshipsImplCopyWith<_$ConnectionsAndRelationshipsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

LookingForward _$LookingForwardFromJson(Map<String, dynamic> json) {
  return _LookingForward.fromJson(json);
}

/// @nodoc
mixin _$LookingForward {
  String get do_differently_tomorrow => throw _privateConstructorUsedError;
  String get continue_what_worked => throw _privateConstructorUsedError;
  List<String> get top_3_priorities_tomorrow =>
      throw _privateConstructorUsedError;

  /// Serializes this LookingForward to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LookingForward
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LookingForwardCopyWith<LookingForward> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LookingForwardCopyWith<$Res> {
  factory $LookingForwardCopyWith(
          LookingForward value, $Res Function(LookingForward) then) =
      _$LookingForwardCopyWithImpl<$Res, LookingForward>;
  @useResult
  $Res call(
      {String do_differently_tomorrow,
      String continue_what_worked,
      List<String> top_3_priorities_tomorrow});
}

/// @nodoc
class _$LookingForwardCopyWithImpl<$Res, $Val extends LookingForward>
    implements $LookingForwardCopyWith<$Res> {
  _$LookingForwardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LookingForward
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? do_differently_tomorrow = null,
    Object? continue_what_worked = null,
    Object? top_3_priorities_tomorrow = null,
  }) {
    return _then(_value.copyWith(
      do_differently_tomorrow: null == do_differently_tomorrow
          ? _value.do_differently_tomorrow
          : do_differently_tomorrow // ignore: cast_nullable_to_non_nullable
              as String,
      continue_what_worked: null == continue_what_worked
          ? _value.continue_what_worked
          : continue_what_worked // ignore: cast_nullable_to_non_nullable
              as String,
      top_3_priorities_tomorrow: null == top_3_priorities_tomorrow
          ? _value.top_3_priorities_tomorrow
          : top_3_priorities_tomorrow // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LookingForwardImplCopyWith<$Res>
    implements $LookingForwardCopyWith<$Res> {
  factory _$$LookingForwardImplCopyWith(_$LookingForwardImpl value,
          $Res Function(_$LookingForwardImpl) then) =
      __$$LookingForwardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String do_differently_tomorrow,
      String continue_what_worked,
      List<String> top_3_priorities_tomorrow});
}

/// @nodoc
class __$$LookingForwardImplCopyWithImpl<$Res>
    extends _$LookingForwardCopyWithImpl<$Res, _$LookingForwardImpl>
    implements _$$LookingForwardImplCopyWith<$Res> {
  __$$LookingForwardImplCopyWithImpl(
      _$LookingForwardImpl _value, $Res Function(_$LookingForwardImpl) _then)
      : super(_value, _then);

  /// Create a copy of LookingForward
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? do_differently_tomorrow = null,
    Object? continue_what_worked = null,
    Object? top_3_priorities_tomorrow = null,
  }) {
    return _then(_$LookingForwardImpl(
      do_differently_tomorrow: null == do_differently_tomorrow
          ? _value.do_differently_tomorrow
          : do_differently_tomorrow // ignore: cast_nullable_to_non_nullable
              as String,
      continue_what_worked: null == continue_what_worked
          ? _value.continue_what_worked
          : continue_what_worked // ignore: cast_nullable_to_non_nullable
              as String,
      top_3_priorities_tomorrow: null == top_3_priorities_tomorrow
          ? _value._top_3_priorities_tomorrow
          : top_3_priorities_tomorrow // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LookingForwardImpl implements _LookingForward {
  const _$LookingForwardImpl(
      {required this.do_differently_tomorrow,
      required this.continue_what_worked,
      required final List<String> top_3_priorities_tomorrow})
      : _top_3_priorities_tomorrow = top_3_priorities_tomorrow;

  factory _$LookingForwardImpl.fromJson(Map<String, dynamic> json) =>
      _$$LookingForwardImplFromJson(json);

  @override
  final String do_differently_tomorrow;
  @override
  final String continue_what_worked;
  final List<String> _top_3_priorities_tomorrow;
  @override
  List<String> get top_3_priorities_tomorrow {
    if (_top_3_priorities_tomorrow is EqualUnmodifiableListView)
      return _top_3_priorities_tomorrow;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_top_3_priorities_tomorrow);
  }

  @override
  String toString() {
    return 'LookingForward(do_differently_tomorrow: $do_differently_tomorrow, continue_what_worked: $continue_what_worked, top_3_priorities_tomorrow: $top_3_priorities_tomorrow)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LookingForwardImpl &&
            (identical(
                    other.do_differently_tomorrow, do_differently_tomorrow) ||
                other.do_differently_tomorrow == do_differently_tomorrow) &&
            (identical(other.continue_what_worked, continue_what_worked) ||
                other.continue_what_worked == continue_what_worked) &&
            const DeepCollectionEquality().equals(
                other._top_3_priorities_tomorrow, _top_3_priorities_tomorrow));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      do_differently_tomorrow,
      continue_what_worked,
      const DeepCollectionEquality().hash(_top_3_priorities_tomorrow));

  /// Create a copy of LookingForward
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LookingForwardImplCopyWith<_$LookingForwardImpl> get copyWith =>
      __$$LookingForwardImplCopyWithImpl<_$LookingForwardImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LookingForwardImplToJson(
      this,
    );
  }
}

abstract class _LookingForward implements LookingForward {
  const factory _LookingForward(
          {required final String do_differently_tomorrow,
          required final String continue_what_worked,
          required final List<String> top_3_priorities_tomorrow}) =
      _$LookingForwardImpl;

  factory _LookingForward.fromJson(Map<String, dynamic> json) =
      _$LookingForwardImpl.fromJson;

  @override
  String get do_differently_tomorrow;
  @override
  String get continue_what_worked;
  @override
  List<String> get top_3_priorities_tomorrow;

  /// Create a copy of LookingForward
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LookingForwardImplCopyWith<_$LookingForwardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyReflection _$DailyReflectionFromJson(Map<String, dynamic> json) {
  return _DailyReflection.fromJson(json);
}

/// @nodoc
mixin _$DailyReflection {
  String get reflection_summary => throw _privateConstructorUsedError;
  Gratitude get gratitude => throw _privateConstructorUsedError;
  ChallengesAndGrowth get challenges_and_growth =>
      throw _privateConstructorUsedError;
  LearningAndInsights get learning_and_insights =>
      throw _privateConstructorUsedError;
  ConnectionsAndRelationships get connections_and_relationships =>
      throw _privateConstructorUsedError;
  LookingForward get looking_forward => throw _privateConstructorUsedError;

  /// Serializes this DailyReflection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyReflection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyReflectionCopyWith<DailyReflection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyReflectionCopyWith<$Res> {
  factory $DailyReflectionCopyWith(
          DailyReflection value, $Res Function(DailyReflection) then) =
      _$DailyReflectionCopyWithImpl<$Res, DailyReflection>;
  @useResult
  $Res call(
      {String reflection_summary,
      Gratitude gratitude,
      ChallengesAndGrowth challenges_and_growth,
      LearningAndInsights learning_and_insights,
      ConnectionsAndRelationships connections_and_relationships,
      LookingForward looking_forward});

  $GratitudeCopyWith<$Res> get gratitude;
  $ChallengesAndGrowthCopyWith<$Res> get challenges_and_growth;
  $LearningAndInsightsCopyWith<$Res> get learning_and_insights;
  $ConnectionsAndRelationshipsCopyWith<$Res> get connections_and_relationships;
  $LookingForwardCopyWith<$Res> get looking_forward;
}

/// @nodoc
class _$DailyReflectionCopyWithImpl<$Res, $Val extends DailyReflection>
    implements $DailyReflectionCopyWith<$Res> {
  _$DailyReflectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyReflection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reflection_summary = null,
    Object? gratitude = null,
    Object? challenges_and_growth = null,
    Object? learning_and_insights = null,
    Object? connections_and_relationships = null,
    Object? looking_forward = null,
  }) {
    return _then(_value.copyWith(
      reflection_summary: null == reflection_summary
          ? _value.reflection_summary
          : reflection_summary // ignore: cast_nullable_to_non_nullable
              as String,
      gratitude: null == gratitude
          ? _value.gratitude
          : gratitude // ignore: cast_nullable_to_non_nullable
              as Gratitude,
      challenges_and_growth: null == challenges_and_growth
          ? _value.challenges_and_growth
          : challenges_and_growth // ignore: cast_nullable_to_non_nullable
              as ChallengesAndGrowth,
      learning_and_insights: null == learning_and_insights
          ? _value.learning_and_insights
          : learning_and_insights // ignore: cast_nullable_to_non_nullable
              as LearningAndInsights,
      connections_and_relationships: null == connections_and_relationships
          ? _value.connections_and_relationships
          : connections_and_relationships // ignore: cast_nullable_to_non_nullable
              as ConnectionsAndRelationships,
      looking_forward: null == looking_forward
          ? _value.looking_forward
          : looking_forward // ignore: cast_nullable_to_non_nullable
              as LookingForward,
    ) as $Val);
  }

  /// Create a copy of DailyReflection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GratitudeCopyWith<$Res> get gratitude {
    return $GratitudeCopyWith<$Res>(_value.gratitude, (value) {
      return _then(_value.copyWith(gratitude: value) as $Val);
    });
  }

  /// Create a copy of DailyReflection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChallengesAndGrowthCopyWith<$Res> get challenges_and_growth {
    return $ChallengesAndGrowthCopyWith<$Res>(_value.challenges_and_growth,
        (value) {
      return _then(_value.copyWith(challenges_and_growth: value) as $Val);
    });
  }

  /// Create a copy of DailyReflection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LearningAndInsightsCopyWith<$Res> get learning_and_insights {
    return $LearningAndInsightsCopyWith<$Res>(_value.learning_and_insights,
        (value) {
      return _then(_value.copyWith(learning_and_insights: value) as $Val);
    });
  }

  /// Create a copy of DailyReflection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ConnectionsAndRelationshipsCopyWith<$Res> get connections_and_relationships {
    return $ConnectionsAndRelationshipsCopyWith<$Res>(
        _value.connections_and_relationships, (value) {
      return _then(
          _value.copyWith(connections_and_relationships: value) as $Val);
    });
  }

  /// Create a copy of DailyReflection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LookingForwardCopyWith<$Res> get looking_forward {
    return $LookingForwardCopyWith<$Res>(_value.looking_forward, (value) {
      return _then(_value.copyWith(looking_forward: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DailyReflectionImplCopyWith<$Res>
    implements $DailyReflectionCopyWith<$Res> {
  factory _$$DailyReflectionImplCopyWith(_$DailyReflectionImpl value,
          $Res Function(_$DailyReflectionImpl) then) =
      __$$DailyReflectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String reflection_summary,
      Gratitude gratitude,
      ChallengesAndGrowth challenges_and_growth,
      LearningAndInsights learning_and_insights,
      ConnectionsAndRelationships connections_and_relationships,
      LookingForward looking_forward});

  @override
  $GratitudeCopyWith<$Res> get gratitude;
  @override
  $ChallengesAndGrowthCopyWith<$Res> get challenges_and_growth;
  @override
  $LearningAndInsightsCopyWith<$Res> get learning_and_insights;
  @override
  $ConnectionsAndRelationshipsCopyWith<$Res> get connections_and_relationships;
  @override
  $LookingForwardCopyWith<$Res> get looking_forward;
}

/// @nodoc
class __$$DailyReflectionImplCopyWithImpl<$Res>
    extends _$DailyReflectionCopyWithImpl<$Res, _$DailyReflectionImpl>
    implements _$$DailyReflectionImplCopyWith<$Res> {
  __$$DailyReflectionImplCopyWithImpl(
      _$DailyReflectionImpl _value, $Res Function(_$DailyReflectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyReflection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reflection_summary = null,
    Object? gratitude = null,
    Object? challenges_and_growth = null,
    Object? learning_and_insights = null,
    Object? connections_and_relationships = null,
    Object? looking_forward = null,
  }) {
    return _then(_$DailyReflectionImpl(
      reflection_summary: null == reflection_summary
          ? _value.reflection_summary
          : reflection_summary // ignore: cast_nullable_to_non_nullable
              as String,
      gratitude: null == gratitude
          ? _value.gratitude
          : gratitude // ignore: cast_nullable_to_non_nullable
              as Gratitude,
      challenges_and_growth: null == challenges_and_growth
          ? _value.challenges_and_growth
          : challenges_and_growth // ignore: cast_nullable_to_non_nullable
              as ChallengesAndGrowth,
      learning_and_insights: null == learning_and_insights
          ? _value.learning_and_insights
          : learning_and_insights // ignore: cast_nullable_to_non_nullable
              as LearningAndInsights,
      connections_and_relationships: null == connections_and_relationships
          ? _value.connections_and_relationships
          : connections_and_relationships // ignore: cast_nullable_to_non_nullable
              as ConnectionsAndRelationships,
      looking_forward: null == looking_forward
          ? _value.looking_forward
          : looking_forward // ignore: cast_nullable_to_non_nullable
              as LookingForward,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyReflectionImpl implements _DailyReflection {
  const _$DailyReflectionImpl(
      {required this.reflection_summary,
      required this.gratitude,
      required this.challenges_and_growth,
      required this.learning_and_insights,
      required this.connections_and_relationships,
      required this.looking_forward});

  factory _$DailyReflectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyReflectionImplFromJson(json);

  @override
  final String reflection_summary;
  @override
  final Gratitude gratitude;
  @override
  final ChallengesAndGrowth challenges_and_growth;
  @override
  final LearningAndInsights learning_and_insights;
  @override
  final ConnectionsAndRelationships connections_and_relationships;
  @override
  final LookingForward looking_forward;

  @override
  String toString() {
    return 'DailyReflection(reflection_summary: $reflection_summary, gratitude: $gratitude, challenges_and_growth: $challenges_and_growth, learning_and_insights: $learning_and_insights, connections_and_relationships: $connections_and_relationships, looking_forward: $looking_forward)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyReflectionImpl &&
            (identical(other.reflection_summary, reflection_summary) ||
                other.reflection_summary == reflection_summary) &&
            (identical(other.gratitude, gratitude) ||
                other.gratitude == gratitude) &&
            (identical(other.challenges_and_growth, challenges_and_growth) ||
                other.challenges_and_growth == challenges_and_growth) &&
            (identical(other.learning_and_insights, learning_and_insights) ||
                other.learning_and_insights == learning_and_insights) &&
            (identical(other.connections_and_relationships,
                    connections_and_relationships) ||
                other.connections_and_relationships ==
                    connections_and_relationships) &&
            (identical(other.looking_forward, looking_forward) ||
                other.looking_forward == looking_forward));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      reflection_summary,
      gratitude,
      challenges_and_growth,
      learning_and_insights,
      connections_and_relationships,
      looking_forward);

  /// Create a copy of DailyReflection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyReflectionImplCopyWith<_$DailyReflectionImpl> get copyWith =>
      __$$DailyReflectionImplCopyWithImpl<_$DailyReflectionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyReflectionImplToJson(
      this,
    );
  }
}

abstract class _DailyReflection implements DailyReflection {
  const factory _DailyReflection(
      {required final String reflection_summary,
      required final Gratitude gratitude,
      required final ChallengesAndGrowth challenges_and_growth,
      required final LearningAndInsights learning_and_insights,
      required final ConnectionsAndRelationships connections_and_relationships,
      required final LookingForward looking_forward}) = _$DailyReflectionImpl;

  factory _DailyReflection.fromJson(Map<String, dynamic> json) =
      _$DailyReflectionImpl.fromJson;

  @override
  String get reflection_summary;
  @override
  Gratitude get gratitude;
  @override
  ChallengesAndGrowth get challenges_and_growth;
  @override
  LearningAndInsights get learning_and_insights;
  @override
  ConnectionsAndRelationships get connections_and_relationships;
  @override
  LookingForward get looking_forward;

  /// Create a copy of DailyReflection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyReflectionImplCopyWith<_$DailyReflectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Note _$NoteFromJson(Map<String, dynamic> json) {
  return _Note.fromJson(json);
}

/// @nodoc
mixin _$Note {
  String get id => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;

  /// Serializes this Note to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Note
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NoteCopyWith<Note> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteCopyWith<$Res> {
  factory $NoteCopyWith(Note value, $Res Function(Note) then) =
      _$NoteCopyWithImpl<$Res, Note>;
  @useResult
  $Res call({String id, String content});
}

/// @nodoc
class _$NoteCopyWithImpl<$Res, $Val extends Note>
    implements $NoteCopyWith<$Res> {
  _$NoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Note
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NoteImplCopyWith<$Res> implements $NoteCopyWith<$Res> {
  factory _$$NoteImplCopyWith(
          _$NoteImpl value, $Res Function(_$NoteImpl) then) =
      __$$NoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String content});
}

/// @nodoc
class __$$NoteImplCopyWithImpl<$Res>
    extends _$NoteCopyWithImpl<$Res, _$NoteImpl>
    implements _$$NoteImplCopyWith<$Res> {
  __$$NoteImplCopyWithImpl(_$NoteImpl _value, $Res Function(_$NoteImpl) _then)
      : super(_value, _then);

  /// Create a copy of Note
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? content = null,
  }) {
    return _then(_$NoteImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
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
class _$NoteImpl implements _Note {
  const _$NoteImpl({required this.id, required this.content});

  factory _$NoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoteImplFromJson(json);

  @override
  final String id;
  @override
  final String content;

  @override
  String toString() {
    return 'Note(id: $id, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.content, content) || other.content == content));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, content);

  /// Create a copy of Note
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NoteImplCopyWith<_$NoteImpl> get copyWith =>
      __$$NoteImplCopyWithImpl<_$NoteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NoteImplToJson(
      this,
    );
  }
}

abstract class _Note implements Note {
  const factory _Note(
      {required final String id, required final String content}) = _$NoteImpl;

  factory _Note.fromJson(Map<String, dynamic> json) = _$NoteImpl.fromJson;

  @override
  String get id;
  @override
  String get content;

  /// Create a copy of Note
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NoteImplCopyWith<_$NoteImpl> get copyWith =>
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
    return _then(_value.copyWith(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HighlightImplCopyWith<$Res>
    implements $HighlightCopyWith<$Res> {
  factory _$$HighlightImplCopyWith(
          _$HighlightImpl value, $Res Function(_$HighlightImpl) then) =
      __$$HighlightImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String category, String content, int color});
}

/// @nodoc
class __$$HighlightImplCopyWithImpl<$Res>
    extends _$HighlightCopyWithImpl<$Res, _$HighlightImpl>
    implements _$$HighlightImplCopyWith<$Res> {
  __$$HighlightImplCopyWithImpl(
      _$HighlightImpl _value, $Res Function(_$HighlightImpl) _then)
      : super(_value, _then);

  /// Create a copy of Highlight
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? category = null,
    Object? content = null,
    Object? color = null,
  }) {
    return _then(_$HighlightImpl(
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HighlightImpl implements _Highlight {
  const _$HighlightImpl(
      {required this.category, required this.content, this.color = 0xFF00FF00});

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
    return _$$HighlightImplToJson(
      this,
    );
  }
}

abstract class _Highlight implements Highlight {
  const factory _Highlight(
      {required final String category,
      required final String content,
      final int color}) = _$HighlightImpl;

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
          ArchivedHighlights value, $Res Function(ArchivedHighlights) then) =
      _$ArchivedHighlightsCopyWithImpl<$Res, ArchivedHighlights>;
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
    return _then(_value.copyWith(
      beginTime: null == beginTime
          ? _value.beginTime
          : beginTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      highlights: null == highlights
          ? _value.highlights
          : highlights // ignore: cast_nullable_to_non_nullable
              as List<Highlight>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ArchivedHighlightsImplCopyWith<$Res>
    implements $ArchivedHighlightsCopyWith<$Res> {
  factory _$$ArchivedHighlightsImplCopyWith(_$ArchivedHighlightsImpl value,
          $Res Function(_$ArchivedHighlightsImpl) then) =
      __$$ArchivedHighlightsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime beginTime, DateTime endTime, List<Highlight> highlights});
}

/// @nodoc
class __$$ArchivedHighlightsImplCopyWithImpl<$Res>
    extends _$ArchivedHighlightsCopyWithImpl<$Res, _$ArchivedHighlightsImpl>
    implements _$$ArchivedHighlightsImplCopyWith<$Res> {
  __$$ArchivedHighlightsImplCopyWithImpl(_$ArchivedHighlightsImpl _value,
      $Res Function(_$ArchivedHighlightsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ArchivedHighlights
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? beginTime = null,
    Object? endTime = null,
    Object? highlights = null,
  }) {
    return _then(_$ArchivedHighlightsImpl(
      beginTime: null == beginTime
          ? _value.beginTime
          : beginTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      highlights: null == highlights
          ? _value._highlights
          : highlights // ignore: cast_nullable_to_non_nullable
              as List<Highlight>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ArchivedHighlightsImpl implements _ArchivedHighlights {
  const _$ArchivedHighlightsImpl(
      {required this.beginTime,
      required this.endTime,
      required final List<Highlight> highlights})
      : _highlights = highlights;

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
            const DeepCollectionEquality()
                .equals(other._highlights, _highlights));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, beginTime, endTime,
      const DeepCollectionEquality().hash(_highlights));

  /// Create a copy of ArchivedHighlights
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ArchivedHighlightsImplCopyWith<_$ArchivedHighlightsImpl> get copyWith =>
      __$$ArchivedHighlightsImplCopyWithImpl<_$ArchivedHighlightsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArchivedHighlightsImplToJson(
      this,
    );
  }
}

abstract class _ArchivedHighlights implements ArchivedHighlights {
  const factory _ArchivedHighlights(
      {required final DateTime beginTime,
      required final DateTime endTime,
      required final List<Highlight> highlights}) = _$ArchivedHighlightsImpl;

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
  String get id => throw _privateConstructorUsedError;
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
  $Res call({String id, String tag, String description, bool isCompleted});
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
    Object? id = null,
    Object? tag = null,
    Object? description = null,
    Object? isCompleted = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tag: null == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskImplCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$$TaskImplCopyWith(
          _$TaskImpl value, $Res Function(_$TaskImpl) then) =
      __$$TaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String tag, String description, bool isCompleted});
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
    Object? id = null,
    Object? tag = null,
    Object? description = null,
    Object? isCompleted = null,
  }) {
    return _then(_$TaskImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      tag: null == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskImpl implements _Task {
  const _$TaskImpl(
      {required this.id,
      required this.tag,
      required this.description,
      this.isCompleted = false});

  factory _$TaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskImplFromJson(json);

  @override
  final String id;
  @override
  final String tag;
  @override
  final String description;
  @override
  @JsonKey()
  final bool isCompleted;

  @override
  String toString() {
    return 'Task(id: $id, tag: $tag, description: $description, isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tag, tag) || other.tag == tag) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, tag, description, isCompleted);

  /// Create a copy of Task
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskImplCopyWith<_$TaskImpl> get copyWith =>
      __$$TaskImplCopyWithImpl<_$TaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskImplToJson(
      this,
    );
  }
}

abstract class _Task implements Task {
  const factory _Task(
      {required final String id,
      required final String tag,
      required final String description,
      final bool isCompleted}) = _$TaskImpl;

  factory _Task.fromJson(Map<String, dynamic> json) = _$TaskImpl.fromJson;

  @override
  String get id;
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
          MoodTracking value, $Res Function(MoodTracking) then) =
      _$MoodTrackingCopyWithImpl<$Res, MoodTracking>;
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
  $Res call({
    Object? name = null,
    Object? value = null,
    Object? color = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MoodTrackingImplCopyWith<$Res>
    implements $MoodTrackingCopyWith<$Res> {
  factory _$$MoodTrackingImplCopyWith(
          _$MoodTrackingImpl value, $Res Function(_$MoodTrackingImpl) then) =
      __$$MoodTrackingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, double value, int color});
}

/// @nodoc
class __$$MoodTrackingImplCopyWithImpl<$Res>
    extends _$MoodTrackingCopyWithImpl<$Res, _$MoodTrackingImpl>
    implements _$$MoodTrackingImplCopyWith<$Res> {
  __$$MoodTrackingImplCopyWithImpl(
      _$MoodTrackingImpl _value, $Res Function(_$MoodTrackingImpl) _then)
      : super(_value, _then);

  /// Create a copy of MoodTracking
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = null,
    Object? color = null,
  }) {
    return _then(_$MoodTrackingImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MoodTrackingImpl implements _MoodTracking {
  const _$MoodTrackingImpl(
      {required this.name, required this.value, this.color = 0xFF000000});

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
    return _$$MoodTrackingImplToJson(
      this,
    );
  }
}

abstract class _MoodTracking implements MoodTracking {
  const factory _MoodTracking(
      {required final String name,
      required final double value,
      final int color}) = _$MoodTrackingImpl;

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
  String get name => throw _privateConstructorUsedError;
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
          AwakeTimeAllocation value, $Res Function(AwakeTimeAllocation) then) =
      _$AwakeTimeAllocationCopyWithImpl<$Res, AwakeTimeAllocation>;
  @useResult
  $Res call({String name, double value, int color});
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
    Object? name = null,
    Object? value = null,
    Object? color = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AwakeTimeAllocationImplCopyWith<$Res>
    implements $AwakeTimeAllocationCopyWith<$Res> {
  factory _$$AwakeTimeAllocationImplCopyWith(_$AwakeTimeAllocationImpl value,
          $Res Function(_$AwakeTimeAllocationImpl) then) =
      __$$AwakeTimeAllocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, double value, int color});
}

/// @nodoc
class __$$AwakeTimeAllocationImplCopyWithImpl<$Res>
    extends _$AwakeTimeAllocationCopyWithImpl<$Res, _$AwakeTimeAllocationImpl>
    implements _$$AwakeTimeAllocationImplCopyWith<$Res> {
  __$$AwakeTimeAllocationImplCopyWithImpl(_$AwakeTimeAllocationImpl _value,
      $Res Function(_$AwakeTimeAllocationImpl) _then)
      : super(_value, _then);

  /// Create a copy of AwakeTimeAllocation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? value = null,
    Object? color = null,
  }) {
    return _then(_$AwakeTimeAllocationImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AwakeTimeAllocationImpl implements _AwakeTimeAllocation {
  const _$AwakeTimeAllocationImpl(
      {required this.name, required this.value, this.color = 0xFF00FF00});

  factory _$AwakeTimeAllocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$AwakeTimeAllocationImplFromJson(json);

  @override
  final String name;
  @override
  final double value;
  @override
  @JsonKey()
  final int color;

  @override
  String toString() {
    return 'AwakeTimeAllocation(name: $name, value: $value, color: $color)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AwakeTimeAllocationImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.color, color) || other.color == color));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, value, color);

  /// Create a copy of AwakeTimeAllocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AwakeTimeAllocationImplCopyWith<_$AwakeTimeAllocationImpl> get copyWith =>
      __$$AwakeTimeAllocationImplCopyWithImpl<_$AwakeTimeAllocationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AwakeTimeAllocationImplToJson(
      this,
    );
  }
}

abstract class _AwakeTimeAllocation implements AwakeTimeAllocation {
  const factory _AwakeTimeAllocation(
      {required final String name,
      required final double value,
      final int color}) = _$AwakeTimeAllocationImpl;

  factory _AwakeTimeAllocation.fromJson(Map<String, dynamic> json) =
      _$AwakeTimeAllocationImpl.fromJson;

  @override
  String get name;
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

LegacyJournal _$LegacyJournalFromJson(Map<String, dynamic> json) {
  return _Journal.fromJson(json);
}

/// @nodoc
mixin _$LegacyJournal {
  String get id => throw _privateConstructorUsedError;
  DateTime get dateTime =>
      throw _privateConstructorUsedError; //required List<Quote> quotes,
//required MoodScore moodScore,
//required StressLevel stressLevel,
  List<Highlight> get highlights =>
      throw _privateConstructorUsedError; //required List<EnergyLevel> energyLevels,
  List<MoodTracking> get moodTrackings => throw _privateConstructorUsedError;
  List<AwakeTimeAllocation> get awakeTimeAllocations =>
      throw _privateConstructorUsedError;

  /// Serializes this LegacyJournal to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LegacyJournal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LegacyJournalCopyWith<LegacyJournal> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LegacyJournalCopyWith<$Res> {
  factory $LegacyJournalCopyWith(
          LegacyJournal value, $Res Function(LegacyJournal) then) =
      _$LegacyJournalCopyWithImpl<$Res, LegacyJournal>;
  @useResult
  $Res call(
      {String id,
      DateTime dateTime,
      List<Highlight> highlights,
      List<MoodTracking> moodTrackings,
      List<AwakeTimeAllocation> awakeTimeAllocations});
}

/// @nodoc
class _$LegacyJournalCopyWithImpl<$Res, $Val extends LegacyJournal>
    implements $LegacyJournalCopyWith<$Res> {
  _$LegacyJournalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LegacyJournal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dateTime = null,
    Object? highlights = null,
    Object? moodTrackings = null,
    Object? awakeTimeAllocations = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      highlights: null == highlights
          ? _value.highlights
          : highlights // ignore: cast_nullable_to_non_nullable
              as List<Highlight>,
      moodTrackings: null == moodTrackings
          ? _value.moodTrackings
          : moodTrackings // ignore: cast_nullable_to_non_nullable
              as List<MoodTracking>,
      awakeTimeAllocations: null == awakeTimeAllocations
          ? _value.awakeTimeAllocations
          : awakeTimeAllocations // ignore: cast_nullable_to_non_nullable
              as List<AwakeTimeAllocation>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$JournalImplCopyWith<$Res>
    implements $LegacyJournalCopyWith<$Res> {
  factory _$$JournalImplCopyWith(
          _$JournalImpl value, $Res Function(_$JournalImpl) then) =
      __$$JournalImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime dateTime,
      List<Highlight> highlights,
      List<MoodTracking> moodTrackings,
      List<AwakeTimeAllocation> awakeTimeAllocations});
}

/// @nodoc
class __$$JournalImplCopyWithImpl<$Res>
    extends _$LegacyJournalCopyWithImpl<$Res, _$JournalImpl>
    implements _$$JournalImplCopyWith<$Res> {
  __$$JournalImplCopyWithImpl(
      _$JournalImpl _value, $Res Function(_$JournalImpl) _then)
      : super(_value, _then);

  /// Create a copy of LegacyJournal
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dateTime = null,
    Object? highlights = null,
    Object? moodTrackings = null,
    Object? awakeTimeAllocations = null,
  }) {
    return _then(_$JournalImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      highlights: null == highlights
          ? _value._highlights
          : highlights // ignore: cast_nullable_to_non_nullable
              as List<Highlight>,
      moodTrackings: null == moodTrackings
          ? _value._moodTrackings
          : moodTrackings // ignore: cast_nullable_to_non_nullable
              as List<MoodTracking>,
      awakeTimeAllocations: null == awakeTimeAllocations
          ? _value._awakeTimeAllocations
          : awakeTimeAllocations // ignore: cast_nullable_to_non_nullable
              as List<AwakeTimeAllocation>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$JournalImpl implements _Journal {
  const _$JournalImpl(
      {required this.id,
      required this.dateTime,
      required final List<Highlight> highlights,
      required final List<MoodTracking> moodTrackings,
      required final List<AwakeTimeAllocation> awakeTimeAllocations})
      : _highlights = highlights,
        _moodTrackings = moodTrackings,
        _awakeTimeAllocations = awakeTimeAllocations;

  factory _$JournalImpl.fromJson(Map<String, dynamic> json) =>
      _$$JournalImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime dateTime;
//required List<Quote> quotes,
//required MoodScore moodScore,
//required StressLevel stressLevel,
  final List<Highlight> _highlights;
//required List<Quote> quotes,
//required MoodScore moodScore,
//required StressLevel stressLevel,
  @override
  List<Highlight> get highlights {
    if (_highlights is EqualUnmodifiableListView) return _highlights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_highlights);
  }

//required List<EnergyLevel> energyLevels,
  final List<MoodTracking> _moodTrackings;
//required List<EnergyLevel> energyLevels,
  @override
  List<MoodTracking> get moodTrackings {
    if (_moodTrackings is EqualUnmodifiableListView) return _moodTrackings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_moodTrackings);
  }

  final List<AwakeTimeAllocation> _awakeTimeAllocations;
  @override
  List<AwakeTimeAllocation> get awakeTimeAllocations {
    if (_awakeTimeAllocations is EqualUnmodifiableListView)
      return _awakeTimeAllocations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_awakeTimeAllocations);
  }

  @override
  String toString() {
    return 'LegacyJournal(id: $id, dateTime: $dateTime, highlights: $highlights, moodTrackings: $moodTrackings, awakeTimeAllocations: $awakeTimeAllocations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JournalImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime) &&
            const DeepCollectionEquality()
                .equals(other._highlights, _highlights) &&
            const DeepCollectionEquality()
                .equals(other._moodTrackings, _moodTrackings) &&
            const DeepCollectionEquality()
                .equals(other._awakeTimeAllocations, _awakeTimeAllocations));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      dateTime,
      const DeepCollectionEquality().hash(_highlights),
      const DeepCollectionEquality().hash(_moodTrackings),
      const DeepCollectionEquality().hash(_awakeTimeAllocations));

  /// Create a copy of LegacyJournal
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JournalImplCopyWith<_$JournalImpl> get copyWith =>
      __$$JournalImplCopyWithImpl<_$JournalImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JournalImplToJson(
      this,
    );
  }
}

abstract class _Journal implements LegacyJournal {
  const factory _Journal(
          {required final String id,
          required final DateTime dateTime,
          required final List<Highlight> highlights,
          required final List<MoodTracking> moodTrackings,
          required final List<AwakeTimeAllocation> awakeTimeAllocations}) =
      _$JournalImpl;

  factory _Journal.fromJson(Map<String, dynamic> json) = _$JournalImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get dateTime; //required List<Quote> quotes,
//required MoodScore moodScore,
//required StressLevel stressLevel,
  @override
  List<Highlight> get highlights; //required List<EnergyLevel> energyLevels,
  @override
  List<MoodTracking> get moodTrackings;
  @override
  List<AwakeTimeAllocation> get awakeTimeAllocations;

  /// Create a copy of LegacyJournal
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
  List<String> get insights => throw _privateConstructorUsedError;
  List<double> get scores => throw _privateConstructorUsedError;
  List<double> get day => throw _privateConstructorUsedError;
  List<double> get week => throw _privateConstructorUsedError;
  List<double> get month => throw _privateConstructorUsedError;

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
          MoodScoreDashboard value, $Res Function(MoodScoreDashboard) then) =
      _$MoodScoreDashboardCopyWithImpl<$Res, MoodScoreDashboard>;
  @useResult
  $Res call(
      {List<String> insights,
      List<double> scores,
      List<double> day,
      List<double> week,
      List<double> month});
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
  $Res call({
    Object? insights = null,
    Object? scores = null,
    Object? day = null,
    Object? week = null,
    Object? month = null,
  }) {
    return _then(_value.copyWith(
      insights: null == insights
          ? _value.insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<String>,
      scores: null == scores
          ? _value.scores
          : scores // ignore: cast_nullable_to_non_nullable
              as List<double>,
      day: null == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as List<double>,
      week: null == week
          ? _value.week
          : week // ignore: cast_nullable_to_non_nullable
              as List<double>,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as List<double>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MoodScoreDashboardImplCopyWith<$Res>
    implements $MoodScoreDashboardCopyWith<$Res> {
  factory _$$MoodScoreDashboardImplCopyWith(_$MoodScoreDashboardImpl value,
          $Res Function(_$MoodScoreDashboardImpl) then) =
      __$$MoodScoreDashboardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> insights,
      List<double> scores,
      List<double> day,
      List<double> week,
      List<double> month});
}

/// @nodoc
class __$$MoodScoreDashboardImplCopyWithImpl<$Res>
    extends _$MoodScoreDashboardCopyWithImpl<$Res, _$MoodScoreDashboardImpl>
    implements _$$MoodScoreDashboardImplCopyWith<$Res> {
  __$$MoodScoreDashboardImplCopyWithImpl(_$MoodScoreDashboardImpl _value,
      $Res Function(_$MoodScoreDashboardImpl) _then)
      : super(_value, _then);

  /// Create a copy of MoodScoreDashboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? insights = null,
    Object? scores = null,
    Object? day = null,
    Object? week = null,
    Object? month = null,
  }) {
    return _then(_$MoodScoreDashboardImpl(
      insights: null == insights
          ? _value._insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<String>,
      scores: null == scores
          ? _value._scores
          : scores // ignore: cast_nullable_to_non_nullable
              as List<double>,
      day: null == day
          ? _value._day
          : day // ignore: cast_nullable_to_non_nullable
              as List<double>,
      week: null == week
          ? _value._week
          : week // ignore: cast_nullable_to_non_nullable
              as List<double>,
      month: null == month
          ? _value._month
          : month // ignore: cast_nullable_to_non_nullable
              as List<double>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MoodScoreDashboardImpl implements _MoodScoreDashboard {
  const _$MoodScoreDashboardImpl(
      {required final List<String> insights,
      required final List<double> scores,
      required final List<double> day,
      required final List<double> week,
      required final List<double> month})
      : _insights = insights,
        _scores = scores,
        _day = day,
        _week = week,
        _month = month;

  factory _$MoodScoreDashboardImpl.fromJson(Map<String, dynamic> json) =>
      _$$MoodScoreDashboardImplFromJson(json);

  final List<String> _insights;
  @override
  List<String> get insights {
    if (_insights is EqualUnmodifiableListView) return _insights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_insights);
  }

  final List<double> _scores;
  @override
  List<double> get scores {
    if (_scores is EqualUnmodifiableListView) return _scores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scores);
  }

  final List<double> _day;
  @override
  List<double> get day {
    if (_day is EqualUnmodifiableListView) return _day;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_day);
  }

  final List<double> _week;
  @override
  List<double> get week {
    if (_week is EqualUnmodifiableListView) return _week;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_week);
  }

  final List<double> _month;
  @override
  List<double> get month {
    if (_month is EqualUnmodifiableListView) return _month;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_month);
  }

  @override
  String toString() {
    return 'MoodScoreDashboard(insights: $insights, scores: $scores, day: $day, week: $week, month: $month)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoodScoreDashboardImpl &&
            const DeepCollectionEquality().equals(other._insights, _insights) &&
            const DeepCollectionEquality().equals(other._scores, _scores) &&
            const DeepCollectionEquality().equals(other._day, _day) &&
            const DeepCollectionEquality().equals(other._week, _week) &&
            const DeepCollectionEquality().equals(other._month, _month));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_insights),
      const DeepCollectionEquality().hash(_scores),
      const DeepCollectionEquality().hash(_day),
      const DeepCollectionEquality().hash(_week),
      const DeepCollectionEquality().hash(_month));

  /// Create a copy of MoodScoreDashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MoodScoreDashboardImplCopyWith<_$MoodScoreDashboardImpl> get copyWith =>
      __$$MoodScoreDashboardImplCopyWithImpl<_$MoodScoreDashboardImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MoodScoreDashboardImplToJson(
      this,
    );
  }
}

abstract class _MoodScoreDashboard implements MoodScoreDashboard {
  const factory _MoodScoreDashboard(
      {required final List<String> insights,
      required final List<double> scores,
      required final List<double> day,
      required final List<double> week,
      required final List<double> month}) = _$MoodScoreDashboardImpl;

  factory _MoodScoreDashboard.fromJson(Map<String, dynamic> json) =
      _$MoodScoreDashboardImpl.fromJson;

  @override
  List<String> get insights;
  @override
  List<double> get scores;
  @override
  List<double> get day;
  @override
  List<double> get week;
  @override
  List<double> get month;

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
  List<String> get insights => throw _privateConstructorUsedError;
  List<double> get scores => throw _privateConstructorUsedError;
  List<double> get day => throw _privateConstructorUsedError;
  List<double> get week => throw _privateConstructorUsedError;
  List<double> get month => throw _privateConstructorUsedError;

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
  factory $StressLevelDashboardCopyWith(StressLevelDashboard value,
          $Res Function(StressLevelDashboard) then) =
      _$StressLevelDashboardCopyWithImpl<$Res, StressLevelDashboard>;
  @useResult
  $Res call(
      {List<String> insights,
      List<double> scores,
      List<double> day,
      List<double> week,
      List<double> month});
}

/// @nodoc
class _$StressLevelDashboardCopyWithImpl<$Res,
        $Val extends StressLevelDashboard>
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
  $Res call({
    Object? insights = null,
    Object? scores = null,
    Object? day = null,
    Object? week = null,
    Object? month = null,
  }) {
    return _then(_value.copyWith(
      insights: null == insights
          ? _value.insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<String>,
      scores: null == scores
          ? _value.scores
          : scores // ignore: cast_nullable_to_non_nullable
              as List<double>,
      day: null == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as List<double>,
      week: null == week
          ? _value.week
          : week // ignore: cast_nullable_to_non_nullable
              as List<double>,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as List<double>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StressLevelDashboardImplCopyWith<$Res>
    implements $StressLevelDashboardCopyWith<$Res> {
  factory _$$StressLevelDashboardImplCopyWith(_$StressLevelDashboardImpl value,
          $Res Function(_$StressLevelDashboardImpl) then) =
      __$$StressLevelDashboardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> insights,
      List<double> scores,
      List<double> day,
      List<double> week,
      List<double> month});
}

/// @nodoc
class __$$StressLevelDashboardImplCopyWithImpl<$Res>
    extends _$StressLevelDashboardCopyWithImpl<$Res, _$StressLevelDashboardImpl>
    implements _$$StressLevelDashboardImplCopyWith<$Res> {
  __$$StressLevelDashboardImplCopyWithImpl(_$StressLevelDashboardImpl _value,
      $Res Function(_$StressLevelDashboardImpl) _then)
      : super(_value, _then);

  /// Create a copy of StressLevelDashboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? insights = null,
    Object? scores = null,
    Object? day = null,
    Object? week = null,
    Object? month = null,
  }) {
    return _then(_$StressLevelDashboardImpl(
      insights: null == insights
          ? _value._insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<String>,
      scores: null == scores
          ? _value._scores
          : scores // ignore: cast_nullable_to_non_nullable
              as List<double>,
      day: null == day
          ? _value._day
          : day // ignore: cast_nullable_to_non_nullable
              as List<double>,
      week: null == week
          ? _value._week
          : week // ignore: cast_nullable_to_non_nullable
              as List<double>,
      month: null == month
          ? _value._month
          : month // ignore: cast_nullable_to_non_nullable
              as List<double>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StressLevelDashboardImpl implements _StressLevelDashboard {
  const _$StressLevelDashboardImpl(
      {required final List<String> insights,
      required final List<double> scores,
      required final List<double> day,
      required final List<double> week,
      required final List<double> month})
      : _insights = insights,
        _scores = scores,
        _day = day,
        _week = week,
        _month = month;

  factory _$StressLevelDashboardImpl.fromJson(Map<String, dynamic> json) =>
      _$$StressLevelDashboardImplFromJson(json);

  final List<String> _insights;
  @override
  List<String> get insights {
    if (_insights is EqualUnmodifiableListView) return _insights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_insights);
  }

  final List<double> _scores;
  @override
  List<double> get scores {
    if (_scores is EqualUnmodifiableListView) return _scores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scores);
  }

  final List<double> _day;
  @override
  List<double> get day {
    if (_day is EqualUnmodifiableListView) return _day;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_day);
  }

  final List<double> _week;
  @override
  List<double> get week {
    if (_week is EqualUnmodifiableListView) return _week;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_week);
  }

  final List<double> _month;
  @override
  List<double> get month {
    if (_month is EqualUnmodifiableListView) return _month;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_month);
  }

  @override
  String toString() {
    return 'StressLevelDashboard(insights: $insights, scores: $scores, day: $day, week: $week, month: $month)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StressLevelDashboardImpl &&
            const DeepCollectionEquality().equals(other._insights, _insights) &&
            const DeepCollectionEquality().equals(other._scores, _scores) &&
            const DeepCollectionEquality().equals(other._day, _day) &&
            const DeepCollectionEquality().equals(other._week, _week) &&
            const DeepCollectionEquality().equals(other._month, _month));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_insights),
      const DeepCollectionEquality().hash(_scores),
      const DeepCollectionEquality().hash(_day),
      const DeepCollectionEquality().hash(_week),
      const DeepCollectionEquality().hash(_month));

  /// Create a copy of StressLevelDashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StressLevelDashboardImplCopyWith<_$StressLevelDashboardImpl>
      get copyWith =>
          __$$StressLevelDashboardImplCopyWithImpl<_$StressLevelDashboardImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StressLevelDashboardImplToJson(
      this,
    );
  }
}

abstract class _StressLevelDashboard implements StressLevelDashboard {
  const factory _StressLevelDashboard(
      {required final List<String> insights,
      required final List<double> scores,
      required final List<double> day,
      required final List<double> week,
      required final List<double> month}) = _$StressLevelDashboardImpl;

  factory _StressLevelDashboard.fromJson(Map<String, dynamic> json) =
      _$StressLevelDashboardImpl.fromJson;

  @override
  List<String> get insights;
  @override
  List<double> get scores;
  @override
  List<double> get day;
  @override
  List<double> get week;
  @override
  List<double> get month;

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
  List<String> get insights => throw _privateConstructorUsedError;
  List<double> get scores => throw _privateConstructorUsedError;
  List<double> get day => throw _privateConstructorUsedError;
  List<double> get week => throw _privateConstructorUsedError;
  List<double> get month => throw _privateConstructorUsedError;

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
  factory $EnergyLevelDashboardCopyWith(EnergyLevelDashboard value,
          $Res Function(EnergyLevelDashboard) then) =
      _$EnergyLevelDashboardCopyWithImpl<$Res, EnergyLevelDashboard>;
  @useResult
  $Res call(
      {List<String> insights,
      List<double> scores,
      List<double> day,
      List<double> week,
      List<double> month});
}

/// @nodoc
class _$EnergyLevelDashboardCopyWithImpl<$Res,
        $Val extends EnergyLevelDashboard>
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
  $Res call({
    Object? insights = null,
    Object? scores = null,
    Object? day = null,
    Object? week = null,
    Object? month = null,
  }) {
    return _then(_value.copyWith(
      insights: null == insights
          ? _value.insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<String>,
      scores: null == scores
          ? _value.scores
          : scores // ignore: cast_nullable_to_non_nullable
              as List<double>,
      day: null == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as List<double>,
      week: null == week
          ? _value.week
          : week // ignore: cast_nullable_to_non_nullable
              as List<double>,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as List<double>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EnergyLevelDashboardImplCopyWith<$Res>
    implements $EnergyLevelDashboardCopyWith<$Res> {
  factory _$$EnergyLevelDashboardImplCopyWith(_$EnergyLevelDashboardImpl value,
          $Res Function(_$EnergyLevelDashboardImpl) then) =
      __$$EnergyLevelDashboardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> insights,
      List<double> scores,
      List<double> day,
      List<double> week,
      List<double> month});
}

/// @nodoc
class __$$EnergyLevelDashboardImplCopyWithImpl<$Res>
    extends _$EnergyLevelDashboardCopyWithImpl<$Res, _$EnergyLevelDashboardImpl>
    implements _$$EnergyLevelDashboardImplCopyWith<$Res> {
  __$$EnergyLevelDashboardImplCopyWithImpl(_$EnergyLevelDashboardImpl _value,
      $Res Function(_$EnergyLevelDashboardImpl) _then)
      : super(_value, _then);

  /// Create a copy of EnergyLevelDashboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? insights = null,
    Object? scores = null,
    Object? day = null,
    Object? week = null,
    Object? month = null,
  }) {
    return _then(_$EnergyLevelDashboardImpl(
      insights: null == insights
          ? _value._insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<String>,
      scores: null == scores
          ? _value._scores
          : scores // ignore: cast_nullable_to_non_nullable
              as List<double>,
      day: null == day
          ? _value._day
          : day // ignore: cast_nullable_to_non_nullable
              as List<double>,
      week: null == week
          ? _value._week
          : week // ignore: cast_nullable_to_non_nullable
              as List<double>,
      month: null == month
          ? _value._month
          : month // ignore: cast_nullable_to_non_nullable
              as List<double>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EnergyLevelDashboardImpl implements _EnergyLevelDashboard {
  const _$EnergyLevelDashboardImpl(
      {required final List<String> insights,
      required final List<double> scores,
      required final List<double> day,
      required final List<double> week,
      required final List<double> month})
      : _insights = insights,
        _scores = scores,
        _day = day,
        _week = week,
        _month = month;

  factory _$EnergyLevelDashboardImpl.fromJson(Map<String, dynamic> json) =>
      _$$EnergyLevelDashboardImplFromJson(json);

  final List<String> _insights;
  @override
  List<String> get insights {
    if (_insights is EqualUnmodifiableListView) return _insights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_insights);
  }

  final List<double> _scores;
  @override
  List<double> get scores {
    if (_scores is EqualUnmodifiableListView) return _scores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scores);
  }

  final List<double> _day;
  @override
  List<double> get day {
    if (_day is EqualUnmodifiableListView) return _day;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_day);
  }

  final List<double> _week;
  @override
  List<double> get week {
    if (_week is EqualUnmodifiableListView) return _week;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_week);
  }

  final List<double> _month;
  @override
  List<double> get month {
    if (_month is EqualUnmodifiableListView) return _month;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_month);
  }

  @override
  String toString() {
    return 'EnergyLevelDashboard(insights: $insights, scores: $scores, day: $day, week: $week, month: $month)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EnergyLevelDashboardImpl &&
            const DeepCollectionEquality().equals(other._insights, _insights) &&
            const DeepCollectionEquality().equals(other._scores, _scores) &&
            const DeepCollectionEquality().equals(other._day, _day) &&
            const DeepCollectionEquality().equals(other._week, _week) &&
            const DeepCollectionEquality().equals(other._month, _month));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_insights),
      const DeepCollectionEquality().hash(_scores),
      const DeepCollectionEquality().hash(_day),
      const DeepCollectionEquality().hash(_week),
      const DeepCollectionEquality().hash(_month));

  /// Create a copy of EnergyLevelDashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EnergyLevelDashboardImplCopyWith<_$EnergyLevelDashboardImpl>
      get copyWith =>
          __$$EnergyLevelDashboardImplCopyWithImpl<_$EnergyLevelDashboardImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EnergyLevelDashboardImplToJson(
      this,
    );
  }
}

abstract class _EnergyLevelDashboard implements EnergyLevelDashboard {
  const factory _EnergyLevelDashboard(
      {required final List<String> insights,
      required final List<double> scores,
      required final List<double> day,
      required final List<double> week,
      required final List<double> month}) = _$EnergyLevelDashboardImpl;

  factory _EnergyLevelDashboard.fromJson(Map<String, dynamic> json) =
      _$EnergyLevelDashboardImpl.fromJson;

  @override
  List<String> get insights;
  @override
  List<double> get scores;
  @override
  List<double> get day;
  @override
  List<double> get week;
  @override
  List<double> get month;

  /// Create a copy of EnergyLevelDashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EnergyLevelDashboardImplCopyWith<_$EnergyLevelDashboardImpl>
      get copyWith => throw _privateConstructorUsedError;
}

MoodTrackingDashboardEntry _$MoodTrackingDashboardEntryFromJson(
    Map<String, dynamic> json) {
  return _MoodTrackingDashboardEntry.fromJson(json);
}

/// @nodoc
mixin _$MoodTrackingDashboardEntry {
  MoodTracking get moodTracking => throw _privateConstructorUsedError;
  List<double> get day => throw _privateConstructorUsedError;
  List<double> get week => throw _privateConstructorUsedError;
  List<double> get month => throw _privateConstructorUsedError;

  /// Serializes this MoodTrackingDashboardEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MoodTrackingDashboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MoodTrackingDashboardEntryCopyWith<MoodTrackingDashboardEntry>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoodTrackingDashboardEntryCopyWith<$Res> {
  factory $MoodTrackingDashboardEntryCopyWith(MoodTrackingDashboardEntry value,
          $Res Function(MoodTrackingDashboardEntry) then) =
      _$MoodTrackingDashboardEntryCopyWithImpl<$Res,
          MoodTrackingDashboardEntry>;
  @useResult
  $Res call(
      {MoodTracking moodTracking,
      List<double> day,
      List<double> week,
      List<double> month});

  $MoodTrackingCopyWith<$Res> get moodTracking;
}

/// @nodoc
class _$MoodTrackingDashboardEntryCopyWithImpl<$Res,
        $Val extends MoodTrackingDashboardEntry>
    implements $MoodTrackingDashboardEntryCopyWith<$Res> {
  _$MoodTrackingDashboardEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MoodTrackingDashboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? moodTracking = null,
    Object? day = null,
    Object? week = null,
    Object? month = null,
  }) {
    return _then(_value.copyWith(
      moodTracking: null == moodTracking
          ? _value.moodTracking
          : moodTracking // ignore: cast_nullable_to_non_nullable
              as MoodTracking,
      day: null == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as List<double>,
      week: null == week
          ? _value.week
          : week // ignore: cast_nullable_to_non_nullable
              as List<double>,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as List<double>,
    ) as $Val);
  }

  /// Create a copy of MoodTrackingDashboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MoodTrackingCopyWith<$Res> get moodTracking {
    return $MoodTrackingCopyWith<$Res>(_value.moodTracking, (value) {
      return _then(_value.copyWith(moodTracking: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MoodTrackingDashboardEntryImplCopyWith<$Res>
    implements $MoodTrackingDashboardEntryCopyWith<$Res> {
  factory _$$MoodTrackingDashboardEntryImplCopyWith(
          _$MoodTrackingDashboardEntryImpl value,
          $Res Function(_$MoodTrackingDashboardEntryImpl) then) =
      __$$MoodTrackingDashboardEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {MoodTracking moodTracking,
      List<double> day,
      List<double> week,
      List<double> month});

  @override
  $MoodTrackingCopyWith<$Res> get moodTracking;
}

/// @nodoc
class __$$MoodTrackingDashboardEntryImplCopyWithImpl<$Res>
    extends _$MoodTrackingDashboardEntryCopyWithImpl<$Res,
        _$MoodTrackingDashboardEntryImpl>
    implements _$$MoodTrackingDashboardEntryImplCopyWith<$Res> {
  __$$MoodTrackingDashboardEntryImplCopyWithImpl(
      _$MoodTrackingDashboardEntryImpl _value,
      $Res Function(_$MoodTrackingDashboardEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of MoodTrackingDashboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? moodTracking = null,
    Object? day = null,
    Object? week = null,
    Object? month = null,
  }) {
    return _then(_$MoodTrackingDashboardEntryImpl(
      moodTracking: null == moodTracking
          ? _value.moodTracking
          : moodTracking // ignore: cast_nullable_to_non_nullable
              as MoodTracking,
      day: null == day
          ? _value._day
          : day // ignore: cast_nullable_to_non_nullable
              as List<double>,
      week: null == week
          ? _value._week
          : week // ignore: cast_nullable_to_non_nullable
              as List<double>,
      month: null == month
          ? _value._month
          : month // ignore: cast_nullable_to_non_nullable
              as List<double>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MoodTrackingDashboardEntryImpl implements _MoodTrackingDashboardEntry {
  const _$MoodTrackingDashboardEntryImpl(
      {required this.moodTracking,
      required final List<double> day,
      required final List<double> week,
      required final List<double> month})
      : _day = day,
        _week = week,
        _month = month;

  factory _$MoodTrackingDashboardEntryImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$MoodTrackingDashboardEntryImplFromJson(json);

  @override
  final MoodTracking moodTracking;
  final List<double> _day;
  @override
  List<double> get day {
    if (_day is EqualUnmodifiableListView) return _day;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_day);
  }

  final List<double> _week;
  @override
  List<double> get week {
    if (_week is EqualUnmodifiableListView) return _week;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_week);
  }

  final List<double> _month;
  @override
  List<double> get month {
    if (_month is EqualUnmodifiableListView) return _month;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_month);
  }

  @override
  String toString() {
    return 'MoodTrackingDashboardEntry(moodTracking: $moodTracking, day: $day, week: $week, month: $month)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoodTrackingDashboardEntryImpl &&
            (identical(other.moodTracking, moodTracking) ||
                other.moodTracking == moodTracking) &&
            const DeepCollectionEquality().equals(other._day, _day) &&
            const DeepCollectionEquality().equals(other._week, _week) &&
            const DeepCollectionEquality().equals(other._month, _month));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      moodTracking,
      const DeepCollectionEquality().hash(_day),
      const DeepCollectionEquality().hash(_week),
      const DeepCollectionEquality().hash(_month));

  /// Create a copy of MoodTrackingDashboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MoodTrackingDashboardEntryImplCopyWith<_$MoodTrackingDashboardEntryImpl>
      get copyWith => __$$MoodTrackingDashboardEntryImplCopyWithImpl<
          _$MoodTrackingDashboardEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MoodTrackingDashboardEntryImplToJson(
      this,
    );
  }
}

abstract class _MoodTrackingDashboardEntry
    implements MoodTrackingDashboardEntry {
  const factory _MoodTrackingDashboardEntry(
      {required final MoodTracking moodTracking,
      required final List<double> day,
      required final List<double> week,
      required final List<double> month}) = _$MoodTrackingDashboardEntryImpl;

  factory _MoodTrackingDashboardEntry.fromJson(Map<String, dynamic> json) =
      _$MoodTrackingDashboardEntryImpl.fromJson;

  @override
  MoodTracking get moodTracking;
  @override
  List<double> get day;
  @override
  List<double> get week;
  @override
  List<double> get month;

  /// Create a copy of MoodTrackingDashboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MoodTrackingDashboardEntryImplCopyWith<_$MoodTrackingDashboardEntryImpl>
      get copyWith => throw _privateConstructorUsedError;
}

MoodTrackingDashboard _$MoodTrackingDashboardFromJson(
    Map<String, dynamic> json) {
  return _MoodTrackingDashboard.fromJson(json);
}

/// @nodoc
mixin _$MoodTrackingDashboard {
  List<MoodTrackingDashboardEntry> get entries =>
      throw _privateConstructorUsedError;
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
  factory $MoodTrackingDashboardCopyWith(MoodTrackingDashboard value,
          $Res Function(MoodTrackingDashboard) then) =
      _$MoodTrackingDashboardCopyWithImpl<$Res, MoodTrackingDashboard>;
  @useResult
  $Res call({List<MoodTrackingDashboardEntry> entries, List<String> insights});
}

/// @nodoc
class _$MoodTrackingDashboardCopyWithImpl<$Res,
        $Val extends MoodTrackingDashboard>
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
  $Res call({
    Object? entries = null,
    Object? insights = null,
  }) {
    return _then(_value.copyWith(
      entries: null == entries
          ? _value.entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<MoodTrackingDashboardEntry>,
      insights: null == insights
          ? _value.insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MoodTrackingDashboardImplCopyWith<$Res>
    implements $MoodTrackingDashboardCopyWith<$Res> {
  factory _$$MoodTrackingDashboardImplCopyWith(
          _$MoodTrackingDashboardImpl value,
          $Res Function(_$MoodTrackingDashboardImpl) then) =
      __$$MoodTrackingDashboardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<MoodTrackingDashboardEntry> entries, List<String> insights});
}

/// @nodoc
class __$$MoodTrackingDashboardImplCopyWithImpl<$Res>
    extends _$MoodTrackingDashboardCopyWithImpl<$Res,
        _$MoodTrackingDashboardImpl>
    implements _$$MoodTrackingDashboardImplCopyWith<$Res> {
  __$$MoodTrackingDashboardImplCopyWithImpl(_$MoodTrackingDashboardImpl _value,
      $Res Function(_$MoodTrackingDashboardImpl) _then)
      : super(_value, _then);

  /// Create a copy of MoodTrackingDashboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entries = null,
    Object? insights = null,
  }) {
    return _then(_$MoodTrackingDashboardImpl(
      entries: null == entries
          ? _value._entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<MoodTrackingDashboardEntry>,
      insights: null == insights
          ? _value._insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MoodTrackingDashboardImpl implements _MoodTrackingDashboard {
  const _$MoodTrackingDashboardImpl(
      {required final List<MoodTrackingDashboardEntry> entries,
      required final List<String> insights})
      : _entries = entries,
        _insights = insights;

  factory _$MoodTrackingDashboardImpl.fromJson(Map<String, dynamic> json) =>
      _$$MoodTrackingDashboardImplFromJson(json);

  final List<MoodTrackingDashboardEntry> _entries;
  @override
  List<MoodTrackingDashboardEntry> get entries {
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entries);
  }

  final List<String> _insights;
  @override
  List<String> get insights {
    if (_insights is EqualUnmodifiableListView) return _insights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_insights);
  }

  @override
  String toString() {
    return 'MoodTrackingDashboard(entries: $entries, insights: $insights)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoodTrackingDashboardImpl &&
            const DeepCollectionEquality().equals(other._entries, _entries) &&
            const DeepCollectionEquality().equals(other._insights, _insights));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_entries),
      const DeepCollectionEquality().hash(_insights));

  /// Create a copy of MoodTrackingDashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MoodTrackingDashboardImplCopyWith<_$MoodTrackingDashboardImpl>
      get copyWith => __$$MoodTrackingDashboardImplCopyWithImpl<
          _$MoodTrackingDashboardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MoodTrackingDashboardImplToJson(
      this,
    );
  }
}

abstract class _MoodTrackingDashboard implements MoodTrackingDashboard {
  const factory _MoodTrackingDashboard(
      {required final List<MoodTrackingDashboardEntry> entries,
      required final List<String> insights}) = _$MoodTrackingDashboardImpl;

  factory _MoodTrackingDashboard.fromJson(Map<String, dynamic> json) =
      _$MoodTrackingDashboardImpl.fromJson;

  @override
  List<MoodTrackingDashboardEntry> get entries;
  @override
  List<String> get insights;

  /// Create a copy of MoodTrackingDashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MoodTrackingDashboardImplCopyWith<_$MoodTrackingDashboardImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AwakeTimeAllocationDashboardEntry _$AwakeTimeAllocationDashboardEntryFromJson(
    Map<String, dynamic> json) {
  return _AwakeTimeAllocationDashboardEntry.fromJson(json);
}

/// @nodoc
mixin _$AwakeTimeAllocationDashboardEntry {
  AwakeTimeAllocation get awakeTimeAllocation =>
      throw _privateConstructorUsedError;
  List<double> get day => throw _privateConstructorUsedError;
  List<double> get week => throw _privateConstructorUsedError;
  List<double> get month => throw _privateConstructorUsedError;

  /// Serializes this AwakeTimeAllocationDashboardEntry to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AwakeTimeAllocationDashboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AwakeTimeAllocationDashboardEntryCopyWith<AwakeTimeAllocationDashboardEntry>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AwakeTimeAllocationDashboardEntryCopyWith<$Res> {
  factory $AwakeTimeAllocationDashboardEntryCopyWith(
          AwakeTimeAllocationDashboardEntry value,
          $Res Function(AwakeTimeAllocationDashboardEntry) then) =
      _$AwakeTimeAllocationDashboardEntryCopyWithImpl<$Res,
          AwakeTimeAllocationDashboardEntry>;
  @useResult
  $Res call(
      {AwakeTimeAllocation awakeTimeAllocation,
      List<double> day,
      List<double> week,
      List<double> month});

  $AwakeTimeAllocationCopyWith<$Res> get awakeTimeAllocation;
}

/// @nodoc
class _$AwakeTimeAllocationDashboardEntryCopyWithImpl<$Res,
        $Val extends AwakeTimeAllocationDashboardEntry>
    implements $AwakeTimeAllocationDashboardEntryCopyWith<$Res> {
  _$AwakeTimeAllocationDashboardEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AwakeTimeAllocationDashboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? awakeTimeAllocation = null,
    Object? day = null,
    Object? week = null,
    Object? month = null,
  }) {
    return _then(_value.copyWith(
      awakeTimeAllocation: null == awakeTimeAllocation
          ? _value.awakeTimeAllocation
          : awakeTimeAllocation // ignore: cast_nullable_to_non_nullable
              as AwakeTimeAllocation,
      day: null == day
          ? _value.day
          : day // ignore: cast_nullable_to_non_nullable
              as List<double>,
      week: null == week
          ? _value.week
          : week // ignore: cast_nullable_to_non_nullable
              as List<double>,
      month: null == month
          ? _value.month
          : month // ignore: cast_nullable_to_non_nullable
              as List<double>,
    ) as $Val);
  }

  /// Create a copy of AwakeTimeAllocationDashboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AwakeTimeAllocationCopyWith<$Res> get awakeTimeAllocation {
    return $AwakeTimeAllocationCopyWith<$Res>(_value.awakeTimeAllocation,
        (value) {
      return _then(_value.copyWith(awakeTimeAllocation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AwakeTimeAllocationDashboardEntryImplCopyWith<$Res>
    implements $AwakeTimeAllocationDashboardEntryCopyWith<$Res> {
  factory _$$AwakeTimeAllocationDashboardEntryImplCopyWith(
          _$AwakeTimeAllocationDashboardEntryImpl value,
          $Res Function(_$AwakeTimeAllocationDashboardEntryImpl) then) =
      __$$AwakeTimeAllocationDashboardEntryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AwakeTimeAllocation awakeTimeAllocation,
      List<double> day,
      List<double> week,
      List<double> month});

  @override
  $AwakeTimeAllocationCopyWith<$Res> get awakeTimeAllocation;
}

/// @nodoc
class __$$AwakeTimeAllocationDashboardEntryImplCopyWithImpl<$Res>
    extends _$AwakeTimeAllocationDashboardEntryCopyWithImpl<$Res,
        _$AwakeTimeAllocationDashboardEntryImpl>
    implements _$$AwakeTimeAllocationDashboardEntryImplCopyWith<$Res> {
  __$$AwakeTimeAllocationDashboardEntryImplCopyWithImpl(
      _$AwakeTimeAllocationDashboardEntryImpl _value,
      $Res Function(_$AwakeTimeAllocationDashboardEntryImpl) _then)
      : super(_value, _then);

  /// Create a copy of AwakeTimeAllocationDashboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? awakeTimeAllocation = null,
    Object? day = null,
    Object? week = null,
    Object? month = null,
  }) {
    return _then(_$AwakeTimeAllocationDashboardEntryImpl(
      awakeTimeAllocation: null == awakeTimeAllocation
          ? _value.awakeTimeAllocation
          : awakeTimeAllocation // ignore: cast_nullable_to_non_nullable
              as AwakeTimeAllocation,
      day: null == day
          ? _value._day
          : day // ignore: cast_nullable_to_non_nullable
              as List<double>,
      week: null == week
          ? _value._week
          : week // ignore: cast_nullable_to_non_nullable
              as List<double>,
      month: null == month
          ? _value._month
          : month // ignore: cast_nullable_to_non_nullable
              as List<double>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AwakeTimeAllocationDashboardEntryImpl
    implements _AwakeTimeAllocationDashboardEntry {
  const _$AwakeTimeAllocationDashboardEntryImpl(
      {required this.awakeTimeAllocation,
      required final List<double> day,
      required final List<double> week,
      required final List<double> month})
      : _day = day,
        _week = week,
        _month = month;

  factory _$AwakeTimeAllocationDashboardEntryImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$AwakeTimeAllocationDashboardEntryImplFromJson(json);

  @override
  final AwakeTimeAllocation awakeTimeAllocation;
  final List<double> _day;
  @override
  List<double> get day {
    if (_day is EqualUnmodifiableListView) return _day;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_day);
  }

  final List<double> _week;
  @override
  List<double> get week {
    if (_week is EqualUnmodifiableListView) return _week;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_week);
  }

  final List<double> _month;
  @override
  List<double> get month {
    if (_month is EqualUnmodifiableListView) return _month;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_month);
  }

  @override
  String toString() {
    return 'AwakeTimeAllocationDashboardEntry(awakeTimeAllocation: $awakeTimeAllocation, day: $day, week: $week, month: $month)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AwakeTimeAllocationDashboardEntryImpl &&
            (identical(other.awakeTimeAllocation, awakeTimeAllocation) ||
                other.awakeTimeAllocation == awakeTimeAllocation) &&
            const DeepCollectionEquality().equals(other._day, _day) &&
            const DeepCollectionEquality().equals(other._week, _week) &&
            const DeepCollectionEquality().equals(other._month, _month));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      awakeTimeAllocation,
      const DeepCollectionEquality().hash(_day),
      const DeepCollectionEquality().hash(_week),
      const DeepCollectionEquality().hash(_month));

  /// Create a copy of AwakeTimeAllocationDashboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AwakeTimeAllocationDashboardEntryImplCopyWith<
          _$AwakeTimeAllocationDashboardEntryImpl>
      get copyWith => __$$AwakeTimeAllocationDashboardEntryImplCopyWithImpl<
          _$AwakeTimeAllocationDashboardEntryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AwakeTimeAllocationDashboardEntryImplToJson(
      this,
    );
  }
}

abstract class _AwakeTimeAllocationDashboardEntry
    implements AwakeTimeAllocationDashboardEntry {
  const factory _AwakeTimeAllocationDashboardEntry(
          {required final AwakeTimeAllocation awakeTimeAllocation,
          required final List<double> day,
          required final List<double> week,
          required final List<double> month}) =
      _$AwakeTimeAllocationDashboardEntryImpl;

  factory _AwakeTimeAllocationDashboardEntry.fromJson(
          Map<String, dynamic> json) =
      _$AwakeTimeAllocationDashboardEntryImpl.fromJson;

  @override
  AwakeTimeAllocation get awakeTimeAllocation;
  @override
  List<double> get day;
  @override
  List<double> get week;
  @override
  List<double> get month;

  /// Create a copy of AwakeTimeAllocationDashboardEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AwakeTimeAllocationDashboardEntryImplCopyWith<
          _$AwakeTimeAllocationDashboardEntryImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AwakeTimeAllocationDashboard _$AwakeTimeAllocationDashboardFromJson(
    Map<String, dynamic> json) {
  return _AwakeTimeAllocationDashboard.fromJson(json);
}

/// @nodoc
mixin _$AwakeTimeAllocationDashboard {
  List<AwakeTimeAllocationDashboardEntry> get entries =>
      throw _privateConstructorUsedError;
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
          $Res Function(AwakeTimeAllocationDashboard) then) =
      _$AwakeTimeAllocationDashboardCopyWithImpl<$Res,
          AwakeTimeAllocationDashboard>;
  @useResult
  $Res call(
      {List<AwakeTimeAllocationDashboardEntry> entries, List<String> insights});
}

/// @nodoc
class _$AwakeTimeAllocationDashboardCopyWithImpl<$Res,
        $Val extends AwakeTimeAllocationDashboard>
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
  $Res call({
    Object? entries = null,
    Object? insights = null,
  }) {
    return _then(_value.copyWith(
      entries: null == entries
          ? _value.entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<AwakeTimeAllocationDashboardEntry>,
      insights: null == insights
          ? _value.insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AwakeTimeAllocationDashboardImplCopyWith<$Res>
    implements $AwakeTimeAllocationDashboardCopyWith<$Res> {
  factory _$$AwakeTimeAllocationDashboardImplCopyWith(
          _$AwakeTimeAllocationDashboardImpl value,
          $Res Function(_$AwakeTimeAllocationDashboardImpl) then) =
      __$$AwakeTimeAllocationDashboardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<AwakeTimeAllocationDashboardEntry> entries, List<String> insights});
}

/// @nodoc
class __$$AwakeTimeAllocationDashboardImplCopyWithImpl<$Res>
    extends _$AwakeTimeAllocationDashboardCopyWithImpl<$Res,
        _$AwakeTimeAllocationDashboardImpl>
    implements _$$AwakeTimeAllocationDashboardImplCopyWith<$Res> {
  __$$AwakeTimeAllocationDashboardImplCopyWithImpl(
      _$AwakeTimeAllocationDashboardImpl _value,
      $Res Function(_$AwakeTimeAllocationDashboardImpl) _then)
      : super(_value, _then);

  /// Create a copy of AwakeTimeAllocationDashboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entries = null,
    Object? insights = null,
  }) {
    return _then(_$AwakeTimeAllocationDashboardImpl(
      entries: null == entries
          ? _value._entries
          : entries // ignore: cast_nullable_to_non_nullable
              as List<AwakeTimeAllocationDashboardEntry>,
      insights: null == insights
          ? _value._insights
          : insights // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AwakeTimeAllocationDashboardImpl
    implements _AwakeTimeAllocationDashboard {
  const _$AwakeTimeAllocationDashboardImpl(
      {required final List<AwakeTimeAllocationDashboardEntry> entries,
      required final List<String> insights})
      : _entries = entries,
        _insights = insights;

  factory _$AwakeTimeAllocationDashboardImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$AwakeTimeAllocationDashboardImplFromJson(json);

  final List<AwakeTimeAllocationDashboardEntry> _entries;
  @override
  List<AwakeTimeAllocationDashboardEntry> get entries {
    if (_entries is EqualUnmodifiableListView) return _entries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_entries);
  }

  final List<String> _insights;
  @override
  List<String> get insights {
    if (_insights is EqualUnmodifiableListView) return _insights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_insights);
  }

  @override
  String toString() {
    return 'AwakeTimeAllocationDashboard(entries: $entries, insights: $insights)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AwakeTimeAllocationDashboardImpl &&
            const DeepCollectionEquality().equals(other._entries, _entries) &&
            const DeepCollectionEquality().equals(other._insights, _insights));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_entries),
      const DeepCollectionEquality().hash(_insights));

  /// Create a copy of AwakeTimeAllocationDashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AwakeTimeAllocationDashboardImplCopyWith<
          _$AwakeTimeAllocationDashboardImpl>
      get copyWith => __$$AwakeTimeAllocationDashboardImplCopyWithImpl<
          _$AwakeTimeAllocationDashboardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AwakeTimeAllocationDashboardImplToJson(
      this,
    );
  }
}

abstract class _AwakeTimeAllocationDashboard
    implements AwakeTimeAllocationDashboard {
  const factory _AwakeTimeAllocationDashboard(
          {required final List<AwakeTimeAllocationDashboardEntry> entries,
          required final List<String> insights}) =
      _$AwakeTimeAllocationDashboardImpl;

  factory _AwakeTimeAllocationDashboard.fromJson(Map<String, dynamic> json) =
      _$AwakeTimeAllocationDashboardImpl.fromJson;

  @override
  List<AwakeTimeAllocationDashboardEntry> get entries;
  @override
  List<String> get insights;

  /// Create a copy of AwakeTimeAllocationDashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AwakeTimeAllocationDashboardImplCopyWith<
          _$AwakeTimeAllocationDashboardImpl>
      get copyWith => throw _privateConstructorUsedError;
}

Dashboard _$DashboardFromJson(Map<String, dynamic> json) {
  return _Dashboard.fromJson(json);
}

/// @nodoc
mixin _$Dashboard {
  DateTime get dateTime => throw _privateConstructorUsedError;
  MoodScoreDashboard get moodScore => throw _privateConstructorUsedError;
  StressLevelDashboard get stressLevel => throw _privateConstructorUsedError;
  EnergyLevelDashboard get energyLevel => throw _privateConstructorUsedError;
  MoodTrackingDashboard get moodTracking => throw _privateConstructorUsedError;
  AwakeTimeAllocationDashboard get awakeTimeAllocation =>
      throw _privateConstructorUsedError;

  /// Serializes this Dashboard to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Dashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardCopyWith<Dashboard> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardCopyWith<$Res> {
  factory $DashboardCopyWith(Dashboard value, $Res Function(Dashboard) then) =
      _$DashboardCopyWithImpl<$Res, Dashboard>;
  @useResult
  $Res call(
      {DateTime dateTime,
      MoodScoreDashboard moodScore,
      StressLevelDashboard stressLevel,
      EnergyLevelDashboard energyLevel,
      MoodTrackingDashboard moodTracking,
      AwakeTimeAllocationDashboard awakeTimeAllocation});

  $MoodScoreDashboardCopyWith<$Res> get moodScore;
  $StressLevelDashboardCopyWith<$Res> get stressLevel;
  $EnergyLevelDashboardCopyWith<$Res> get energyLevel;
  $MoodTrackingDashboardCopyWith<$Res> get moodTracking;
  $AwakeTimeAllocationDashboardCopyWith<$Res> get awakeTimeAllocation;
}

/// @nodoc
class _$DashboardCopyWithImpl<$Res, $Val extends Dashboard>
    implements $DashboardCopyWith<$Res> {
  _$DashboardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Dashboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dateTime = null,
    Object? moodScore = null,
    Object? stressLevel = null,
    Object? energyLevel = null,
    Object? moodTracking = null,
    Object? awakeTimeAllocation = null,
  }) {
    return _then(_value.copyWith(
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      moodScore: null == moodScore
          ? _value.moodScore
          : moodScore // ignore: cast_nullable_to_non_nullable
              as MoodScoreDashboard,
      stressLevel: null == stressLevel
          ? _value.stressLevel
          : stressLevel // ignore: cast_nullable_to_non_nullable
              as StressLevelDashboard,
      energyLevel: null == energyLevel
          ? _value.energyLevel
          : energyLevel // ignore: cast_nullable_to_non_nullable
              as EnergyLevelDashboard,
      moodTracking: null == moodTracking
          ? _value.moodTracking
          : moodTracking // ignore: cast_nullable_to_non_nullable
              as MoodTrackingDashboard,
      awakeTimeAllocation: null == awakeTimeAllocation
          ? _value.awakeTimeAllocation
          : awakeTimeAllocation // ignore: cast_nullable_to_non_nullable
              as AwakeTimeAllocationDashboard,
    ) as $Val);
  }

  /// Create a copy of Dashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MoodScoreDashboardCopyWith<$Res> get moodScore {
    return $MoodScoreDashboardCopyWith<$Res>(_value.moodScore, (value) {
      return _then(_value.copyWith(moodScore: value) as $Val);
    });
  }

  /// Create a copy of Dashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StressLevelDashboardCopyWith<$Res> get stressLevel {
    return $StressLevelDashboardCopyWith<$Res>(_value.stressLevel, (value) {
      return _then(_value.copyWith(stressLevel: value) as $Val);
    });
  }

  /// Create a copy of Dashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $EnergyLevelDashboardCopyWith<$Res> get energyLevel {
    return $EnergyLevelDashboardCopyWith<$Res>(_value.energyLevel, (value) {
      return _then(_value.copyWith(energyLevel: value) as $Val);
    });
  }

  /// Create a copy of Dashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MoodTrackingDashboardCopyWith<$Res> get moodTracking {
    return $MoodTrackingDashboardCopyWith<$Res>(_value.moodTracking, (value) {
      return _then(_value.copyWith(moodTracking: value) as $Val);
    });
  }

  /// Create a copy of Dashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AwakeTimeAllocationDashboardCopyWith<$Res> get awakeTimeAllocation {
    return $AwakeTimeAllocationDashboardCopyWith<$Res>(
        _value.awakeTimeAllocation, (value) {
      return _then(_value.copyWith(awakeTimeAllocation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DashboardImplCopyWith<$Res>
    implements $DashboardCopyWith<$Res> {
  factory _$$DashboardImplCopyWith(
          _$DashboardImpl value, $Res Function(_$DashboardImpl) then) =
      __$$DashboardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime dateTime,
      MoodScoreDashboard moodScore,
      StressLevelDashboard stressLevel,
      EnergyLevelDashboard energyLevel,
      MoodTrackingDashboard moodTracking,
      AwakeTimeAllocationDashboard awakeTimeAllocation});

  @override
  $MoodScoreDashboardCopyWith<$Res> get moodScore;
  @override
  $StressLevelDashboardCopyWith<$Res> get stressLevel;
  @override
  $EnergyLevelDashboardCopyWith<$Res> get energyLevel;
  @override
  $MoodTrackingDashboardCopyWith<$Res> get moodTracking;
  @override
  $AwakeTimeAllocationDashboardCopyWith<$Res> get awakeTimeAllocation;
}

/// @nodoc
class __$$DashboardImplCopyWithImpl<$Res>
    extends _$DashboardCopyWithImpl<$Res, _$DashboardImpl>
    implements _$$DashboardImplCopyWith<$Res> {
  __$$DashboardImplCopyWithImpl(
      _$DashboardImpl _value, $Res Function(_$DashboardImpl) _then)
      : super(_value, _then);

  /// Create a copy of Dashboard
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dateTime = null,
    Object? moodScore = null,
    Object? stressLevel = null,
    Object? energyLevel = null,
    Object? moodTracking = null,
    Object? awakeTimeAllocation = null,
  }) {
    return _then(_$DashboardImpl(
      dateTime: null == dateTime
          ? _value.dateTime
          : dateTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      moodScore: null == moodScore
          ? _value.moodScore
          : moodScore // ignore: cast_nullable_to_non_nullable
              as MoodScoreDashboard,
      stressLevel: null == stressLevel
          ? _value.stressLevel
          : stressLevel // ignore: cast_nullable_to_non_nullable
              as StressLevelDashboard,
      energyLevel: null == energyLevel
          ? _value.energyLevel
          : energyLevel // ignore: cast_nullable_to_non_nullable
              as EnergyLevelDashboard,
      moodTracking: null == moodTracking
          ? _value.moodTracking
          : moodTracking // ignore: cast_nullable_to_non_nullable
              as MoodTrackingDashboard,
      awakeTimeAllocation: null == awakeTimeAllocation
          ? _value.awakeTimeAllocation
          : awakeTimeAllocation // ignore: cast_nullable_to_non_nullable
              as AwakeTimeAllocationDashboard,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DashboardImpl implements _Dashboard {
  const _$DashboardImpl(
      {required this.dateTime,
      required this.moodScore,
      required this.stressLevel,
      required this.energyLevel,
      required this.moodTracking,
      required this.awakeTimeAllocation});

  factory _$DashboardImpl.fromJson(Map<String, dynamic> json) =>
      _$$DashboardImplFromJson(json);

  @override
  final DateTime dateTime;
  @override
  final MoodScoreDashboard moodScore;
  @override
  final StressLevelDashboard stressLevel;
  @override
  final EnergyLevelDashboard energyLevel;
  @override
  final MoodTrackingDashboard moodTracking;
  @override
  final AwakeTimeAllocationDashboard awakeTimeAllocation;

  @override
  String toString() {
    return 'Dashboard(dateTime: $dateTime, moodScore: $moodScore, stressLevel: $stressLevel, energyLevel: $energyLevel, moodTracking: $moodTracking, awakeTimeAllocation: $awakeTimeAllocation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardImpl &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime) &&
            (identical(other.moodScore, moodScore) ||
                other.moodScore == moodScore) &&
            (identical(other.stressLevel, stressLevel) ||
                other.stressLevel == stressLevel) &&
            (identical(other.energyLevel, energyLevel) ||
                other.energyLevel == energyLevel) &&
            (identical(other.moodTracking, moodTracking) ||
                other.moodTracking == moodTracking) &&
            (identical(other.awakeTimeAllocation, awakeTimeAllocation) ||
                other.awakeTimeAllocation == awakeTimeAllocation));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, dateTime, moodScore, stressLevel,
      energyLevel, moodTracking, awakeTimeAllocation);

  /// Create a copy of Dashboard
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardImplCopyWith<_$DashboardImpl> get copyWith =>
      __$$DashboardImplCopyWithImpl<_$DashboardImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DashboardImplToJson(
      this,
    );
  }
}

abstract class _Dashboard implements Dashboard {
  const factory _Dashboard(
          {required final DateTime dateTime,
          required final MoodScoreDashboard moodScore,
          required final StressLevelDashboard stressLevel,
          required final EnergyLevelDashboard energyLevel,
          required final MoodTrackingDashboard moodTracking,
          required final AwakeTimeAllocationDashboard awakeTimeAllocation}) =
      _$DashboardImpl;

  factory _Dashboard.fromJson(Map<String, dynamic> json) =
      _$DashboardImpl.fromJson;

  @override
  DateTime get dateTime;
  @override
  MoodScoreDashboard get moodScore;
  @override
  StressLevelDashboard get stressLevel;
  @override
  EnergyLevelDashboard get energyLevel;
  @override
  MoodTrackingDashboard get moodTracking;
  @override
  AwakeTimeAllocationDashboard get awakeTimeAllocation;

  /// Create a copy of Dashboard
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardImplCopyWith<_$DashboardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

JournalFile _$JournalFileFromJson(Map<String, dynamic> json) {
  return _JournalFile.fromJson(json);
}

/// @nodoc
mixin _$JournalFile {
  String get username => throw _privateConstructorUsedError;
  String get time_stamp => throw _privateConstructorUsedError;
  List<EventAnalysis> get events => throw _privateConstructorUsedError;
  DailyReflection get daily_reflection => throw _privateConstructorUsedError;

  /// Serializes this JournalFile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of JournalFile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $JournalFileCopyWith<JournalFile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $JournalFileCopyWith<$Res> {
  factory $JournalFileCopyWith(
          JournalFile value, $Res Function(JournalFile) then) =
      _$JournalFileCopyWithImpl<$Res, JournalFile>;
  @useResult
  $Res call(
      {String username,
      String time_stamp,
      List<EventAnalysis> events,
      DailyReflection daily_reflection});

  $DailyReflectionCopyWith<$Res> get daily_reflection;
}

/// @nodoc
class _$JournalFileCopyWithImpl<$Res, $Val extends JournalFile>
    implements $JournalFileCopyWith<$Res> {
  _$JournalFileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of JournalFile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? time_stamp = null,
    Object? events = null,
    Object? daily_reflection = null,
  }) {
    return _then(_value.copyWith(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      time_stamp: null == time_stamp
          ? _value.time_stamp
          : time_stamp // ignore: cast_nullable_to_non_nullable
              as String,
      events: null == events
          ? _value.events
          : events // ignore: cast_nullable_to_non_nullable
              as List<EventAnalysis>,
      daily_reflection: null == daily_reflection
          ? _value.daily_reflection
          : daily_reflection // ignore: cast_nullable_to_non_nullable
              as DailyReflection,
    ) as $Val);
  }

  /// Create a copy of JournalFile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DailyReflectionCopyWith<$Res> get daily_reflection {
    return $DailyReflectionCopyWith<$Res>(_value.daily_reflection, (value) {
      return _then(_value.copyWith(daily_reflection: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$JournalFileImplCopyWith<$Res>
    implements $JournalFileCopyWith<$Res> {
  factory _$$JournalFileImplCopyWith(
          _$JournalFileImpl value, $Res Function(_$JournalFileImpl) then) =
      __$$JournalFileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String username,
      String time_stamp,
      List<EventAnalysis> events,
      DailyReflection daily_reflection});

  @override
  $DailyReflectionCopyWith<$Res> get daily_reflection;
}

/// @nodoc
class __$$JournalFileImplCopyWithImpl<$Res>
    extends _$JournalFileCopyWithImpl<$Res, _$JournalFileImpl>
    implements _$$JournalFileImplCopyWith<$Res> {
  __$$JournalFileImplCopyWithImpl(
      _$JournalFileImpl _value, $Res Function(_$JournalFileImpl) _then)
      : super(_value, _then);

  /// Create a copy of JournalFile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? username = null,
    Object? time_stamp = null,
    Object? events = null,
    Object? daily_reflection = null,
  }) {
    return _then(_$JournalFileImpl(
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      time_stamp: null == time_stamp
          ? _value.time_stamp
          : time_stamp // ignore: cast_nullable_to_non_nullable
              as String,
      events: null == events
          ? _value._events
          : events // ignore: cast_nullable_to_non_nullable
              as List<EventAnalysis>,
      daily_reflection: null == daily_reflection
          ? _value.daily_reflection
          : daily_reflection // ignore: cast_nullable_to_non_nullable
              as DailyReflection,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$JournalFileImpl implements _JournalFile {
  const _$JournalFileImpl(
      {required this.username,
      required this.time_stamp,
      required final List<EventAnalysis> events,
      required this.daily_reflection})
      : _events = events;

  factory _$JournalFileImpl.fromJson(Map<String, dynamic> json) =>
      _$$JournalFileImplFromJson(json);

  @override
  final String username;
  @override
  final String time_stamp;
  final List<EventAnalysis> _events;
  @override
  List<EventAnalysis> get events {
    if (_events is EqualUnmodifiableListView) return _events;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_events);
  }

  @override
  final DailyReflection daily_reflection;

  @override
  String toString() {
    return 'JournalFile(username: $username, time_stamp: $time_stamp, events: $events, daily_reflection: $daily_reflection)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$JournalFileImpl &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.time_stamp, time_stamp) ||
                other.time_stamp == time_stamp) &&
            const DeepCollectionEquality().equals(other._events, _events) &&
            (identical(other.daily_reflection, daily_reflection) ||
                other.daily_reflection == daily_reflection));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, username, time_stamp,
      const DeepCollectionEquality().hash(_events), daily_reflection);

  /// Create a copy of JournalFile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$JournalFileImplCopyWith<_$JournalFileImpl> get copyWith =>
      __$$JournalFileImplCopyWithImpl<_$JournalFileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$JournalFileImplToJson(
      this,
    );
  }
}

abstract class _JournalFile implements JournalFile {
  const factory _JournalFile(
      {required final String username,
      required final String time_stamp,
      required final List<EventAnalysis> events,
      required final DailyReflection daily_reflection}) = _$JournalFileImpl;

  factory _JournalFile.fromJson(Map<String, dynamic> json) =
      _$JournalFileImpl.fromJson;

  @override
  String get username;
  @override
  String get time_stamp;
  @override
  List<EventAnalysis> get events;
  @override
  DailyReflection get daily_reflection;

  /// Create a copy of JournalFile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$JournalFileImplCopyWith<_$JournalFileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
