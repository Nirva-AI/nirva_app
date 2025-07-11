import 'package:flutter/material.dart';
import 'package:nirva_app/api_models.dart';

class ChatManager {
  // 存储对话记录
  final ValueNotifier<List<ChatMessage>> _chatHistory = ValueNotifier([]);

  // 获取所有消息
  ValueNotifier<List<ChatMessage>> get chatHistory {
    return _chatHistory;
  }

  void addMessages(List<ChatMessage> conversation) {
    _chatHistory.value = [..._chatHistory.value, ...conversation];
  }
}
