// 这是一个数据管理器类，负责管理应用程序中的数据结构和数据
import 'package:flutter/material.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/app_runtime_context.dart';
import 'dart:math';
import 'package:nirva_app/utils.dart';

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

    // 这里读取日记。
    await loadTestJournalFile(
      'assets/analyze_result_2025-04-19-01.txt.json',
      DateTime(2025, 4, 19),
    );
    await loadTestJournalFile(
      'assets/analyze_result_2025-05-09-01.txt.json',
      DateTime(2025, 5, 9),
    );

    // 添加todo数据
    AppRuntimeContext().data.tasks = TestData.createTestTasks();

    // 添加日记数据
    AppRuntimeContext().data.journals.add(
      TestData.createTestJournal(DateTime(2025, 5, 22)),
    );

    // 添加高亮数据
    AppRuntimeContext().data.weeklyArchivedHighlights =
        TestData.createTestWeeklyArchivedHighlights();

    AppRuntimeContext().data.monthlyArchivedHighlights =
        TestData.createTestMonthlyArchivedHighlights();

    // 添加日记的最爱数据
    initializeTestFavorites(AppRuntimeContext().data.currentJournalFile);

    // 添加日记的笔记数据
    initializeTestMyNotes(AppRuntimeContext().data.currentJournalFile);

    //
    initializeTestSocalMap();

    //
    AppRuntimeContext().data.dashboards.add(
      TestData.createTestDashboard(
        AppRuntimeContext().data.currentJournal.dateTime,
        AppRuntimeContext().data.currentJournal.moodTrackings,
        AppRuntimeContext().data.currentJournal.awakeTimeAllocations,
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
      final journalFile = JournalFile.fromJson(jsonData);
      AppRuntimeContext().data.journalFiles.add(journalFile);
      AppRuntimeContext().data.journalFilesMap[dateTime] = journalFile;
      debugPrint('成功加载日记文件: ${journalFile.message}');
      debugPrint('事件数量: ${journalFile.label_extraction.events.length}');
    } catch (error) {
      debugPrint('加载日记文件时出错: $error');
    }
  }

  // 添加日记的最爱数据
  static void initializeTestFavorites(JournalFile journalFile) {
    // 设置测试数据
    List<Event> events = journalFile.label_extraction.events;

    //
    if (events.isNotEmpty) {
      Event randomEvent = events[random.nextInt(events.length)];
      debugPrint('随机选中的日记: ${randomEvent.event_title}');
      AppRuntimeContext().data.favorites.value = [randomEvent.event_id];
      debugPrint('已添加到最爱: ${randomEvent.event_id}');
    } else {
      debugPrint('diaryEntries 列表为空');
    }
  }

  // 添加日记的笔记数据
  static void initializeTestMyNotes(JournalFile journalFile) {
    // 设置测试数据
    List<Event> events = journalFile.label_extraction.events;

    //
    if (events.isNotEmpty) {
      //final random = Random();
      Event randomEvent = events[random.nextInt(events.length)];
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

  // 随机生成社交影响
  static void initializeTestSocalMap() {
    Map<String, SocialEntity> globalSocialMap = {};

    for (var journal in AppRuntimeContext().data.journals) {
      // 设置测试数据
      for (var socialEntity in journal.socialMap.socialEntities) {
        debugPrint('社交实体: ${socialEntity.name}');
        if (globalSocialMap.containsKey(socialEntity.name)) {
          debugPrint('社交实体已存在: ${socialEntity.name}');
          SocialEntity existingEntity = globalSocialMap[socialEntity.name]!;
          //目前就把时间相加。
          globalSocialMap[socialEntity.name] = existingEntity.copyWith(
            hours: existingEntity.hours + socialEntity.hours,
          );

          continue;
        }

        globalSocialMap[socialEntity.name] = socialEntity.copyWith(
          impact: randomSocialImpact(),
        );
      }
    }

    // 把 globalSocialMap 的value合成一个list
    List<SocialEntity> socialEntities = globalSocialMap.values.toList();
    AppRuntimeContext().data.globalSocialMap = SocialMap(
      id: "",
      socialEntities: socialEntities,
    );
  }

  // 测试数据： 初始化待办事项数据
  static List<Task> createTestTasks() {
    return [
      Task(id: "", tag: 'Wellness', description: 'Morning meditation'),
      Task(id: "", tag: 'Wellness', description: 'Evening reading - 30 mins'),
      Task(
        id: "",
        tag: 'Work',
        description: 'Prepare presentation for meeting',
      ),
      Task(id: "", tag: 'Personal', description: 'Call mom', isCompleted: true),
      Task(id: "", tag: 'Health', description: 'Schedule dentist appointment'),
    ];
  }

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
  static Journal createTestJournal(DateTime dateTime) {
    // final String summary =
    //     'Today was a day of deep conversations with friends, self-reflection, and cultural experiences. My emotions fluctuated between relaxation, joy, reflection, slight anxiety, and nostalgia.';

    // 引言卡片数据
    final List<Quote> quotes = [
      Quote(
        text:
            '"Today was a day of deep conversations with friends, self-reflection, and cultural experiences."',
        mood: 'reflective',
      ),
      Quote(
        text:
            '"Meaningful connections with others help me understand myself better and grow as a person."',
        mood: 'calm',
      ),
      Quote(
        text:
            '"I am grateful for friends who share their wisdom and provide space for authentic expression."',
        mood: 'focused',
      ),
    ];

    // 个人反思
    // final List<Reflection> selfReflections = [
    //   Reflection(
    //     id: '1',
    //     title: 'I am feeling grateful for:',
    //     items: [
    //       'Deep conversations with friends who listen and share wisdom',
    //       'Access to art and film that opens my eyes to different perspectives',
    //       'The privilege to contemplate my future on my own terms',
    //     ],
    //     content:
    //         "In reflecting on what I'm grateful for today, I find myself particularly appreciative of the deep conversations I've had with friends who truly listen and offer their wisdom. There's something profoundly nourishing about being heard without judgment, about exchanging ideas with people who challenge my thinking in constructive ways. These conversations have helped me navigate complex emotions and decisions, offering perspectives I might never have considered on my own.",
    //   ),
    //   Reflection(
    //     id: '2',
    //     title: 'I can celebrate:',
    //     items: [
    //       'Making time for meaningful connections despite a busy schedule',
    //       'Being open to different cultural experiences and perspectives',
    //       'Taking steps to consider my future options thoughtfully',
    //     ],
    //     content:
    //         "I can celebrate the fact that I made time for meaningful connections today, even amidst a busy schedule. I took the initiative to reach out to friends and engage in deep conversations that nourished my soul. I also feel proud of my openness to different cultural experiences and perspectives, as they enrich my understanding of the world. Additionally, I'm taking steps to consider my future options thoughtfully, which is empowering.",
    //   ),
    //   Reflection(
    //     id: '3',
    //     title: 'I can do better at:',
    //     items: [
    //       'Finding better balance between solitude and social connection',
    //       'Being more productive with my free time instead of oversleeping',
    //       'Managing feelings of envy about others\' lives more constructively',
    //     ],
    //     content:
    //         "While I have much to celebrate, I also recognize areas where I can improve. I need to find a better balance between solitude and social connection, as too much of either can lead to feelings of isolation or overwhelm. I also want to be more productive with my free time instead of falling into the trap of oversleeping or procrastination. Lastly, I need to manage my feelings of envy about others' lives more constructively, perhaps by focusing on my own journey and what I can do to create the life I want.",
    //   ),
    // ];

    // // 详细见解
    // final List<Reflection> detailedInsights = [
    //   Reflection(
    //     id: '4',
    //     title: 'Relationships',
    //     items: [
    //       'Deep conversations with friends provide invaluable emotional support and perspective.',
    //       'I value authentic connections but feel frustrated by unpredictable dating experiences.',
    //       'Being \'ghosted\' after meaningful connections is a recurring pattern that causes confusion.',
    //     ],
    //     content:
    //         "I find that deep conversations with friends provide invaluable emotional support and perspective. These discussions help me navigate complex feelings and decisions, offering insights I might not have considered on my own. However, I also feel frustrated by the unpredictable nature of dating experiences. The emotional rollercoaster of connecting with someone only to be 'ghosted' afterward is a recurring pattern that leaves me feeling confused and questioning my worth.",
    //   ),
    //   Reflection(
    //     id: '5',
    //     title: 'Self-Discovery',
    //     items: [
    //       'I\'m contemplating the balance between solitude and social connection in my life.',
    //       'When I have excess free time, I tend toward unproductive behaviors like oversleeping.',
    //       'I feel both curious about and envious of others\' stable family lives.',
    //     ],
    //     content:
    //         "I find myself contemplating the balance between solitude and social connection in my life. While I cherish my alone time for self-reflection, I also recognize the importance of meaningful connections with others. However, when I have excess free time, I tend to fall into unproductive behaviors like oversleeping or mindless scrolling on social media. This leads to feelings of guilt and frustration. Additionally, I feel both curious about and envious of others' stable family lives, which makes me question my own choices and priorities.",
    //   ),
    //   Reflection(
    //     id: '6',
    //     title: 'Future Planning',
    //     items: [
    //       'I\'m considering egg freezing and planning to make decisions about children by age 40.',
    //       'Financial considerations and family support are important factors in my fertility decisions.',
    //       'I\'m open to alternative pathways to parenthood beyond traditional routes.',
    //     ],
    //     content:
    //         "As I think about my future, I'm considering the option of egg freezing and planning to make decisions about having children by age 40. Financial considerations and family support are important factors in my fertility decisions. I want to ensure that I have the resources and emotional backing to make informed choices. Additionally, I'm open to alternative pathways to parenthood beyond traditional routes, such as adoption or co-parenting arrangements.",
    //   ),
    //   Reflection(
    //     id: '7',
    //     title: 'Cultural Perspectives',
    //     items: [
    //       'Art and film provide windows into different cultural and historical experiences.',
    //       'My family background gives me a unique perspective on political events like Tiananmen Square.',
    //       'I\'m exploring philosophical concepts from different cultures like Tibetan Buddhist compassion.',
    //     ],
    //     content:
    //         "I find that art and film provide windows into different cultural and historical experiences. They allow me to explore perspectives that I may not have encountered in my own life. My family background gives me a unique perspective on political events like Tiananmen Square, which shapes my understanding of current events. I'm also exploring philosophical concepts from different cultures, such as Tibetan Buddhist compassion, which resonates with my desire for emotional growth and understanding.",
    //   ),
    // ];

    // 目标
    // final List<Reflection> goals = [
    //   Reflection(
    //     id: '8',
    //     title: 'Deepen meaningful relationships',
    //     items: [
    //       'Schedule monthly deep conversations with close friends',
    //       'Join a community group aligned with my interests',
    //       'Practice active listening techniques',
    //     ],
    //     content: "",
    //   ),
    //   Reflection(
    //     id: '9',
    //     title: 'Explore fertility options',
    //     items: [
    //       'Research egg freezing clinics and costs',
    //       'Schedule consultation with fertility specialist',
    //       'Create financial plan for family planning options',
    //     ],
    //     content: "",
    //   ),
    //   Reflection(
    //     id: '10',
    //     title: 'Expand cultural understanding',
    //     items: [
    //       'Watch one international film per week',
    //       'Read books from diverse cultural perspectives',
    //     ],
    //     content: "",
    //   ),
    // ];

    final MoodScore moodScore = MoodScore(value: 7.8, change: 0.5);

    final StressLevel stressLevel = StressLevel(value: 3.2, change: -1.3);

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

    final List<EnergyLevel> energyLevels = [
      EnergyLevel(dateTime: DateTime(2025, 5, 6, 10, 0), value: 1.0),
      EnergyLevel(dateTime: DateTime(2025, 5, 6, 10, 30), value: 2.0),
      EnergyLevel(dateTime: DateTime(2025, 5, 6, 11, 30), value: 1.5),
      EnergyLevel(dateTime: DateTime(2025, 5, 6, 13, 0), value: 2.8),
      EnergyLevel(dateTime: DateTime(2025, 5, 6, 13, 30), value: 2.0),
      EnergyLevel(dateTime: DateTime(2025, 5, 6, 14, 30), value: 3.0),
      EnergyLevel(dateTime: DateTime(2025, 5, 6, 15, 10), value: 1.5),
      EnergyLevel(dateTime: DateTime(2025, 5, 6, 16, 30), value: 2.5),
      EnergyLevel(dateTime: DateTime(2025, 5, 6, 18, 30), value: 3.2),
      EnergyLevel(dateTime: DateTime(2025, 5, 6, 19, 0), value: 2.8),
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

    List<SocialEntity> socialEntities = [
      SocialEntity(
        id: "",
        name: 'Ashley',
        description:
            'Deep, supportive conversation. Vulnerability was met with understanding.',
        tips: [
          'Reciprocate Support: Ensure you\'re actively listening and offering support for her challenges (job search, etc.) as she does for you.',
          'Follow Through: Act on plans discussed, like the library meet-up, to build reliability.',
          'Shared Fun: Continue exploring shared interests beyond processing difficulties, like the arts or potential future activities.',
        ],
        hours: 3,
      ),
      SocialEntity(
        id: "",
        name: 'Trent',
        description:
            'Shared a fun hiking trip. Great teamwork and mutual encouragement.',
        tips: [
          'Acknowledge Commitments: Address things like listening to the record he gave you to show you value his gestures and follow through.',
          'Appreciate His Perspective: Even when disagreeing (like on AI ethics), acknowledge and show respect for his viewpoint to maintain positive discourse.',
          'Continue Shared Exploration: Lean into shared interests like film, exploring challenging ideas, and trying new experiences (restaurants, neighborhoods). Ask about his work/life updates proactively.',
        ],
        hours: 2,
      ),
      SocialEntity(
        id: "",
        name: 'Charlie',
        description:
            'Had a long discussion about books and movies. Discovered shared interests.',
        tips: [
          'Explore Shared Interests: Continue discussing books and movies to deepen your connection. Consider starting a book club or movie night together.',
          'Plan Future Activities: Discuss and plan future outings or activities together to strengthen your bond. Consider exploring new places or trying new hobbies together.',
          'Be Open to Vulnerability: Share your thoughts and feelings openly to foster a deeper connection.',
        ],
        hours: 1.5,
      ),
      SocialEntity(
        id: "",
        name: 'Diana',
        description:
            'Enjoyed a relaxing day at the park. Shared thoughts and future plans.',
        tips: [
          'Plan Future Outings: Discuss and plan future outings or activities together to strengthen your bond. Consider exploring new places or trying new hobbies together.',
          'Be Open to Vulnerability: Share your thoughts and feelings openly to foster a deeper connection.',
          'Explore Shared Interests: Continue discussing books and movies to deepen your connection. Consider starting a book club or movie night together.',
        ],
        hours: 4,
      ),
    ];

    //analyze_result_2025-04-19-01.txt.json

    return Journal(
      id: dateTime.toIso8601String(),
      dateTime: dateTime,
      //summary: summary,
      //diaryEntries: diaryEntries,
      quotes: quotes,
      // selfReflections: selfReflections,
      // detailedInsights: detailedInsights,
      // goals: goals,
      moodScore: moodScore,
      stressLevel: stressLevel,
      highlights: highlights,
      energyLevels: energyLevels,
      moodTrackings: moodTrackings,
      awakeTimeAllocations: awakeTimeAllocations,
      socialMap: SocialMap(id: "", socialEntities: socialEntities),
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
