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

_$DiaryEntryyNoteImpl _$$DiaryEntryyNoteImplFromJson(
  Map<String, dynamic> json,
) => _$DiaryEntryyNoteImpl(
  id: json['id'] as String,
  content: json['content'] as String,
);

Map<String, dynamic> _$$DiaryEntryyNoteImplToJson(
  _$DiaryEntryyNoteImpl instance,
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

_$ScoreImpl _$$ScoreImplFromJson(Map<String, dynamic> json) => _$ScoreImpl(
  title: json['title'] as String,
  value: (json['value'] as num).toDouble(),
  change: (json['change'] as num).toDouble(),
);

Map<String, dynamic> _$$ScoreImplToJson(_$ScoreImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'value': instance.value,
      'change': instance.change,
    };

_$HighlightImpl _$$HighlightImplFromJson(Map<String, dynamic> json) =>
    _$HighlightImpl(
      title: json['title'] as String,
      content: json['content'] as String,
      color: (json['color'] as num?)?.toInt() ?? 0xFF00FF00,
    );

Map<String, dynamic> _$$HighlightImplToJson(_$HighlightImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'color': instance.color,
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

_$EnergyLabelImpl _$$EnergyLabelImplFromJson(Map<String, dynamic> json) =>
    _$EnergyLabelImpl(
      label: json['label'] as String,
      measurementValue: (json['measurementValue'] as num).toDouble(),
    );

Map<String, dynamic> _$$EnergyLabelImplToJson(_$EnergyLabelImpl instance) =>
    <String, dynamic>{
      'label': instance.label,
      'measurementValue': instance.measurementValue,
    };

_$EnergyImpl _$$EnergyImplFromJson(Map<String, dynamic> json) => _$EnergyImpl(
  dateTime: DateTime.parse(json['dateTime'] as String),
  energyLevel: (json['energyLevel'] as num).toDouble(),
);

Map<String, dynamic> _$$EnergyImplToJson(_$EnergyImpl instance) =>
    <String, dynamic>{
      'dateTime': instance.dateTime.toIso8601String(),
      'energyLevel': instance.energyLevel,
    };

_$MoodImpl _$$MoodImplFromJson(Map<String, dynamic> json) => _$MoodImpl(
  name: json['name'] as String,
  moodValue: (json['moodValue'] as num).toDouble(),
  moodPercentage: (json['moodPercentage'] as num).toDouble(),
  color: (json['color'] as num?)?.toInt() ?? 0xFF00FF00,
);

Map<String, dynamic> _$$MoodImplToJson(_$MoodImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'moodValue': instance.moodValue,
      'moodPercentage': instance.moodPercentage,
      'color': instance.color,
    };

_$AwakeTimeActionImpl _$$AwakeTimeActionImplFromJson(
  Map<String, dynamic> json,
) => _$AwakeTimeActionImpl(
  label: json['label'] as String,
  value: (json['value'] as num).toDouble(),
  color: (json['color'] as num?)?.toInt() ?? 0xFF00FF00,
);

Map<String, dynamic> _$$AwakeTimeActionImplToJson(
  _$AwakeTimeActionImpl instance,
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

_$PersonalJournalImpl _$$PersonalJournalImplFromJson(
  Map<String, dynamic> json,
) => _$PersonalJournalImpl(
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
  moodScore: Score.fromJson(json['moodScore'] as Map<String, dynamic>),
  stressLevel: Score.fromJson(json['stressLevel'] as Map<String, dynamic>),
  highlights:
      (json['highlights'] as List<dynamic>)
          .map((e) => Highlight.fromJson(e as Map<String, dynamic>))
          .toList(),
  energyRecords:
      (json['energyRecords'] as List<dynamic>)
          .map((e) => Energy.fromJson(e as Map<String, dynamic>))
          .toList(),
  moods:
      (json['moods'] as List<dynamic>)
          .map((e) => Mood.fromJson(e as Map<String, dynamic>))
          .toList(),
  awakeTimeActions:
      (json['awakeTimeActions'] as List<dynamic>)
          .map((e) => AwakeTimeAction.fromJson(e as Map<String, dynamic>))
          .toList(),
  socialMap: SocialMap.fromJson(json['socialMap'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$PersonalJournalImplToJson(
  _$PersonalJournalImpl instance,
) => <String, dynamic>{
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
  'energyRecords': instance.energyRecords,
  'moods': instance.moods,
  'awakeTimeActions': instance.awakeTimeActions,
  'socialMap': instance.socialMap,
};
