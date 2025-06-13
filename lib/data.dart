// ignore_for_file: non_constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
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

class MoodTracking2 {
  static const peacefulColor = 0xFF2196F3; // 蓝色
  static const energizedColor = 0xFFFF9800; // 橙色
  static const engagedColor = 0xFF4CAF50; // 绿色
  static const disengagedColor = 0xFF9E9E9E; // 灰色
  static const happyColor = 0xFFFFEB3B; // 黄色
  static const sadColor = 0xFF9C27B0; // 紫色
  static const anxiousColor = 0xFFF44336; // 红色
  static const stressedColor = 0xFFCDDC39; // 浅绿色
  static const relaxedColor = 0xFF00BCD4; // 青色
  static const excitedColor = 0xFFFFC107; // 深黄色
  static const boredColor = 0xFF673AB7; // 深紫色
  static const frustratedColor = 0xFF3F51B5; // 深蓝色
  static const contentColor = 0xFF8BC34A; // 浅绿色
  static const neutralColor = 0xFF9E9E9E; // 灰色

  final String name;
  double percentage;
  MoodTracking2({required this.name, required this.percentage});

  int get color {
    switch (name.toLowerCase()) {
      case 'peaceful':
        return peacefulColor;
      case 'energized':
        return energizedColor;
      case 'engaged':
        return engagedColor;
      case 'disengaged':
        return disengagedColor;
      case 'happy':
        return happyColor;
      case 'sad':
        return sadColor;
      case 'anxious':
        return anxiousColor;
      case 'stressed':
        return stressedColor;
      case 'relaxed':
        return relaxedColor;
      case 'excited':
        return excitedColor;
      case 'bored':
        return boredColor;
      case 'frustrated':
        return frustratedColor;
      case 'content':
        return contentColor;
      default:
        return neutralColor; // 默认颜色为灰色
    }
  }
}

class AwakeTimeAllocation2 {
  static const workColor = 0xFF2196F3; // 蓝色
  static const exerciseColor = 0xFFFF9800; // 橙色
  static const socialColor = 0xFF4CAF50; // 绿色
  static const learningColor = 0xFF9E9E9E; // 灰色
  static const selfCareColor = 0xFFFFEB3B; // 黄色
  static const choresColor = 0xFF9C27B0; // 紫色
  static const commuteColor = 0xFFF44336; // 红色
  static const mealColor = 0xFFCDDC39; // 浅绿色
  static const leisureColor = 0xFF00BCD4; // 青色
  static const unknownColor = 0xFF9E9E9E; // 灰色

  final String name;
  double minutes;

  AwakeTimeAllocation2({required this.name, required this.minutes});

  int get color {
    switch (name.toLowerCase()) {
      case 'work':
        return workColor;
      case 'exercise':
        return exerciseColor;
      case 'social':
        return socialColor;
      case 'learning':
        return learningColor;
      case 'self-care':
        return selfCareColor;
      case 'chores':
        return choresColor;
      case 'commute':
        return commuteColor;
      case 'meal':
        return mealColor;
      case 'leisure':
        return leisureColor;
      default:
        return unknownColor; // 默认颜色为灰色
    }
  }
}

class SocialEntity2 {
  static const energizingColor = 0xFF4CAF50; // 绿色
  static const drainingColor = 0xFFF44336; // 红色
  static const neutralColor = 0xFF9E9E9E; // 灰色

  final String name;
  double minutes;
  final Set<String> interactionDynamics;
  final Set<String> impacts;

  SocialEntity2({
    required this.name,
    required this.minutes,
    required this.interactionDynamics,
    required this.impacts,
  });

  // 写一个方法，和另外一个 SocialEntity2 合并，并返回自身。
  SocialEntity2 merge(SocialEntity2 other) {
    if (name != other.name) {
      throw ArgumentError('Cannot merge different social entities');
    }
    return SocialEntity2(
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
    double totalMoodScore = 0;
    for (var event in events) {
      totalMoodScore += event.mood_score;
    }
    return totalMoodScore / events.length;
  }

  double get stressLevelAverage {
    double totalStressLevel = 0;
    for (var event in events) {
      totalStressLevel += event.stress_level;
    }
    return totalStressLevel / events.length;
  }

  double get energyLevelAverage {
    double totalEnergyLevel = 0;
    for (var event in events) {
      totalEnergyLevel += event.energy_level;
    }
    return totalEnergyLevel / events.length;
  }

  double get totalDurationMinutes {
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

  List<MoodTracking2> get moodTracking2 {
    List<MoodTracking2> ret = [];
    final totalTime = totalDurationMinutes;
    for (var entry in moodTimeMap.entries) {
      double percentage = entry.value / totalTime;
      ret.add(MoodTracking2(name: entry.key, percentage: percentage));
    }

    return ret;
  }

  List<AwakeTimeAllocation2> get awakeTimeAllocation2 {
    List<AwakeTimeAllocation2> ret = [];
    for (var entry in activityTimeMap.entries) {
      ret.add(AwakeTimeAllocation2(name: entry.key, minutes: entry.value));
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

  Map<String, SocialEntity2> get socialEntities {
    Map<String, SocialEntity2> socialMap = {};
    for (var event in events) {
      for (var person in event.people_involved) {
        if (socialMap.containsKey(person)) {
          socialMap[person]!.minutes += event.duration_minutes.toDouble();
          socialMap[person]!.interactionDynamics.add(event.interaction_dynamic);
          socialMap[person]!.impacts.add(event.inferred_impact_on_user_name);
        } else {
          socialMap[person] = SocialEntity2(
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
