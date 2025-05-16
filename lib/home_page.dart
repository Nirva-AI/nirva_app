import 'package:flutter/material.dart';
import 'package:nirva_app/smart_diary_page.dart';
import 'package:nirva_app/reflections_page.dart';
import 'package:nirva_app/dashboard_page.dart';
import 'package:nirva_app/todo_list_view.dart';
import 'package:nirva_app/assistant_chat_panel.dart';
import 'package:nirva_app/chat_manager.dart';
import 'package:nirva_app/me_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPage = 0;

  final TextEditingController _textController = TextEditingController();

  void _floatingActionButtonPressed() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 保持内容可滚动
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9, // 设置 ModalBottomSheet 占屏幕高度的 90%
          child: AssistantChatPanel(
            chatMessages: ChatManager().getMessages(),
            textController: _textController,
            //onSend: (message) {},
          ),
        );
      },
    );
  }

  Widget _getBodyContent() {
    switch (_selectedPage) {
      case 0:
        return SmartDiaryPage();
      case 1:
        return const ReflectionsPage();
      case 2:
        return const DashboardPage();
      default:
        return const MePage();
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
        backgroundColor: Colors.purple,
        shape: const CircleBorder(),
        child: const Text(
          'N',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
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
                  isSelected: _selectedPage == 0,
                  onTap: () {
                    setState(() {
                      _selectedPage = 0;
                    });
                  },
                ),
              ),
              Expanded(
                child: _buildBottomAppBarItem(
                  icon: Icons.lightbulb,
                  label: 'Reflections',
                  isSelected: _selectedPage == 1,
                  onTap: () {
                    setState(() {
                      _selectedPage = 1;
                    });
                  },
                ),
              ),
              Expanded(
                child: _buildBottomAppBarItem(
                  icon: Icons.dashboard,
                  label: 'Dashboard',
                  isSelected: _selectedPage == 2,
                  onTap: () {
                    setState(() {
                      _selectedPage = 2;
                    });
                  },
                ),
              ),
              Expanded(
                child: _buildBottomAppBarItem(
                  icon: Icons.person,
                  label: 'Me',
                  isSelected: _selectedPage == 3,
                  onTap: () {
                    debugPrint('Me button tapped');
                    setState(() {
                      _selectedPage = 3;
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
