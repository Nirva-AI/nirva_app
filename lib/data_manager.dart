// 这是一个数据管理器类，负责管理应用程序中的数据结构和数据
import 'package:json_annotation/json_annotation.dart';
import 'package:nirva_app/utils.dart';
import 'dart:convert'; // 用于 JSON 编码和解码
part 'data_manager.g.dart'; // 引入生成的文件

// 引言卡片数据结构
@JsonSerializable(explicitToJson: true)
class Quote {
  final String text;

  Quote({required this.text});

  // JSON序列化和反序列化
  factory Quote.fromJson(Map<String, dynamic> json) =>
      _$QuoteFromJson(json); // 反序列化
  Map<String, dynamic> toJson() => _$QuoteToJson(this); // 序列化
}

// 日记条目的数据结构
@JsonSerializable(explicitToJson: true)
class Diary {
  final String time;
  final String title;
  final String summary;
  final String content;
  final List<String> tags;
  final String location;

  Diary({
    required this.time,
    required this.title,
    required this.summary,
    required this.content,
    required this.tags,
    required this.location,
  });

  // JSON序列化和反序列化
  factory Diary.fromJson(Map<String, dynamic> json) =>
      _$DiaryFromJson(json); // 反序列化
  Map<String, dynamic> toJson() => _$DiaryToJson(this); // 序列化
}

// 个人反思数据结构
@JsonSerializable(explicitToJson: true)
class Reflection {
  final String title;
  final List<String> items;

  Reflection({required this.title, required this.items});

  // JSON序列化和反序列化
  factory Reflection.fromJson(Map<String, dynamic> json) =>
      _$ReflectionFromJson(json); // 反序列化
  Map<String, dynamic> toJson() => _$ReflectionToJson(this); // 序列化
}

// 评分卡片数据结构
@JsonSerializable(explicitToJson: true)
class Score {
  final String title;
  final double value;
  final double change;

  Score({required this.title, required this.value, required this.change});

  // JSON序列化和反序列化
  factory Score.fromJson(Map<String, dynamic> json) =>
      _$ScoreFromJson(json); // 反序列化
  Map<String, dynamic> toJson() => _$ScoreToJson(this); // 序列化
}

// 高亮数据结构
@JsonSerializable(explicitToJson: true)
class Highlight {
  final String title;
  final String content;
  final int color = 0xFF00FF00; // 默认颜色为绿色

  Highlight({required this.title, required this.content});

  // JSON序列化和反序列化
  factory Highlight.fromJson(Map<String, dynamic> json) =>
      _$HighlightFromJson(json); // 反序列化
  Map<String, dynamic> toJson() => _$HighlightToJson(this); // 序列化
}

// 任务数据结构
@JsonSerializable(explicitToJson: true)
class Task {
  final String category;
  final String description;
  bool isCompleted = false;

  Task({required this.category, required this.description});

  bool equalsTask(Task other) {
    return category == other.category && description == other.description;
  }

  // JSON序列化和反序列化
  factory Task.fromJson(Map<String, dynamic> json) =>
      _$TaskFromJson(json); // 反序列化
  Map<String, dynamic> toJson() => _$TaskToJson(this); // 序列化
}

// 任务列表数据结构
@JsonSerializable(explicitToJson: true)
class TodoList {
  final List<Task> tasks;

  TodoList({required this.tasks});

  void addTask(Task task) {
    for (var existingTask in tasks) {
      if (existingTask.equalsTask(task)) {
        return; // 任务已存在，直接返回
      }
    }
    tasks.add(task);
  }

  //实现一个getter 名叫 categorizedTasks，数据结构为 Map<String, List<Task>>
  Map<String, List<Task>> get categorizedTasks {
    final Map<String, List<Task>> categorizedTasks = {};
    for (var task in tasks) {
      if (!categorizedTasks.containsKey(task.category)) {
        categorizedTasks[task.category] = [];
      }
      categorizedTasks[task.category]!.add(task);
    }
    return categorizedTasks;
  }

  // JSON序列化和反序列化
  factory TodoList.fromJson(Map<String, dynamic> json) =>
      _$TodoListFromJson(json); // 反序列化
  Map<String, dynamic> toJson() => _$TodoListToJson(this); // 序列化
}

// 能量标签枚举
@JsonSerializable(explicitToJson: true)
class EnergyLabel {
  final String label;
  final double measurementValue;
  const EnergyLabel(this.label, this.measurementValue);

  // JSON序列化和反序列化
  factory EnergyLabel.fromJson(Map<String, dynamic> json) =>
      _$EnergyLabelFromJson(json); // 反序列化
  Map<String, dynamic> toJson() => _$EnergyLabelToJson(this); // 序列化
}

// 能量数据结构
@JsonSerializable(explicitToJson: true)
class Energy {
  static const lowMinus = EnergyLabel('', 0.0);
  static const low = EnergyLabel('Low', 1.0);
  static const neutral = EnergyLabel('Neutral', 2.0);
  static const high = EnergyLabel('High', 3.0);
  static const highPlus = EnergyLabel('', 4.0);

  final DateTime dateTime; // 标准时间格式
  final double energyLevel; // 能量值，例如 1.0

  Energy({required this.dateTime, required this.energyLevel});

  // 动态生成时间字符串，仅输出时间部分
  String get time =>
      "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";

  // 根据 energyLevel 动态生成标签
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

  // 获取能量标签的字符串值
  String get energyLabelString => energyLabel.label;

  // JSON序列化和反序列化
  factory Energy.fromJson(Map<String, dynamic> json) =>
      _$EnergyFromJson(json); // 反序列化
  Map<String, dynamic> toJson() => _$EnergyToJson(this); // 序列化
}

// 情绪心情数据结构
@JsonSerializable(explicitToJson: true)
class Mood {
  final String name;
  final double moodValue;
  final double moodPercentage;
  final int color = 0xFF00FF00; // 默认颜色为绿色
  Mood(this.name, this.moodValue, this.moodPercentage);

  // JSON序列化和反序列化
  factory Mood.fromJson(Map<String, dynamic> json) =>
      _$MoodFromJson(json); // 反序列化
  Map<String, dynamic> toJson() => _$MoodToJson(this); // 序列化
}

// 醒着时间的行为数据结构
@JsonSerializable(explicitToJson: true)
class AwakeTimeAction {
  final String label;
  final double value;
  final int color = 0xFF00FF00; // 默认颜色为绿色

  AwakeTimeAction({required this.label, required this.value});

  // JSON序列化和反序列化
  factory AwakeTimeAction.fromJson(Map<String, dynamic> json) =>
      _$AwakeTimeActionFromJson(json); // 反序列化
  Map<String, dynamic> toJson() => _$AwakeTimeActionToJson(this); // 序列化
}

// 日记类，包含日期和日记条目列表
@JsonSerializable(explicitToJson: true)
class PersonalJournal {
  final DateTime dateTime; // 标准时间格式

  PersonalJournal({required this.dateTime});

  String summary = "";

  // 日记条目列表
  List<Diary> diaryEntries = [];

  // 引言卡片数据
  List<Quote> quotes = [];

  // 个人反思
  List<Reflection> selfReflections = [];

  // 详细见解
  List<Reflection> detailedInsights = [];

  // 目标
  List<Reflection> goals = [];

  // 评分卡片数据
  Score moodScore = Score(title: 'Mood Score', value: 0.0, change: 0.0);

  // 评分卡片数据
  Score stressLevel = Score(title: 'Stress Level', value: 0.0, change: -1.3);

  // 重点
  List<Highlight> highlights = [];

  // 能量记录
  List<Energy> energyRecords = [];

  // 心情追踪器
  //MoodTracker moodTracker = MoodTracker([]);
  List<Mood> moods = [];

  // 社交对象列表
  List<AwakeTimeAction> awakeTimeActions = [];

  // 获取心情数据
  Map<String, double> get moodMap {
    final Map<String, double> moodMap = {};
    for (var mood in moods) {
      moodMap[mood.name] = mood.moodPercentage;
    }
    return moodMap;
  }

  // 输出日期字符串
  String get formattedDate {
    final monthNames = [
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
    return '${monthNames[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }

  // JSON序列化和反序列化
  factory PersonalJournal.fromJson(Map<String, dynamic> json) =>
      _$PersonalJournalFromJson(json); // 反序列化
  Map<String, dynamic> toJson() => _$PersonalJournalToJson(this); // 序列化
}

// 社交对象数据结构
@JsonSerializable(explicitToJson: true)
class SocialEntity {
  final String name; // 社交对象的名字
  final String details; // 详细信息
  final List<String> tips;
  final String timeSpent; // 互动时间

  SocialEntity({
    required this.name,
    required this.details,
    required this.tips,
    required this.timeSpent,
  });

  // JSON序列化和反序列化
  factory SocialEntity.fromJson(Map<String, dynamic> json) =>
      _$SocialEntityFromJson(json); // 反序列化
  Map<String, dynamic> toJson() => _$SocialEntityToJson(this); // 序列化
}

// 社交对象列表数据结构
@JsonSerializable(explicitToJson: true)
class SocialMap {
  List<SocialEntity> socialEntities = [];
  SocialMap({required this.socialEntities});
  // JSON序列化和反序列化
  factory SocialMap.fromJson(Map<String, dynamic> json) =>
      _$SocialMapFromJson(json); // 反序列化
  Map<String, dynamic> toJson() => _$SocialMapToJson(this); // 序列化
}

// 管理全局数据的类
class DataManager {
  // 单例模式
  static final DataManager _instance = DataManager._internal();
  factory DataManager() => _instance;
  DataManager._internal();

  // 当前的日记和仪表板数据
  PersonalJournal currentJournalEntry = PersonalJournal(
    dateTime: DateTime.now(),
  );

  // 当前的待办事项数据
  TodoList todoList = TodoList(tasks: []);

  // 社交对象数据
  SocialMap socialMap = SocialMap(socialEntities: []);

  // 清空数据
  clear() {
    currentJournalEntry = PersonalJournal(dateTime: DateTime.now());
    todoList = TodoList(tasks: []);
    socialMap = SocialMap(socialEntities: []);
  }

  // 初始化方法
  initialize() {
    // 初始化待办事项数据
    currentJournalEntry = PersonalJournal(dateTime: DateTime(2025, 4, 19));

    //
    todoList = TodoList(tasks: []);

    // 初始化社交对象数据
    socialMap = SocialMap(socialEntities: []);

    // 添加测试数据
    _addTestTodoList();
    // 添加测试数据
    _addTestPersonal();
    // 添加测试数据
    _addTestSocialMap();

    // 直接用 Logger.d 来打印todoList序列化成的json，要求是合规的json数据格式。
    String todoListJson = jsonEncode(todoList.toJson());
    Logger.d('todoList=\n$todoListJson');

    String personalJson = jsonEncode(currentJournalEntry.toJson());
    Logger.d('personalJson=\n$personalJson');

    String socialMapJson = jsonEncode(socialMap.toJson());
    Logger.d('socialMapJson=\n$socialMapJson');
  }

  // 测试数据： 初始化待办事项数据
  void _addTestTodoList() {
    todoList.addTask(
      Task(category: 'Wellness', description: 'Morning meditation'),
    );
    todoList.addTask(
      Task(category: 'Wellness', description: 'Evening reading - 30 mins'),
    );
    todoList.addTask(
      Task(category: 'Work', description: 'Prepare presentation for meeting'),
    );
    Task callMomTask = Task(category: 'Personal', description: 'Call mom');
    callMomTask.isCompleted = true; // 标记为已完成
    todoList.addTask(callMomTask);
    todoList.addTask(
      Task(category: 'Health', description: 'Schedule dentist appointment'),
    );
  }

  // 测试数据： 初始化个人数据
  void _addTestPersonal() {
    currentJournalEntry.summary =
        'Today was a day of deep conversations with friends, self-reflection, and cultural experiences. My emotions fluctuated between relaxation, joy, reflection, slight anxiety, and nostalgia.';

    // 日记条目列表
    currentJournalEntry.diaryEntries = [
      Diary(
        time: '10:00 AM - 1:00 PM',
        title: 'Morning in the Park with Ashley',
        summary:
            'Deep conversations about life, dating experiences, and exploring crystals and tarot cards.',
        content:
            'Ashley and I spent the morning in the park, discussing our lives and sharing insights. We explored crystals and tarot cards, which added a mystical touch to our conversations.',
        tags: ['peaceful', 'outdoor', 'conversation'],
        location: 'Park',
      ),
      Diary(
        time: '1:00 PM - 1:30 PM',
        title: 'Departure from Park',
        summary:
            'Said goodbye to Ashley and prepared to meet Trent for our trip to San Francisco.',
        content:
            'After a fulfilling morning, I bid farewell to Ashley. We shared a warm hug and promised to meet again soon. I felt a mix of calmness and anticipation as I prepared for my next adventure.',
        tags: ['calm', 'outdoor', 'transportation'],
        location: 'Park',
      ),
      Diary(
        time: '1:30 PM - 2:50 PM',
        title: 'Drive to San Francisco with Trent',
        summary:
            'Philosophical discussions about work, life perspectives, and AI companionship during our drive.',
        content:
            'The drive to San Francisco with Trent was filled with deep discussions. We talked about our work, life perspectives, and even the role of AI in our lives. It was an engaging conversation that made the drive feel shorter.',
        tags: ['engaged', 'transportation', 'conversation'],
        location: 'In the car',
      ),
      // 添加更多测试数据
      Diary(
        time: '3:00 PM - 4:00 PM',
        title: 'Coffee Break with Sarah',
        summary: 'Discussed future plans and shared some laughs over coffee.',
        content:
            'Sarah and I took a break at a cozy cafe. We discussed our future plans, shared some laughs, and enjoyed the warm ambiance. It was a relaxing moment that allowed us to unwind.',
        tags: ['relaxing', 'indoor', 'conversation'],
        location: 'Cafe',
      ),
      Diary(
        time: '4:30 PM - 6:00 PM',
        title: 'Evening Walk',
        summary: 'A peaceful walk in the park to clear my mind.',
        content:
            'I took a peaceful walk in the park to clear my mind. The fresh air and nature around me provided a calming effect. I reflected on the day and felt grateful for the meaningful connections I made.',
        tags: ['peaceful', 'outdoor', 'exercise'],
        location: 'Park',
      ),
      Diary(
        time: '10:00 AM - 1:00 PM',
        title: 'Morning in the Park with Ashley',
        summary:
            'Deep conversations about life, dating experiences, and exploring crystals and tarot cards.',
        content:
            'Ashley and I spent the morning in the park, discussing our lives and sharing insights. We explored crystals and tarot cards, which added a mystical touch to our conversations.',
        tags: ['peaceful', 'outdoor', 'conversation'],
        location: 'Park',
      ),
      Diary(
        time: '1:00 PM - 1:30 PM',
        title: 'Departure from Park',
        summary:
            'Said goodbye to Ashley and prepared to meet Trent for our trip to San Francisco.',
        content:
            'After a fulfilling morning, I bid farewell to Ashley. We shared a warm hug and promised to meet again soon. I felt a mix of calmness and anticipation as I prepared for my next adventure.',
        tags: ['calm', 'outdoor', 'transportation'],
        location: 'Park',
      ),
      Diary(
        time: '1:30 PM - 2:50 PM',
        title: 'Drive to San Francisco with Trent',
        summary:
            'Philosophical discussions about work, life perspectives, and AI companionship during our drive.',
        content:
            'The drive to San Francisco with Trent was filled with deep discussions. We talked about our work, life perspectives, and even the role of AI in our lives. It was an engaging conversation that made the drive feel shorter.',
        tags: ['engaged', 'transportation', 'conversation'],
        location: 'In the car',
      ),
      // 添加更多测试数据
      Diary(
        time: '3:00 PM - 4:00 PM',
        title: 'Coffee Break with Sarah',
        summary: 'Discussed future plans and shared some laughs over coffee.',
        content:
            'Sarah and I took a break at a cozy cafe. We discussed our future plans, shared some laughs, and enjoyed the warm ambiance. It was a relaxing moment that allowed us to unwind.',
        tags: ['relaxing', 'indoor', 'conversation'],
        location: 'Cafe',
      ),
      Diary(
        time: '4:30 PM - 6:00 PM',
        title: 'Evening Walk',
        summary: 'A peaceful walk in the park to clear my mind.',
        content:
            'I took a peaceful walk in the park to clear my mind. The fresh air and nature around me provided a calming effect. I reflected on the day and felt grateful for the meaningful connections I made.',
        tags: ['peaceful', 'outdoor', 'exercise'],
        location: 'Park',
      ),
    ];

    // 引言卡片数据
    currentJournalEntry.quotes = [
      Quote(
        text:
            '"Today was a day of deep conversations with friends, self-reflection, and cultural experiences."',
      ),
      Quote(
        text:
            '"Meaningful connections with others help me understand myself better and grow as a person."',
      ),
      Quote(
        text:
            '"I am grateful for friends who share their wisdom and provide space for authentic expression."',
      ),
    ];

    // 个人反思
    currentJournalEntry.selfReflections = [
      Reflection(
        title: 'I am feeling grateful for:',
        items: [
          'Deep conversations with friends who listen and share wisdom',
          'Access to art and film that opens my eyes to different perspectives',
          'The privilege to contemplate my future on my own terms',
        ],
      ),
      Reflection(
        title: 'I can celebrate:',
        items: [
          'Making time for meaningful connections despite a busy schedule',
          'Being open to different cultural experiences and perspectives',
          'Taking steps to consider my future options thoughtfully',
        ],
      ),
      Reflection(
        title: 'I can do better at:',
        items: [
          'Finding better balance between solitude and social connection',
          'Being more productive with my free time instead of oversleeping',
          'Managing feelings of envy about others\' lives more constructively',
        ],
      ),
    ];

    // 详细见解
    currentJournalEntry.detailedInsights = [
      Reflection(
        title: 'Relationships',
        items: [
          'Deep conversations with friends provide invaluable emotional support and perspective.',
          'I value authentic connections but feel frustrated by unpredictable dating experiences.',
          'Being \'ghosted\' after meaningful connections is a recurring pattern that causes confusion.',
        ],
      ),
      Reflection(
        title: 'Self-Discovery',
        items: [
          'I\'m contemplating the balance between solitude and social connection in my life.',
          'When I have excess free time, I tend toward unproductive behaviors like oversleeping.',
          'I feel both curious about and envious of others\' stable family lives.',
        ],
      ),
      Reflection(
        title: 'Future Planning',
        items: [
          'I\'m considering egg freezing and planning to make decisions about children by age 40.',
          'Financial considerations and family support are important factors in my fertility decisions.',
          'I\'m open to alternative pathways to parenthood beyond traditional routes.',
        ],
      ),
      Reflection(
        title: 'Cultural Perspectives',
        items: [
          'Art and film provide windows into different cultural and historical experiences.',
          'My family background gives me a unique perspective on political events like Tiananmen Square.',
          'I\'m exploring philosophical concepts from different cultures like Tibetan Buddhist compassion.',
        ],
      ),
    ];

    // 目标
    currentJournalEntry.goals = [
      Reflection(
        title: 'Deepen meaningful relationships',
        items: [
          'Schedule monthly deep conversations with close friends',
          'Join a community group aligned with my interests',
          'Practice active listening techniques',
        ],
      ),
      Reflection(
        title: 'Explore fertility options',
        items: [
          'Research egg freezing clinics and costs',
          'Schedule consultation with fertility specialist',
          'Create financial plan for family planning options',
        ],
      ),
      Reflection(
        title: 'Expand cultural understanding',
        items: [
          'Watch one international film per week',
          'Read books from diverse cultural perspectives',
        ],
      ),
    ];

    currentJournalEntry.moodScore = Score(
      title: 'Mood Score',
      value: 7.8,
      change: 0.5,
    );

    currentJournalEntry.stressLevel = Score(
      title: 'Stress Level',
      value: 3.2,
      change: -1.3,
    );

    currentJournalEntry.highlights = [
      Highlight(
        title: 'ACHIEVEMENT',
        content: 'Completed your morning meditation streak - 7 days!',
      ),
      Highlight(
        title: 'INSIGHT',
        content: 'You\'re most productive between 9-11 AM.',
      ),
      Highlight(
        title: 'SOCIAL',
        content: 'You\'ve connected with 3 friends this week.',
      ),
    ];

    currentJournalEntry.energyRecords = [
      Energy(dateTime: DateTime(2025, 5, 6, 10, 0), energyLevel: 1.0),
      Energy(dateTime: DateTime(2025, 5, 6, 10, 30), energyLevel: 2.0),
      Energy(dateTime: DateTime(2025, 5, 6, 11, 30), energyLevel: 1.5),
      Energy(dateTime: DateTime(2025, 5, 6, 13, 0), energyLevel: 2.8),
      Energy(dateTime: DateTime(2025, 5, 6, 13, 30), energyLevel: 2.0),
      Energy(dateTime: DateTime(2025, 5, 6, 14, 30), energyLevel: 3.0),
      Energy(dateTime: DateTime(2025, 5, 6, 15, 10), energyLevel: 1.5),
      Energy(dateTime: DateTime(2025, 5, 6, 16, 30), energyLevel: 2.5),
      Energy(dateTime: DateTime(2025, 5, 6, 18, 30), energyLevel: 3.2),
      Energy(dateTime: DateTime(2025, 5, 6, 19, 0), energyLevel: 2.8),
    ];

    currentJournalEntry.moods = [
      Mood('Happy', 0.5, 50),
      Mood('Calm', 0.3, 30),
      Mood('Stressed', -0.9, 10),
      Mood('Focused', -0.5, 10),
    ];

    currentJournalEntry.awakeTimeActions = [
      AwakeTimeAction(label: 'Work', value: 8),
      AwakeTimeAction(label: 'Exercise', value: 2),
      AwakeTimeAction(label: 'Social', value: 3),
      AwakeTimeAction(label: 'Learning', value: 3),
      AwakeTimeAction(label: 'Self-care', value: 1),
      AwakeTimeAction(label: 'Other', value: 4),
    ];
  }

  // 测试数据： 初始化社交对象数据
  void _addTestSocialMap() {
    socialMap.socialEntities = [
      SocialEntity(
        name: 'Ashley',
        details:
            'Deep, supportive conversation. Vulnerability was met with understanding.',
        tips: [
          'Reciprocate Support: Ensure you\'re actively listening and offering support for her challenges (job search, etc.) as she does for you.',
          'Follow Through: Act on plans discussed, like the library meet-up, to build reliability.',
          'Shared Fun: Continue exploring shared interests beyond processing difficulties, like the arts or potential future activities.',
        ],
        timeSpent: '~3 hours',
      ),
      SocialEntity(
        name: 'Trent',
        details:
            'Shared a fun hiking trip. Great teamwork and mutual encouragement.',
        tips: [
          'Acknowledge Commitments: Address things like listening to the record he gave you to show you value his gestures and follow through.',
          'Appreciate His Perspective: Even when disagreeing (like on AI ethics), acknowledge and show respect for his viewpoint to maintain positive discourse.',
          'Continue Shared Exploration: Lean into shared interests like film, exploring challenging ideas, and trying new experiences (restaurants, neighborhoods). Ask about his work/life updates proactively.',
        ],
        timeSpent: '~2 hours',
      ),
      SocialEntity(
        name: 'Charlie',
        details:
            'Had a long discussion about books and movies. Discovered shared interests.',
        tips: [
          'Explore Shared Interests: Continue discussing books and movies to deepen your connection. Consider starting a book club or movie night together.',
          'Plan Future Activities: Discuss and plan future outings or activities together to strengthen your bond. Consider exploring new places or trying new hobbies together.',
          'Be Open to Vulnerability: Share your thoughts and feelings openly to foster a deeper connection.',
        ],
        timeSpent: '~1.5 hours',
      ),
      SocialEntity(
        name: 'Diana',
        details:
            'Enjoyed a relaxing day at the park. Shared thoughts and future plans.',
        tips: [
          'Plan Future Outings: Discuss and plan future outings or activities together to strengthen your bond. Consider exploring new places or trying new hobbies together.',
          'Be Open to Vulnerability: Share your thoughts and feelings openly to foster a deeper connection.',
          'Explore Shared Interests: Continue discussing books and movies to deepen your connection. Consider starting a book club or movie night together.',
        ],
        timeSpent: '~4 hours',
      ),
    ];
  }
}


/*

*/