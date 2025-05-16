// 这是一个数据管理器类，负责管理应用程序中的数据结构和数据
import 'package:nirva_app/data.dart';
import 'package:nirva_app/data_manager.dart';

// 管理全局数据的类
class FillTestData {
  //
  static void fillTestData() {
    DataManager().clear();
    // 添加测试数据
    DataManager().userName = 'Wei';
    DataManager().tasks = FillTestData.createTestTasks();
    DataManager().journalEntries.add(FillTestData.createTestPersonalJournal());
  }

  // 测试数据： 初始化待办事项数据
  static List<Task> createTestTasks() {
    return [
      Task(tag: 'Wellness', description: 'Morning meditation'),
      Task(tag: 'Wellness', description: 'Evening reading - 30 mins'),
      Task(tag: 'Work', description: 'Prepare presentation for meeting'),
      Task(tag: 'Personal', description: 'Call mom', isCompleted: true),
      Task(tag: 'Health', description: 'Schedule dentist appointment'),
    ];
  }

  // 测试数据： 初始化个人数据
  static PersonalJournal createTestPersonalJournal() {
    final String summary =
        'Today was a day of deep conversations with friends, self-reflection, and cultural experiences. My emotions fluctuated between relaxation, joy, reflection, slight anxiety, and nostalgia.';

    // 日记条目列表
    final List<DiaryEntry> diaryEntries = [
      DiaryEntry(
        //time: '10:00 AM - 1:00 PM',
        beginTime: DateTime(2025, 4, 19, 10, 0),
        endTime: DateTime(2025, 4, 19, 13, 0),
        title: 'Morning in the Park with Ashley',
        summary:
            'Deep conversations about life, dating experiences, and exploring crystals and tarot cards.',
        content:
            'Ashley and I spent the morning in the park, discussing our lives and sharing insights. We explored crystals and tarot cards, which added a mystical touch to our conversations.',
        tags: ['peaceful', 'outdoor', 'conversation'],
        location: 'Park',
        //isStarred: false,
      ),
      DiaryEntry(
        //time: '1:00 PM - 1:30 PM',
        beginTime: DateTime(2025, 4, 19, 13, 0),
        endTime: DateTime(2025, 4, 19, 13, 30),
        title: 'Departure from Park',
        summary:
            'Said goodbye to Ashley and prepared to meet Trent for our trip to San Francisco.',
        content:
            'After a fulfilling morning, I bid farewell to Ashley. We shared a warm hug and promised to meet again soon. I felt a mix of calmness and anticipation as I prepared for my next adventure.',
        tags: ['calm', 'outdoor', 'transportation'],
        location: 'Park',
        //isStarred: false,
      ),
      DiaryEntry(
        //time: '1:30 PM - 2:50 PM',
        beginTime: DateTime(2025, 4, 19, 13, 30),
        endTime: DateTime(2025, 4, 19, 14, 50),
        title: 'Drive to San Francisco with Trent',
        summary:
            'Philosophical discussions about work, life perspectives, and AI companionship during our drive.',
        content:
            'The drive to San Francisco with Trent was filled with deep discussions. We talked about our work, life perspectives, and even the role of AI in our lives. It was an engaging conversation that made the drive feel shorter.',
        tags: ['engaged', 'transportation', 'conversation'],
        location: 'In the car',
        //isStarred: false,
      ),
      // 添加更多测试数据
      DiaryEntry(
        //time: '3:00 PM - 4:00 PM',
        beginTime: DateTime(2025, 4, 19, 15, 0),
        endTime: DateTime(2025, 4, 19, 16, 0),
        title: 'Coffee Break with Sarah',
        summary: 'Discussed future plans and shared some laughs over coffee.',
        content:
            'Sarah and I took a break at a cozy cafe. We discussed our future plans, shared some laughs, and enjoyed the warm ambiance. It was a relaxing moment that allowed us to unwind.',
        tags: ['relaxing', 'indoor', 'conversation'],
        location: 'Cafe',
        //isStarred: false,
      ),
      DiaryEntry(
        //time: '4:30 PM - 6:00 PM',
        beginTime: DateTime(2025, 4, 19, 16, 30),
        endTime: DateTime(2025, 4, 19, 18, 0),
        title: 'Evening Walk',
        summary: 'A peaceful walk in the park to clear my mind.',
        content:
            'I took a peaceful walk in the park to clear my mind. The fresh air and nature around me provided a calming effect. I reflected on the day and felt grateful for the meaningful connections I made.',
        tags: ['peaceful', 'outdoor', 'exercise'],
        location: 'Park',
        //isStarred: false,
      ),
      DiaryEntry(
        //time: '10:00 AM - 1:00 PM',
        beginTime: DateTime(2025, 4, 19, 10, 0),
        endTime: DateTime(2025, 4, 19, 13, 0),
        title: 'Morning in the Park with Ashley',
        summary:
            'Deep conversations about life, dating experiences, and exploring crystals and tarot cards.',
        content:
            'Ashley and I spent the morning in the park, discussing our lives and sharing insights. We explored crystals and tarot cards, which added a mystical touch to our conversations.',
        tags: ['peaceful', 'outdoor', 'conversation'],
        location: 'Park',
        //isStarred: false,
      ),
      DiaryEntry(
        //time: '1:00 PM - 1:30 PM',
        beginTime: DateTime(2025, 4, 19, 13, 0),
        endTime: DateTime(2025, 4, 19, 13, 30),
        title: 'Departure from Park',
        summary:
            'Said goodbye to Ashley and prepared to meet Trent for our trip to San Francisco.',
        content:
            'After a fulfilling morning, I bid farewell to Ashley. We shared a warm hug and promised to meet again soon. I felt a mix of calmness and anticipation as I prepared for my next adventure.',
        tags: ['calm', 'outdoor', 'transportation'],
        location: 'Park',
        //isStarred: false,
      ),
      DiaryEntry(
        //time: '1:30 PM - 2:50 PM',
        beginTime: DateTime(2025, 4, 19, 13, 30),
        endTime: DateTime(2025, 4, 19, 14, 50),
        title: 'Drive to San Francisco with Trent',
        summary:
            'Philosophical discussions about work, life perspectives, and AI companionship during our drive.',
        content:
            'The drive to San Francisco with Trent was filled with deep discussions. We talked about our work, life perspectives, and even the role of AI in our lives. It was an engaging conversation that made the drive feel shorter.',
        tags: ['engaged', 'transportation', 'conversation'],
        location: 'In the car',
        //isStarred: false,
      ),
      // 添加更多测试数据
      DiaryEntry(
        //time: '3:00 PM - 4:00 PM',
        beginTime: DateTime(2025, 4, 19, 15, 0),
        endTime: DateTime(2025, 4, 19, 16, 0),
        title: 'Coffee Break with Sarah',
        summary: 'Discussed future plans and shared some laughs over coffee.',
        content:
            'Sarah and I took a break at a cozy cafe. We discussed our future plans, shared some laughs, and enjoyed the warm ambiance. It was a relaxing moment that allowed us to unwind.',
        tags: ['relaxing', 'indoor', 'conversation'],
        location: 'Cafe',
        //isStarred: false,
      ),
      DiaryEntry(
        //time: '4:30 PM - 6:00 PM',
        beginTime: DateTime(2025, 4, 19, 16, 30),
        endTime: DateTime(2025, 4, 19, 18, 0),
        title: 'Evening Walk',
        summary: 'A peaceful walk in the park to clear my mind.',
        content:
            'I took a peaceful walk in the park to clear my mind. The fresh air and nature around me provided a calming effect. I reflected on the day and felt grateful for the meaningful connections I made.',
        tags: ['peaceful', 'outdoor', 'exercise'],
        location: 'Park',
        //isStarred: false,
      ),
    ];

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
    final List<Reflection> selfReflections = [
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
    final List<Reflection> detailedInsights = [
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
    final List<Reflection> goals = [
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

    final Score moodScore = Score(title: 'Mood Score', value: 7.8, change: 0.5);

    final Score stressLevel = Score(
      title: 'Stress Level',
      value: 3.2,
      change: -1.3,
    );

    final List<Highlight> highlights = [
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

    final List<Energy> energyRecords = [
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

    final List<Mood> moods = [
      Mood(name: 'Happy', moodValue: 0.5, moodPercentage: 50),
      Mood(name: 'Calm', moodValue: 0.3, moodPercentage: 30),
      Mood(name: 'Stressed', moodValue: -0.9, moodPercentage: 10),
      Mood(name: 'Focused', moodValue: -0.5, moodPercentage: 10),
    ];

    final List<AwakeTimeAction> awakeTimeActions = [
      AwakeTimeAction(label: 'Work', value: 8),
      AwakeTimeAction(label: 'Exercise', value: 2),
      AwakeTimeAction(label: 'Social', value: 3),
      AwakeTimeAction(label: 'Learning', value: 3),
      AwakeTimeAction(label: 'Self-care', value: 1),
      AwakeTimeAction(label: 'Other', value: 4),
    ];

    List<SocialEntity> socialEntities = [
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

    return PersonalJournal(
      dateTime: DateTime(2025, 4, 19),
      summary: summary,
      diaryEntries: diaryEntries,
      quotes: quotes,
      selfReflections: selfReflections,
      detailedInsights: detailedInsights,
      goals: goals,
      moodScore: moodScore,
      stressLevel: stressLevel,
      highlights: highlights,
      energyRecords: energyRecords,
      moods: moods,
      awakeTimeActions: awakeTimeActions,
      socialMap: SocialMap(socialEntities: socialEntities),
    );
  }
}
