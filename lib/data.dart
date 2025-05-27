import 'package:freezed_annotation/freezed_annotation.dart';
part 'data.freezed.dart';
part 'data.g.dart';

@freezed
class User with _$User {
  const factory User({required String name}) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _User).toJson();
}

@freezed
class Quote with _$Quote {
  const factory Quote({required String text, required String mood}) = _Quote;

  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _Quote).toJson();
}

@freezed
class EventTag with _$EventTag {
  const factory EventTag({
    required String name,
    @Default(0xFFDFE7FF) int color,
  }) = _EventTag;

  factory EventTag.fromJson(Map<String, dynamic> json) =>
      _$EventTagFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _EventTag).toJson();
}

@freezed
class EventLocation with _$EventLocation {
  const factory EventLocation({required String name}) = _EventLocation;

  factory EventLocation.fromJson(Map<String, dynamic> json) =>
      _$EventLocationFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _EventLocation).toJson();
}

@freezed
class DiaryEntry with _$DiaryEntry {
  const factory DiaryEntry({
    required String id,
    required DateTime beginTime,
    required DateTime endTime,
    required String title,
    required String summary,
    required String content,
    required List<EventTag> tags,
    required EventLocation location,
  }) = _DiaryEntry;

  factory DiaryEntry.fromJson(Map<String, dynamic> json) =>
      _$DiaryEntryFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _DiaryEntry).toJson();
}

@freezed
class DiaryEntryNote with _$DiaryEntryNote {
  const factory DiaryEntryNote({required String id, required String content}) =
      _DiaryEntryNote;

  factory DiaryEntryNote.fromJson(Map<String, dynamic> json) =>
      _$DiaryEntryNoteFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _DiaryEntryNote).toJson();
}

@freezed
class Reflection with _$Reflection {
  const factory Reflection({
    required String id,
    required String title,
    required List<String> items,
    required String content,
  }) = _Reflection;

  factory Reflection.fromJson(Map<String, dynamic> json) =>
      _$ReflectionFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _Reflection).toJson();
}

@freezed
class MoodScore with _$MoodScore {
  const factory MoodScore({required double value, required double change}) =
      _MoodScore;

  factory MoodScore.fromJson(Map<String, dynamic> json) =>
      _$MoodScoreFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _MoodScore).toJson();
}

@freezed
class StressLevel with _$StressLevel {
  const factory StressLevel({required double value, required double change}) =
      _StressLevel;

  factory StressLevel.fromJson(Map<String, dynamic> json) =>
      _$StressLevelFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _StressLevel).toJson();
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
class EnergyLevel with _$EnergyLevel {
  const factory EnergyLevel({
    required DateTime dateTime,
    required double value,
  }) = _EnergyLevel;

  factory EnergyLevel.fromJson(Map<String, dynamic> json) =>
      _$EnergyLevelFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _EnergyLevel).toJson();
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
    required String summary,
    required List<DiaryEntry> diaryEntries,
    required List<Quote> quotes,
    required List<Reflection> selfReflections,
    required List<Reflection> detailedInsights,
    required List<Reflection> goals,
    required MoodScore moodScore,
    required StressLevel stressLevel,
    required List<Highlight> highlights,
    required List<EnergyLevel> energyLevels,
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
