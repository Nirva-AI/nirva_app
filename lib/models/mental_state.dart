import 'package:freezed_annotation/freezed_annotation.dart';

part 'mental_state.freezed.dart';
part 'mental_state.g.dart';

@freezed
class MentalStatePoint with _$MentalStatePoint {
  const factory MentalStatePoint({
    required DateTime timestamp,
    @JsonKey(name: 'energy_score') required double energyScore,
    @JsonKey(name: 'stress_score') required double stressScore,
    @JsonKey(name: 'mood_score') double? moodScore,
    required double confidence,
    @JsonKey(name: 'data_source') required String dataSource,
    @JsonKey(name: 'event_id') String? eventId,
  }) = _MentalStatePoint;

  factory MentalStatePoint.fromJson(Map<String, dynamic> json) =>
      _$MentalStatePointFromJson(json);
}

@freezed
class DailyMentalStateStats with _$DailyMentalStateStats {
  const factory DailyMentalStateStats({
    @JsonKey(name: 'avg_energy') required double avgEnergy,
    @JsonKey(name: 'avg_stress') required double avgStress,
    @JsonKey(name: 'avg_mood') double? avgMood,
    @JsonKey(name: 'peak_energy_time') required String peakEnergyTime,
    @JsonKey(name: 'peak_stress_time') required String peakStressTime,
    @JsonKey(name: 'peak_mood_time') String? peakMoodTime,
    @JsonKey(name: 'optimal_state_minutes') required int optimalStateMinutes,
    @JsonKey(name: 'burnout_risk_minutes') required int burnoutRiskMinutes,
    @JsonKey(name: 'recovery_periods') required int recoveryPeriods,
  }) = _DailyMentalStateStats;

  factory DailyMentalStateStats.fromJson(Map<String, dynamic> json) =>
      _$DailyMentalStateStatsFromJson(json);
}

@freezed
class MentalStatePattern with _$MentalStatePattern {
  const factory MentalStatePattern({
    @JsonKey(name: 'pattern_type') required String patternType,
    required String description,
    required String frequency,
    required String impact,
  }) = _MentalStatePattern;

  factory MentalStatePattern.fromJson(Map<String, dynamic> json) =>
      _$MentalStatePatternFromJson(json);
}

@freezed
class MentalStateInsights with _$MentalStateInsights {
  const factory MentalStateInsights({
    @JsonKey(name: 'current_state') required MentalStatePoint currentState,
    @JsonKey(name: 'timeline_24h') required List<MentalStatePoint> timeline24h,
    @JsonKey(name: 'timeline_7d') required List<MentalStatePoint> timeline7d,
    @JsonKey(name: 'daily_stats') required DailyMentalStateStats dailyStats,
    required List<MentalStatePattern> patterns,
    required List<String> recommendations,
    @JsonKey(name: 'risk_indicators') required Map<String, dynamic> riskIndicators,
  }) = _MentalStateInsights;

  factory MentalStateInsights.fromJson(Map<String, dynamic> json) =>
      _$MentalStateInsightsFromJson(json);
}