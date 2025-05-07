import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'chat_manager.g.dart'; // 引入生成的文件

// 写一个枚举类，表示消息的角色，目前只有AI 和用户和非法。
class ChatRole {
  static final String user = 'user';
  static final String ai = 'ai';
  static final String illegal = 'illegal';
}

// 基础消息类
@JsonSerializable(explicitToJson: true)
class BaseMessage {
  final String role;
  final String content;

  BaseMessage({required this.role, required this.content});

  //JSON序列化和反序列化
  factory BaseMessage.fromJson(Map<String, dynamic> json) =>
      _$BaseMessageFromJson(json);
  Map<String, dynamic> toJson() => _$BaseMessageToJson(this);
}

// AI 消息类
@JsonSerializable(explicitToJson: true)
class AIMessage extends BaseMessage {
  AIMessage({required super.content}) : super(role: ChatRole.ai);

  //// JSON序列化和反序列化
  factory AIMessage.fromJson(Map<String, dynamic> json) =>
      _$AIMessageFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$AIMessageToJson(this);
}

// 用户消息类
@JsonSerializable(explicitToJson: true)
class UserMessage extends BaseMessage {
  UserMessage({required super.content}) : super(role: ChatRole.user);

  //// JSON序列化和反序列化
  factory UserMessage.fromJson(Map<String, dynamic> json) =>
      _$UserMessageFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserMessageToJson(this);
}

class ChatManager {
  // 单例实例
  static final ChatManager _instance = ChatManager._internal();

  // 私有构造函数
  ChatManager._internal();

  // 获取单例实例
  factory ChatManager() => _instance;

  // 存储对话记录
  final ValueNotifier<List<BaseMessage>> _chatMessages = ValueNotifier([]);

  // 添加消息
  void _addMessage(BaseMessage message) {
    _chatMessages.value = [..._chatMessages.value, message];
  }

  // 添加AI消息
  void addAIMessage(String content) {
    _addMessage(AIMessage(content: content));
  }

  // 添加用户消息
  void addUserMessage(String content) {
    _addMessage(UserMessage(content: content));
  }

  // 获取所有消息
  ValueNotifier<List<BaseMessage>> getMessages() {
    return _chatMessages;
  }

  // 清空消息
  clear() {
    // 清空消息
    _chatMessages.value = [];
  }

  // 清空消息
  initialize() {
    // 初始化对话记录
    addAIMessage(
      'Hi Wei! I know you have spent some great time with Ashley and Trent today. Do you want to chat more about it?',
    );
  }
}
