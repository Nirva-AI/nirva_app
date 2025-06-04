// ignore_for_file: non_constant_identifier_names
import 'package:freezed_annotation/freezed_annotation.dart';
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
class Event with _$Event {
  const factory Event({
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
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _Event).toJson();
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
class Highlight with _$Highlight {
  const factory Highlight({
    required String category,
    required String content,
    @Default(0xFF00FF00) int color, // 默认颜色为绿色
  }) = _Highlight;

  factory Highlight.fromJson(Map<String, dynamic> json) =>
      _$HighlightFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _Highlight).toJson();
}

@freezed
class ArchivedHighlights with _$ArchivedHighlights {
  const factory ArchivedHighlights({
    required DateTime beginTime,
    required DateTime endTime,
    required List<Highlight> highlights,
  }) = _ArchivedHighlights;

  factory ArchivedHighlights.fromJson(Map<String, dynamic> json) =>
      _$ArchivedHighlightsFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _ArchivedHighlights).toJson();
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

@freezed
class MoodTracking with _$MoodTracking {
  const factory MoodTracking({
    required String name,
    required double value,
    @Default(0xFF000000) int color, // 默认颜色为绿色
  }) = _MoodTracking;

  factory MoodTracking.fromJson(Map<String, dynamic> json) =>
      _$MoodTrackingFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _MoodTracking).toJson();
}

@freezed
class AwakeTimeAllocation with _$AwakeTimeAllocation {
  const factory AwakeTimeAllocation({
    required String name,
    required double value,
    @Default(0xFF00FF00) int color, // 默认颜色为绿色
  }) = _AwakeTimeAllocation;

  factory AwakeTimeAllocation.fromJson(Map<String, dynamic> json) =>
      _$AwakeTimeAllocationFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _AwakeTimeAllocation).toJson();
}

@freezed
class SocialEntity with _$SocialEntity {
  const factory SocialEntity({
    required String id,
    required String name,
    required String description,
    required List<String> tips,
    required double hours,
    @Default('') String impact,
  }) = _SocialEntity;

  factory SocialEntity.fromJson(Map<String, dynamic> json) =>
      _$SocialEntityFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _SocialEntity).toJson();
}

@freezed
class SocialMap with _$SocialMap {
  const factory SocialMap({
    required String id,
    required List<SocialEntity> socialEntities,
  }) = _SocialMap;

  factory SocialMap.fromJson(Map<String, dynamic> json) =>
      _$SocialMapFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _SocialMap).toJson();
}

@freezed
class Journal with _$Journal {
  const factory Journal({
    required String id,
    required DateTime dateTime,
    //required List<Quote> quotes,
    //required MoodScore moodScore,
    //required StressLevel stressLevel,
    required List<Highlight> highlights,
    //required List<EnergyLevel> energyLevels,
    required List<MoodTracking> moodTrackings,
    required List<AwakeTimeAllocation> awakeTimeAllocations,
    required SocialMap socialMap,
  }) = _Journal;

  factory Journal.fromJson(Map<String, dynamic> json) =>
      _$JournalFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _Journal).toJson();
}

extension JournalExtensions on Journal {
  Map<MoodTracking, double> get moodTrackingMap {
    double totalValue = 0.0;
    for (var mood in moodTrackings) {
      totalValue += mood.value;
    }
    final Map<MoodTracking, double> moodMap = {};
    if (totalValue == 0) {
      return moodMap;
    }
    for (var mood in moodTrackings) {
      moodMap[mood] = mood.value / totalValue;
    }
    return moodMap;
  }
}

@freezed
class MoodScoreDashboard with _$MoodScoreDashboard {
  const factory MoodScoreDashboard({
    required List<String> insights,
    required List<double> scores,
    required List<double> day,
    required List<double> week,
    required List<double> month,
  }) = _MoodScoreDashboard;

  factory MoodScoreDashboard.fromJson(Map<String, dynamic> json) =>
      _$MoodScoreDashboardFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _MoodScoreDashboard).toJson();
}

@freezed
class StressLevelDashboard with _$StressLevelDashboard {
  const factory StressLevelDashboard({
    required List<String> insights,
    required List<double> scores,
    required List<double> day,
    required List<double> week,
    required List<double> month,
  }) = _StressLevelDashboard;

  factory StressLevelDashboard.fromJson(Map<String, dynamic> json) =>
      _$StressLevelDashboardFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _StressLevelDashboard).toJson();
}

@freezed
class EnergyLevelDashboard with _$EnergyLevelDashboard {
  const factory EnergyLevelDashboard({
    required List<String> insights,
    required List<double> scores,
    required List<double> day,
    required List<double> week,
    required List<double> month,
  }) = _EnergyLevelDashboard;

  factory EnergyLevelDashboard.fromJson(Map<String, dynamic> json) =>
      _$EnergyLevelDashboardFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _EnergyLevelDashboard).toJson();
}

@freezed
class MoodTrackingDashboardEntry with _$MoodTrackingDashboardEntry {
  const factory MoodTrackingDashboardEntry({
    required MoodTracking moodTracking,
    required List<double> day,
    required List<double> week,
    required List<double> month,
  }) = _MoodTrackingDashboardEntry;

  factory MoodTrackingDashboardEntry.fromJson(Map<String, dynamic> json) =>
      _$MoodTrackingDashboardEntryFromJson(json);
  @override
  Map<String, dynamic> toJson() =>
      (this as _MoodTrackingDashboardEntry).toJson();
}

@freezed
class MoodTrackingDashboard with _$MoodTrackingDashboard {
  const factory MoodTrackingDashboard({
    required List<MoodTrackingDashboardEntry> entries,
    required List<String> insights,
  }) = _MoodTrackingDashboard;

  factory MoodTrackingDashboard.fromJson(Map<String, dynamic> json) =>
      _$MoodTrackingDashboardFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _MoodTrackingDashboard).toJson();
}

extension MoodTrackingDashboardExtensions on MoodTrackingDashboard {
  Map<String, MoodTrackingDashboardEntry> get moodTrackingMap {
    final Map<String, MoodTrackingDashboardEntry> moodMap = {};
    for (var entry in entries) {
      moodMap[entry.moodTracking.name] = entry;
    }
    return moodMap;
  }
}

@freezed
class AwakeTimeAllocationDashboardEntry
    with _$AwakeTimeAllocationDashboardEntry {
  const factory AwakeTimeAllocationDashboardEntry({
    required AwakeTimeAllocation awakeTimeAllocation,
    required List<double> day,
    required List<double> week,
    required List<double> month,
  }) = _AwakeTimeAllocationDashboardEntry;

  factory AwakeTimeAllocationDashboardEntry.fromJson(
    Map<String, dynamic> json,
  ) => _$AwakeTimeAllocationDashboardEntryFromJson(json);
  @override
  Map<String, dynamic> toJson() =>
      (this as _AwakeTimeAllocationDashboardEntry).toJson();
}

@freezed
class AwakeTimeAllocationDashboard with _$AwakeTimeAllocationDashboard {
  const factory AwakeTimeAllocationDashboard({
    required List<AwakeTimeAllocationDashboardEntry> entries,
    required List<String> insights,
  }) = _AwakeTimeAllocationDashboard;

  factory AwakeTimeAllocationDashboard.fromJson(Map<String, dynamic> json) =>
      _$AwakeTimeAllocationDashboardFromJson(json);
  @override
  Map<String, dynamic> toJson() =>
      (this as _AwakeTimeAllocationDashboard).toJson();
}

extension AwakeTimeAllocationDashboardExtensions
    on AwakeTimeAllocationDashboard {
  Map<String, AwakeTimeAllocationDashboardEntry> get awakeTimeAllocationMap {
    final Map<String, AwakeTimeAllocationDashboardEntry> allocationMap = {};
    for (var entry in entries) {
      allocationMap[entry.awakeTimeAllocation.name] = entry;
    }
    return allocationMap;
  }
}

@freezed
class Dashboard with _$Dashboard {
  const factory Dashboard({
    required DateTime dateTime,
    required MoodScoreDashboard moodScore,
    required StressLevelDashboard stressLevel,
    required EnergyLevelDashboard energyLevel,
    required MoodTrackingDashboard moodTracking,
    required AwakeTimeAllocationDashboard awakeTimeAllocation,
  }) = _Dashboard;

  factory Dashboard.fromJson(Map<String, dynamic> json) =>
      _$DashboardFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _Dashboard).toJson();

  static Dashboard createEmpty() {
    return Dashboard(
      dateTime: DateTime.now(),
      moodScore: MoodScoreDashboard(
        insights: [],
        scores: [],
        day: [],
        week: [],
        month: [],
      ),
      stressLevel: StressLevelDashboard(
        insights: [],
        scores: [],
        day: [],
        week: [],
        month: [],
      ),
      energyLevel: EnergyLevelDashboard(
        insights: [],
        scores: [],
        day: [],
        week: [],
        month: [],
      ),
      moodTracking: MoodTrackingDashboard(entries: [], insights: []),
      awakeTimeAllocation: AwakeTimeAllocationDashboard(
        entries: [],
        insights: [],
      ),
    );
  }
}

@freezed
class LabelExtraction with _$LabelExtraction {
  const factory LabelExtraction({required List<Event> events}) =
      _LabelExtraction;

  factory LabelExtraction.fromJson(Map<String, dynamic> json) =>
      _$LabelExtractionFromJson(json);
}

@freezed
class ReflectionData with _$ReflectionData {
  const factory ReflectionData({required DailyReflection daily_reflection}) =
      _ReflectionData;

  factory ReflectionData.fromJson(Map<String, dynamic> json) =>
      _$ReflectionDataFromJson(json);
}

@freezed
class JournalFile with _$JournalFile {
  const factory JournalFile({
    required LabelExtraction label_extraction,
    required ReflectionData reflection,
    required String message,
  }) = _JournalFile;

  factory JournalFile.fromJson(Map<String, dynamic> json) =>
      _$JournalFileFromJson(json);

  @override
  Map<String, dynamic> toJson() => (this as _JournalFile).toJson();
}

//  mood_labels: List[str] = Field(
//         description="Identify 1 to 3 mood labels that best describe user_name's personal mood during this event, based on their speech and reactions.
//Choose from:
//peaceful,
//energized,
//engaged,
//disengaged,
//happy,
//sad,
//anxious,
//stressed,
//relaxed,
//excited,
//bored,
//frustrated,
//content,
//neutral.
//
//The first label should be the most dominant mood for user_name. If only one strong mood is evident for user_name, use only that one label. If user_name's mood is unclear or mixed without a dominant feeling, use 'neutral'. These labels should reflect user_name's state, not the general atmosphere or the mood of other people involved, unless it clearly dictates user_name's mood."
//     )

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

extension JournalFileExtensions on JournalFile {
  List<Event> get events {
    // 返回 LabelExtraction 中的事件列表
    return label_extraction.events;
  }

  DailyReflection get dailyReflection {
    // 返回 ReflectionData 中的日常反思
    return reflection.daily_reflection;
  }

  Gratitude get gratitude {
    // 返回日常反思中的感恩部分
    return reflection.daily_reflection.gratitude;
  }

  ChallengesAndGrowth get challengesAndGrowth {
    // 返回日常反思中的挑战与成长部分
    return reflection.daily_reflection.challenges_and_growth;
  }

  LearningAndInsights get learningAndInsights {
    // 返回日常反思中的学习与洞察部分
    return reflection.daily_reflection.learning_and_insights;
  }

  ConnectionsAndRelationships get connectionsAndRelationships {
    // 返回日常反思中的连接与关系部分
    return reflection.daily_reflection.connections_and_relationships;
  }

  LookingForward get lookingForward {
    // 返回日常反思中的展望未来部分
    return reflection.daily_reflection.looking_forward;
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

  List<MoodTracking2> get moodTracking2 {
    List<MoodTracking2> ret = [];
    final totalTime = totalDurationMinutes;
    for (var entry in moodTimeMap.entries) {
      double percentage = entry.value / totalTime;
      ret.add(MoodTracking2(name: entry.key, percentage: percentage));
    }

    return ret;
  }
}
