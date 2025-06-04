// 这是一个数据管理器类，负责管理应用程序中的数据结构和数据
import 'package:nirva_app/data.dart';
import 'package:flutter/foundation.dart';

// 管理全局数据的类
class RuntimeData {
  // 用户信息
  User user = User(username: "", password: "", displayName: "");

  // 当前的日记和仪表板数据
  List<Journal> journals = [];
  List<JournalFile> journalFiles = [];
  Map<DateTime, JournalFile> journalFilesMap = {};

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

  //
  SocialMap globalSocialMap = SocialMap(id: "", socialEntities: []);

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

  Journal get currentJournal {
    // 获取当前的日记条目
    if (journals.isNotEmpty) {
      return journals.last;
    } else {
      return Journal(
        id: "",
        dateTime: DateTime.now(),
        //summary: '',
        //diaryEntries: [],
        quotes: [],
        // selfReflections: [],
        // detailedInsights: [],
        // goals: [],
        moodScore: MoodScore(value: 0.0, change: 0.0),
        stressLevel: StressLevel(value: 0.0, change: 0.0),
        highlights: [],
        energyLevels: [],
        moodTrackings: [],
        awakeTimeAllocations: [],
        socialMap: SocialMap(id: "", socialEntities: []),
      );
    }
  }

  JournalFile get currentJournalFile {
    // 获取当前的日记文件
    if (journalFiles.isNotEmpty) {
      return journalFiles.first;
    } else {
      return JournalFile(
        label_extraction: LabelExtraction(events: []),
        reflection: ReflectionData(
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
          ),
        ),
        message: "",
      );
    }
  }

  DateTime get currentJournalFileDate {
    // 便利 journalFilesMap 如果 value 是 currentJournalFile，则返回 key
    for (final entry in journalFilesMap.entries) {
      if (entry.value == currentJournalFile) {
        return entry.key;
      }
    }
    return DateTime.now();
  }

  Dashboard get currentDashboard {
    // 获取当前的仪表板
    if (dashboards.isNotEmpty) {
      return dashboards.last;
    } else {
      return Dashboard.createEmpty();
    }
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

  void switchEventFavoriteStatus(Event event) {
    if (favorites.value.contains(event.event_id)) {
      favorites.value.remove(event.event_id);
    } else {
      favorites.value.add(event.event_id);
    }
    // 更新收藏列表
    favorites.value = List.from(favorites.value); // 通知监听者
  }

  bool checkFavorite(Event event) {
    return favorites.value.contains(event.event_id);
  }

  // 修改日记条目笔记
  void updateNote(Event event, String content) {
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
