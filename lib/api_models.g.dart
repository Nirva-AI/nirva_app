// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$URLConfigurationResponseImpl _$$URLConfigurationResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$URLConfigurationResponseImpl(
      api_version: json['api_version'] as String,
      endpoints: Map<String, String>.from(json['endpoints'] as Map),
      deprecated: json['deprecated'] as bool,
      notice: json['notice'] as String,
    );

Map<String, dynamic> _$$URLConfigurationResponseImplToJson(
        _$URLConfigurationResponseImpl instance) =>
    <String, dynamic>{
      'api_version': instance.api_version,
      'endpoints': instance.endpoints,
      'deprecated': instance.deprecated,
      'notice': instance.notice,
    };

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: json['id'] as String,
      role: (json['role'] as num).toInt(),
      content: json['content'] as String,
      time_stamp: json['time_stamp'] as String,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'content': instance.content,
      'time_stamp': instance.time_stamp,
      'tags': instance.tags,
    };

_$ChatActionRequestImpl _$$ChatActionRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatActionRequestImpl(
      human_message:
          ChatMessage.fromJson(json['human_message'] as Map<String, dynamic>),
      chat_history: (json['chat_history'] as List<dynamic>)
          .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ChatActionRequestImplToJson(
        _$ChatActionRequestImpl instance) =>
    <String, dynamic>{
      'human_message': instance.human_message,
      'chat_history': instance.chat_history,
    };

_$ChatActionResponseImpl _$$ChatActionResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatActionResponseImpl(
      ai_message:
          ChatMessage.fromJson(json['ai_message'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ChatActionResponseImplToJson(
        _$ChatActionResponseImpl instance) =>
    <String, dynamic>{
      'ai_message': instance.ai_message,
    };
