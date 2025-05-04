// 引言卡片的数据结构
class QuoteData {
  final String text;

  QuoteData({required this.text});
}

// 日记条目的数据结构
class DiaryItem {
  final String time;
  final String title;
  final String description;
  final List<String> tags;
  final String location;

  DiaryItem({
    required this.time,
    required this.title,
    required this.description,
    required this.tags,
    required this.location,
  });
}

// 日记类，包含日期和日记条目列表
class Diary {
  final String date;

  Diary({required this.date});

  final String dateAndSummary =
      'Today was a day of deep conversations with friends, self-reflection, and cultural experiences. My emotions fluctuated between relaxation, joy, reflection, slight anxiety, and nostalgia.';

  // 日记条目列表
  final List<DiaryItem> entries = [
    DiaryItem(
      time: '10:00 AM - 1:00 PM',
      title: 'Morning in the Park with Ashley',
      description:
          'Deep conversations about life, dating experiences, and exploring crystals and tarot cards.',
      tags: ['peaceful', 'outdoor', 'conversation'],
      location: 'Park',
    ),
    DiaryItem(
      time: '1:00 PM - 1:30 PM',
      title: 'Departure from Park',
      description:
          'Said goodbye to Ashley and prepared to meet Trent for our trip to San Francisco.',
      tags: ['calm', 'outdoor', 'transportation'],
      location: 'Park',
    ),
    DiaryItem(
      time: '1:30 PM - 2:50 PM',
      title: 'Drive to San Francisco with Trent',
      description:
          'Philosophical discussions about work, life perspectives, and AI companionship during our drive.',
      tags: ['engaged', 'transportation', 'conversation'],
      location: 'In the car',
    ),
    // 添加更多测试数据
    DiaryItem(
      time: '3:00 PM - 4:00 PM',
      title: 'Coffee Break with Sarah',
      description: 'Discussed future plans and shared some laughs over coffee.',
      tags: ['relaxing', 'indoor', 'conversation'],
      location: 'Cafe',
    ),
    DiaryItem(
      time: '4:30 PM - 6:00 PM',
      title: 'Evening Walk',
      description: 'A peaceful walk in the park to clear my mind.',
      tags: ['peaceful', 'outdoor', 'exercise'],
      location: 'Park',
    ),
    DiaryItem(
      time: '10:00 AM - 1:00 PM',
      title: 'Morning in the Park with Ashley',
      description:
          'Deep conversations about life, dating experiences, and exploring crystals and tarot cards.',
      tags: ['peaceful', 'outdoor', 'conversation'],
      location: 'Park',
    ),
    DiaryItem(
      time: '1:00 PM - 1:30 PM',
      title: 'Departure from Park',
      description:
          'Said goodbye to Ashley and prepared to meet Trent for our trip to San Francisco.',
      tags: ['calm', 'outdoor', 'transportation'],
      location: 'Park',
    ),
    DiaryItem(
      time: '1:30 PM - 2:50 PM',
      title: 'Drive to San Francisco with Trent',
      description:
          'Philosophical discussions about work, life perspectives, and AI companionship during our drive.',
      tags: ['engaged', 'transportation', 'conversation'],
      location: 'In the car',
    ),
    // 添加更多测试数据
    DiaryItem(
      time: '3:00 PM - 4:00 PM',
      title: 'Coffee Break with Sarah',
      description: 'Discussed future plans and shared some laughs over coffee.',
      tags: ['relaxing', 'indoor', 'conversation'],
      location: 'Cafe',
    ),
    DiaryItem(
      time: '4:30 PM - 6:00 PM',
      title: 'Evening Walk',
      description: 'A peaceful walk in the park to clear my mind.',
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
    QuoteData(
      text:
          '"Every day is a new opportunity to learn, grow, and make meaningful memories."',
    ),
    QuoteData(
      text:
          '"Happiness is found in the little moments of gratitude and connection."',
    ),
  ];
}

// 管理日记条目的单例类
class DataManager {
  // 单例模式
  static final DataManager _instance = DataManager._internal();
  factory DataManager() => _instance;
  DataManager._internal();

  final Diary currentDiary = Diary(date: 'April 19, 2025');
}
