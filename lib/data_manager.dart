// 引言卡片的数据结构
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

/*
class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Material(
        color: Colors.transparent, // 背景透明
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6, // 宽度为屏幕的 60%
          height: MediaQuery.of(context).size.height * 0.6, // 高度为屏幕的 60%
          margin: EdgeInsets.only(
            top:
                kToolbarHeight +
                MediaQuery.of(context).padding.top, // 从 AppBar 下方开始
          ),
          color: Colors.white, // 背景为白色
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题栏
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'To-Do List',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop(); // 关闭面板
                      },
                    ),
                  ],
                ),
              ),
              const Divider(),
              // 内容
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    const Text(
                      'Wellness',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 5,
                      ),
                      title: Text('Morning meditation'),
                    ),
                    const ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orange,
                        radius: 5,
                      ),
                      title: Text('Evening reading - 30 mins'),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Work',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 5,
                      ),
                      title: Text('Prepare presentation for meeting'),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Personal',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.orange,
                        radius: 5,
                      ),
                      title: Text(
                        'Call mom',
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Health',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 5,
                      ),
                      title: Text('Schedule dentist appointment'),
                    ),
                  ],
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Add New Task'),
                onTap: () {
                  debugPrint('Add New Task tapped');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/

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

  testAddTask() {
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
}

// 管理全局数据的类
class DataManager {
  // 单例模式
  static final DataManager _instance = DataManager._internal();
  factory DataManager() => _instance;
  DataManager._internal();
  // 当前的日记和仪表板数据
  final PersonalData currentPersonalData = PersonalData(date: 'April 19, 2025');

  final TodoListData currentTodoListData = TodoListData();
}
