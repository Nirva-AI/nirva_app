// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mental_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MentalStatePointImpl _$$MentalStatePointImplFromJson(
        Map<String, dynamic> json) =>
    _$MentalStatePointImpl(
      timestamp: DateTime.parse(json['timestamp'] as String),
      energyScore: (json['energy_score'] as num).toDouble(),
      stressScore: (json['stress_score'] as num).toDouble(),
      moodScore: (json['mood_score'] as num?)?.toDouble(),
      confidence: (json['confidence'] as num).toDouble(),
      dataSource: json['data_source'] as String,
      eventId: json['event_id'] as String?,
    );

Map<String, dynamic> _$$MentalStatePointImplToJson(
        _$MentalStatePointImpl instance) =>
    <String, dynamic>{
      'timestamp': instance.timestamp.toIso8601String(),
      'energy_score': instance.energyScore,
      'stress_score': instance.stressScore,
      'mood_score': instance.moodScore,
      'confidence': instance.confidence,
      'data_source': instance.dataSource,
      'event_id': instance.eventId,
    };

_$DailyMentalStateStatsImpl _$$DailyMentalStateStatsImplFromJson(
        Map<String, dynamic> json) =>
    _$DailyMentalStateStatsImpl(
      avgEnergy: (json['avg_energy'] as num).toDouble(),
      avgStress: (json['avg_stress'] as num).toDouble(),
      avgMood: (json['avg_mood'] as num?)?.toDouble(),
      peakEnergyTime: json['peak_energy_time'] as String,
      peakStressTime: json['peak_stress_time'] as String,
      peakMoodTime: json['peak_mood_time'] as String?,
      optimalStateMinutes: (json['optimal_state_minutes'] as num).toInt(),
      burnoutRiskMinutes: (json['burnout_risk_minutes'] as num).toInt(),
      recoveryPeriods: (json['recovery_periods'] as num).toInt(),
    );

Map<String, dynamic> _$$DailyMentalStateStatsImplToJson(
        _$DailyMentalStateStatsImpl instance) =>
    <String, dynamic>{
      'avg_energy': instance.avgEnergy,
      'avg_stress': instance.avgStress,
      'avg_mood': instance.avgMood,
      'peak_energy_time': instance.peakEnergyTime,
      'peak_stress_time': instance.peakStressTime,
      'peak_mood_time': instance.peakMoodTime,
      'optimal_state_minutes': instance.optimalStateMinutes,
      'burnout_risk_minutes': instance.burnoutRiskMinutes,
      'recovery_periods': instance.recoveryPeriods,
    };

_$MentalStatePatternImpl _$$MentalStatePatternImplFromJson(
        Map<String, dynamic> json) =>
    _$MentalStatePatternImpl(
      patternType: json['pattern_type'] as String,
      description: json['description'] as String,
      frequency: json['frequency'] as String,
      impact: json['impact'] as String,
    );

Map<String, dynamic> _$$MentalStatePatternImplToJson(
        _$MentalStatePatternImpl instance) =>
    <String, dynamic>{
      'pattern_type': instance.patternType,
      'description': instance.description,
      'frequency': instance.frequency,
      'impact': instance.impact,
    };

_$MentalStateInsightsImpl _$$MentalStateInsightsImplFromJson(
        Map<String, dynamic> json) =>
    _$MentalStateInsightsImpl(
      currentState: MentalStatePoint.fromJson(
          json['current_state'] as Map<String, dynamic>),
      timeline24h: (json['timeline_24h'] as List<dynamic>)
          .map((e) => MentalStatePoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      timeline7d: (json['timeline_7d'] as List<dynamic>)
          .map((e) => MentalStatePoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      dailyStats: DailyMentalStateStats.fromJson(
          json['daily_stats'] as Map<String, dynamic>),
      patterns: (json['patterns'] as List<dynamic>)
          .map((e) => MentalStatePattern.fromJson(e as Map<String, dynamic>))
          .toList(),
      recommendations: (json['recommendations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      riskIndicators: json['risk_indicators'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$MentalStateInsightsImplToJson(
        _$MentalStateInsightsImpl instance) =>
    <String, dynamic>{
      'current_state': instance.currentState,
      'timeline_24h': instance.timeline24h,
      'timeline_7d': instance.timeline7d,
      'daily_stats': instance.dailyStats,
      'patterns': instance.patterns,
      'recommendations': instance.recommendations,
      'risk_indicators': instance.riskIndicators,
    };
