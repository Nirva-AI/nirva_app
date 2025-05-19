// 这是一个数据管理器类，负责管理应用程序中的数据结构和数据
import 'package:nirva_app/data.dart';
import 'package:flutter/foundation.dart';

// 管理全局数据的类
class DataManager {
  // 单例模式
  static final DataManager _instance = DataManager._internal();
  factory DataManager() => _instance;
  DataManager._internal();

  // 用户信息
  User user = User(name: '');

  // 当前的日记和仪表板数据
  List<PersonalJournal> journalEntries = [];

  // 当前的待办事项数据
  List<Task> tasks = [];

  // 当前的高亮数据
  List<HighlightGroup> archivedHighlights = [];

  // 标记为最爱的日记条目，存本地手机即可，暂时不考虑存服务器。
  ValueNotifier<List<String>> diaryFavoritesNotifier = ValueNotifier([]);

  // 日记条目笔记
  ValueNotifier<List<DiaryEntryyNote>> diaryEntryyNotesNotifier = ValueNotifier(
    [],
  ); // 用于存储日记条目笔记的通知器

  // 清空数据
  void clear() {
    user = User(name: '');
    journalEntries = [];
    tasks = [];
    archivedHighlights = [];
    diaryFavoritesNotifier = ValueNotifier([]);
    diaryEntryyNotesNotifier = ValueNotifier([]);
  }

  //
  Map<String, List<Task>> get groupedTasks {
    final Map<String, List<Task>> groupedTasks = {};
    for (var task in tasks) {
      if (!groupedTasks.containsKey(task.tag)) {
        groupedTasks[task.tag] = [];
      }
      groupedTasks[task.tag]!.add(task);
    }
    return groupedTasks;
  }

  PersonalJournal get currentJournalEntry {
    // 获取当前的日记条目
    if (journalEntries.isNotEmpty) {
      return journalEntries.last;
    } else {
      return PersonalJournal.createEmpty();
    }
  }

  // 切换任务的完成状态
  void toggleTaskCompletion(Task task) {
    // 切换任务的完成状态
    final int index = tasks.indexOf(task);
    if (index != -1) {
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      tasks[index] = updatedTask;
    }
  }

  // 切换日记条目的收藏状态
  void toggleFavoriteDiaryEntry(DiaryEntry diaryEntry) {
    if (diaryFavoritesNotifier.value.contains(diaryEntry.id)) {
      diaryFavoritesNotifier.value.remove(diaryEntry.id);
    } else {
      diaryFavoritesNotifier.value.add(diaryEntry.id);
    }
    diaryFavoritesNotifier.value = List.from(
      diaryFavoritesNotifier.value,
    ); // 通知监听者
  }

  // 检查日记条目是否被标记为最爱
  bool isFavoriteDiaryEntry(DiaryEntry diaryEntry) {
    return diaryFavoritesNotifier.value.contains(diaryEntry.id);
  }

  // 修改日记条目笔记
  void modifyDiaryEntryNote(DiaryEntry diaryEntry, String content) {
    // 保存日记条目笔记
    final note = DiaryEntryyNote(id: diaryEntry.id, content: content);
    if (diaryEntryyNotesNotifier.value.any(
      (element) => element.id == diaryEntry.id,
    )) {
      // 如果已经存在，则更新
      final index = diaryEntryyNotesNotifier.value.indexWhere(
        (element) => element.id == diaryEntry.id,
      );
      diaryEntryyNotesNotifier.value[index] = note;
    } else {
      // 如果不存在，则添加
      diaryEntryyNotesNotifier.value.add(note);
    }
    // 通知监听者
    diaryEntryyNotesNotifier.value = List.from(diaryEntryyNotesNotifier.value);
  }

  // 获取日记条目笔记
  String getDiaryEntryNote(DiaryEntry diaryEntry) {
    // 获取日记条目笔记
    final note = diaryEntryyNotesNotifier.value.firstWhere(
      (element) => element.id == diaryEntry.id,
      orElse: () => DiaryEntryyNote(id: '', content: ''),
    );
    return note.content;
  }
}
