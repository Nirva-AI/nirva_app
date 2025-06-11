// 这是一个数据管理器类，负责管理应用程序中的数据结构和数据
import 'package:nirva_app/data.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

// 管理全局数据的类
class RuntimeData {
  // 用户信息
  User user = User(username: "", password: "", displayName: "");

  // 当前的日记和仪表板数据
  List<Journal> journals = []; // 旧的数据。！
  DateTime selectedDateTime = DateTime.now();

  // 当前的待办事项数据
  List<Task> tasks = [];

  // 当前的高亮数据
  List<ArchivedHighlights> weeklyArchivedHighlights = [];
  List<ArchivedHighlights> monthlyArchivedHighlights = [];

  // 标记为最爱的日记条目，存本地手机即可，暂时不考虑存服务器。
  ValueNotifier<List<String>> favorites = ValueNotifier([]);

  // 日记条目笔记
  ValueNotifier<List<Note>> notes = ValueNotifier([]);

  //
  List<Dashboard> dashboards = [];

  Journal get currentJournal {
    // 获取当前的日记条目
    if (journals.isNotEmpty) {
      return journals.last;
    } else {
      return Journal(
        id: "",
        dateTime: DateTime.now(),
        highlights: [],
        //energyLevels: [],
        moodTrackings: [],
        awakeTimeAllocations: [],
        //socialMap: SocialMap(id: "", socialEntities: []),
      );
    }
  }

  Dashboard get currentDashboard {
    // 获取当前的仪表板
    if (dashboards.isNotEmpty) {
      return dashboards.last;
    } else {
      return Dashboard.createEmpty();
    }
  }

  bool hasTask(String tag, String description) {
    // 检查是否存在指定标签和描述的任务
    return tasks.any(
      (task) => task.tag == tag && task.description == description,
    );
  }

  void addTask(String tag, String description) {
    if (hasTask(tag, description)) {
      // 如果任务已存在，则不添加
      debugPrint('Task already exists: $tag - $description');
      return;
    }

    // 添加任务到任务列表
    final uuid = Uuid(); // 创建UUID生成器实例
    final newTask = Task(
      id: uuid.v4(), // 生成唯一的任务ID
      tag: tag,
      description: description,
      isCompleted: false,
    );
    tasks.add(newTask);
    debugPrint('Task added: $tag - $description');
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

  // 切换任务的完成状态
  void switchTaskStatus(Task task) {
    // 切换任务的完成状态
    final int index = tasks.indexOf(task);
    if (index != -1) {
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      tasks[index] = updatedTask;
    }
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
}
