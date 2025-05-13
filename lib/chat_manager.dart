import 'package:flutter/material.dart';
import 'package:nirva_app/message.dart';

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
    _addMessage(BaseMessage.aiMessage(content: content));
  }

  // 添加用户消息
  void addUserMessage(String content) {
    _addMessage(BaseMessage.userMessage(content: content));
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
  fillTestData() {
    // 初始化对话记录
    addAIMessage(
      'Hi Wei! I know you have spent some great time with Ashley and Trent today. Do you want to chat more about it?',
    );
  }
}
