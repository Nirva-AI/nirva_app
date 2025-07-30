import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/providers/tasks_provider.dart';
import 'package:nirva_app/lounge/lounge_screen.dart';
import 'package:nirva_app/smart_diary_page.dart';
import 'package:nirva_app/reflections_page.dart';
import 'package:nirva_app/dashboard_page.dart';
import 'package:nirva_app/todo_list_view.dart';
import 'package:nirva_app/assistant_chat_page.dart';
import 'package:nirva_app/me_page.dart';

enum HomePageNavigationType { lounge, smartDiary, dashboard, me }

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 使用枚举类型替代整数
  HomePageNavigationType _selectedPage = HomePageNavigationType.lounge;

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
      case HomePageNavigationType.lounge:
        return const LoungeScreen();
      case HomePageNavigationType.smartDiary:
        return SmartDiaryPage();
      case HomePageNavigationType.dashboard:
        return const DashboardPage();
      case HomePageNavigationType.me:
        return const MePage();
    }
  }

  String _getTitle() {
    switch (_selectedPage) {
      case HomePageNavigationType.lounge:
        return 'Lounge';
      case HomePageNavigationType.smartDiary:
        return 'Smart Diary';
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
      backgroundColor: const Color(0xFFfaf9f5),
      appBar: _selectedPage == HomePageNavigationType.lounge 
        ? null 
        : PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
                          child: AppBar(
                backgroundColor: const Color(0xFFfaf9f5),
              title: Text(_getTitle()),
              centerTitle: false,
              elevation: 0, // 移除默认阴影
              actions: [
                IconButton(
                  icon: const Icon(Icons.checklist),
                  onPressed: () {
                    debugPrint('to-do list');
                    final tasksProvider = Provider.of<TasksProvider>(
                      context,
                      listen: false,
                    );
                    tasksProvider.clearCompletedTasks();
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
      floatingActionButton: Container(
        width: 72, // Larger size
        height: 72, // Larger size
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            // Multiple shadows for glowing effect
            BoxShadow(
              color: const Color(0xFFe7bf57).withOpacity(0.2),
              blurRadius: 12,
              spreadRadius: 3,
              offset: const Offset(0, 3),
            ),
            BoxShadow(
              color: const Color(0xFFe7bf57).withOpacity(0.15),
              blurRadius: 18,
              spreadRadius: 6,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: const Color(0xFFe7bf57).withOpacity(0.08),
              blurRadius: 24,
              spreadRadius: 9,
              offset: const Offset(0, 9),
            ),
          ],
        ),
        child: Material(
          color: const Color(0xFFe7bf57),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: _floatingActionButtonPressed,
            borderRadius: BorderRadius.circular(36), // Half of width/height
            child: const Center(
              child: Icon(
                Icons.chat,
                color: Colors.white,
                size: 32, // Larger icon
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFfaf9f5),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              children: [
                // Left side tabs (2 tabs)
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildBottomAppBarItem(
                          icon: Icons.home,
                          label: 'Lounge',
                          isSelected: _selectedPage == HomePageNavigationType.lounge,
                          onTap: () {
                            setState(() {
                              _selectedPage = HomePageNavigationType.lounge;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: _buildBottomAppBarItem(
                          icon: Icons.book,
                          label: 'Diary',
                          isSelected: _selectedPage == HomePageNavigationType.smartDiary,
                          onTap: () {
                            setState(() {
                              _selectedPage = HomePageNavigationType.smartDiary;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Center space for floating action button
                const SizedBox(width: 100), // Increased space for larger button
                // Right side tabs (2 tabs)
                Expanded(
                  child: Row(
                    children: [
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
                          label: 'Profile',
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
              ],
            ),
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
        height: double.infinity,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? const Color(0xFFe7bf57) : Colors.grey.shade600,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? const Color(0xFFe7bf57) : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
