// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_manager.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
