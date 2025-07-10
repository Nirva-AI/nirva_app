// 这是一个数据管理器类，负责管理应用程序中的数据结构和数据
import 'package:nirva_app/data.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

// 管理全局数据的类
class RuntimeData {
  // 用户信息
  User user = User(id: "", username: "", password: "", displayName: "");

  // 当前的待办事项数据
  ValueNotifier<List<Task>> tasks = ValueNotifier([]);

  // 标记为最爱的日记条目，存本地手机即可，暂时不考虑存服务器。
  ValueNotifier<List<String>> favorites = ValueNotifier([]);

  // 日记条目笔记
  ValueNotifier<List<Note>> notes = ValueNotifier([]);

  // 缓存的日记文件列表
  ValueNotifier<List<JournalFile>> journalFiles = ValueNotifier([]);

  //
  List<Dashboard> dashboards = [];

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

  //
  List<JournalFile> _sortJournalFilesByDate() {
    // 按照时间戳排序日记文件
    journalFiles.value =
        journalFiles.value.where((file) => file.time_stamp.isNotEmpty).toList()
          ..sort(
            (a, b) => DateTime.parse(
              a.time_stamp,
            ).compareTo(DateTime.parse(b.time_stamp)),
          );

    return journalFiles.value;
  }

  void _refreshDashboardData() {
    dashboards.clear();
    if (journalFiles.value.isEmpty) {
      return;
    }

    final firstDayTimeStamp = journalFiles.value.first.time_stamp;
    final currentDay = DateTime.now();

    var firstDay = DateTime.parse(firstDayTimeStamp);
    var daysBetween = currentDay.difference(firstDay).inDays;
    if (daysBetween < 14) {
      // 如果当前日期早于第一个日记文件的日期，则不需要创建仪表板
      firstDay = currentDay.subtract(Duration(days: 14));
      daysBetween = 14; // 确保至少有14天的数据
      debugPrint(
        'Rebuilding Dashboard2 with first day: $firstDay, days between: $daysBetween',
      );
    }

    for (int i = 0; i <= daysBetween; i++) {
      final date = firstDay.add(Duration(days: i));
      dashboards.add(Dashboard(dateTime: date));
      // 如果是测试模式，则测试仪表板的随机打乱
      dashboards.last.testShuffle();
    }

    for (var dashboard in dashboards) {
      // 遍历每个仪表板，填充数据
      final journalFile = getJournalFileByDate(dashboard.dateTime);
      if (journalFile != null) {
        dashboard.journalFile = journalFile;
        dashboard.syncDataWithJournalFile();
      }
    }
  }

  JournalFile? getJournalFileByDate(DateTime date) {
    // 根据日期获取日记文件
    final dateString = JournalFile.dateTimeToKey(date);
    for (var file in journalFiles.value) {
      if (file.time_stamp.startsWith(dateString)) {
        return file; // 返回匹配的日记文件
      }
    }
    return null; // 如果没有找到匹配的日记文件，则返回null
  }

  //
  void setupJournalFiles(List<JournalFile> files) {
    // 初始化日记文件列表
    journalFiles.value = files;
    _sortJournalFilesByDate(); // 排序
    _refreshDashboardData();
  }
}
