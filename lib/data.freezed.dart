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
