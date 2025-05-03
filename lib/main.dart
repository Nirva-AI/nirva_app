import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 不同平台可能会有不同的UI表现与调用函数。
    debugPrint('Running on: ${Theme.of(context).platform}');
    return MaterialApp(
      title: 'Nirva App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'MyHomePage title'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedPage = 0;

  void _floatingActionButtonPressed() {
    setState(() {
      debugPrint('_floatingActionButtonPressed');
    });
  }

  Widget _getBodyContent() {
    switch (_selectedPage) {
      case 0:
        return SmartDiaryPage(); // 使用新的 SmartDiaryPage 组件
      case 1:
        return const Center(child: Text('Reflections Page'));
      case 2:
        return const Center(child: Text('Dashboard Page'));
      default:
        return const Center(child: Text('Unknown Page'));
    }
  }

  String _getTitle() {
    switch (_selectedPage) {
      case 0:
        return 'Smart Diary';
      case 1:
        return 'Reflections';
      case 2:
        return 'Dashboard';
      default:
        return 'Unknown Page';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(_getTitle()),
        centerTitle: false, // 将标题靠近左侧
        actions: [
          IconButton(
            icon: const Icon(Icons.checklist), // 选择一个表示 "to-do list" 的图标
            onPressed: () {
              debugPrint('to-do list'); // 打印 "to-do list"
            },
          ),
        ],
      ),
      body: _getBodyContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: _floatingActionButtonPressed,
        tooltip: 'FloatingActionButton',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // 自定义位置
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildBottomAppBarItem(
                icon: Icons.book,
                label: 'Smart Diary',
                isSelected: _selectedPage == 0,
                onTap: () {
                  setState(() {
                    _selectedPage = 0;
                  });
                },
              ),
              _buildBottomAppBarItem(
                icon: Icons.lightbulb,
                label: 'Reflections',
                isSelected: _selectedPage == 1,
                onTap: () {
                  setState(() {
                    _selectedPage = 1;
                  });
                },
              ),
              _buildBottomAppBarItem(
                icon: Icons.dashboard,
                label: 'Dashboard',
                isSelected: _selectedPage == 2,
                onTap: () {
                  setState(() {
                    _selectedPage = 2;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomAppBarItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: isSelected ? Colors.blue : Colors.grey),
          Text(
            label,
            style: TextStyle(
              fontSize: 20,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

// 修改 TestPage 组件
class TestPage extends StatelessWidget {
  final String content;

  const TestPage({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('测试页面'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(content, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}

// 管理日记条目的单例类
class DiaryEntryManager {
  // 单例模式
  static final DiaryEntryManager _instance = DiaryEntryManager._internal();
  factory DiaryEntryManager() => _instance;
  DiaryEntryManager._internal();

  // 日记条目列表
  final List<DiaryEntryData> entries = [
    DiaryEntryData(
      time: '10:00 AM - 1:00 PM',
      title: 'Morning in the Park with Ashley',
      description:
          'Deep conversations about life, dating experiences, and exploring crystals and tarot cards.',
      tags: ['peaceful', 'outdoor', 'conversation'],
      location: 'Park',
    ),
    DiaryEntryData(
      time: '1:00 PM - 1:30 PM',
      title: 'Departure from Park',
      description:
          'Said goodbye to Ashley and prepared to meet Trent for our trip to San Francisco.',
      tags: ['calm', 'outdoor', 'transportation'],
      location: 'Park',
    ),
    DiaryEntryData(
      time: '1:30 PM - 2:50 PM',
      title: 'Drive to San Francisco with Trent',
      description:
          'Philosophical discussions about work, life perspectives, and AI companionship during our drive.',
      tags: ['engaged', 'transportation', 'conversation'],
      location: 'In the car',
    ),
    // 添加更多测试数据
    DiaryEntryData(
      time: '3:00 PM - 4:00 PM',
      title: 'Coffee Break with Sarah',
      description: 'Discussed future plans and shared some laughs over coffee.',
      tags: ['relaxing', 'indoor', 'conversation'],
      location: 'Cafe',
    ),
    DiaryEntryData(
      time: '4:30 PM - 6:00 PM',
      title: 'Evening Walk',
      description: 'A peaceful walk in the park to clear my mind.',
      tags: ['peaceful', 'outdoor', 'exercise'],
      location: 'Park',
    ),
    DiaryEntryData(
      time: '10:00 AM - 1:00 PM',
      title: 'Morning in the Park with Ashley',
      description:
          'Deep conversations about life, dating experiences, and exploring crystals and tarot cards.',
      tags: ['peaceful', 'outdoor', 'conversation'],
      location: 'Park',
    ),
    DiaryEntryData(
      time: '1:00 PM - 1:30 PM',
      title: 'Departure from Park',
      description:
          'Said goodbye to Ashley and prepared to meet Trent for our trip to San Francisco.',
      tags: ['calm', 'outdoor', 'transportation'],
      location: 'Park',
    ),
    DiaryEntryData(
      time: '1:30 PM - 2:50 PM',
      title: 'Drive to San Francisco with Trent',
      description:
          'Philosophical discussions about work, life perspectives, and AI companionship during our drive.',
      tags: ['engaged', 'transportation', 'conversation'],
      location: 'In the car',
    ),
    // 添加更多测试数据
    DiaryEntryData(
      time: '3:00 PM - 4:00 PM',
      title: 'Coffee Break with Sarah',
      description: 'Discussed future plans and shared some laughs over coffee.',
      tags: ['relaxing', 'indoor', 'conversation'],
      location: 'Cafe',
    ),
    DiaryEntryData(
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
      gradient: const LinearGradient(
        colors: [Colors.pinkAccent, Colors.purpleAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    QuoteData(
      text:
          '"Meaningful connections with others help me understand myself better and grow as a person."',
      gradient: const LinearGradient(
        colors: [Colors.greenAccent, Colors.blueAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    QuoteData(
      text:
          '"I am grateful for friends who share their wisdom and provide space for authentic expression."',
      gradient: const LinearGradient(
        colors: [Colors.blueAccent, Colors.lightBlueAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    QuoteData(
      text:
          '"Every day is a new opportunity to learn, grow, and make meaningful memories."',
      gradient: const LinearGradient(
        colors: [Colors.orangeAccent, Colors.redAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    QuoteData(
      text:
          '"Happiness is found in the little moments of gratitude and connection."',
      gradient: const LinearGradient(
        colors: [Colors.tealAccent, Colors.cyanAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ];
}

// 引言卡片的数据结构
class QuoteData {
  final String text;
  final LinearGradient gradient;

  QuoteData({required this.text, required this.gradient});
}

// 日记条目的数据结构
class DiaryEntryData {
  final String time;
  final String title;
  final String description;
  final List<String> tags;
  final String location;

  DiaryEntryData({
    required this.time,
    required this.title,
    required this.description,
    required this.tags,
    required this.location,
  });
}

// 修改 SmartDiaryPage 组件
class SmartDiaryPage extends StatelessWidget {
  const SmartDiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取引言卡片数据
    final quotes = DiaryEntryManager().quotes;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部引言卡片轮播
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: QuoteCarousel(quotes: quotes),
          ),
          // 日期标题
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'April 19, 2025',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // 使用 ListView.builder 动态展示日记条目
          ListView.builder(
            shrinkWrap: true, // 使 ListView 适应父组件高度
            physics: const NeverScrollableScrollPhysics(), // 禁用内部滚动
            itemCount: DiaryEntryManager().entries.length,
            itemBuilder: (context, index) {
              final entry = DiaryEntryManager().entries[index];
              return DiaryEntry(
                time: entry.time,
                title: entry.title,
                description: entry.description,
                tags: entry.tags,
                location: entry.location,
              );
            },
          ),
        ],
      ),
    );
  }
}

// 修改 QuoteCarousel 组件
class QuoteCarousel extends StatefulWidget {
  final List<QuoteData> quotes;

  const QuoteCarousel({super.key, required this.quotes});

  @override
  State<QuoteCarousel> createState() => _QuoteCarouselState();
}

class _QuoteCarouselState extends State<QuoteCarousel> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150, // 设置卡片高度
          child: PageView.builder(
            itemCount: widget.quotes.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final quote = widget.quotes[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: quote.gradient,
                ),
                child: Center(
                  child: Text(
                    quote.text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // 分页指示器
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.quotes.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              width: _currentPage == index ? 12.0 : 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                color: _currentPage == index ? Colors.purple : Colors.grey,
                borderRadius: BorderRadius.circular(4.0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// 修改 DiaryEntry 组件
class DiaryEntry extends StatelessWidget {
  final String time;
  final String title;
  final String description;
  final List<String> tags;
  final String location;

  const DiaryEntry({
    super.key,
    required this.time,
    required this.title,
    required this.description,
    required this.tags,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    // 拼接卡片的所有文本内容
    final cardContent = '''
Time: $time
Title: $title
Description: $description
Tags: ${tags.join(', ')}
Location: $location
''';

    return GestureDetector(
      onTap: () {
        // 跳转到 TestPage，并传递卡片内容
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TestPage(content: cardContent),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  children:
                      tags
                          .map(
                            (tag) => Chip(
                              label: Text(tag),
                              backgroundColor: Colors.blue.shade100,
                            ),
                          )
                          .toList(),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      location,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const Icon(Icons.star_border), // 收藏按钮
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
