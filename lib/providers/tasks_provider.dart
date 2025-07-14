import 'package:flutter/foundation.dart';
import 'package:nirva_app/data.dart';
import 'package:uuid/uuid.dart';

class TasksProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  final Uuid _uuid = Uuid();

  List<Task> get tasks => List.unmodifiable(_tasks);

  /// 设置任务列表（用于初始化数据）
  void setupTasks(List<Task> tasks) {
    _tasks = tasks;
    notifyListeners();
  }

  /// 检查是否存在指定标签和描述的任务
  bool hasTask(String tag, String description) {
    return _tasks.any(
      (task) => task.tag == tag && task.description == description,
    );
  }

  /// 添加任务到任务列表
  void addTask(String tag, String description) {
    final newTask = Task(
      id: _uuid.v4(),
      tag: tag,
      description: description,
      isCompleted: false,
    );
    _tasks.add(newTask);
    notifyListeners();
    debugPrint('Task added: $tag - $description');
  }

  /// 切换任务的完成状态
  void switchTaskStatus(Task task) {
    final int index = _tasks.indexOf(task);
    if (index != -1) {
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      _tasks[index] = updatedTask;
      notifyListeners();
    }
  }

  /// 删除指定任务
  void removeTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  /// 根据ID删除任务
  void removeTaskById(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  /// 获取按标签分组的任务
  Map<String, List<Task>> get groupedTasks {
    final Map<String, List<Task>> groupedTasks = {};
    for (var task in _tasks) {
      if (!groupedTasks.containsKey(task.tag)) {
        groupedTasks[task.tag] = [];
      }
      groupedTasks[task.tag]!.add(task);
    }
    return groupedTasks;
  }

  /// 清除已完成的任务
  void clearCompletedTasks() {
    _tasks = _tasks.where((task) => !task.isCompleted).toList();
    notifyListeners();
  }

  /// 获取已完成的任务列表
  List<Task> get completedTasks {
    return _tasks.where((task) => task.isCompleted).toList();
  }

  /// 获取未完成的任务列表
  List<Task> get incompleteTasks {
    return _tasks.where((task) => !task.isCompleted).toList();
  }

  /// 根据标签获取任务
  List<Task> getTasksByTag(String tag) {
    return _tasks.where((task) => task.tag == tag).toList();
  }

  /// 获取任务总数
  int get totalTasksCount => _tasks.length;

  /// 获取已完成任务数
  int get completedTasksCount => completedTasks.length;

  /// 获取未完成任务数
  int get incompleteTasksCount => incompleteTasks.length;

  /// 清空所有任务
  void clearAllTasks() {
    _tasks.clear();
    notifyListeners();
  }
}
