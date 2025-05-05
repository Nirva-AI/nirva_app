import 'package:flutter/material.dart';
import 'package:nirva_app/smart_diary_page.dart';
import 'package:nirva_app/reflections_page.dart';
import 'package:nirva_app/dashboard_page.dart';
import 'package:nirva_app/todo_list.dart';
import 'package:nirva_app/robot_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPage = 0;

  void _floatingActionButtonPressed() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const RobotDialog();
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
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: const TodoList(),
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
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.checklist),
            onPressed: () {
              debugPrint('to-do list');
              _showToDoList(context);
            },
          ),
        ],
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
