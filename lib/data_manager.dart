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
  List<Journal> journals = [];

  // 当前的待办事项数据
  List<Task> tasks = [];

  // 当前的高亮数据
  List<HighlightGroup> archivedHighlights = [];

  // 标记为最爱的日记条目，存本地手机即可，暂时不考虑存服务器。
  ValueNotifier<List<String>> diaryFavoritesNotifier = ValueNotifier([]);

  // 日记条目笔记
  ValueNotifier<List<DiaryEntryNote>> diaryNotesNotifier = ValueNotifier([]);

  //
  MoodScoreInsights moodScoreInsights = MoodScoreInsights(
    dateTime: DateTime.now(),
    insights: [],
  );

  // 清空数据
  void clear() {
    user = User(name: '');
    journals = [];
    tasks = [];
    archivedHighlights = [];
    diaryFavoritesNotifier = ValueNotifier([]);
    diaryNotesNotifier = ValueNotifier([]);
    moodScoreInsights = MoodScoreInsights(
      dateTime: DateTime.now(),
      insights: [],
    );
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

  Journal get currentJournal {
    // 获取当前的日记条目
    if (journals.isNotEmpty) {
      return journals.last;
    } else {
      return Journal.createEmpty();
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
  void toggleFavoriteDiary(DiaryEntry diaryEntry) {
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
  bool isFavoriteDiary(DiaryEntry diaryEntry) {
    return diaryFavoritesNotifier.value.contains(diaryEntry.id);
  }

  // 修改日记条目笔记
  void modifyDiaryNote(DiaryEntry diaryEntry, String content) {
    // 保存日记条目笔记
    final note = DiaryEntryNote(id: diaryEntry.id, content: content);
    if (diaryNotesNotifier.value.any(
      (element) => element.id == diaryEntry.id,
    )) {
      // 如果已经存在，则更新
      final index = diaryNotesNotifier.value.indexWhere(
        (element) => element.id == diaryEntry.id,
      );
      diaryNotesNotifier.value[index] = note;
    } else {
      // 如果不存在，则添加
      diaryNotesNotifier.value.add(note);
    }
    // 通知监听者
    diaryNotesNotifier.value = List.from(diaryNotesNotifier.value);
  }

  // 获取日记条目笔记
  String getDiaryNote(DiaryEntry diaryEntry) {
    // 获取日记条目笔记
    final note = diaryNotesNotifier.value.firstWhere(
      (element) => element.id == diaryEntry.id,
      orElse: () => DiaryEntryNote(id: '', content: ''),
    );
    return note.content;
  }
}
