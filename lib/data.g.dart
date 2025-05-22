// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) =>
    _$UserImpl(name: json['name'] as String);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{'name': instance.name};

_$QuoteImpl _$$QuoteImplFromJson(Map<String, dynamic> json) =>
    _$QuoteImpl(text: json['text'] as String, mood: json['mood'] as String);

Map<String, dynamic> _$$QuoteImplToJson(_$QuoteImpl instance) =>
    <String, dynamic>{'text': instance.text, 'mood': instance.mood};

_$EventTagImpl _$$EventTagImplFromJson(Map<String, dynamic> json) =>
    _$EventTagImpl(name: json['name'] as String);

Map<String, dynamic> _$$EventTagImplToJson(_$EventTagImpl instance) =>
    <String, dynamic>{'name': instance.name};

_$EventLocationImpl _$$EventLocationImplFromJson(Map<String, dynamic> json) =>
    _$EventLocationImpl(name: json['name'] as String);

Map<String, dynamic> _$$EventLocationImplToJson(_$EventLocationImpl instance) =>
    <String, dynamic>{'name': instance.name};

_$DiaryEntryImpl _$$DiaryEntryImplFromJson(Map<String, dynamic> json) =>
    _$DiaryEntryImpl(
      id: json['id'] as String,
      beginTime: DateTime.parse(json['beginTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      title: json['title'] as String,
      summary: json['summary'] as String,
      content: json['content'] as String,
      tags:
          (json['tags'] as List<dynamic>)
              .map((e) => EventTag.fromJson(e as Map<String, dynamic>))
              .toList(),
      location: EventLocation.fromJson(
        json['location'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$DiaryEntryImplToJson(_$DiaryEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'beginTime': instance.beginTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'title': instance.title,
      'summary': instance.summary,
      'content': instance.content,
      'tags': instance.tags,
      'location': instance.location,
    };

_$DiaryEntryNoteImpl _$$DiaryEntryNoteImplFromJson(Map<String, dynamic> json) =>
    _$DiaryEntryNoteImpl(
      id: json['id'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$$DiaryEntryNoteImplToJson(
  _$DiaryEntryNoteImpl instance,
) => <String, dynamic>{'id': instance.id, 'content': instance.content};

_$ReflectionImpl _$$ReflectionImplFromJson(Map<String, dynamic> json) =>
    _$ReflectionImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      items: (json['items'] as List<dynamic>).map((e) => e as String).toList(),
      content: json['content'] as String,
    );

Map<String, dynamic> _$$ReflectionImplToJson(_$ReflectionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'items': instance.items,
      'content': instance.content,
    };

_$MoodScoreImpl _$$MoodScoreImplFromJson(Map<String, dynamic> json) =>
    _$MoodScoreImpl(
      value: (json['value'] as num).toDouble(),
      change: (json['change'] as num).toDouble(),
    );

Map<String, dynamic> _$$MoodScoreImplToJson(_$MoodScoreImpl instance) =>
    <String, dynamic>{'value': instance.value, 'change': instance.change};

_$StressLevelImpl _$$StressLevelImplFromJson(Map<String, dynamic> json) =>
    _$StressLevelImpl(
      value: (json['value'] as num).toDouble(),
      change: (json['change'] as num).toDouble(),
    );

Map<String, dynamic> _$$StressLevelImplToJson(_$StressLevelImpl instance) =>
    <String, dynamic>{'value': instance.value, 'change': instance.change};

_$HighlightImpl _$$HighlightImplFromJson(Map<String, dynamic> json) =>
    _$HighlightImpl(
      category: json['category'] as String,
      content: json['content'] as String,
      color: (json['color'] as num?)?.toInt() ?? 0xFF00FF00,
    );

Map<String, dynamic> _$$HighlightImplToJson(_$HighlightImpl instance) =>
    <String, dynamic>{
      'category': instance.category,
      'content': instance.content,
      'color': instance.color,
    };

_$HighlightGroupImpl _$$HighlightGroupImplFromJson(Map<String, dynamic> json) =>
    _$HighlightGroupImpl(
      beginTime: DateTime.parse(json['beginTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      highlights:
          (json['highlights'] as List<dynamic>)
              .map((e) => Highlight.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$$HighlightGroupImplToJson(
  _$HighlightGroupImpl instance,
) => <String, dynamic>{
  'beginTime': instance.beginTime.toIso8601String(),
  'endTime': instance.endTime.toIso8601String(),
  'highlights': instance.highlights,
};

_$TaskImpl _$$TaskImplFromJson(Map<String, dynamic> json) => _$TaskImpl(
  tag: json['tag'] as String,
  description: json['description'] as String,
  isCompleted: json['isCompleted'] as bool? ?? false,
);

Map<String, dynamic> _$$TaskImplToJson(_$TaskImpl instance) =>
    <String, dynamic>{
      'tag': instance.tag,
      'description': instance.description,
      'isCompleted': instance.isCompleted,
    };

_$EnergyLevelImpl _$$EnergyLevelImplFromJson(Map<String, dynamic> json) =>
    _$EnergyLevelImpl(
      dateTime: DateTime.parse(json['dateTime'] as String),
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$$EnergyLevelImplToJson(_$EnergyLevelImpl instance) =>
    <String, dynamic>{
      'dateTime': instance.dateTime.toIso8601String(),
      'value': instance.value,
    };

_$MoodTrackingImpl _$$MoodTrackingImplFromJson(Map<String, dynamic> json) =>
    _$MoodTrackingImpl(
      name: json['name'] as String,
      value: (json['value'] as num).toDouble(),
      color: (json['color'] as num?)?.toInt() ?? 0xFF000000,
    );

Map<String, dynamic> _$$MoodTrackingImplToJson(_$MoodTrackingImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
      'color': instance.color,
    };

_$AwakeTimeAllocationImpl _$$AwakeTimeAllocationImplFromJson(
  Map<String, dynamic> json,
) => _$AwakeTimeAllocationImpl(
  label: json['label'] as String,
  value: (json['value'] as num).toDouble(),
  color: (json['color'] as num?)?.toInt() ?? 0xFF00FF00,
);

Map<String, dynamic> _$$AwakeTimeAllocationImplToJson(
  _$AwakeTimeAllocationImpl instance,
) => <String, dynamic>{
  'label': instance.label,
  'value': instance.value,
  'color': instance.color,
};

_$SocialEntityImpl _$$SocialEntityImplFromJson(Map<String, dynamic> json) =>
    _$SocialEntityImpl(
      name: json['name'] as String,
      details: json['details'] as String,
      tips: (json['tips'] as List<dynamic>).map((e) => e as String).toList(),
      timeSpent: json['timeSpent'] as String,
    );

Map<String, dynamic> _$$SocialEntityImplToJson(_$SocialEntityImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'details': instance.details,
      'tips': instance.tips,
      'timeSpent': instance.timeSpent,
    };

_$SocialMapImpl _$$SocialMapImplFromJson(Map<String, dynamic> json) =>
    _$SocialMapImpl(
      socialEntities:
          (json['socialEntities'] as List<dynamic>)
              .map((e) => SocialEntity.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$$SocialMapImplToJson(_$SocialMapImpl instance) =>
    <String, dynamic>{'socialEntities': instance.socialEntities};

_$JournalImpl _$$JournalImplFromJson(Map<String, dynamic> json) =>
    _$JournalImpl(
      dateTime: DateTime.parse(json['dateTime'] as String),
      summary: json['summary'] as String,
      diaryEntries:
          (json['diaryEntries'] as List<dynamic>)
              .map((e) => DiaryEntry.fromJson(e as Map<String, dynamic>))
              .toList(),
      quotes:
          (json['quotes'] as List<dynamic>)
              .map((e) => Quote.fromJson(e as Map<String, dynamic>))
              .toList(),
      selfReflections:
          (json['selfReflections'] as List<dynamic>)
              .map((e) => Reflection.fromJson(e as Map<String, dynamic>))
              .toList(),
      detailedInsights:
          (json['detailedInsights'] as List<dynamic>)
              .map((e) => Reflection.fromJson(e as Map<String, dynamic>))
              .toList(),
      goals:
          (json['goals'] as List<dynamic>)
              .map((e) => Reflection.fromJson(e as Map<String, dynamic>))
              .toList(),
      moodScore: MoodScore.fromJson(json['moodScore'] as Map<String, dynamic>),
      stressLevel: StressLevel.fromJson(
        json['stressLevel'] as Map<String, dynamic>,
      ),
      highlights:
          (json['highlights'] as List<dynamic>)
              .map((e) => Highlight.fromJson(e as Map<String, dynamic>))
              .toList(),
      energyLevels:
          (json['energyLevels'] as List<dynamic>)
              .map((e) => EnergyLevel.fromJson(e as Map<String, dynamic>))
              .toList(),
      moodTrackings:
          (json['moodTrackings'] as List<dynamic>)
              .map((e) => MoodTracking.fromJson(e as Map<String, dynamic>))
              .toList(),
      awakeTimeActions:
          (json['awakeTimeActions'] as List<dynamic>)
              .map(
                (e) => AwakeTimeAllocation.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
      socialMap: SocialMap.fromJson(json['socialMap'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$JournalImplToJson(_$JournalImpl instance) =>
    <String, dynamic>{
      'dateTime': instance.dateTime.toIso8601String(),
      'summary': instance.summary,
      'diaryEntries': instance.diaryEntries,
      'quotes': instance.quotes,
      'selfReflections': instance.selfReflections,
      'detailedInsights': instance.detailedInsights,
      'goals': instance.goals,
      'moodScore': instance.moodScore,
      'stressLevel': instance.stressLevel,
      'highlights': instance.highlights,
      'energyLevels': instance.energyLevels,
      'moodTrackings': instance.moodTrackings,
      'awakeTimeActions': instance.awakeTimeActions,
      'socialMap': instance.socialMap,
    };

_$MoodScoreDashboradImpl _$$MoodScoreDashboradImplFromJson(
  Map<String, dynamic> json,
) => _$MoodScoreDashboradImpl(
  dateTime: DateTime.parse(json['dateTime'] as String),
  insights:
      (json['insights'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$$MoodScoreDashboradImplToJson(
  _$MoodScoreDashboradImpl instance,
) => <String, dynamic>{
  'dateTime': instance.dateTime.toIso8601String(),
  'insights': instance.insights,
};

_$StressLevelDashboradImpl _$$StressLevelDashboradImplFromJson(
  Map<String, dynamic> json,
) => _$StressLevelDashboradImpl(
  dateTime: DateTime.parse(json['dateTime'] as String),
  insights:
      (json['insights'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$$StressLevelDashboradImplToJson(
  _$StressLevelDashboradImpl instance,
) => <String, dynamic>{
  'dateTime': instance.dateTime.toIso8601String(),
  'insights': instance.insights,
};

_$EnergyLevelDashboradImpl _$$EnergyLevelDashboradImplFromJson(
  Map<String, dynamic> json,
) => _$EnergyLevelDashboradImpl(
  dateTime: DateTime.parse(json['dateTime'] as String),
  insights:
      (json['insights'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$$EnergyLevelDashboradImplToJson(
  _$EnergyLevelDashboradImpl instance,
) => <String, dynamic>{
  'dateTime': instance.dateTime.toIso8601String(),
  'insights': instance.insights,
};

_$MoodTrackingDashboradImpl _$$MoodTrackingDashboradImplFromJson(
  Map<String, dynamic> json,
) => _$MoodTrackingDashboradImpl(
  dateTime: DateTime.parse(json['dateTime'] as String),
  insights:
      (json['insights'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$$MoodTrackingDashboradImplToJson(
  _$MoodTrackingDashboradImpl instance,
) => <String, dynamic>{
  'dateTime': instance.dateTime.toIso8601String(),
  'insights': instance.insights,
};
