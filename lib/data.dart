// ignore_for_file: non_constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'dart:math';
part 'data.freezed.dart';
part 'data.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String username,
    required String password,
    required String displayName,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _User).toJson();
}

@freezed
class EventAnalysis with _$EventAnalysis {
  const factory EventAnalysis({
    required String event_id,
    required String event_title,
    required String time_range,
    required int duration_minutes,
    required String location,
    required List<String> mood_labels,
    required int mood_score,
    required int stress_level,
    required int energy_level,
    required String activity_type,
    required List<String> people_involved,
    required String interaction_dynamic,
    required String inferred_impact_on_user_name,
    required List<String> topic_labels,
    required String one_sentence_summary,
    required String first_person_narrative,
    required String action_item,
  }) = _EventAnalysis;

  factory EventAnalysis.fromJson(Map<String, dynamic> json) =>
      _$EventAnalysisFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _EventAnalysis).toJson();
}

// 日常反思中的感恩部分
@freezed
class Gratitude with _$Gratitude {
  const factory Gratitude({
    required List<String> gratitude_summary,
    required String gratitude_details,
    required List<String> win_summary,
    required String win_details,
    required String feel_alive_moments,
  }) = _Gratitude;

  factory Gratitude.fromJson(Map<String, dynamic> json) =>
      _$GratitudeFromJson(json);
}

// 日常反思中的挑战与成长部分
@freezed
class ChallengesAndGrowth with _$ChallengesAndGrowth {
  const factory ChallengesAndGrowth({
    required List<String> growth_summary,
    required String obstacles_faced,
    required String unfinished_intentions,
    required String contributing_factors,
  }) = _ChallengesAndGrowth;

  factory ChallengesAndGrowth.fromJson(Map<String, dynamic> json) =>
      _$ChallengesAndGrowthFromJson(json);
}

// 日常反思中的学习与洞察部分
@freezed
class LearningAndInsights with _$LearningAndInsights {
  const factory LearningAndInsights({
    required String new_knowledge,
    required String self_discovery,
    required String insights_about_others,
    required String broader_lessons,
  }) = _LearningAndInsights;

  factory LearningAndInsights.fromJson(Map<String, dynamic> json) =>
      _$LearningAndInsightsFromJson(json);
}

// 日常反思中的连接与关系部分
@freezed
class ConnectionsAndRelationships with _$ConnectionsAndRelationships {
  const factory ConnectionsAndRelationships({
    required String meaningful_interactions,
    required String notable_about_people,
    required String follow_up_needed,
  }) = _ConnectionsAndRelationships;

  factory ConnectionsAndRelationships.fromJson(Map<String, dynamic> json) =>
      _$ConnectionsAndRelationshipsFromJson(json);
}

// 日常反思中的展望未来部分
@freezed
class LookingForward with _$LookingForward {
  const factory LookingForward({
    required String do_differently_tomorrow,
    required String continue_what_worked,
    required List<String> top_3_priorities_tomorrow,
  }) = _LookingForward;

  factory LookingForward.fromJson(Map<String, dynamic> json) =>
      _$LookingForwardFromJson(json);
}

// 完整的日常反思数据结构
@freezed
class DailyReflection with _$DailyReflection {
  const factory DailyReflection({
    required String reflection_summary,
    required Gratitude gratitude,
    required ChallengesAndGrowth challenges_and_growth,
    required LearningAndInsights learning_and_insights,
    required ConnectionsAndRelationships connections_and_relationships,
    required LookingForward looking_forward,
  }) = _DailyReflection;

  factory DailyReflection.fromJson(Map<String, dynamic> json) =>
      _$DailyReflectionFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _DailyReflection).toJson();
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

@freezed
class Note with _$Note {
  const factory Note({required String id, required String content}) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _Note).toJson();
}

@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String tag,
    required String description,
    @Default(false) bool isCompleted,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _Task).toJson();
}

class MoodTracking {
  static const List<String> moodNames = [
    'peaceful',
    'energized',
    'engaged',
    'disengaged',
    'happy',
    'sad',
    'anxious',
    'stressed',
    'relaxed',
    'excited',
    'bored',
    'frustrated',
    'content',
    'neutral', // 添加一个中性情绪
  ];

  final String name;
  double ratio;
  MoodTracking({required this.name, required this.ratio});

  int get color {
    switch (name.toLowerCase()) {
      case 'peaceful':
        return 0xFF2196F3;
      case 'energized':
        return 0xFFFF9800;
      case 'engaged':
        return 0xFF4CAF50;
      case 'disengaged':
        return 0xFF9E9E9E;
      case 'happy':
        return 0xFFFFEB3B;
      case 'sad':
        return 0xFF9C27B0;
      case 'anxious':
        return 0xFFF44336;
      case 'stressed':
        return 0xFFCDDC39;
      case 'relaxed':
        return 0xFF00BCD4;
      case 'excited':
        return 0xFFFFC107;
      case 'bored':
        return 0xFF673AB7;
      case 'frustrated':
        return 0xFF3F51B5;
      case 'content':
        return 0xFF8BC34A;
      case 'neutral':
        return 0xFF9E9E9E; // 中性情绪的颜色
      default:
        return 0xFF9E9E9E; // 默认颜色为灰色
    }
  }
}

class AwakeTimeAllocation {
  static const List<String> activityNames = [
    'work',
    'exercise',
    'social',
    'learning',
    'self-care',
    'chores',
    'commute',
    'meal',
    'leisure',
  ];

  final String name;
  double minutes;

  AwakeTimeAllocation({required this.name, required this.minutes});

  int get color {
    switch (name.toLowerCase()) {
      case 'work':
        return 0xFF2196F3; // 蓝色
      case 'exercise':
        return 0xFFFF9800; // 橙色
      case 'social':
        return 0xFF4CAF50; // 绿色
      case 'learning':
        return 0xFF9E9E9E; // 灰色
      case 'self-care':
        return 0xFFFFEB3B; // 黄色
      case 'chores':
        return 0xFF9C27B0; // 紫色
      case 'commute':
        return 0xFFF44336; // 红色
      case 'meal':
        return 0xFFCDDC39; // 浅绿色
      case 'leisure':
        return 0xFF00BCD4; // 青色
      default:
        return 0xFF9E9E9E; // 默认颜色为灰色
    }
  }
}

class SocialEntity {
  static const energizingColor = 0xFF4CAF50; // 绿色
  static const drainingColor = 0xFFF44336; // 红色
  static const neutralColor = 0xFF9E9E9E; // 灰色

  final String name;
  double minutes;
  final Set<String> interactionDynamics;
  final Set<String> impacts;

  SocialEntity({
    required this.name,
    required this.minutes,
    required this.interactionDynamics,
    required this.impacts,
  });

  // 写一个方法，和另外一个 SocialEntity2 合并，并返回自身。
  SocialEntity merge(SocialEntity other) {
    if (name != other.name) {
      throw ArgumentError('Cannot merge different social entities');
    }
    return SocialEntity(
      name: name,
      minutes: minutes + other.minutes,
      interactionDynamics: Set.from(interactionDynamics)
        ..addAll(other.interactionDynamics),
      impacts: Set.from(impacts)..addAll(other.impacts),
    );
  }

  double get hours {
    return minutes / 60.0; // 将分钟转换为小时
  }

  String get impact {
    if (impacts.isEmpty) return 'N/A';
    // 假设影响是正面、中性或负面
    if (impacts.contains('energizing')) {
      return 'energizing';
    } else if (impacts.contains('draining')) {
      return 'draining';
    } else {
      return 'neutral';
    }
  }

  // 根据 interactionDynamics 和 impacts 生成描述
  String get discription {
    String dynamicsDescription =
        interactionDynamics.isNotEmpty ? interactionDynamics.join(', ') : 'N/A';
    String impactDescription = impacts.isNotEmpty ? impacts.join(', ') : 'N/A';
    return 'Dynamics: $dynamicsDescription, Impact: $impactDescription';
  }

  int get color {
    switch (impact) {
      case 'energizing':
        return energizingColor;
      case 'draining':
        return drainingColor;
      case 'neutral':
        return neutralColor;
      default:
        return neutralColor; // 默认颜色为灰色
    }
  }
}

@freezed
class JournalFile with _$JournalFile {
  const factory JournalFile({
    required String username,
    required String time_stamp,
    required List<EventAnalysis> events,
    required DailyReflection daily_reflection,
  }) = _JournalFile;

  factory JournalFile.fromJson(Map<String, dynamic> json) =>
      _$JournalFileFromJson(json);

  @override
  Map<String, dynamic> toJson() => (this as _JournalFile).toJson();

  static String dateTimeToKey(DateTime date) {
    // 格式 "yyyy-MM-ddTHH:mm:ss" 完全符合 ISO8601 格式但不含毫秒
    final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    return formatter.format(date);
  }

  static JournalFile createEmpty() {
    // 创建一个空的 JournalFile
    return JournalFile(
      username: "",
      time_stamp: "",
      events: [],
      daily_reflection: DailyReflection(
        reflection_summary: '',
        gratitude: Gratitude(
          gratitude_summary: [],
          gratitude_details: '',
          win_summary: [],
          win_details: '',
          feel_alive_moments: '',
        ),
        challenges_and_growth: ChallengesAndGrowth(
          growth_summary: [],
          obstacles_faced: '',
          unfinished_intentions: '',
          contributing_factors: '',
        ),
        learning_and_insights: LearningAndInsights(
          new_knowledge: '',
          self_discovery: '',
          insights_about_others: '',
          broader_lessons: '',
        ),
        connections_and_relationships: ConnectionsAndRelationships(
          meaningful_interactions: '',
          notable_about_people: '',
          follow_up_needed: '',
        ),
        looking_forward: LookingForward(
          do_differently_tomorrow: '',
          continue_what_worked: '',
          top_3_priorities_tomorrow: [],
        ),
        // ),
      ),
      //message: "",
    );
  }
}

extension JournalFileExtensions on JournalFile {
  Gratitude get gratitude {
    // 返回日常反思中的感恩部分
    return daily_reflection.gratitude;
  }

  ChallengesAndGrowth get challengesAndGrowth {
    // 返回日常反思中的挑战与成长部分
    return daily_reflection.challenges_and_growth;
  }

  LearningAndInsights get learningAndInsights {
    // 返回日常反思中的学习与洞察部分
    return daily_reflection.learning_and_insights;
  }

  ConnectionsAndRelationships get connectionsAndRelationships {
    // 返回日常反思中的连接与关系部分
    return daily_reflection.connections_and_relationships;
  }

  LookingForward get lookingForward {
    // 返回日常反思中的展望未来部分
    return daily_reflection.looking_forward;
  }

  double get moodScoreAverage {
    if (events.isEmpty) {
      return 0.0; // 避免除以零
    }
    double totalMoodScore = 0;
    for (var event in events) {
      totalMoodScore += event.mood_score;
    }
    return totalMoodScore / events.length;
  }

  double get stressLevelAverage {
    if (events.isEmpty) {
      return 0.0; // 避免除以零
    }
    double totalStressLevel = 0;
    for (var event in events) {
      totalStressLevel += event.stress_level;
    }
    return totalStressLevel / events.length;
  }

  double get energyLevelAverage {
    if (events.isEmpty) {
      return 0.0; // 避免除以零
    }
    double totalEnergyLevel = 0;
    for (var event in events) {
      totalEnergyLevel += event.energy_level;
    }
    return totalEnergyLevel / events.length;
  }

  double get totalDurationMinutes {
    if (events.isEmpty) {
      return 0.0; // 避免除以零
    }
    double totalDuration = 0;
    for (var event in events) {
      totalDuration += event.duration_minutes.toDouble();
    }
    return totalDuration;
  }

  Map<String, double> get moodTimeMap {
    Map<String, double> moodTimeMap = {};
    for (var event in events) {
      for (var moodLabel in event.mood_labels) {
        if (moodTimeMap.containsKey(moodLabel)) {
          moodTimeMap[moodLabel] =
              moodTimeMap[moodLabel]! + event.duration_minutes.toDouble();
        } else {
          moodTimeMap[moodLabel] = event.duration_minutes.toDouble();
        }
      }
    }
    return moodTimeMap;
  }

  Map<String, double> get activityTimeMap {
    Map<String, double> activityTimeMap = {};
    for (var event in events) {
      if (activityTimeMap.containsKey(event.activity_type)) {
        activityTimeMap[event.activity_type] =
            activityTimeMap[event.activity_type]! +
            event.duration_minutes.toDouble();
      } else {
        activityTimeMap[event.activity_type] =
            event.duration_minutes.toDouble();
      }
    }
    return activityTimeMap;
  }

  List<MoodTracking> get moodTracking {
    final totalTime = totalDurationMinutes;
    if (totalTime == 0) {
      return []; // 如果没有事件，返回空列表
    }
    List<MoodTracking> ret = [];
    for (var entry in moodTimeMap.entries) {
      final ratio = entry.value / totalTime;
      ret.add(MoodTracking(name: entry.key, ratio: ratio));
    }

    return ret;
  }

  List<AwakeTimeAllocation> get awakeTimeAllocation {
    List<AwakeTimeAllocation> ret = [];
    for (var entry in activityTimeMap.entries) {
      ret.add(AwakeTimeAllocation(name: entry.key, minutes: entry.value));
    }
    return ret;
  }

  Set<String> get peoples_involved {
    Set<String> peoples = {};
    for (var event in events) {
      peoples.addAll(event.people_involved);
    }
    return peoples;
  }

  SocialEntity getSocialEntity(String name) {
    // 根据名字获取社交实体
    for (var event in events) {
      if (event.people_involved.contains(name)) {
        return SocialEntity(
          name: name,
          minutes: event.duration_minutes.toDouble(),
          interactionDynamics: {event.interaction_dynamic},
          impacts: {event.inferred_impact_on_user_name},
        );
      }
    }
    return SocialEntity(
      name: name,
      minutes: 0.0,
      interactionDynamics: {},
      impacts: {},
    );
  }

  Map<String, SocialEntity> get socialEntities {
    Map<String, SocialEntity> socialMap = {};
    for (var event in events) {
      for (var person in event.people_involved) {
        if (socialMap.containsKey(person)) {
          socialMap[person]!.minutes += event.duration_minutes.toDouble();
          socialMap[person]!.interactionDynamics.add(event.interaction_dynamic);
          socialMap[person]!.impacts.add(event.inferred_impact_on_user_name);
        } else {
          socialMap[person] = SocialEntity(
            name: person,
            minutes: event.duration_minutes.toDouble(),
            interactionDynamics: {event.interaction_dynamic},
            impacts: {event.inferred_impact_on_user_name},
          );
        }
      }
    }
    return socialMap;
  }

  double totalSocialTime() {
    double total = 0.0;
    for (var entity in socialEntities.values) {
      total += entity.minutes;
    }
    return total;
  }

  List<String> genQuotes() {
    // 返回所有事件的 action_item
    if (events.isEmpty) {
      return [];
    }

    List<String> quotes = [];
    for (var event in events) {
      if (event.action_item.isEmpty || event.action_item == 'N/A') {
        continue;
      }

      quotes.add(event.action_item);
    }

    return quotes;
  }
}

class Dashboard {
  static final random = Random();

  // 指数1～10
  static const double moodScoreMinY = 0;
  static const double moodScoreMaxY = 12;
  static List<double> moodScoreYAxisLabels = [2.0, 4.0, 6.0, 8.0, 10.0];

  // 指数1～10
  static const double stressLevelMinY = 0;
  static const double stressLevelMaxY = 12;
  static List<double> stressLevelYAxisLabels = [2.0, 4.0, 6.0, 8.0, 10.0];

  // 指数1～10
  static const double energyLevelMinY = 0;
  static const double energyLevelMaxY = 12;
  static List<double> energyLevelYAxisLabels = [2.0, 4.0, 6.0, 8.0, 10.0];

  // 全天的百分率
  static const double moodTrackingMinY = 0;
  static const double moodTrackingMaxY = 100;
  static List<double> moodTrackingYAxisLabels = [20, 40, 60, 80];

  // 小时
  static const double awakeTimeAllocationMinY = 0;
  static const double awakeTimeAllocationMaxY = 10;
  static List<double> awakeTimeAllocationYAxisLabels = [2, 4, 6, 8];

  // 测试用的随机数生成器
  bool _isShuffled = false;

  // 仪表盘的日期
  final DateTime dateTime;

  // 仪表盘对应的 JournalFile
  JournalFile? journalFile;

  // 平均情绪分数
  double? moodScoreAverage;

  // 平均压力水平
  double? stressLevelAverage;

  // 平均能量水平
  double? energyLevelAverage;

  //moodTrackingMap 用于存储情绪追踪数据
  Map<String, double> moodTrackingMap = {};

  // awakeTimeAllocationMap 用于存储清醒时间分配数据
  Map<String, double> awakeTimeAllocationMap = {};

  //
  Dashboard({required this.dateTime});

  void syncDataWithJournalFile() {
    if (journalFile == null) {
      moodScoreAverage = null;
      stressLevelAverage = null;
      return;
    }

    moodScoreAverage = journalFile!.moodScoreAverage;
    stressLevelAverage = journalFile!.stressLevelAverage;
    energyLevelAverage = journalFile!.energyLevelAverage;

    // 清空之前的数据
    moodTrackingMap.clear();
    for (var entry in journalFile!.moodTracking) {
      moodTrackingMap[entry.name] = entry.ratio;
    }

    // 清空之前的 awakeTimeAllocationMap
    awakeTimeAllocationMap.clear();
    for (var entry in journalFile!.awakeTimeAllocation) {
      awakeTimeAllocationMap[entry.name] = entry.minutes;
    }
  }

  void shuffleData() {
    //return;
    if (random.nextDouble() < 0.1) {
      return;
    }
    _isShuffled = true;
    moodScoreAverage = 4 + random.nextDouble() * 6;
    stressLevelAverage = 4 + random.nextDouble() * 6;
    energyLevelAverage = 4 + random.nextDouble() * 6;
  }

  //
  double? getMoodTrackingRatio(String moodName) {
    if (_isShuffled && !moodTrackingMap.containsKey(moodName)) {
      moodTrackingMap[moodName] = 0.2 + random.nextDouble() * 0.6;
    }
    if (moodTrackingMap.containsKey(moodName)) {
      return moodTrackingMap[moodName];
    }
    return null;
  }

  double? getAwakeTimeAllocationMinutes(String activityName) {
    if (_isShuffled && !awakeTimeAllocationMap.containsKey(activityName)) {
      // 返回2h~8h 即（60 * 2 与 60 * 8）之间的数字
      awakeTimeAllocationMap[activityName] =
          120 + random.nextDouble() * 360; // 2小时到8小时之间
    }
    if (awakeTimeAllocationMap.containsKey(activityName)) {
      return awakeTimeAllocationMap[activityName];
    }
    return null;
  }
}
