// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) =>
    _$UserImpl(id: (json['id'] as num).toInt(), name: json['name'] as String);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

_$QuoteImpl _$$QuoteImplFromJson(Map<String, dynamic> json) =>
    _$QuoteImpl(text: json['text'] as String);

Map<String, dynamic> _$$QuoteImplToJson(_$QuoteImpl instance) =>
    <String, dynamic>{'text': instance.text};

_$DiaryImpl _$$DiaryImplFromJson(Map<String, dynamic> json) => _$DiaryImpl(
  time: json['time'] as String,
  title: json['title'] as String,
  summary: json['summary'] as String,
  content: json['content'] as String,
  tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
  location: json['location'] as String,
);

Map<String, dynamic> _$$DiaryImplToJson(_$DiaryImpl instance) =>
    <String, dynamic>{
      'time': instance.time,
      'title': instance.title,
      'summary': instance.summary,
      'content': instance.content,
      'tags': instance.tags,
      'location': instance.location,
    };

_$ReflectionImpl _$$ReflectionImplFromJson(Map<String, dynamic> json) =>
    _$ReflectionImpl(
      title: json['title'] as String,
      items: (json['items'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$ReflectionImplToJson(_$ReflectionImpl instance) =>
    <String, dynamic>{'title': instance.title, 'items': instance.items};

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

_$TodoListImpl _$$TodoListImplFromJson(Map<String, dynamic> json) =>
    _$TodoListImpl(
      tasks:
          (json['tasks'] as List<dynamic>)
              .map((e) => Task.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$$TodoListImplToJson(_$TodoListImpl instance) =>
    <String, dynamic>{'tasks': instance.tasks};

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
