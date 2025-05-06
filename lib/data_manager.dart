// 这是一个数据管理器类，负责管理应用程序中的数据结构和数据

class QuoteData {
  final String text;

  QuoteData({required this.text});
}

// 日记条目的数据结构
class DiaryData {
  final String time;
  final String title;
  final String summary;
  final String content;
  final List<String> tags;
  final String location;

  DiaryData({
    required this.time,
    required this.title,
    required this.summary,
    required this.content,
    required this.tags,
    required this.location,
  });
}

// ReflectionData Class
class ReflectionData {
  final String title;
  final List<String> items;

  ReflectionData({required this.title, required this.items});
}

// 评分卡片数据结构
class ScoreCardData {
  final String title;
  final double value;
  final double change;

  ScoreCardData({
    required this.title,
    required this.value,
    required this.change,
  });
}

class HighlightCardData {
  final String title;
  final String content;

  HighlightCardData({required this.title, required this.content});
}

// 任务数据结构
class TaskData {
  final String description;
  bool isCompleted = false;

  TaskData({required this.description});
}

// 任务列表数据结构
class TodoListData {
  final Map<String, List<TaskData>> categorizedTasks = {};
  TodoListData();

  addTask(String category, TaskData task) {
    if (categorizedTasks.containsKey(category)) {
      categorizedTasks[category]!.add(task);
    } else {
      categorizedTasks[category] = [task];
    }
  }

  addTestTask() {
    categorizedTasks.clear(); // 清空之前的任务数据
    addTask('Wellness', TaskData(description: 'Morning meditation'));
    addTask('Wellness', TaskData(description: 'Evening reading - 30 mins'));
    addTask('Work', TaskData(description: 'Prepare presentation for meeting'));
    TaskData callMomTask = TaskData(description: 'Call mom');
    callMomTask.isCompleted = true; // 标记为已完成
    addTask('Personal', callMomTask);
    addTask('Health', TaskData(description: 'Schedule dentist appointment'));
  }
}

enum EnergyLabel {
  lowMinus('', 0.0),
  low('Low', 1.0),
  neutral('Neutral', 2.0),
  high('High', 3.0),
  highPlus('', 4.0);

  final String label;
  final double measurementValue;
  const EnergyLabel(this.label, this.measurementValue);
}

class EnergyData {
  final DateTime dateTime; // 标准时间格式
  final double energyLevel; // 能量值，例如 1.0

  EnergyData({required this.dateTime, required this.energyLevel});

  // 动态生成时间字符串，仅输出时间部分
  String get time =>
      "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";

  // 根据 energyLevel 动态生成标签
  EnergyLabel get energyLabel {
    if (energyLevel <= EnergyLabel.lowMinus.measurementValue) {
      return EnergyLabel.lowMinus;
    }
    if (energyLevel <= EnergyLabel.low.measurementValue) {
      return EnergyLabel.low;
    }
    if (energyLevel <= EnergyLabel.neutral.measurementValue) {
      return EnergyLabel.neutral;
    }
    if (energyLevel <= EnergyLabel.high.measurementValue) {
      return EnergyLabel.high;
    }
    return EnergyLabel.highPlus;
  }

  // 获取能量标签的字符串值
  String get energyLabelString => energyLabel.label;
}

class MoodData {
  final String mood;
  final double moodValue;
  final double moodPercentage;
  final int color = 0xFF00FF00; // 默认颜色为绿色
  MoodData(this.mood, this.moodValue, this.moodPercentage);
}

class MoodTracker {
  final List<MoodData> moods;
  MoodTracker(this.moods);

  Map<String, double> get data {
    final Map<String, double> moodMap = {};
    for (var mood in moods) {
      moodMap[mood.mood] = mood.moodPercentage;
    }
    return moodMap;
  }
}

class AwakeTimeAllocationData {
  final String label;
  final double value;
  final int color = 0xFF00FF00; // 默认颜色为绿色

  AwakeTimeAllocationData({required this.label, required this.value});
}

// 日记类，包含日期和日记条目列表
class PersonalData {
  final String date;

  PersonalData({required this.date});

  final String summary =
      'Today was a day of deep conversations with friends, self-reflection, and cultural experiences. My emotions fluctuated between relaxation, joy, reflection, slight anxiety, and nostalgia.';

  // 日记条目列表
  final List<DiaryData> diaryEntries = [
    DiaryData(
      time: '10:00 AM - 1:00 PM',
      title: 'Morning in the Park with Ashley',
      summary:
          'Deep conversations about life, dating experiences, and exploring crystals and tarot cards.',
      content:
          'Ashley and I spent the morning in the park, discussing our lives and sharing insights. We explored crystals and tarot cards, which added a mystical touch to our conversations.',
      tags: ['peaceful', 'outdoor', 'conversation'],
      location: 'Park',
    ),
    DiaryData(
      time: '1:00 PM - 1:30 PM',
      title: 'Departure from Park',
      summary:
          'Said goodbye to Ashley and prepared to meet Trent for our trip to San Francisco.',
      content:
          'After a fulfilling morning, I bid farewell to Ashley. We shared a warm hug and promised to meet again soon. I felt a mix of calmness and anticipation as I prepared for my next adventure.',
      tags: ['calm', 'outdoor', 'transportation'],
      location: 'Park',
    ),
    DiaryData(
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
    DiaryData(
      time: '3:00 PM - 4:00 PM',
      title: 'Coffee Break with Sarah',
      summary: 'Discussed future plans and shared some laughs over coffee.',
      content:
          'Sarah and I took a break at a cozy cafe. We discussed our future plans, shared some laughs, and enjoyed the warm ambiance. It was a relaxing moment that allowed us to unwind.',
      tags: ['relaxing', 'indoor', 'conversation'],
      location: 'Cafe',
    ),
    DiaryData(
      time: '4:30 PM - 6:00 PM',
      title: 'Evening Walk',
      summary: 'A peaceful walk in the park to clear my mind.',
      content:
          'I took a peaceful walk in the park to clear my mind. The fresh air and nature around me provided a calming effect. I reflected on the day and felt grateful for the meaningful connections I made.',
      tags: ['peaceful', 'outdoor', 'exercise'],
      location: 'Park',
    ),
    DiaryData(
      time: '10:00 AM - 1:00 PM',
      title: 'Morning in the Park with Ashley',
      summary:
          'Deep conversations about life, dating experiences, and exploring crystals and tarot cards.',
      content:
          'Ashley and I spent the morning in the park, discussing our lives and sharing insights. We explored crystals and tarot cards, which added a mystical touch to our conversations.',
      tags: ['peaceful', 'outdoor', 'conversation'],
      location: 'Park',
    ),
    DiaryData(
      time: '1:00 PM - 1:30 PM',
      title: 'Departure from Park',
      summary:
          'Said goodbye to Ashley and prepared to meet Trent for our trip to San Francisco.',
      content:
          'After a fulfilling morning, I bid farewell to Ashley. We shared a warm hug and promised to meet again soon. I felt a mix of calmness and anticipation as I prepared for my next adventure.',
      tags: ['calm', 'outdoor', 'transportation'],
      location: 'Park',
    ),
    DiaryData(
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
    DiaryData(
      time: '3:00 PM - 4:00 PM',
      title: 'Coffee Break with Sarah',
      summary: 'Discussed future plans and shared some laughs over coffee.',
      content:
          'Sarah and I took a break at a cozy cafe. We discussed our future plans, shared some laughs, and enjoyed the warm ambiance. It was a relaxing moment that allowed us to unwind.',
      tags: ['relaxing', 'indoor', 'conversation'],
      location: 'Cafe',
    ),
    DiaryData(
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
  final List<QuoteData> quotes = [
    QuoteData(
      text:
          '"Today was a day of deep conversations with friends, self-reflection, and cultural experiences."',
    ),
    QuoteData(
      text:
          '"Meaningful connections with others help me understand myself better and grow as a person."',
    ),
    QuoteData(
      text:
          '"I am grateful for friends who share their wisdom and provide space for authentic expression."',
    ),
  ];

  // 个人反思
  final List<ReflectionData> personalReflections = [
    ReflectionData(
      title: 'I am feeling grateful for:',
      items: [
        'Deep conversations with friends who listen and share wisdom',
        'Access to art and film that opens my eyes to different perspectives',
        'The privilege to contemplate my future on my own terms',
      ],
    ),
    ReflectionData(
      title: 'I can celebrate:',
      items: [
        'Making time for meaningful connections despite a busy schedule',
        'Being open to different cultural experiences and perspectives',
        'Taking steps to consider my future options thoughtfully',
      ],
    ),
    ReflectionData(
      title: 'I can do better at:',
      items: [
        'Finding better balance between solitude and social connection',
        'Being more productive with my free time instead of oversleeping',
        'Managing feelings of envy about others\' lives more constructively',
      ],
    ),
  ];

  // 详细见解
  final List<ReflectionData> detailedInsights = [
    ReflectionData(
      title: 'Relationships',
      items: [
        'Deep conversations with friends provide invaluable emotional support and perspective.',
        'I value authentic connections but feel frustrated by unpredictable dating experiences.',
        'Being \'ghosted\' after meaningful connections is a recurring pattern that causes confusion.',
      ],
    ),
    ReflectionData(
      title: 'Self-Discovery',
      items: [
        'I\'m contemplating the balance between solitude and social connection in my life.',
        'When I have excess free time, I tend toward unproductive behaviors like oversleeping.',
        'I feel both curious about and envious of others\' stable family lives.',
      ],
    ),
    ReflectionData(
      title: 'Future Planning',
      items: [
        'I\'m considering egg freezing and planning to make decisions about children by age 40.',
        'Financial considerations and family support are important factors in my fertility decisions.',
        'I\'m open to alternative pathways to parenthood beyond traditional routes.',
      ],
    ),
    ReflectionData(
      title: '🌍 Cultural Perspectives',
      items: [
        'Art and film provide windows into different cultural and historical experiences.',
        'My family background gives me a unique perspective on political events like Tiananmen Square.',
        'I\'m exploring philosophical concepts from different cultures like Tibetan Buddhist compassion.',
      ],
    ),
  ];

  // 目标
  final List<ReflectionData> goals = [
    ReflectionData(
      title: 'Deepen meaningful relationships',
      items: [
        'Schedule monthly deep conversations with close friends',
        'Join a community group aligned with my interests',
        'Practice active listening techniques',
      ],
    ),
    ReflectionData(
      title: 'Explore fertility options',
      items: [
        'Research egg freezing clinics and costs',
        'Schedule consultation with fertility specialist',
        'Create financial plan for family planning options',
      ],
    ),
    ReflectionData(
      title: 'Expand cultural understanding',
      items: [
        'Watch one international film per week',
        'Read books from diverse cultural perspectives',
      ],
    ),
  ];

  final ScoreCardData moodScore = ScoreCardData(
    title: 'Mood Score',
    value: 7.8,
    change: 0.5,
  );

  final ScoreCardData stressLevel = ScoreCardData(
    title: 'Stress Level',
    value: 3.2,
    change: -1.3,
  );

  final List<HighlightCardData> highlights = [
    HighlightCardData(
      title: 'ACHIEVEMENT',
      content: 'Completed your morning meditation streak - 7 days!',
    ),
    HighlightCardData(
      title: 'INSIGHT',
      content: 'You\'re most productive between 9-11 AM.',
    ),
    HighlightCardData(
      title: 'SOCIAL',
      content: 'You\'ve connected with 3 friends this week.',
    ),
  ];

  final List<EnergyData> energyRecords = [
    EnergyData(dateTime: DateTime(2025, 5, 6, 10, 0), energyLevel: 1.0),
    EnergyData(dateTime: DateTime(2025, 5, 6, 10, 30), energyLevel: 2.0),
    EnergyData(dateTime: DateTime(2025, 5, 6, 11, 30), energyLevel: 1.5),
    EnergyData(dateTime: DateTime(2025, 5, 6, 13, 0), energyLevel: 2.8),
    EnergyData(dateTime: DateTime(2025, 5, 6, 13, 30), energyLevel: 2.0),
    EnergyData(dateTime: DateTime(2025, 5, 6, 14, 30), energyLevel: 3.0),
    EnergyData(dateTime: DateTime(2025, 5, 6, 15, 10), energyLevel: 1.5),
    EnergyData(dateTime: DateTime(2025, 5, 6, 16, 30), energyLevel: 2.5),
    EnergyData(dateTime: DateTime(2025, 5, 6, 18, 30), energyLevel: 3.2),
    EnergyData(dateTime: DateTime(2025, 5, 6, 19, 0), energyLevel: 2.8),
  ];

  final MoodTracker moodTracker = MoodTracker([
    MoodData('Happy', 0.5, 50),
    MoodData('Calm', 0.3, 30),
    MoodData('Stressed', -0.9, 10),
    MoodData('Focused', -0.5, 10),
  ]);

  final List<AwakeTimeAllocationData> awakeTimeAllocationDataList = [
    AwakeTimeAllocationData(label: 'Work', value: 8),
    AwakeTimeAllocationData(label: 'Exercise', value: 2),
    AwakeTimeAllocationData(label: 'Social', value: 3),
    AwakeTimeAllocationData(label: 'Learning', value: 3),
    AwakeTimeAllocationData(label: 'Self-care', value: 1),
    AwakeTimeAllocationData(label: 'Other', value: 4),
  ];
}

// 写一个枚举类，表示消息的角色，目前只有AI 和用户和非法。
enum MessageRole { user, ai, illegal }

class BaseMessage {
  final MessageRole role;
  final String content;

  BaseMessage({required this.role, required this.content});
}

class AIMessage extends BaseMessage {
  AIMessage({required super.content}) : super(role: MessageRole.ai);
}

class UserMessage extends BaseMessage {
  UserMessage({required super.content}) : super(role: MessageRole.user);
}

class RobotDialogData {
  List<BaseMessage> messages = [];

  BaseMessage getMessage(int index) {
    if (index < 0 || index >= messages.length) {
      return BaseMessage(
        role: MessageRole.illegal,
        content: 'Invalid message index',
      );
    }
    return messages[index];
  }

  addAIMessage(String content) {
    messages.add(AIMessage(content: content));
  }

  addUserMessage(String content) {
    messages.add(UserMessage(content: content));
  }

  addTestMessage() {
    messages.clear(); // 清空之前的消息数据
    addAIMessage(
      'Hi Wei! I know you have spent some great time with Ashley and Trent today. Do you want to chat more about it?',
    );
  }
}

// 管理全局数据的类
class DataManager {
  // 单例模式
  static final DataManager _instance = DataManager._internal();
  factory DataManager() => _instance;
  DataManager._internal();

  // 当前的日记和仪表板数据
  final PersonalData activePersonal = PersonalData(date: 'April 19, 2025');

  // 当前的待办事项数据
  final TodoListData activeTodoList = TodoListData();

  // 当前的对话数据
  final RobotDialogData activeRobotDialog = RobotDialogData();

  //
  initialize() {
    activeTodoList.addTestTask();
    activeRobotDialog.addTestMessage();
  }
}
