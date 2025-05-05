import 'package:flutter/material.dart';
import 'package:nirva_app/smart_diary_page.dart';
import 'package:nirva_app/reflections_page.dart';
import 'package:nirva_app/dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 不同平台可能会有不同的UI表现与调用函数。
    debugPrint('Running on: ${Theme.of(context).platform}');
    // 获取当前设备的screen size
    final screenSize = MediaQuery.of(context).size;
    debugPrint('Screen size: ${screenSize.width} x ${screenSize.height}');

    return MaterialApp(
      title: 'Nirva App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Nirva App Home Page'),
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
        return const ReflectionsPage(); // 使用独立的 ReflectionsPage 类
      case 2:
        return const DashboardPage(); // 使用独立的 DashboardPage 类
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

  void _showToDoList(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0), // 从右侧滑入
              end: Offset.zero,
            ).animate(animation),
            child: Align(
              alignment: Alignment.topRight,
              child: Material(
                color: Colors.transparent, // 背景透明
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6, // 宽度为屏幕的 60%
                  height:
                      MediaQuery.of(context).size.height *
                      0.6, // 高度为 body 的 60%
                  margin: EdgeInsets.only(
                    top:
                        kToolbarHeight +
                        MediaQuery.of(context).padding.top, // 确保从 AppBar 下方开始
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
            ),
          );
        },
      ),
    );
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
              _showToDoList(context); // 打开 To-Do List 面板
            },
          ),
        ],
      ),
      body: _getBodyContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: _floatingActionButtonPressed,
        tooltip: 'FloatingActionButton',
        backgroundColor: Colors.purple, // 设置背景颜色为紫色
        shape: const CircleBorder(), // 确保按钮为圆形
        child: const Text(
          'N',
          style: TextStyle(
            fontSize: 24, // 字体大小
            color: Colors.white, // 字体颜色为白色
            fontWeight: FontWeight.bold, // 字体加粗
          ),
        ),
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
