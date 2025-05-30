import 'package:flutter/material.dart';
import 'package:nirva_app/message.dart';

class NirvaChat {
  // 存储对话记录
  final ValueNotifier<List<BaseMessage>> _messages = ValueNotifier([]);

  // 添加消息
  void _addMessage(BaseMessage message) {
    _messages.value = [..._messages.value, message];
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
  ValueNotifier<List<BaseMessage>> get messages {
    return _messages;
  }
}
