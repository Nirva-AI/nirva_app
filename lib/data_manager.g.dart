// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_manager.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoList _$TodoListFromJson(Map<String, dynamic> json) => TodoList(
  tasks:
      (json['tasks'] as List<dynamic>)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$TodoListToJson(TodoList instance) => <String, dynamic>{
  'tasks': instance.tasks.map((e) => e.toJson()).toList(),
};

EnergyLabel _$EnergyLabelFromJson(Map<String, dynamic> json) => EnergyLabel(
  json['label'] as String,
  (json['measurementValue'] as num).toDouble(),
);

Map<String, dynamic> _$EnergyLabelToJson(EnergyLabel instance) =>
    <String, dynamic>{
      'label': instance.label,
      'measurementValue': instance.measurementValue,
    };

Energy _$EnergyFromJson(Map<String, dynamic> json) => Energy(
  dateTime: DateTime.parse(json['dateTime'] as String),
  energyLevel: (json['energyLevel'] as num).toDouble(),
);

Map<String, dynamic> _$EnergyToJson(Energy instance) => <String, dynamic>{
  'dateTime': instance.dateTime.toIso8601String(),
  'energyLevel': instance.energyLevel,
};

Mood _$MoodFromJson(Map<String, dynamic> json) => Mood(
  json['name'] as String,
  (json['moodValue'] as num).toDouble(),
  (json['moodPercentage'] as num).toDouble(),
);

Map<String, dynamic> _$MoodToJson(Mood instance) => <String, dynamic>{
  'name': instance.name,
  'moodValue': instance.moodValue,
  'moodPercentage': instance.moodPercentage,
};

AwakeTimeAction _$AwakeTimeActionFromJson(Map<String, dynamic> json) =>
    AwakeTimeAction(
      label: json['label'] as String,
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$AwakeTimeActionToJson(AwakeTimeAction instance) =>
    <String, dynamic>{'label': instance.label, 'value': instance.value};

PersonalJournal _$PersonalJournalFromJson(Map<String, dynamic> json) =>
    PersonalJournal(dateTime: DateTime.parse(json['dateTime'] as String))
      ..summary = json['summary'] as String
      ..diaryEntries =
          (json['diaryEntries'] as List<dynamic>)
              .map((e) => Diary.fromJson(e as Map<String, dynamic>))
              .toList()
      ..quotes =
          (json['quotes'] as List<dynamic>)
              .map((e) => Quote.fromJson(e as Map<String, dynamic>))
              .toList()
      ..selfReflections =
          (json['selfReflections'] as List<dynamic>)
              .map((e) => Reflection.fromJson(e as Map<String, dynamic>))
              .toList()
      ..detailedInsights =
          (json['detailedInsights'] as List<dynamic>)
              .map((e) => Reflection.fromJson(e as Map<String, dynamic>))
              .toList()
      ..goals =
          (json['goals'] as List<dynamic>)
              .map((e) => Reflection.fromJson(e as Map<String, dynamic>))
              .toList()
      ..moodScore = Score.fromJson(json['moodScore'] as Map<String, dynamic>)
      ..stressLevel = Score.fromJson(
        json['stressLevel'] as Map<String, dynamic>,
      )
      ..highlights =
          (json['highlights'] as List<dynamic>)
              .map((e) => Highlight.fromJson(e as Map<String, dynamic>))
              .toList()
      ..energyRecords =
          (json['energyRecords'] as List<dynamic>)
              .map((e) => Energy.fromJson(e as Map<String, dynamic>))
              .toList()
      ..moods =
          (json['moods'] as List<dynamic>)
              .map((e) => Mood.fromJson(e as Map<String, dynamic>))
              .toList()
      ..awakeTimeActions =
          (json['awakeTimeActions'] as List<dynamic>)
              .map((e) => AwakeTimeAction.fromJson(e as Map<String, dynamic>))
              .toList()
      ..socialMap = SocialMap.fromJson(
        json['socialMap'] as Map<String, dynamic>,
      );

Map<String, dynamic> _$PersonalJournalToJson(
  PersonalJournal instance,
) => <String, dynamic>{
  'dateTime': instance.dateTime.toIso8601String(),
  'summary': instance.summary,
  'diaryEntries': instance.diaryEntries.map((e) => e.toJson()).toList(),
  'quotes': instance.quotes.map((e) => e.toJson()).toList(),
  'selfReflections': instance.selfReflections.map((e) => e.toJson()).toList(),
  'detailedInsights': instance.detailedInsights.map((e) => e.toJson()).toList(),
  'goals': instance.goals.map((e) => e.toJson()).toList(),
  'moodScore': instance.moodScore.toJson(),
  'stressLevel': instance.stressLevel.toJson(),
  'highlights': instance.highlights.map((e) => e.toJson()).toList(),
  'energyRecords': instance.energyRecords.map((e) => e.toJson()).toList(),
  'moods': instance.moods.map((e) => e.toJson()).toList(),
  'awakeTimeActions': instance.awakeTimeActions.map((e) => e.toJson()).toList(),
  'socialMap': instance.socialMap.toJson(),
};

SocialEntity _$SocialEntityFromJson(Map<String, dynamic> json) => SocialEntity(
  name: json['name'] as String,
  details: json['details'] as String,
  tips: (json['tips'] as List<dynamic>).map((e) => e as String).toList(),
  timeSpent: json['timeSpent'] as String,
);

Map<String, dynamic> _$SocialEntityToJson(SocialEntity instance) =>
    <String, dynamic>{
      'name': instance.name,
      'details': instance.details,
      'tips': instance.tips,
      'timeSpent': instance.timeSpent,
    };

SocialMap _$SocialMapFromJson(Map<String, dynamic> json) => SocialMap(
  socialEntities:
      (json['socialEntities'] as List<dynamic>)
          .map((e) => SocialEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$SocialMapToJson(SocialMap instance) => <String, dynamic>{
  'socialEntities': instance.socialEntities.map((e) => e.toJson()).toList(),
};
