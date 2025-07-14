// 这是一个数据管理器类，负责管理应用程序中的数据结构和数据
import 'package:nirva_app/data.dart';
import 'package:nirva_app/api_models.dart';
import 'package:flutter/foundation.dart';

// 管理全局数据的类
class RuntimeData {
  // 日记条目笔记
  ValueNotifier<List<Note>> notes = ValueNotifier([]);

  // 聊天消息历史记录
  ValueNotifier<List<ChatMessage>> chatHistory = ValueNotifier([]);

  // 修改日记条目笔记
  void updateNote(EventAnalysis event, String content) {
    // 保存日记条目笔记
    final note = Note(id: event.event_id, content: content);
    if (notes.value.any((element) => element.id == event.event_id)) {
      // 如果已经存在，则更新
      final index = notes.value.indexWhere(
        (element) => element.id == event.event_id,
      );
      notes.value[index] = note;
    } else {
      // 如果不存在，则添加
      notes.value.add(note);
    }
    // 通知监听者
    notes.value = List.from(notes.value);
  }

  // 添加聊天消息到历史记录
  void addChatMessages(List<ChatMessage> conversation) {
    chatHistory.value = [...chatHistory.value, ...conversation];
  }
}
