// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mental_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MentalStatePoint _$MentalStatePointFromJson(Map<String, dynamic> json) {
  return _MentalStatePoint.fromJson(json);
}

/// @nodoc
mixin _$MentalStatePoint {
  DateTime get timestamp => throw _privateConstructorUsedError;
  @JsonKey(name: 'energy_score')
  double get energyScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'stress_score')
  double get stressScore => throw _privateConstructorUsedError;
  @JsonKey(name: 'mood_score')
  double? get moodScore => throw _privateConstructorUsedError;
  double get confidence => throw _privateConstructorUsedError;
  @JsonKey(name: 'data_source')
  String get dataSource => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_id')
  String? get eventId => throw _privateConstructorUsedError;

  /// Serializes this MentalStatePoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MentalStatePoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MentalStatePointCopyWith<MentalStatePoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MentalStatePointCopyWith<$Res> {
  factory $MentalStatePointCopyWith(
          MentalStatePoint value, $Res Function(MentalStatePoint) then) =
      _$MentalStatePointCopyWithImpl<$Res, MentalStatePoint>;
  @useResult
  $Res call(
      {DateTime timestamp,
      @JsonKey(name: 'energy_score') double energyScore,
      @JsonKey(name: 'stress_score') double stressScore,
      @JsonKey(name: 'mood_score') double? moodScore,
      double confidence,
      @JsonKey(name: 'data_source') String dataSource,
      @JsonKey(name: 'event_id') String? eventId});
}

/// @nodoc
class _$MentalStatePointCopyWithImpl<$Res, $Val extends MentalStatePoint>
    implements $MentalStatePointCopyWith<$Res> {
  _$MentalStatePointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MentalStatePoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? energyScore = null,
    Object? stressScore = null,
    Object? moodScore = freezed,
    Object? confidence = null,
    Object? dataSource = null,
    Object? eventId = freezed,
  }) {
    return _then(_value.copyWith(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      energyScore: null == energyScore
          ? _value.energyScore
          : energyScore // ignore: cast_nullable_to_non_nullable
              as double,
      stressScore: null == stressScore
          ? _value.stressScore
          : stressScore // ignore: cast_nullable_to_non_nullable
              as double,
      moodScore: freezed == moodScore
          ? _value.moodScore
          : moodScore // ignore: cast_nullable_to_non_nullable
              as double?,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      dataSource: null == dataSource
          ? _value.dataSource
          : dataSource // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MentalStatePointImplCopyWith<$Res>
    implements $MentalStatePointCopyWith<$Res> {
  factory _$$MentalStatePointImplCopyWith(_$MentalStatePointImpl value,
          $Res Function(_$MentalStatePointImpl) then) =
      __$$MentalStatePointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime timestamp,
      @JsonKey(name: 'energy_score') double energyScore,
      @JsonKey(name: 'stress_score') double stressScore,
      @JsonKey(name: 'mood_score') double? moodScore,
      double confidence,
      @JsonKey(name: 'data_source') String dataSource,
      @JsonKey(name: 'event_id') String? eventId});
}

/// @nodoc
class __$$MentalStatePointImplCopyWithImpl<$Res>
    extends _$MentalStatePointCopyWithImpl<$Res, _$MentalStatePointImpl>
    implements _$$MentalStatePointImplCopyWith<$Res> {
  __$$MentalStatePointImplCopyWithImpl(_$MentalStatePointImpl _value,
      $Res Function(_$MentalStatePointImpl) _then)
      : super(_value, _then);

  /// Create a copy of MentalStatePoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? timestamp = null,
    Object? energyScore = null,
    Object? stressScore = null,
    Object? moodScore = freezed,
    Object? confidence = null,
    Object? dataSource = null,
    Object? eventId = freezed,
  }) {
    return _then(_$MentalStatePointImpl(
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      energyScore: null == energyScore
          ? _value.energyScore
          : energyScore // ignore: cast_nullable_to_non_nullable
              as double,
      stressScore: null == stressScore
          ? _value.stressScore
          : stressScore // ignore: cast_nullable_to_non_nullable
              as double,
      moodScore: freezed == moodScore
          ? _value.moodScore
          : moodScore // ignore: cast_nullable_to_non_nullable
              as double?,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      dataSource: null == dataSource
          ? _value.dataSource
          : dataSource // ignore: cast_nullable_to_non_nullable
              as String,
      eventId: freezed == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MentalStatePointImpl implements _MentalStatePoint {
  const _$MentalStatePointImpl(
      {required this.timestamp,
      @JsonKey(name: 'energy_score') required this.energyScore,
      @JsonKey(name: 'stress_score') required this.stressScore,
      @JsonKey(name: 'mood_score') this.moodScore,
      required this.confidence,
      @JsonKey(name: 'data_source') required this.dataSource,
      @JsonKey(name: 'event_id') this.eventId});

  factory _$MentalStatePointImpl.fromJson(Map<String, dynamic> json) =>
      _$$MentalStatePointImplFromJson(json);

  @override
  final DateTime timestamp;
  @override
  @JsonKey(name: 'energy_score')
  final double energyScore;
  @override
  @JsonKey(name: 'stress_score')
  final double stressScore;
  @override
  @JsonKey(name: 'mood_score')
  final double? moodScore;
  @override
  final double confidence;
  @override
  @JsonKey(name: 'data_source')
  final String dataSource;
  @override
  @JsonKey(name: 'event_id')
  final String? eventId;

  @override
  String toString() {
    return 'MentalStatePoint(timestamp: $timestamp, energyScore: $energyScore, stressScore: $stressScore, moodScore: $moodScore, confidence: $confidence, dataSource: $dataSource, eventId: $eventId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MentalStatePointImpl &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.energyScore, energyScore) ||
                other.energyScore == energyScore) &&
            (identical(other.stressScore, stressScore) ||
                other.stressScore == stressScore) &&
            (identical(other.moodScore, moodScore) ||
                other.moodScore == moodScore) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.dataSource, dataSource) ||
                other.dataSource == dataSource) &&
            (identical(other.eventId, eventId) || other.eventId == eventId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, timestamp, energyScore,
      stressScore, moodScore, confidence, dataSource, eventId);

  /// Create a copy of MentalStatePoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MentalStatePointImplCopyWith<_$MentalStatePointImpl> get copyWith =>
      __$$MentalStatePointImplCopyWithImpl<_$MentalStatePointImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MentalStatePointImplToJson(
      this,
    );
  }
}

abstract class _MentalStatePoint implements MentalStatePoint {
  const factory _MentalStatePoint(
          {required final DateTime timestamp,
          @JsonKey(name: 'energy_score') required final double energyScore,
          @JsonKey(name: 'stress_score') required final double stressScore,
          @JsonKey(name: 'mood_score') final double? moodScore,
          required final double confidence,
          @JsonKey(name: 'data_source') required final String dataSource,
          @JsonKey(name: 'event_id') final String? eventId}) =
      _$MentalStatePointImpl;

  factory _MentalStatePoint.fromJson(Map<String, dynamic> json) =
      _$MentalStatePointImpl.fromJson;

  @override
  DateTime get timestamp;
  @override
  @JsonKey(name: 'energy_score')
  double get energyScore;
  @override
  @JsonKey(name: 'stress_score')
  double get stressScore;
  @override
  @JsonKey(name: 'mood_score')
  double? get moodScore;
  @override
  double get confidence;
  @override
  @JsonKey(name: 'data_source')
  String get dataSource;
  @override
  @JsonKey(name: 'event_id')
  String? get eventId;

  /// Create a copy of MentalStatePoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MentalStatePointImplCopyWith<_$MentalStatePointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DailyMentalStateStats _$DailyMentalStateStatsFromJson(
    Map<String, dynamic> json) {
  return _DailyMentalStateStats.fromJson(json);
}

/// @nodoc
mixin _$DailyMentalStateStats {
  @JsonKey(name: 'avg_energy')
  double get avgEnergy => throw _privateConstructorUsedError;
  @JsonKey(name: 'avg_stress')
  double get avgStress => throw _privateConstructorUsedError;
  @JsonKey(name: 'avg_mood')
  double? get avgMood => throw _privateConstructorUsedError;
  @JsonKey(name: 'peak_energy_time')
  String get peakEnergyTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'peak_stress_time')
  String get peakStressTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'peak_mood_time')
  String? get peakMoodTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'optimal_state_minutes')
  int get optimalStateMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'burnout_risk_minutes')
  int get burnoutRiskMinutes => throw _privateConstructorUsedError;
  @JsonKey(name: 'recovery_periods')
  int get recoveryPeriods => throw _privateConstructorUsedError;

  /// Serializes this DailyMentalStateStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DailyMentalStateStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DailyMentalStateStatsCopyWith<DailyMentalStateStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DailyMentalStateStatsCopyWith<$Res> {
  factory $DailyMentalStateStatsCopyWith(DailyMentalStateStats value,
          $Res Function(DailyMentalStateStats) then) =
      _$DailyMentalStateStatsCopyWithImpl<$Res, DailyMentalStateStats>;
  @useResult
  $Res call(
      {@JsonKey(name: 'avg_energy') double avgEnergy,
      @JsonKey(name: 'avg_stress') double avgStress,
      @JsonKey(name: 'avg_mood') double? avgMood,
      @JsonKey(name: 'peak_energy_time') String peakEnergyTime,
      @JsonKey(name: 'peak_stress_time') String peakStressTime,
      @JsonKey(name: 'peak_mood_time') String? peakMoodTime,
      @JsonKey(name: 'optimal_state_minutes') int optimalStateMinutes,
      @JsonKey(name: 'burnout_risk_minutes') int burnoutRiskMinutes,
      @JsonKey(name: 'recovery_periods') int recoveryPeriods});
}

/// @nodoc
class _$DailyMentalStateStatsCopyWithImpl<$Res,
        $Val extends DailyMentalStateStats>
    implements $DailyMentalStateStatsCopyWith<$Res> {
  _$DailyMentalStateStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DailyMentalStateStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? avgEnergy = null,
    Object? avgStress = null,
    Object? avgMood = freezed,
    Object? peakEnergyTime = null,
    Object? peakStressTime = null,
    Object? peakMoodTime = freezed,
    Object? optimalStateMinutes = null,
    Object? burnoutRiskMinutes = null,
    Object? recoveryPeriods = null,
  }) {
    return _then(_value.copyWith(
      avgEnergy: null == avgEnergy
          ? _value.avgEnergy
          : avgEnergy // ignore: cast_nullable_to_non_nullable
              as double,
      avgStress: null == avgStress
          ? _value.avgStress
          : avgStress // ignore: cast_nullable_to_non_nullable
              as double,
      avgMood: freezed == avgMood
          ? _value.avgMood
          : avgMood // ignore: cast_nullable_to_non_nullable
              as double?,
      peakEnergyTime: null == peakEnergyTime
          ? _value.peakEnergyTime
          : peakEnergyTime // ignore: cast_nullable_to_non_nullable
              as String,
      peakStressTime: null == peakStressTime
          ? _value.peakStressTime
          : peakStressTime // ignore: cast_nullable_to_non_nullable
              as String,
      peakMoodTime: freezed == peakMoodTime
          ? _value.peakMoodTime
          : peakMoodTime // ignore: cast_nullable_to_non_nullable
              as String?,
      optimalStateMinutes: null == optimalStateMinutes
          ? _value.optimalStateMinutes
          : optimalStateMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      burnoutRiskMinutes: null == burnoutRiskMinutes
          ? _value.burnoutRiskMinutes
          : burnoutRiskMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      recoveryPeriods: null == recoveryPeriods
          ? _value.recoveryPeriods
          : recoveryPeriods // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DailyMentalStateStatsImplCopyWith<$Res>
    implements $DailyMentalStateStatsCopyWith<$Res> {
  factory _$$DailyMentalStateStatsImplCopyWith(
          _$DailyMentalStateStatsImpl value,
          $Res Function(_$DailyMentalStateStatsImpl) then) =
      __$$DailyMentalStateStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'avg_energy') double avgEnergy,
      @JsonKey(name: 'avg_stress') double avgStress,
      @JsonKey(name: 'avg_mood') double? avgMood,
      @JsonKey(name: 'peak_energy_time') String peakEnergyTime,
      @JsonKey(name: 'peak_stress_time') String peakStressTime,
      @JsonKey(name: 'peak_mood_time') String? peakMoodTime,
      @JsonKey(name: 'optimal_state_minutes') int optimalStateMinutes,
      @JsonKey(name: 'burnout_risk_minutes') int burnoutRiskMinutes,
      @JsonKey(name: 'recovery_periods') int recoveryPeriods});
}

/// @nodoc
class __$$DailyMentalStateStatsImplCopyWithImpl<$Res>
    extends _$DailyMentalStateStatsCopyWithImpl<$Res,
        _$DailyMentalStateStatsImpl>
    implements _$$DailyMentalStateStatsImplCopyWith<$Res> {
  __$$DailyMentalStateStatsImplCopyWithImpl(_$DailyMentalStateStatsImpl _value,
      $Res Function(_$DailyMentalStateStatsImpl) _then)
      : super(_value, _then);

  /// Create a copy of DailyMentalStateStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? avgEnergy = null,
    Object? avgStress = null,
    Object? avgMood = freezed,
    Object? peakEnergyTime = null,
    Object? peakStressTime = null,
    Object? peakMoodTime = freezed,
    Object? optimalStateMinutes = null,
    Object? burnoutRiskMinutes = null,
    Object? recoveryPeriods = null,
  }) {
    return _then(_$DailyMentalStateStatsImpl(
      avgEnergy: null == avgEnergy
          ? _value.avgEnergy
          : avgEnergy // ignore: cast_nullable_to_non_nullable
              as double,
      avgStress: null == avgStress
          ? _value.avgStress
          : avgStress // ignore: cast_nullable_to_non_nullable
              as double,
      avgMood: freezed == avgMood
          ? _value.avgMood
          : avgMood // ignore: cast_nullable_to_non_nullable
              as double?,
      peakEnergyTime: null == peakEnergyTime
          ? _value.peakEnergyTime
          : peakEnergyTime // ignore: cast_nullable_to_non_nullable
              as String,
      peakStressTime: null == peakStressTime
          ? _value.peakStressTime
          : peakStressTime // ignore: cast_nullable_to_non_nullable
              as String,
      peakMoodTime: freezed == peakMoodTime
          ? _value.peakMoodTime
          : peakMoodTime // ignore: cast_nullable_to_non_nullable
              as String?,
      optimalStateMinutes: null == optimalStateMinutes
          ? _value.optimalStateMinutes
          : optimalStateMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      burnoutRiskMinutes: null == burnoutRiskMinutes
          ? _value.burnoutRiskMinutes
          : burnoutRiskMinutes // ignore: cast_nullable_to_non_nullable
              as int,
      recoveryPeriods: null == recoveryPeriods
          ? _value.recoveryPeriods
          : recoveryPeriods // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DailyMentalStateStatsImpl implements _DailyMentalStateStats {
  const _$DailyMentalStateStatsImpl(
      {@JsonKey(name: 'avg_energy') required this.avgEnergy,
      @JsonKey(name: 'avg_stress') required this.avgStress,
      @JsonKey(name: 'avg_mood') this.avgMood,
      @JsonKey(name: 'peak_energy_time') required this.peakEnergyTime,
      @JsonKey(name: 'peak_stress_time') required this.peakStressTime,
      @JsonKey(name: 'peak_mood_time') this.peakMoodTime,
      @JsonKey(name: 'optimal_state_minutes') required this.optimalStateMinutes,
      @JsonKey(name: 'burnout_risk_minutes') required this.burnoutRiskMinutes,
      @JsonKey(name: 'recovery_periods') required this.recoveryPeriods});

  factory _$DailyMentalStateStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DailyMentalStateStatsImplFromJson(json);

  @override
  @JsonKey(name: 'avg_energy')
  final double avgEnergy;
  @override
  @JsonKey(name: 'avg_stress')
  final double avgStress;
  @override
  @JsonKey(name: 'avg_mood')
  final double? avgMood;
  @override
  @JsonKey(name: 'peak_energy_time')
  final String peakEnergyTime;
  @override
  @JsonKey(name: 'peak_stress_time')
  final String peakStressTime;
  @override
  @JsonKey(name: 'peak_mood_time')
  final String? peakMoodTime;
  @override
  @JsonKey(name: 'optimal_state_minutes')
  final int optimalStateMinutes;
  @override
  @JsonKey(name: 'burnout_risk_minutes')
  final int burnoutRiskMinutes;
  @override
  @JsonKey(name: 'recovery_periods')
  final int recoveryPeriods;

  @override
  String toString() {
    return 'DailyMentalStateStats(avgEnergy: $avgEnergy, avgStress: $avgStress, avgMood: $avgMood, peakEnergyTime: $peakEnergyTime, peakStressTime: $peakStressTime, peakMoodTime: $peakMoodTime, optimalStateMinutes: $optimalStateMinutes, burnoutRiskMinutes: $burnoutRiskMinutes, recoveryPeriods: $recoveryPeriods)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyMentalStateStatsImpl &&
            (identical(other.avgEnergy, avgEnergy) ||
                other.avgEnergy == avgEnergy) &&
            (identical(other.avgStress, avgStress) ||
                other.avgStress == avgStress) &&
            (identical(other.avgMood, avgMood) || other.avgMood == avgMood) &&
            (identical(other.peakEnergyTime, peakEnergyTime) ||
                other.peakEnergyTime == peakEnergyTime) &&
            (identical(other.peakStressTime, peakStressTime) ||
                other.peakStressTime == peakStressTime) &&
            (identical(other.peakMoodTime, peakMoodTime) ||
                other.peakMoodTime == peakMoodTime) &&
            (identical(other.optimalStateMinutes, optimalStateMinutes) ||
                other.optimalStateMinutes == optimalStateMinutes) &&
            (identical(other.burnoutRiskMinutes, burnoutRiskMinutes) ||
                other.burnoutRiskMinutes == burnoutRiskMinutes) &&
            (identical(other.recoveryPeriods, recoveryPeriods) ||
                other.recoveryPeriods == recoveryPeriods));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      avgEnergy,
      avgStress,
      avgMood,
      peakEnergyTime,
      peakStressTime,
      peakMoodTime,
      optimalStateMinutes,
      burnoutRiskMinutes,
      recoveryPeriods);

  /// Create a copy of DailyMentalStateStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyMentalStateStatsImplCopyWith<_$DailyMentalStateStatsImpl>
      get copyWith => __$$DailyMentalStateStatsImplCopyWithImpl<
          _$DailyMentalStateStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DailyMentalStateStatsImplToJson(
      this,
    );
  }
}

abstract class _DailyMentalStateStats implements DailyMentalStateStats {
  const factory _DailyMentalStateStats(
      {@JsonKey(name: 'avg_energy') required final double avgEnergy,
      @JsonKey(name: 'avg_stress') required final double avgStress,
      @JsonKey(name: 'avg_mood') final double? avgMood,
      @JsonKey(name: 'peak_energy_time') required final String peakEnergyTime,
      @JsonKey(name: 'peak_stress_time') required final String peakStressTime,
      @JsonKey(name: 'peak_mood_time') final String? peakMoodTime,
      @JsonKey(name: 'optimal_state_minutes')
      required final int optimalStateMinutes,
      @JsonKey(name: 'burnout_risk_minutes')
      required final int burnoutRiskMinutes,
      @JsonKey(name: 'recovery_periods')
      required final int recoveryPeriods}) = _$DailyMentalStateStatsImpl;

  factory _DailyMentalStateStats.fromJson(Map<String, dynamic> json) =
      _$DailyMentalStateStatsImpl.fromJson;

  @override
  @JsonKey(name: 'avg_energy')
  double get avgEnergy;
  @override
  @JsonKey(name: 'avg_stress')
  double get avgStress;
  @override
  @JsonKey(name: 'avg_mood')
  double? get avgMood;
  @override
  @JsonKey(name: 'peak_energy_time')
  String get peakEnergyTime;
  @override
  @JsonKey(name: 'peak_stress_time')
  String get peakStressTime;
  @override
  @JsonKey(name: 'peak_mood_time')
  String? get peakMoodTime;
  @override
  @JsonKey(name: 'optimal_state_minutes')
  int get optimalStateMinutes;
  @override
  @JsonKey(name: 'burnout_risk_minutes')
  int get burnoutRiskMinutes;
  @override
  @JsonKey(name: 'recovery_periods')
  int get recoveryPeriods;

  /// Create a copy of DailyMentalStateStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DailyMentalStateStatsImplCopyWith<_$DailyMentalStateStatsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

MentalStatePattern _$MentalStatePatternFromJson(Map<String, dynamic> json) {
  return _MentalStatePattern.fromJson(json);
}

/// @nodoc
mixin _$MentalStatePattern {
  @JsonKey(name: 'pattern_type')
  String get patternType => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get frequency => throw _privateConstructorUsedError;
  String get impact => throw _privateConstructorUsedError;

  /// Serializes this MentalStatePattern to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MentalStatePattern
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MentalStatePatternCopyWith<MentalStatePattern> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MentalStatePatternCopyWith<$Res> {
  factory $MentalStatePatternCopyWith(
          MentalStatePattern value, $Res Function(MentalStatePattern) then) =
      _$MentalStatePatternCopyWithImpl<$Res, MentalStatePattern>;
  @useResult
  $Res call(
      {@JsonKey(name: 'pattern_type') String patternType,
      String description,
      String frequency,
      String impact});
}

/// @nodoc
class _$MentalStatePatternCopyWithImpl<$Res, $Val extends MentalStatePattern>
    implements $MentalStatePatternCopyWith<$Res> {
  _$MentalStatePatternCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MentalStatePattern
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? patternType = null,
    Object? description = null,
    Object? frequency = null,
    Object? impact = null,
  }) {
    return _then(_value.copyWith(
      patternType: null == patternType
          ? _value.patternType
          : patternType // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String,
      impact: null == impact
          ? _value.impact
          : impact // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MentalStatePatternImplCopyWith<$Res>
    implements $MentalStatePatternCopyWith<$Res> {
  factory _$$MentalStatePatternImplCopyWith(_$MentalStatePatternImpl value,
          $Res Function(_$MentalStatePatternImpl) then) =
      __$$MentalStatePatternImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'pattern_type') String patternType,
      String description,
      String frequency,
      String impact});
}

/// @nodoc
class __$$MentalStatePatternImplCopyWithImpl<$Res>
    extends _$MentalStatePatternCopyWithImpl<$Res, _$MentalStatePatternImpl>
    implements _$$MentalStatePatternImplCopyWith<$Res> {
  __$$MentalStatePatternImplCopyWithImpl(_$MentalStatePatternImpl _value,
      $Res Function(_$MentalStatePatternImpl) _then)
      : super(_value, _then);

  /// Create a copy of MentalStatePattern
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? patternType = null,
    Object? description = null,
    Object? frequency = null,
    Object? impact = null,
  }) {
    return _then(_$MentalStatePatternImpl(
      patternType: null == patternType
          ? _value.patternType
          : patternType // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String,
      impact: null == impact
          ? _value.impact
          : impact // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MentalStatePatternImpl implements _MentalStatePattern {
  const _$MentalStatePatternImpl(
      {@JsonKey(name: 'pattern_type') required this.patternType,
      required this.description,
      required this.frequency,
      required this.impact});

  factory _$MentalStatePatternImpl.fromJson(Map<String, dynamic> json) =>
      _$$MentalStatePatternImplFromJson(json);

  @override
  @JsonKey(name: 'pattern_type')
  final String patternType;
  @override
  final String description;
  @override
  final String frequency;
  @override
  final String impact;

  @override
  String toString() {
    return 'MentalStatePattern(patternType: $patternType, description: $description, frequency: $frequency, impact: $impact)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MentalStatePatternImpl &&
            (identical(other.patternType, patternType) ||
                other.patternType == patternType) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.impact, impact) || other.impact == impact));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, patternType, description, frequency, impact);

  /// Create a copy of MentalStatePattern
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MentalStatePatternImplCopyWith<_$MentalStatePatternImpl> get copyWith =>
      __$$MentalStatePatternImplCopyWithImpl<_$MentalStatePatternImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MentalStatePatternImplToJson(
      this,
    );
  }
}

abstract class _MentalStatePattern implements MentalStatePattern {
  const factory _MentalStatePattern(
      {@JsonKey(name: 'pattern_type') required final String patternType,
      required final String description,
      required final String frequency,
      required final String impact}) = _$MentalStatePatternImpl;

  factory _MentalStatePattern.fromJson(Map<String, dynamic> json) =
      _$MentalStatePatternImpl.fromJson;

  @override
  @JsonKey(name: 'pattern_type')
  String get patternType;
  @override
  String get description;
  @override
  String get frequency;
  @override
  String get impact;

  /// Create a copy of MentalStatePattern
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MentalStatePatternImplCopyWith<_$MentalStatePatternImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MentalStateInsights _$MentalStateInsightsFromJson(Map<String, dynamic> json) {
  return _MentalStateInsights.fromJson(json);
}

/// @nodoc
mixin _$MentalStateInsights {
  @JsonKey(name: 'current_state')
  MentalStatePoint get currentState => throw _privateConstructorUsedError;
  @JsonKey(name: 'timeline_24h')
  List<MentalStatePoint> get timeline24h => throw _privateConstructorUsedError;
  @JsonKey(name: 'timeline_7d')
  List<MentalStatePoint> get timeline7d => throw _privateConstructorUsedError;
  @JsonKey(name: 'daily_stats')
  DailyMentalStateStats get dailyStats => throw _privateConstructorUsedError;
  List<MentalStatePattern> get patterns => throw _privateConstructorUsedError;
  List<String> get recommendations => throw _privateConstructorUsedError;
  @JsonKey(name: 'risk_indicators')
  Map<String, dynamic> get riskIndicators => throw _privateConstructorUsedError;

  /// Serializes this MentalStateInsights to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MentalStateInsights
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MentalStateInsightsCopyWith<MentalStateInsights> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MentalStateInsightsCopyWith<$Res> {
  factory $MentalStateInsightsCopyWith(
          MentalStateInsights value, $Res Function(MentalStateInsights) then) =
      _$MentalStateInsightsCopyWithImpl<$Res, MentalStateInsights>;
  @useResult
  $Res call(
      {@JsonKey(name: 'current_state') MentalStatePoint currentState,
      @JsonKey(name: 'timeline_24h') List<MentalStatePoint> timeline24h,
      @JsonKey(name: 'timeline_7d') List<MentalStatePoint> timeline7d,
      @JsonKey(name: 'daily_stats') DailyMentalStateStats dailyStats,
      List<MentalStatePattern> patterns,
      List<String> recommendations,
      @JsonKey(name: 'risk_indicators') Map<String, dynamic> riskIndicators});

  $MentalStatePointCopyWith<$Res> get currentState;
  $DailyMentalStateStatsCopyWith<$Res> get dailyStats;
}

/// @nodoc
class _$MentalStateInsightsCopyWithImpl<$Res, $Val extends MentalStateInsights>
    implements $MentalStateInsightsCopyWith<$Res> {
  _$MentalStateInsightsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MentalStateInsights
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentState = null,
    Object? timeline24h = null,
    Object? timeline7d = null,
    Object? dailyStats = null,
    Object? patterns = null,
    Object? recommendations = null,
    Object? riskIndicators = null,
  }) {
    return _then(_value.copyWith(
      currentState: null == currentState
          ? _value.currentState
          : currentState // ignore: cast_nullable_to_non_nullable
              as MentalStatePoint,
      timeline24h: null == timeline24h
          ? _value.timeline24h
          : timeline24h // ignore: cast_nullable_to_non_nullable
              as List<MentalStatePoint>,
      timeline7d: null == timeline7d
          ? _value.timeline7d
          : timeline7d // ignore: cast_nullable_to_non_nullable
              as List<MentalStatePoint>,
      dailyStats: null == dailyStats
          ? _value.dailyStats
          : dailyStats // ignore: cast_nullable_to_non_nullable
              as DailyMentalStateStats,
      patterns: null == patterns
          ? _value.patterns
          : patterns // ignore: cast_nullable_to_non_nullable
              as List<MentalStatePattern>,
      recommendations: null == recommendations
          ? _value.recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      riskIndicators: null == riskIndicators
          ? _value.riskIndicators
          : riskIndicators // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }

  /// Create a copy of MentalStateInsights
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MentalStatePointCopyWith<$Res> get currentState {
    return $MentalStatePointCopyWith<$Res>(_value.currentState, (value) {
      return _then(_value.copyWith(currentState: value) as $Val);
    });
  }

  /// Create a copy of MentalStateInsights
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DailyMentalStateStatsCopyWith<$Res> get dailyStats {
    return $DailyMentalStateStatsCopyWith<$Res>(_value.dailyStats, (value) {
      return _then(_value.copyWith(dailyStats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$MentalStateInsightsImplCopyWith<$Res>
    implements $MentalStateInsightsCopyWith<$Res> {
  factory _$$MentalStateInsightsImplCopyWith(_$MentalStateInsightsImpl value,
          $Res Function(_$MentalStateInsightsImpl) then) =
      __$$MentalStateInsightsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'current_state') MentalStatePoint currentState,
      @JsonKey(name: 'timeline_24h') List<MentalStatePoint> timeline24h,
      @JsonKey(name: 'timeline_7d') List<MentalStatePoint> timeline7d,
      @JsonKey(name: 'daily_stats') DailyMentalStateStats dailyStats,
      List<MentalStatePattern> patterns,
      List<String> recommendations,
      @JsonKey(name: 'risk_indicators') Map<String, dynamic> riskIndicators});

  @override
  $MentalStatePointCopyWith<$Res> get currentState;
  @override
  $DailyMentalStateStatsCopyWith<$Res> get dailyStats;
}

/// @nodoc
class __$$MentalStateInsightsImplCopyWithImpl<$Res>
    extends _$MentalStateInsightsCopyWithImpl<$Res, _$MentalStateInsightsImpl>
    implements _$$MentalStateInsightsImplCopyWith<$Res> {
  __$$MentalStateInsightsImplCopyWithImpl(_$MentalStateInsightsImpl _value,
      $Res Function(_$MentalStateInsightsImpl) _then)
      : super(_value, _then);

  /// Create a copy of MentalStateInsights
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentState = null,
    Object? timeline24h = null,
    Object? timeline7d = null,
    Object? dailyStats = null,
    Object? patterns = null,
    Object? recommendations = null,
    Object? riskIndicators = null,
  }) {
    return _then(_$MentalStateInsightsImpl(
      currentState: null == currentState
          ? _value.currentState
          : currentState // ignore: cast_nullable_to_non_nullable
              as MentalStatePoint,
      timeline24h: null == timeline24h
          ? _value._timeline24h
          : timeline24h // ignore: cast_nullable_to_non_nullable
              as List<MentalStatePoint>,
      timeline7d: null == timeline7d
          ? _value._timeline7d
          : timeline7d // ignore: cast_nullable_to_non_nullable
              as List<MentalStatePoint>,
      dailyStats: null == dailyStats
          ? _value.dailyStats
          : dailyStats // ignore: cast_nullable_to_non_nullable
              as DailyMentalStateStats,
      patterns: null == patterns
          ? _value._patterns
          : patterns // ignore: cast_nullable_to_non_nullable
              as List<MentalStatePattern>,
      recommendations: null == recommendations
          ? _value._recommendations
          : recommendations // ignore: cast_nullable_to_non_nullable
              as List<String>,
      riskIndicators: null == riskIndicators
          ? _value._riskIndicators
          : riskIndicators // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MentalStateInsightsImpl implements _MentalStateInsights {
  const _$MentalStateInsightsImpl(
      {@JsonKey(name: 'current_state') required this.currentState,
      @JsonKey(name: 'timeline_24h')
      required final List<MentalStatePoint> timeline24h,
      @JsonKey(name: 'timeline_7d')
      required final List<MentalStatePoint> timeline7d,
      @JsonKey(name: 'daily_stats') required this.dailyStats,
      required final List<MentalStatePattern> patterns,
      required final List<String> recommendations,
      @JsonKey(name: 'risk_indicators')
      required final Map<String, dynamic> riskIndicators})
      : _timeline24h = timeline24h,
        _timeline7d = timeline7d,
        _patterns = patterns,
        _recommendations = recommendations,
        _riskIndicators = riskIndicators;

  factory _$MentalStateInsightsImpl.fromJson(Map<String, dynamic> json) =>
      _$$MentalStateInsightsImplFromJson(json);

  @override
  @JsonKey(name: 'current_state')
  final MentalStatePoint currentState;
  final List<MentalStatePoint> _timeline24h;
  @override
  @JsonKey(name: 'timeline_24h')
  List<MentalStatePoint> get timeline24h {
    if (_timeline24h is EqualUnmodifiableListView) return _timeline24h;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_timeline24h);
  }

  final List<MentalStatePoint> _timeline7d;
  @override
  @JsonKey(name: 'timeline_7d')
  List<MentalStatePoint> get timeline7d {
    if (_timeline7d is EqualUnmodifiableListView) return _timeline7d;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_timeline7d);
  }

  @override
  @JsonKey(name: 'daily_stats')
  final DailyMentalStateStats dailyStats;
  final List<MentalStatePattern> _patterns;
  @override
  List<MentalStatePattern> get patterns {
    if (_patterns is EqualUnmodifiableListView) return _patterns;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_patterns);
  }

  final List<String> _recommendations;
  @override
  List<String> get recommendations {
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendations);
  }

  final Map<String, dynamic> _riskIndicators;
  @override
  @JsonKey(name: 'risk_indicators')
  Map<String, dynamic> get riskIndicators {
    if (_riskIndicators is EqualUnmodifiableMapView) return _riskIndicators;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_riskIndicators);
  }

  @override
  String toString() {
    return 'MentalStateInsights(currentState: $currentState, timeline24h: $timeline24h, timeline7d: $timeline7d, dailyStats: $dailyStats, patterns: $patterns, recommendations: $recommendations, riskIndicators: $riskIndicators)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MentalStateInsightsImpl &&
            (identical(other.currentState, currentState) ||
                other.currentState == currentState) &&
            const DeepCollectionEquality()
                .equals(other._timeline24h, _timeline24h) &&
            const DeepCollectionEquality()
                .equals(other._timeline7d, _timeline7d) &&
            (identical(other.dailyStats, dailyStats) ||
                other.dailyStats == dailyStats) &&
            const DeepCollectionEquality().equals(other._patterns, _patterns) &&
            const DeepCollectionEquality()
                .equals(other._recommendations, _recommendations) &&
            const DeepCollectionEquality()
                .equals(other._riskIndicators, _riskIndicators));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentState,
      const DeepCollectionEquality().hash(_timeline24h),
      const DeepCollectionEquality().hash(_timeline7d),
      dailyStats,
      const DeepCollectionEquality().hash(_patterns),
      const DeepCollectionEquality().hash(_recommendations),
      const DeepCollectionEquality().hash(_riskIndicators));

  /// Create a copy of MentalStateInsights
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MentalStateInsightsImplCopyWith<_$MentalStateInsightsImpl> get copyWith =>
      __$$MentalStateInsightsImplCopyWithImpl<_$MentalStateInsightsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MentalStateInsightsImplToJson(
      this,
    );
  }
}

abstract class _MentalStateInsights implements MentalStateInsights {
  const factory _MentalStateInsights(
          {@JsonKey(name: 'current_state')
          required final MentalStatePoint currentState,
          @JsonKey(name: 'timeline_24h')
          required final List<MentalStatePoint> timeline24h,
          @JsonKey(name: 'timeline_7d')
          required final List<MentalStatePoint> timeline7d,
          @JsonKey(name: 'daily_stats')
          required final DailyMentalStateStats dailyStats,
          required final List<MentalStatePattern> patterns,
          required final List<String> recommendations,
          @JsonKey(name: 'risk_indicators')
          required final Map<String, dynamic> riskIndicators}) =
      _$MentalStateInsightsImpl;

  factory _MentalStateInsights.fromJson(Map<String, dynamic> json) =
      _$MentalStateInsightsImpl.fromJson;

  @override
  @JsonKey(name: 'current_state')
  MentalStatePoint get currentState;
  @override
  @JsonKey(name: 'timeline_24h')
  List<MentalStatePoint> get timeline24h;
  @override
  @JsonKey(name: 'timeline_7d')
  List<MentalStatePoint> get timeline7d;
  @override
  @JsonKey(name: 'daily_stats')
  DailyMentalStateStats get dailyStats;
  @override
  List<MentalStatePattern> get patterns;
  @override
  List<String> get recommendations;
  @override
  @JsonKey(name: 'risk_indicators')
  Map<String, dynamic> get riskIndicators;

  /// Create a copy of MentalStateInsights
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MentalStateInsightsImplCopyWith<_$MentalStateInsightsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
