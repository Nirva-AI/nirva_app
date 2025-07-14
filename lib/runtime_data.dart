// 这是一个数据管理器类，负责管理应用程序中的数据结构和数据
import 'package:nirva_app/data.dart';
import 'package:nirva_app/api_models.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

// 管理全局数据的类
class RuntimeData {
  // 当前的待办事项数据
  ValueNotifier<List<Task>> tasks = ValueNotifier([]);

  // 标记为最爱的日记条目，存本地手机即可，暂时不考虑存服务器。
  ValueNotifier<List<String>> favorites = ValueNotifier([]);

  // 日记条目笔记
  ValueNotifier<List<Note>> notes = ValueNotifier([]);

  // 聊天消息历史记录
  ValueNotifier<List<ChatMessage>> chatHistory = ValueNotifier([]);

  bool hasTask(String tag, String description) {
    // 检查是否存在指定标签和描述的任务
    return tasks.value.any(
      (task) => task.tag == tag && task.description == description,
    );
  }

  void addTask(String tag, String description) {
    // 添加任务到任务列表
    final uuid = Uuid(); // 创建UUID生成器实例
    final newTask = Task(
      id: uuid.v4(), // 生成唯一的任务ID
      tag: tag,
      description: description,
      isCompleted: false,
    );
    tasks.value.add(newTask); // 使用ValueNotifier的add方法
    tasks.value = List.from(tasks.value); // 通知监听者
    debugPrint('Task added: $tag - $description');
  }

  // 切换任务的完成状态
  void switchTaskStatus(Task task) {
    // 切换任务的完成状态
    final int index = tasks.value.indexOf(task);
    if (index != -1) {
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      tasks.value[index] = updatedTask;
      tasks.value = List.from(tasks.value); // 通知监听者
    }
  }

  //
  Map<String, List<Task>> get groupedTasks {
    final Map<String, List<Task>> groupedTasks = {};
    for (var task in tasks.value) {
      if (!groupedTasks.containsKey(task.tag)) {
        groupedTasks[task.tag] = [];
      }
      groupedTasks[task.tag]!.add(task);
    }
    return groupedTasks;
  }

  //
  void clearCompletedTasks() {
    // 清除已完成的任务
    tasks.value = tasks.value.where((task) => !task.isCompleted).toList();
    tasks.value = List.from(tasks.value); // 通知监听者
  }

  void switchEventFavoriteStatus(EventAnalysis event) {
    if (favorites.value.contains(event.event_id)) {
      favorites.value.remove(event.event_id);
    } else {
      favorites.value.add(event.event_id);
    }
    // 更新收藏列表
    favorites.value = List.from(favorites.value); // 通知监听者
  }

  bool checkFavorite(EventAnalysis event) {
    return favorites.value.contains(event.event_id);
  }

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
