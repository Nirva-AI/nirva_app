// 这是一个数据管理器类，负责管理应用程序中的数据结构和数据
import 'package:nirva_app/api_models.dart';
import 'package:flutter/foundation.dart';

// 管理全局数据的类
class RuntimeData {
  // 聊天消息历史记录
  ValueNotifier<List<ChatMessage>> chatHistory = ValueNotifier([]);

  // 添加聊天消息到历史记录
  void addChatMessages(List<ChatMessage> conversation) {
    chatHistory.value = [...chatHistory.value, ...conversation];
  }
}
