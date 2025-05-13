// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AIMessageImpl _$$AIMessageImplFromJson(Map<String, dynamic> json) =>
    _$AIMessageImpl(
      role: json['role'] as String? ?? ChatRole.ai,
      content: json['content'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$AIMessageImplToJson(_$AIMessageImpl instance) =>
    <String, dynamic>{
      'role': instance.role,
      'content': instance.content,
      'runtimeType': instance.$type,
    };

_$UserMessageImpl _$$UserMessageImplFromJson(Map<String, dynamic> json) =>
    _$UserMessageImpl(
      role: json['role'] as String? ?? ChatRole.user,
      content: json['content'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$UserMessageImplToJson(_$UserMessageImpl instance) =>
    <String, dynamic>{
      'role': instance.role,
      'content': instance.content,
      'runtimeType': instance.$type,
    };
