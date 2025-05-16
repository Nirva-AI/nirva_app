// 这是一个数据管理器类，负责管理应用程序中的数据结构和数据
import 'package:nirva_app/data.dart';

// 管理全局数据的类
class DataManager {
  // 单例模式
  static final DataManager _instance = DataManager._internal();
  factory DataManager() => _instance;
  DataManager._internal();

  // 用户名
  String userName = '';

  // 当前的日记和仪表板数据
  List<PersonalJournal> journalEntries = [];

  // 当前的待办事项数据
  List<Task> tasks = [];

  // 标记为最爱的日记条目，存本地手机即可，暂时不考虑存服务器。
  List<String> favoriteDiaries = [];

  // 清空数据
  void clear() {
    userName = '';
    journalEntries = [];
    tasks = [];
    favoriteDiaries = [];
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
    if (favoriteDiaries.contains(diaryEntry.id)) {
      favoriteDiaries.remove(diaryEntry.id);
    } else {
      favoriteDiaries.add(diaryEntry.id);
    }
  }

  // 检查日记条目是否被标记为最爱
  bool isFavoriteDiaryEntry(DiaryEntry diaryEntry) {
    return favoriteDiaries.contains(diaryEntry.id);
  }
}
