// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      displayName: json['displayName'] as String,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'password': instance.password,
      'displayName': instance.displayName,
    };

_$EventAnalysisImpl _$$EventAnalysisImplFromJson(Map<String, dynamic> json) =>
    _$EventAnalysisImpl(
      event_id: json['event_id'] as String,
      event_title: json['event_title'] as String,
      time_range: json['time_range'] as String,
      duration_minutes: (json['duration_minutes'] as num).toInt(),
      location: json['location'] as String,
      mood_labels: (json['mood_labels'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      mood_score: (json['mood_score'] as num).toInt(),
      stress_level: (json['stress_level'] as num).toInt(),
      energy_level: (json['energy_level'] as num).toInt(),
      activity_type: json['activity_type'] as String,
      people_involved: (json['people_involved'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      interaction_dynamic: json['interaction_dynamic'] as String,
      inferred_impact_on_user_name:
          json['inferred_impact_on_user_name'] as String,
      topic_labels: (json['topic_labels'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      one_sentence_summary: json['one_sentence_summary'] as String,
      first_person_narrative: json['first_person_narrative'] as String,
      action_item: json['action_item'] as String,
      event_status: json['event_status'] as String?,
      transcriptions: (json['transcriptions'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$$EventAnalysisImplToJson(_$EventAnalysisImpl instance) =>
    <String, dynamic>{
      'event_id': instance.event_id,
      'event_title': instance.event_title,
      'time_range': instance.time_range,
      'duration_minutes': instance.duration_minutes,
      'location': instance.location,
      'mood_labels': instance.mood_labels,
      'mood_score': instance.mood_score,
      'stress_level': instance.stress_level,
      'energy_level': instance.energy_level,
      'activity_type': instance.activity_type,
      'people_involved': instance.people_involved,
      'interaction_dynamic': instance.interaction_dynamic,
      'inferred_impact_on_user_name': instance.inferred_impact_on_user_name,
      'topic_labels': instance.topic_labels,
      'one_sentence_summary': instance.one_sentence_summary,
      'first_person_narrative': instance.first_person_narrative,
      'action_item': instance.action_item,
      'event_status': instance.event_status,
      'transcriptions': instance.transcriptions,
    };

_$GratitudeImpl _$$GratitudeImplFromJson(Map<String, dynamic> json) =>
    _$GratitudeImpl(
      gratitude_summary: (json['gratitude_summary'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      gratitude_details: json['gratitude_details'] as String,
      win_summary: (json['win_summary'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      win_details: json['win_details'] as String,
      feel_alive_moments: json['feel_alive_moments'] as String,
    );

Map<String, dynamic> _$$GratitudeImplToJson(_$GratitudeImpl instance) =>
    <String, dynamic>{
      'gratitude_summary': instance.gratitude_summary,
      'gratitude_details': instance.gratitude_details,
      'win_summary': instance.win_summary,
      'win_details': instance.win_details,
      'feel_alive_moments': instance.feel_alive_moments,
    };

_$ChallengesAndGrowthImpl _$$ChallengesAndGrowthImplFromJson(
        Map<String, dynamic> json) =>
    _$ChallengesAndGrowthImpl(
      growth_summary: (json['growth_summary'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      obstacles_faced: json['obstacles_faced'] as String,
      unfinished_intentions: json['unfinished_intentions'] as String,
      contributing_factors: json['contributing_factors'] as String,
    );

Map<String, dynamic> _$$ChallengesAndGrowthImplToJson(
        _$ChallengesAndGrowthImpl instance) =>
    <String, dynamic>{
      'growth_summary': instance.growth_summary,
      'obstacles_faced': instance.obstacles_faced,
      'unfinished_intentions': instance.unfinished_intentions,
      'contributing_factors': instance.contributing_factors,
    };

_$LearningAndInsightsImpl _$$LearningAndInsightsImplFromJson(
        Map<String, dynamic> json) =>
    _$LearningAndInsightsImpl(
      new_knowledge: json['new_knowledge'] as String,
      self_discovery: json['self_discovery'] as String,
      insights_about_others: json['insights_about_others'] as String,
      broader_lessons: json['broader_lessons'] as String,
    );

Map<String, dynamic> _$$LearningAndInsightsImplToJson(
        _$LearningAndInsightsImpl instance) =>
    <String, dynamic>{
      'new_knowledge': instance.new_knowledge,
      'self_discovery': instance.self_discovery,
      'insights_about_others': instance.insights_about_others,
      'broader_lessons': instance.broader_lessons,
    };

_$ConnectionsAndRelationshipsImpl _$$ConnectionsAndRelationshipsImplFromJson(
        Map<String, dynamic> json) =>
    _$ConnectionsAndRelationshipsImpl(
      meaningful_interactions: json['meaningful_interactions'] as String,
      notable_about_people: json['notable_about_people'] as String,
      follow_up_needed: json['follow_up_needed'] as String,
    );

Map<String, dynamic> _$$ConnectionsAndRelationshipsImplToJson(
        _$ConnectionsAndRelationshipsImpl instance) =>
    <String, dynamic>{
      'meaningful_interactions': instance.meaningful_interactions,
      'notable_about_people': instance.notable_about_people,
      'follow_up_needed': instance.follow_up_needed,
    };

_$LookingForwardImpl _$$LookingForwardImplFromJson(Map<String, dynamic> json) =>
    _$LookingForwardImpl(
      do_differently_tomorrow: json['do_differently_tomorrow'] as String,
      continue_what_worked: json['continue_what_worked'] as String,
      top_3_priorities_tomorrow:
          (json['top_3_priorities_tomorrow'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
    );

Map<String, dynamic> _$$LookingForwardImplToJson(
        _$LookingForwardImpl instance) =>
    <String, dynamic>{
      'do_differently_tomorrow': instance.do_differently_tomorrow,
      'continue_what_worked': instance.continue_what_worked,
      'top_3_priorities_tomorrow': instance.top_3_priorities_tomorrow,
    };

_$DailyReflectionImpl _$$DailyReflectionImplFromJson(
        Map<String, dynamic> json) =>
    _$DailyReflectionImpl(
      reflection_summary: json['reflection_summary'] as String,
      gratitude: Gratitude.fromJson(json['gratitude'] as Map<String, dynamic>),
      challenges_and_growth: ChallengesAndGrowth.fromJson(
          json['challenges_and_growth'] as Map<String, dynamic>),
      learning_and_insights: LearningAndInsights.fromJson(
          json['learning_and_insights'] as Map<String, dynamic>),
      connections_and_relationships: ConnectionsAndRelationships.fromJson(
          json['connections_and_relationships'] as Map<String, dynamic>),
      looking_forward: LookingForward.fromJson(
          json['looking_forward'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$DailyReflectionImplToJson(
        _$DailyReflectionImpl instance) =>
    <String, dynamic>{
      'reflection_summary': instance.reflection_summary,
      'gratitude': instance.gratitude,
      'challenges_and_growth': instance.challenges_and_growth,
      'learning_and_insights': instance.learning_and_insights,
      'connections_and_relationships': instance.connections_and_relationships,
      'looking_forward': instance.looking_forward,
    };

_$NoteImpl _$$NoteImplFromJson(Map<String, dynamic> json) => _$NoteImpl(
      id: json['id'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$$NoteImplToJson(_$NoteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
    };

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
      id: json['id'] as String,
      tag: json['tag'] as String,
      description: json['description'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tag': instance.tag,
      'description': instance.description,
      'isCompleted': instance.isCompleted,
    };

_$JournalFileImpl _$$JournalFileImplFromJson(Map<String, dynamic> json) =>
    _$JournalFileImpl(
      username: json['username'] as String,
      time_stamp: json['time_stamp'] as String,
      events: (json['events'] as List<dynamic>)
          .map((e) => EventAnalysis.fromJson(e as Map<String, dynamic>))
          .toList(),
      daily_reflection: DailyReflection.fromJson(
          json['daily_reflection'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$JournalFileImplToJson(_$JournalFileImpl instance) =>
    <String, dynamic>{
      'username': instance.username,
      'time_stamp': instance.time_stamp,
      'events': instance.events,
      'daily_reflection': instance.daily_reflection,
    };
