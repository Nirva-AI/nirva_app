import 'package:flutter/material.dart';
import 'data_manager.dart';

class TodoListView extends StatefulWidget {
  const TodoListView({super.key});

  @override
  State<TodoListView> createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.6,
          margin: EdgeInsets.only(
            top: kToolbarHeight + MediaQuery.of(context).padding.top,
          ),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children:
                      DataManager().groupedTasks.entries.map((entry) {
                        final category = entry.key;
                        final tasks = entry.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...tasks.map((task) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    DataManager().toggleTaskCompletion(task);
                                  });
                                  debugPrint(
                                    'Task tapped: ${task.description}',
                                  );
                                },
                                child: ListTile(
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
