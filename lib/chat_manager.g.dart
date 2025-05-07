// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_manager.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseMessage _$BaseMessageFromJson(Map<String, dynamic> json) => BaseMessage(
  role: json['role'] as String,
  content: json['content'] as String,
);

Map<String, dynamic> _$BaseMessageToJson(BaseMessage instance) =>
    <String, dynamic>{'role': instance.role, 'content': instance.content};

AIMessage _$AIMessageFromJson(Map<String, dynamic> json) =>
    AIMessage(content: json['content'] as String);

Map<String, dynamic> _$AIMessageToJson(AIMessage instance) => <String, dynamic>{
  'content': instance.content,
};

UserMessage _$UserMessageFromJson(Map<String, dynamic> json) =>
    UserMessage(content: json['content'] as String);

Map<String, dynamic> _$UserMessageToJson(UserMessage instance) =>
    <String, dynamic>{'content': instance.content};
