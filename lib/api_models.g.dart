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

_$AnalyzeActionRequestImpl _$$AnalyzeActionRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$AnalyzeActionRequestImpl(
      time_stamp: json['time_stamp'] as String,
      file_number: (json['file_number'] as num).toInt(),
    );

Map<String, dynamic> _$$AnalyzeActionRequestImplToJson(
        _$AnalyzeActionRequestImpl instance) =>
    <String, dynamic>{
      'time_stamp': instance.time_stamp,
      'file_number': instance.file_number,
    };

_$UploadTranscriptActionRequestImpl
    _$$UploadTranscriptActionRequestImplFromJson(Map<String, dynamic> json) =>
        _$UploadTranscriptActionRequestImpl(
          transcript_content: json['transcript_content'] as String,
          time_stamp: json['time_stamp'] as String,
          file_number: (json['file_number'] as num).toInt(),
          file_suffix: json['file_suffix'] as String,
        );

Map<String, dynamic> _$$UploadTranscriptActionRequestImplToJson(
        _$UploadTranscriptActionRequestImpl instance) =>
    <String, dynamic>{
      'transcript_content': instance.transcript_content,
      'time_stamp': instance.time_stamp,
      'file_number': instance.file_number,
      'file_suffix': instance.file_suffix,
    };

_$UploadTranscriptActionResponseImpl
    _$$UploadTranscriptActionResponseImplFromJson(Map<String, dynamic> json) =>
        _$UploadTranscriptActionResponseImpl(
          message: json['message'] as String? ?? '',
        );

Map<String, dynamic> _$$UploadTranscriptActionResponseImplToJson(
        _$UploadTranscriptActionResponseImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
    };

_$BackgroundTaskResponseImpl _$$BackgroundTaskResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$BackgroundTaskResponseImpl(
      task_id: json['task_id'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$$BackgroundTaskResponseImplToJson(
        _$BackgroundTaskResponseImpl instance) =>
    <String, dynamic>{
      'task_id': instance.task_id,
      'message': instance.message,
    };

_$TranscriptionItemImpl _$$TranscriptionItemImplFromJson(
        Map<String, dynamic> json) =>
    _$TranscriptionItemImpl(
      id: json['id'] as String?,
      text: json['text'] as String,
      start_time: json['start_time'] as String,
      end_time: json['end_time'] as String,
    );

Map<String, dynamic> _$$TranscriptionItemImplToJson(
        _$TranscriptionItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'start_time': instance.start_time,
      'end_time': instance.end_time,
    };

_$TranscriptionsResponseImpl _$$TranscriptionsResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$TranscriptionsResponseImpl(
      items: (json['transcriptions'] as List<dynamic>)
          .map((e) => TranscriptionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      page_size: (json['page_size'] as num).toInt(),
      has_more: json['has_more'] as bool,
    );

Map<String, dynamic> _$$TranscriptionsResponseImplToJson(
        _$TranscriptionsResponseImpl instance) =>
    <String, dynamic>{
      'transcriptions': instance.items,
      'total': instance.total,
      'page': instance.page,
      'page_size': instance.page_size,
      'has_more': instance.has_more,
    };
