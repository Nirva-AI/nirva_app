import 'package:flutter/material.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Material(
        color: Colors.transparent, // 背景透明
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6, // 宽度为屏幕的 60%
          height: MediaQuery.of(context).size.height * 0.6, // 高度为屏幕的 60%
          margin: EdgeInsets.only(
            top:
                kToolbarHeight +
                MediaQuery.of(context).padding.top, // 从 AppBar 下方开始
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
    );
  }
}
