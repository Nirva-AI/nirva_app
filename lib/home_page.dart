import 'package:flutter/material.dart';
import 'package:nirva_app/app_runtime_context.dart';
import 'package:nirva_app/smart_diary_page.dart';
import 'package:nirva_app/reflections_page.dart';
import 'package:nirva_app/dashboard_page.dart';
import 'package:nirva_app/todo_list_view.dart';
import 'package:nirva_app/assistant_chat_page.dart';
import 'package:nirva_app/me_page.dart';

enum HomePageNavigationType { smartDiary, reflection, dashboard, me }

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 使用枚举类型替代整数
  HomePageNavigationType _selectedPage = HomePageNavigationType.smartDiary;

  final TextEditingController _textController = TextEditingController();

  void _floatingActionButtonPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => AssistantChatPage(textController: _textController),
      ),
    );
  }

  Widget _getBodyContent() {
    switch (_selectedPage) {
      case HomePageNavigationType.smartDiary:
        return SmartDiaryPage();
      case HomePageNavigationType.reflection:
        return const ReflectionsPage();
      case HomePageNavigationType.dashboard:
        return const DashboardPage();
      case HomePageNavigationType.me:
        return const MePage();
    }
  }

  String _getTitle() {
    switch (_selectedPage) {
      case HomePageNavigationType.smartDiary:
        return 'Smart Diary';
      case HomePageNavigationType.reflection:
        return 'Reflections';
      case HomePageNavigationType.dashboard:
        return 'Dashboard';
      case HomePageNavigationType.me:
        return 'Me';
    }
  }

  void _showToDoList(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false, // 设置为透明背景
        transitionDuration: const Duration(milliseconds: 100), // 动画持续时间
        pageBuilder: (context, animation, secondaryAnimation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0), // 从屏幕右侧滑入
              end: Offset.zero, // 到达屏幕位置
            ).animate(animation),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop(); // 点击外部区域关闭视图
              },
              child: Container(
                color: Colors.black.withAlpha(0), // 半透明背景
                child: GestureDetector(
                  onTap: () {}, // 阻止点击 TodoListView 内部区域触发关闭
                  child: const TodoListView(),
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 250, 249, 244),
          title: Text(_getTitle()),
          centerTitle: false,
          elevation: 0, // 移除默认阴影
          actions: [
            IconButton(
              icon: const Icon(Icons.checklist),
              onPressed: () {
                debugPrint('to-do list');
                AppRuntimeContext().data.clearCompletedTasks();
                _showToDoList(context);
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Colors.grey.shade300, // 自定义下边框颜色
              height: 1.0, // 下边框高度
            ),
          ),
        ),
      ),
      body: _getBodyContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: _floatingActionButtonPressed,
        tooltip: 'FloatingActionButton',
        backgroundColor: Colors.yellow,
        shape: const CircleBorder(),
        child: const Text(
          'N',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: SizedBox(
          height: 70,
          child: Row(
            children: [
              Expanded(
                child: _buildBottomAppBarItem(
                  icon: Icons.book,
                  label: 'Smart Diary',
                  isSelected:
                      _selectedPage == HomePageNavigationType.smartDiary,
                  onTap: () {
                    setState(() {
                      _selectedPage = HomePageNavigationType.smartDiary;
                    });
                  },
                ),
              ),
              Expanded(
                child: _buildBottomAppBarItem(
                  icon: Icons.lightbulb,
                  label: 'Reflections',
                  isSelected:
                      _selectedPage == HomePageNavigationType.reflection,
                  onTap: () {
                    setState(() {
                      _selectedPage = HomePageNavigationType.reflection;
                    });
                  },
                ),
              ),
              Expanded(
                child: _buildBottomAppBarItem(
                  icon: Icons.dashboard,
                  label: 'Dashboard',
                  isSelected: _selectedPage == HomePageNavigationType.dashboard,
                  onTap: () {
                    setState(() {
                      _selectedPage = HomePageNavigationType.dashboard;
                    });
                  },
                ),
              ),
              Expanded(
                child: _buildBottomAppBarItem(
                  icon: Icons.person,
                  label: 'Me',
                  isSelected: _selectedPage == HomePageNavigationType.me,
                  onTap: () {
                    debugPrint('Me button tapped');
                    setState(() {
                      _selectedPage = HomePageNavigationType.me;
                    });
                  },
                ),
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
      child: Container(
        height: double.infinity, // 占满父容器的高度
        color: Colors.transparent, // 设置透明背景，确保整个区域可点击
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30, // 调整图标大小
              color: isSelected ? Colors.blue : Colors.grey,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10, // 调整字体大小
                color: isSelected ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
