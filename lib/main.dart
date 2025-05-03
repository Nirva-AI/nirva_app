import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
        return const Center(child: Text('Smart Diary Page'));
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
              fontSize: 12,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
