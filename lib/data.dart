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

@freezed
class EnergyLabel with _$EnergyLabel {
  const factory EnergyLabel({
    required String label,
    required double measurementValue,
  }) = _EnergyLabel;

  factory EnergyLabel.fromJson(Map<String, dynamic> json) =>
      _$EnergyLabelFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _EnergyLabel).toJson();
}

@freezed
class Energy with _$Energy {
  const factory Energy({
    required DateTime dateTime,
    required double energyLevel,
  }) = _Energy;

  factory Energy.fromJson(Map<String, dynamic> json) => _$EnergyFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _Energy).toJson();

  static const lowMinus = EnergyLabel(label: '', measurementValue: 0.0);
  static const low = EnergyLabel(label: 'Low', measurementValue: 1.0);
  static const neutral = EnergyLabel(label: 'Neutral', measurementValue: 2.0);
  static const high = EnergyLabel(label: 'High', measurementValue: 3.0);
  static const highPlus = EnergyLabel(label: '', measurementValue: 4.0);
}

extension EnergyExtensions on Energy {
  String get time =>
      "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";

  EnergyLabel get energyLabel {
    if (energyLevel <= Energy.lowMinus.measurementValue) {
      return Energy.lowMinus;
    }
    if (energyLevel <= Energy.low.measurementValue) {
      return Energy.low;
    }
    if (energyLevel <= Energy.neutral.measurementValue) {
      return Energy.neutral;
    }
    if (energyLevel <= Energy.high.measurementValue) {
      return Energy.high;
    }
    return Energy.highPlus;
  }

  String get energyLabelString => energyLabel.label;
}

@freezed
class Mood with _$Mood {
  const factory Mood({
    required String name,
    required double moodValue,
    required double moodPercentage,
    @Default(0xFF00FF00) int color, // 默认颜色为绿色
  }) = _Mood;

  factory Mood.fromJson(Map<String, dynamic> json) => _$MoodFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _Mood).toJson();
}

@freezed
class AwakeTimeAction with _$AwakeTimeAction {
  const factory AwakeTimeAction({
    required String label,
    required double value,
    @Default(0xFF00FF00) int color, // 默认颜色为绿色
  }) = _AwakeTimeAction;

  factory AwakeTimeAction.fromJson(Map<String, dynamic> json) =>
      _$AwakeTimeActionFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _AwakeTimeAction).toJson();
}

// 社交对象数据结构
// @JsonSerializable(explicitToJson: true)
// class SocialEntity {
//   final String name; // 社交对象的名字
//   final String details; // 详细信息
//   final List<String> tips;
//   final String timeSpent; // 互动时间

//   SocialEntity({
//     required this.name,
//     required this.details,
//     required this.tips,
//     required this.timeSpent,
//   });

//   // JSON序列化和反序列化
//   factory SocialEntity.fromJson(Map<String, dynamic> json) =>
//       _$SocialEntityFromJson(json); // 反序列化
//   Map<String, dynamic> toJson() => _$SocialEntityToJson(this); // 序列化
// }

@freezed
class SocialEntity with _$SocialEntity {
  const factory SocialEntity({
    required String name,
    required String details,
    required List<String> tips,
    required String timeSpent,
  }) = _SocialEntity;

  factory SocialEntity.fromJson(Map<String, dynamic> json) =>
      _$SocialEntityFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _SocialEntity).toJson();
}

// @JsonSerializable(explicitToJson: true)
// class SocialMap {
//   List<SocialEntity> socialEntities = [];
//   SocialMap({required this.socialEntities});
//   // JSON序列化和反序列化
//   factory SocialMap.fromJson(Map<String, dynamic> json) =>
//       _$SocialMapFromJson(json); // 反序列化
//   Map<String, dynamic> toJson() => _$SocialMapToJson(this); // 序列化
// }

@freezed
class SocialMap with _$SocialMap {
  const factory SocialMap({required List<SocialEntity> socialEntities}) =
      _SocialMap;

  factory SocialMap.fromJson(Map<String, dynamic> json) =>
      _$SocialMapFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _SocialMap).toJson();
}
