// ignore_for_file: non_constant_identifier_names
// 请注意，本页是为了对接python fastapi服务器的数据定义的代码，命名风格完全和服务器一致，所以关警告。不要修改命名风格。
import 'package:freezed_annotation/freezed_annotation.dart';
part 'message.freezed.dart';
part 'message.g.dart';

// 写一个枚举类，表示消息的角色，目前只有AI 和用户和非法。
class ChatRole {
  static const String user = 'user';
  static const String ai = 'ai';
  static const String illegal = 'illegal';
}

@freezed
class BaseMessage with _$BaseMessage {
  // 定义 AI 消息类型
  const factory BaseMessage.aiMessage({
    @Default(ChatRole.ai) String role,
    required String content,
  }) = AIMessage;

  // 定义用户消息类型
  const factory BaseMessage.userMessage({
    @Default(ChatRole.user) String role,
    required String content,
  }) = UserMessage;

  // 支持 JSON 序列化
  factory BaseMessage.fromJson(Map<String, dynamic> json) =>
      _$BaseMessageFromJson(json);
}
