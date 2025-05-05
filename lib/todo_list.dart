import 'package:flutter/material.dart';
import 'data_manager.dart'; // 导入 TodoListData 数据

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取测试数据
    final todoListData = DataManager().currentTodoListData;
    todoListData.testAddTask(); // 添加测试数据

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
              // 动态生成任务列表
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children:
                      todoListData.categorizedTasks.entries.map((entry) {
                        final category = entry.key;
                        final tasks = entry.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 分类标题
                            Text(
                              category,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // 分类下的任务列表
                            ...tasks.map((task) {
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      task.isCompleted
                                          ? Colors.green
                                          : Colors.red,
                                  radius: 4,
                                ),
                                title: Text(
                                  task.description,
                                  style: TextStyle(
                                    fontSize: 13,
                                    decoration:
                                        task.isCompleted
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                  ),
                                ),
                              );
                            }),
                            const SizedBox(height: 16),
                          ],
                        );
                      }).toList(),
                ),
              ),
              const Divider(),
              // 添加新任务按钮
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
