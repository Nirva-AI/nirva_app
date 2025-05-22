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
  const factory EventTag({required String name}) = _EventTag;

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
class HighlightGroup with _$HighlightGroup {
  const factory HighlightGroup({
    required DateTime beginTime,
    required DateTime endTime,
    required List<Highlight> highlights,
  }) = _HighlightGroup;

  factory HighlightGroup.fromJson(Map<String, dynamic> json) =>
      _$HighlightGroupFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _HighlightGroup).toJson();
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

@freezed
class SocialMap with _$SocialMap {
  const factory SocialMap({required List<SocialEntity> socialEntities}) =
      _SocialMap;

  factory SocialMap.fromJson(Map<String, dynamic> json) =>
      _$SocialMapFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _SocialMap).toJson();
}

@freezed
class Journal with _$Journal {
  const factory Journal({
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
    required List<Energy> energyRecords,
    required List<Mood> moods,
    required List<AwakeTimeAction> awakeTimeActions,
    required SocialMap socialMap,
  }) = _Journal;

  factory Journal.fromJson(Map<String, dynamic> json) =>
      _$JournalFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _Journal).toJson();

  static Journal createEmpty() {
    return Journal(
      dateTime: DateTime.now(),
      summary: '',
      diaryEntries: [],
      quotes: [],
      selfReflections: [],
      detailedInsights: [],
      goals: [],
      moodScore: MoodScore(value: 0.0, change: 0.0),
      stressLevel: StressLevel(value: 0.0, change: -1.3),
      highlights: [],
      energyRecords: [],
      moods: [],
      awakeTimeActions: [],
      socialMap: SocialMap(socialEntities: []),
    );
  }
}

extension JournalExtensions on Journal {
  Map<String, double> get moodMap {
    final Map<String, double> moodMap = {};
    for (var mood in moods) {
      moodMap[mood.name] = mood.moodPercentage;
    }
    return moodMap;
  }

  static final monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String get formattedDate {
    return '${monthNames[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }
}

@freezed
class MoodScoreInsights with _$MoodScoreInsights {
  const factory MoodScoreInsights({
    required DateTime dateTime,
    required List<String> insights,
  }) = _MoodScoreInsights;

  factory MoodScoreInsights.fromJson(Map<String, dynamic> json) =>
      _$MoodScoreInsightsFromJson(json);
  @override
  Map<String, dynamic> toJson() => (this as _MoodScoreInsights).toJson();
}
