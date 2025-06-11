// 这是一个数据管理器类，负责管理应用程序中的数据结构和数据
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/app_runtime_context.dart';
import 'dart:math';
import 'package:nirva_app/utils.dart';
import 'dart:convert';

// 管理全局数据的类
class TestData {
  static final random = Random();
  //
  static Future<void> initializeTestData() async {
    AppRuntimeContext.clear();

    // 添加用户信息, 目前必须和服务器对上，否则无法登录。
    AppRuntimeContext().data.user = User(
      username: 'weilyupku@gmail.com',
      password: 'secret',
      displayName: 'wei',
    );

    //这里读取日记。
    await loadTestJournalFile(
      'assets/analyze_result_nirva-2025-04-19-00.txt.json',
      DateTime(2025, 4, 19),
    );
    await loadTestJournalFile(
      'assets/analyze_result_nirva-2025-05-09-00.txt.json',
      DateTime(2025, 5, 9),
    );

    AppRuntimeContext().selectedDateTime = DateTime(2025, 4, 19);

    // 添加todo数据
    //AppRuntimeContext().data.tasks = TestData.createTestTasks();

    // 添加日记数据
    AppRuntimeContext().data.legacyJournals.add(
      TestData.createTestJournal(DateTime(2025, 5, 22)),
    );

    // 添加高亮数据
    AppRuntimeContext().data.weeklyArchivedHighlights =
        TestData.createTestWeeklyArchivedHighlights();

    AppRuntimeContext().data.monthlyArchivedHighlights =
        TestData.createTestMonthlyArchivedHighlights();

    //
    AppRuntimeContext().data.dashboards.add(
      TestData.createTestDashboard(
        AppRuntimeContext().data.currentLegacyJournal.dateTime,
        AppRuntimeContext().data.currentLegacyJournal.moodTrackings,
        AppRuntimeContext().data.currentLegacyJournal.awakeTimeAllocations,
      ),
    );
  }

  // 加载测试日记文件 Future<void> initializeTestData() async
  static Future<void> loadTestJournalFile(
    String path,
    DateTime dateTime,
  ) async {
    try {
      final jsonData = await Utils.loadJsonAsset(path);
      final loadJournalFile = JournalFile.fromJson(jsonData);
      debugPrint('事件数量: ${loadJournalFile.events.length}');

      await AppRuntimeContext().storage.createJournalFile(
        //fileName: dateTime.toIso8601String(),
        fileName: Utils.formatDateTimeToIso(dateTime),
        content: jsonEncode(jsonData),
      );

      final journalFileStorage = AppRuntimeContext().storage.getJournalFile(
        //dateTime.toIso8601String(),
        Utils.formatDateTimeToIso(dateTime),
      );
      if (journalFileStorage != null) {
        // 直接测试一次！
        final jsonDecode =
            json.decode(journalFileStorage.content) as Map<String, dynamic>;

        final journalFile = JournalFile.fromJson(jsonDecode);
        Logger().d(
          'loadTestJournalFile Journal file loaded: ${jsonEncode(journalFile.toJson())}',
        );
      }
    } catch (error) {
      debugPrint('加载日记文件时出错: $error');
    }
  }

  // 添加日记的最爱数据
  // static void initializeTestFavorites(JournalFile journalFile) {
  //   // 设置测试数据
  //   List<EventAnalysis> events = journalFile.events;

  //   //
  //   if (events.isNotEmpty) {
  //     EventAnalysis randomEvent = events[random.nextInt(events.length)];
  //     debugPrint('随机选中的日记: ${randomEvent.event_title}');
  //     AppRuntimeContext().data.favorites.value = [randomEvent.event_id];
  //     debugPrint('已添加到最爱: ${randomEvent.event_id}');
  //   } else {
  //     debugPrint('diaryEntries 列表为空');
  //   }
  // }

  // 添加日记的笔记数据
  static void initializeTestMyNotes(JournalFile journalFile) {
    // 设置测试数据
    List<EventAnalysis> events = journalFile.events;

    //
    if (events.isNotEmpty) {
      //final random = Random();
      EventAnalysis randomEvent = events[random.nextInt(events.length)];
      debugPrint('随机选中的日记: ${randomEvent.event_title}');
      AppRuntimeContext().data.notes.value = [
        Note(
          id: randomEvent.event_id,
          content:
              'This is a test note for diary entry ${randomEvent.event_id}.',
        ),
      ];
      debugPrint('已添加到笔记: ${randomEvent.event_id}');
    } else {
      debugPrint('diaryEntries 列表为空');
    }
  }

  // 随机生成社交影响
  static String randomSocialImpact() {
    List<String> impacts = ['Positive', 'Negative', 'Neutral'];
    //final random = Random();
    return impacts[random.nextInt(impacts.length)];
  }

  // 测试数据： 初始化待办事项数据
  // static List<Task> createTestTasks() {
  //   return [
  //     Task(id: "", tag: 'Wellness', description: 'Morning meditation'),
  //     Task(id: "", tag: 'Wellness', description: 'Evening reading - 30 mins'),
  //     Task(
  //       id: "",
  //       tag: 'Work',
  //       description: 'Prepare presentation for meeting',
  //     ),
  //     Task(id: "", tag: 'Personal', description: 'Call mom', isCompleted: true),
  //     Task(id: "", tag: 'Health', description: 'Schedule dentist appointment'),
  //   ];
  // }

  static List<ArchivedHighlights> createTestWeeklyArchivedHighlights() {
    return [
      ArchivedHighlights(
        beginTime: DateTime(2025, 5, 9),
        endTime: DateTime(2025, 5, 15),
        highlights: [
          Highlight(
            category: 'Achievement',
            content: 'Completed 5 meditation sessions',
          ),
          Highlight(
            category: 'Insight',
            content:
                'Your stress levels were 20% lower when you exercised in the morning',
          ),
          Highlight(
            category: 'Social',
            content: 'Connected with 4 friends this week',
          ),
        ],
      ),
      ArchivedHighlights(
        beginTime: DateTime(2025, 5, 2),
        endTime: DateTime(2025, 5, 8),
        highlights: [
          Highlight(
            category: 'Achievement',
            content: 'Completed 3 meditation sessions',
          ),
          Highlight(
            category: 'Insight',
            content:
                'Your stress levels were 15% lower when you exercised in the morning',
          ),
          Highlight(
            category: 'Social',
            content: 'Connected with 2 friends this week',
          ),
        ],
      ),
    ];
  }

  static List<ArchivedHighlights> createTestMonthlyArchivedHighlights() {
    return [
      ArchivedHighlights(
        beginTime: DateTime(2025, 4, 1),
        endTime: DateTime(2025, 4, 30),
        highlights: [
          Highlight(
            category: 'Achievement',
            content: 'Completed 20 meditation sessions this month',
          ),
          Highlight(
            category: 'Insight',
            content:
                'Your stress levels were 25% lower when you exercised in the morning',
          ),
          Highlight(
            category: 'Social',
            content: 'Connected with 10 friends this month',
          ),
        ],
      ),
      ArchivedHighlights(
        beginTime: DateTime(2025, 3, 1),
        endTime: DateTime(2025, 3, 31),
        highlights: [
          Highlight(
            category: 'Achievement',
            content: 'Completed 15 meditation sessions this month',
          ),
          Highlight(
            category: 'Insight',
            content:
                'Your stress levels were 30% lower when you exercised in the morning',
          ),
          Highlight(
            category: 'Social',
            content: 'Connected with 8 friends this month',
          ),
        ],
      ),
    ];
  }

  // 测试数据： 初始化个人数据
  static LegacyJournal createTestJournal(DateTime dateTime) {
    final List<Highlight> highlights = [
      Highlight(
        category: 'ACHIEVEMENT',
        content: 'Completed your morning meditation streak - 7 days!',
        color: 0xFFEDE7F6,
      ),
      Highlight(
        category: 'INSIGHT',
        content: 'You\'re most productive between 9-11 AM.',
        color: 0xFFF1F8E9,
      ),
      Highlight(
        category: 'SOCIAL',
        content: 'You\'ve connected with 3 friends this week.',
        color: 0xFFFFF3E0,
      ),
    ];

    final List<MoodTracking> moodTrackings = [
      MoodTracking(name: 'Happy', value: 50, color: 0xFF2196F3),
      MoodTracking(name: 'Calm', value: 30, color: 0xFF4CAF50),
      MoodTracking(name: 'Stressed', value: 10, color: 0xFFF44336),
      MoodTracking(name: 'Focused', value: 10, color: 0xFFFF9800),
    ];

    final List<AwakeTimeAllocation> awakeTimeAllocations = [
      AwakeTimeAllocation(name: 'Work', value: 8, color: 0xFF2196F3),
      AwakeTimeAllocation(name: 'Exercise', value: 2, color: 0xFF4CAF50),
      AwakeTimeAllocation(name: 'Social', value: 3, color: 0xFFF44336),
      AwakeTimeAllocation(name: 'Learning', value: 3, color: 0xFFFF9800),
      AwakeTimeAllocation(name: 'Self-care', value: 1, color: 0xFF9C27B0),
      AwakeTimeAllocation(name: 'Other', value: 4, color: 0xFF9E9E9E),
    ];

    return LegacyJournal(
      //id: dateTime.toIso8601String(),
      id: Utils.formatDateTimeToIso(dateTime),
      dateTime: dateTime,
      highlights: highlights,
      moodTrackings: moodTrackings,
      awakeTimeAllocations: awakeTimeAllocations,
    );
  }

  static Dashboard createTestDashboard(
    DateTime dateTime,
    List<MoodTracking> moodTrackings,
    List<AwakeTimeAllocation> awakeTimeAllocations,
  ) {
    // 创建情绪分数仪表盘
    final moodScore = MoodScoreDashboard(
      insights: [
        // 'Your mood has been generally trending upward this week.',
        'Morning periods seem to have higher scores than evenings.',
        'Consider activities that boost your mood during lower periods.',
      ],
      scores: [83, 85, 85],
      day: [81, 85, 76, 82, 80, 85, 83],
      week: [78, 82, 79, 85],
      month: [70, 78, 80, 82, 85],
    );

    // 创建压力水平仪表盘
    final stressLevel = StressLevelDashboard(
      insights: [
        //'Your stress levels have decreased over this week.',
        'Meditation sessions appear to reduce stress levels significantly.',
        'Work-related stress peaks on Mondays and gradually decreases throughout the week.',
      ],
      scores: [3.3, 2.9, 3.2],
      day: [4.2, 3.5, 5.3, 4.1, 3.2, 2.9, 3.3],
      week: [4.5, 3.8, 3.2, 2.9],
      month: [5.2, 4.8, 4.3, 3.7, 3.2],
    );

    // 创建能量水平仪表盘
    final energyLevel = EnergyLevelDashboard(
      insights: [
        //'Your energy levels peak in the late morning and early afternoon.',
        'Social interactions appear to boost your energy significantly.',
        'Consider scheduling important tasks during your high-energy periods.',
      ],
      scores: [8.3, 8.1, 8.0],
      day: [7.0, 6.0, 8.0, 7.0, 7.0, 6.0, 8.3],
      week: [6.8, 7.2, 7.5, 7.9],
      month: [6.2, 6.7, 7.3, 7.8, 8.1],
    );

    // 创建情绪追踪仪表盘条目
    List<MoodTrackingDashboardEntry> moodTrackingEntries = [];
    for (var moodTracking in moodTrackings) {
      moodTrackingEntries.add(
        MoodTrackingDashboardEntry(
          moodTracking: moodTracking,
          day: createDaySamples(100),
          week: createWeekSamples(100),
          month: createMonthSamples(100),
        ),
      );
    }

    // 创建情绪追踪仪表盘
    final moodTracking = MoodTrackingDashboard(
      entries: moodTrackingEntries,
      insights: [
        //'Happiness and calmness are your dominant emotions this week.',
        'Stress levels peak during midweek but decrease on weekends.',
        'Focus appears to be strongest in the mornings - consider scheduling important tasks then.',
      ],
    );

    // 创建醒着的时间分配仪表盘条目
    List<AwakeTimeAllocationDashboardEntry> awakeTimeAllocationEntries = [];
    for (var awakeTimeAllocation in awakeTimeAllocations) {
      awakeTimeAllocationEntries.add(
        AwakeTimeAllocationDashboardEntry(
          awakeTimeAllocation: awakeTimeAllocation,
          day: createDaySamples(8),
          week: createWeekSamples(8),
          month: createMonthSamples(8),
        ),
      );
    }

    // 创建醒着的时间分配仪表盘
    final awakeTimeAllocation = AwakeTimeAllocationDashboard(
      entries: awakeTimeAllocationEntries,
      insights: [
        //'Work takes up the majority of your awake hours this week.',
        'Self-care and exercise time has increased compared to previous periods.',
        'Consider increasing learning activities to meet your personal growth goals.',
      ],
    );

    return Dashboard(
      dateTime: dateTime,
      moodScore: moodScore,
      stressLevel: stressLevel,
      energyLevel: energyLevel,
      moodTracking: moodTracking,
      awakeTimeAllocation: awakeTimeAllocation,
    );
  }

  static double randomRange(double maxValue) {
    final random = Random();
    return random.nextDouble() * maxValue;
  }

  // 生成最近的7天数据
  static List<double> createDaySamples(double maxValue) {
    return List.generate(7, (index) => randomRange(maxValue));
  }

  // 生成最近的4周数据
  static List<double> createWeekSamples(double maxValue) {
    return List.generate(4, (index) => randomRange(maxValue));
  }

  // 生成最近的5个月数据
  static List<double> createMonthSamples(double maxValue) {
    return List.generate(5, (index) => randomRange(maxValue));
  }
}
