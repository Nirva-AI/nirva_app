// 这是一个数据管理器类，负责管理应用程序中的数据结构和数据
import 'package:flutter/material.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/data_manager.dart';
import 'dart:math';

// 管理全局数据的类
class FillTestData {
  //
  static void fillTestData() {
    DataManager().clear();
    // 添加测试数据
    DataManager().user = User(name: 'Wei');
    DataManager().tasks = FillTestData.createTestTasks();
    DataManager().journalEntries.add(FillTestData.createTestPersonalJournal());
    initializeTestFavorites(DataManager().currentJournalEntry);
  }

  static void initializeTestFavorites(PersonalJournal journal) {
    // 设置测试数据
    List<DiaryEntry> diaryEntries = journal.diaryEntries;

    //
    if (diaryEntries.isNotEmpty) {
      final random = Random();
      DiaryEntry randomDiaryEntry =
          diaryEntries[random.nextInt(diaryEntries.length)];
      debugPrint('随机选中的日记: ${randomDiaryEntry.title}');
      DataManager().diaryFavoritesNotifier.value = [randomDiaryEntry.id];
      debugPrint('已添加到最爱: ${randomDiaryEntry.id}');
    } else {
      debugPrint('diaryEntries 列表为空');
    }
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
        id: "1",
        //time: '10:00 AM - 1:00 PM',
        beginTime: DateTime(2025, 4, 19, 10, 0),
        endTime: DateTime(2025, 4, 19, 13, 0),
        title: 'Morning in the Park with Ashley',
        summary:
            'Deep conversations about life, dating experiences, and exploring crystals and tarot cards.',
        content:
            'Ashley and I spent the morning in the park, discussing our lives and sharing insights. We explored crystals and tarot cards, which added a mystical touch to our conversations.',
        tags: [
          EventTag(name: 'peaceful'),
          EventTag(name: 'outdoor'),
          EventTag(name: 'conversation'),
        ],
        //location: 'Park',
        location: EventLocation(name: 'Park'),
      ),
      DiaryEntry(
        id: "2",
        //time: '1:00 PM - 1:30 PM',
        beginTime: DateTime(2025, 4, 19, 13, 0),
        endTime: DateTime(2025, 4, 19, 13, 30),
        title: 'Departure from Park',
        summary:
            'Said goodbye to Ashley and prepared to meet Trent for our trip to San Francisco.',
        content:
            'After a fulfilling morning, I bid farewell to Ashley. We shared a warm hug and promised to meet again soon. I felt a mix of calmness and anticipation as I prepared for my next adventure.',
        tags: [
          EventTag(name: 'calm'),
          EventTag(name: 'outdoor'),
          EventTag(name: 'transportation'),
        ],
        //location: 'Park',
        location: EventLocation(name: 'Park'),
      ),
      DiaryEntry(
        id: "3",
        //time: '1:30 PM - 2:50 PM',
        beginTime: DateTime(2025, 4, 19, 13, 30),
        endTime: DateTime(2025, 4, 19, 14, 50),
        title: 'Drive to San Francisco with Trent',
        summary:
            'Philosophical discussions about work, life perspectives, and AI companionship during our drive.',
        content:
            'The drive to San Francisco with Trent was filled with deep discussions. We talked about our work, life perspectives, and even the role of AI in our lives. It was an engaging conversation that made the drive feel shorter.',
        tags: [
          EventTag(name: 'engaged'),
          EventTag(name: 'transportation'),
          EventTag(name: 'conversation'),
        ],
        //location: 'In the car',
        location: EventLocation(name: 'In the car'),
      ),
      // 添加更多测试数据
      DiaryEntry(
        id: "4",
        //time: '3:00 PM - 4:00 PM',
        beginTime: DateTime(2025, 4, 19, 15, 0),
        endTime: DateTime(2025, 4, 19, 16, 0),
        title: 'Coffee Break with Sarah',
        summary: 'Discussed future plans and shared some laughs over coffee.',
        content:
            'Sarah and I took a break at a cozy cafe. We discussed our future plans, shared some laughs, and enjoyed the warm ambiance. It was a relaxing moment that allowed us to unwind.',
        tags: [
          EventTag(name: 'relaxing'),
          EventTag(name: 'indoor'),
          EventTag(name: 'conversation'),
        ],
        //location: 'Cafe',
        location: EventLocation(name: 'Cafe'),
      ),
      DiaryEntry(
        id: "5",
        //time: '4:30 PM - 6:00 PM',
        beginTime: DateTime(2025, 4, 19, 16, 30),
        endTime: DateTime(2025, 4, 19, 18, 0),
        title: 'Evening Walk',
        summary: 'A peaceful walk in the park to clear my mind.',
        content:
            'I took a peaceful walk in the park to clear my mind. The fresh air and nature around me provided a calming effect. I reflected on the day and felt grateful for the meaningful connections I made.',
        tags: [
          EventTag(name: 'peaceful'),
          EventTag(name: 'outdoor'),
          EventTag(name: 'exercise'),
        ],
        //location: 'Park',
        location: EventLocation(name: 'Park'),
      ),
      DiaryEntry(
        id: "6",
        //time: '10:00 AM - 1:00 PM',
        beginTime: DateTime(2025, 4, 19, 10, 0),
        endTime: DateTime(2025, 4, 19, 13, 0),
        title: 'Morning in the Park with Ashley',
        summary:
            'Deep conversations about life, dating experiences, and exploring crystals and tarot cards.',
        content:
            'Ashley and I spent the morning in the park, discussing our lives and sharing insights. We explored crystals and tarot cards, which added a mystical touch to our conversations.',
        tags: [
          EventTag(name: 'peaceful'),
          EventTag(name: 'outdoor'),
          EventTag(name: 'conversation'),
        ],
        //location: 'Park',
        location: EventLocation(name: 'Park'),
      ),
      DiaryEntry(
        id: "7",
        //time: '1:00 PM - 1:30 PM',
        beginTime: DateTime(2025, 4, 19, 13, 0),
        endTime: DateTime(2025, 4, 19, 13, 30),
        title: 'Departure from Park',
        summary:
            'Said goodbye to Ashley and prepared to meet Trent for our trip to San Francisco.',
        content:
            'After a fulfilling morning, I bid farewell to Ashley. We shared a warm hug and promised to meet again soon. I felt a mix of calmness and anticipation as I prepared for my next adventure.',
        tags: [
          EventTag(name: 'calm'),
          EventTag(name: 'outdoor'),
          EventTag(name: 'transportation'),
        ],
        //location: 'Park',
        location: EventLocation(name: 'Park'),
      ),
      DiaryEntry(
        id: "8",
        //time: '1:30 PM - 2:50 PM',
        beginTime: DateTime(2025, 4, 19, 13, 30),
        endTime: DateTime(2025, 4, 19, 14, 50),
        title: 'Drive to San Francisco with Trent',
        summary:
            'Philosophical discussions about work, life perspectives, and AI companionship during our drive.',
        content:
            'The drive to San Francisco with Trent was filled with deep discussions. We talked about our work, life perspectives, and even the role of AI in our lives. It was an engaging conversation that made the drive feel shorter.',
        tags: [
          EventTag(name: 'engaged'),
          EventTag(name: 'transportation'),
          EventTag(name: 'conversation'),
        ],
        //location: 'In the car',
        location: EventLocation(name: 'In the car'),
      ),
      // 添加更多测试数据
      DiaryEntry(
        id: "9",
        //time: '3:00 PM - 4:00 PM',
        beginTime: DateTime(2025, 4, 19, 15, 0),
        endTime: DateTime(2025, 4, 19, 16, 0),
        title: 'Coffee Break with Sarah',
        summary: 'Discussed future plans and shared some laughs over coffee.',
        content:
            'Sarah and I took a break at a cozy cafe. We discussed our future plans, shared some laughs, and enjoyed the warm ambiance. It was a relaxing moment that allowed us to unwind.',
        tags: [
          EventTag(name: 'relaxing'),
          EventTag(name: 'indoor'),
          EventTag(name: 'conversation'),
        ],
        //location: 'Cafe',
        location: EventLocation(name: 'Cafe'),
      ),
      DiaryEntry(
        id: "10",
        //time: '4:30 PM - 6:00 PM',
        beginTime: DateTime(2025, 4, 19, 16, 30),
        endTime: DateTime(2025, 4, 19, 18, 0),
        title: 'Evening Walk',
        summary: 'A peaceful walk in the park to clear my mind.',
        content:
            'I took a peaceful walk in the park to clear my mind. The fresh air and nature around me provided a calming effect. I reflected on the day and felt grateful for the meaningful connections I made.',
        tags: [
          EventTag(name: 'peaceful'),
          EventTag(name: 'outdoor'),
          EventTag(name: 'exercise'),
        ],
        //location: 'Park',
        location: EventLocation(name: 'Park'),
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
        id: '1',
        title: 'I am feeling grateful for:',
        items: [
          'Deep conversations with friends who listen and share wisdom',
          'Access to art and film that opens my eyes to different perspectives',
          'The privilege to contemplate my future on my own terms',
        ],
        content:
            "In reflecting on what I'm grateful for today, I find myself particularly appreciative of the deep conversations I've had with friends who truly listen and offer their wisdom. There's something profoundly nourishing about being heard without judgment, about exchanging ideas with people who challenge my thinking in constructive ways. These conversations have helped me navigate complex emotions and decisions, offering perspectives I might never have considered on my own.",
      ),
      Reflection(
        id: '2',
        title: 'I can celebrate:',
        items: [
          'Making time for meaningful connections despite a busy schedule',
          'Being open to different cultural experiences and perspectives',
          'Taking steps to consider my future options thoughtfully',
        ],
        content:
            "I can celebrate the fact that I made time for meaningful connections today, even amidst a busy schedule. I took the initiative to reach out to friends and engage in deep conversations that nourished my soul. I also feel proud of my openness to different cultural experiences and perspectives, as they enrich my understanding of the world. Additionally, I'm taking steps to consider my future options thoughtfully, which is empowering.",
      ),
      Reflection(
        id: '3',
        title: 'I can do better at:',
        items: [
          'Finding better balance between solitude and social connection',
          'Being more productive with my free time instead of oversleeping',
          'Managing feelings of envy about others\' lives more constructively',
        ],
        content:
            "While I have much to celebrate, I also recognize areas where I can improve. I need to find a better balance between solitude and social connection, as too much of either can lead to feelings of isolation or overwhelm. I also want to be more productive with my free time instead of falling into the trap of oversleeping or procrastination. Lastly, I need to manage my feelings of envy about others' lives more constructively, perhaps by focusing on my own journey and what I can do to create the life I want.",
      ),
    ];

    // 详细见解
    final List<Reflection> detailedInsights = [
      Reflection(
        id: '4',
        title: 'Relationships',
        items: [
          'Deep conversations with friends provide invaluable emotional support and perspective.',
          'I value authentic connections but feel frustrated by unpredictable dating experiences.',
          'Being \'ghosted\' after meaningful connections is a recurring pattern that causes confusion.',
        ],
        content:
            "I find that deep conversations with friends provide invaluable emotional support and perspective. These discussions help me navigate complex feelings and decisions, offering insights I might not have considered on my own. However, I also feel frustrated by the unpredictable nature of dating experiences. The emotional rollercoaster of connecting with someone only to be 'ghosted' afterward is a recurring pattern that leaves me feeling confused and questioning my worth.",
      ),
      Reflection(
        id: '5',
        title: 'Self-Discovery',
        items: [
          'I\'m contemplating the balance between solitude and social connection in my life.',
          'When I have excess free time, I tend toward unproductive behaviors like oversleeping.',
          'I feel both curious about and envious of others\' stable family lives.',
        ],
        content:
            "I find myself contemplating the balance between solitude and social connection in my life. While I cherish my alone time for self-reflection, I also recognize the importance of meaningful connections with others. However, when I have excess free time, I tend to fall into unproductive behaviors like oversleeping or mindless scrolling on social media. This leads to feelings of guilt and frustration. Additionally, I feel both curious about and envious of others' stable family lives, which makes me question my own choices and priorities.",
      ),
      Reflection(
        id: '6',
        title: 'Future Planning',
        items: [
          'I\'m considering egg freezing and planning to make decisions about children by age 40.',
          'Financial considerations and family support are important factors in my fertility decisions.',
          'I\'m open to alternative pathways to parenthood beyond traditional routes.',
        ],
        content:
            "As I think about my future, I'm considering the option of egg freezing and planning to make decisions about having children by age 40. Financial considerations and family support are important factors in my fertility decisions. I want to ensure that I have the resources and emotional backing to make informed choices. Additionally, I'm open to alternative pathways to parenthood beyond traditional routes, such as adoption or co-parenting arrangements.",
      ),
      Reflection(
        id: '7',
        title: 'Cultural Perspectives',
        items: [
          'Art and film provide windows into different cultural and historical experiences.',
          'My family background gives me a unique perspective on political events like Tiananmen Square.',
          'I\'m exploring philosophical concepts from different cultures like Tibetan Buddhist compassion.',
        ],
        content:
            "I find that art and film provide windows into different cultural and historical experiences. They allow me to explore perspectives that I may not have encountered in my own life. My family background gives me a unique perspective on political events like Tiananmen Square, which shapes my understanding of current events. I'm also exploring philosophical concepts from different cultures, such as Tibetan Buddhist compassion, which resonates with my desire for emotional growth and understanding.",
      ),
    ];

    // 目标
    final List<Reflection> goals = [
      Reflection(
        id: '8',
        title: 'Deepen meaningful relationships',
        items: [
          'Schedule monthly deep conversations with close friends',
          'Join a community group aligned with my interests',
          'Practice active listening techniques',
        ],
        content: "",
      ),
      Reflection(
        id: '9',
        title: 'Explore fertility options',
        items: [
          'Research egg freezing clinics and costs',
          'Schedule consultation with fertility specialist',
          'Create financial plan for family planning options',
        ],
        content: "",
      ),
      Reflection(
        id: '10',
        title: 'Expand cultural understanding',
        items: [
          'Watch one international film per week',
          'Read books from diverse cultural perspectives',
        ],
        content: "",
      ),
    ];

    final MoodScore moodScore = MoodScore(value: 7.8, change: 0.5);

    final StressLevel stressLevel = StressLevel(value: 3.2, change: -1.3);

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
