// model/user.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'data.freezed.dart';
part 'data.g.dart';

@freezed
class User with _$User {
  const factory User({required int id, required String name}) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  @override
  Map<String, dynamic> toJson() => (this as _User).toJson();
}

@freezed
class Quote with _$Quote {
  const factory Quote({required String text}) = _Quote;

  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _Quote).toJson();
}

@freezed
class Diary with _$Diary {
  const factory Diary({
    required String time,
    required String title,
    required String summary,
    required String content,
    required List<String> tags,
    required String location,
  }) = _Diary;

  factory Diary.fromJson(Map<String, dynamic> json) => _$DiaryFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _Diary).toJson();
}

@freezed
class Reflection with _$Reflection {
  const factory Reflection({
    required String title,
    required List<String> items,
  }) = _Reflection;

  factory Reflection.fromJson(Map<String, dynamic> json) =>
      _$ReflectionFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _Reflection).toJson();
}

@freezed
class Score with _$Score {
  const factory Score({
    required String title,
    required double value,
    required double change,
  }) = _Score;

  factory Score.fromJson(Map<String, dynamic> json) => _$ScoreFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _Score).toJson();
}

@freezed
class Highlight with _$Highlight {
  const factory Highlight({
    required String title,
    required String content,
    @Default(0xFF00FF00) int color, // 默认颜色为绿色
  }) = _Highlight;

  factory Highlight.fromJson(Map<String, dynamic> json) =>
      _$HighlightFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _Highlight).toJson();
}

@freezed
class Task with _$Task {
  const factory Task({
    required String tag,
    required String description,
    @Default(false) bool isCompleted,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _Task).toJson();
}

extension TaskExtensions on Task {
  Task setCompleted(bool value) {
    return copyWith(isCompleted: value);
  }
}

@freezed
class TodoList with _$TodoList {
  const factory TodoList({required List<Task> tasks}) = _TodoList;

  factory TodoList.fromJson(Map<String, dynamic> json) =>
      _$TodoListFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _TodoList).toJson();
}

extension TodoListExtensions on TodoList {
  TodoList addTask(Task task) {
    return copyWith(tasks: [...tasks, task]);
  }

  TodoList removeTask(Task task) {
    return copyWith(tasks: tasks.where((t) => t != task).toList());
  }

  TodoList updateTask(Task oldTask, Task newTask) {
    return copyWith(
      tasks: tasks.map((t) => t == oldTask ? newTask : t).toList(),
    );
  }

  TodoList toggleTaskCompletion(Task task) {
    return copyWith(
      tasks:
          tasks
              .map(
                (t) => t == task ? t.copyWith(isCompleted: !t.isCompleted) : t,
              )
              .toList(),
    );
  }
}
