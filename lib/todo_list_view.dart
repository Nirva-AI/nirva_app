import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/providers/tasks_provider.dart';
import 'package:nirva_app/hive_helper.dart';

class TodoListView extends StatelessWidget {
  const TodoListView({super.key});

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
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () async {
                        Navigator.of(context).pop();
                        final tasksProvider = Provider.of<TasksProvider>(
                          context,
                          listen: false,
                        );
                        await HiveHelper.saveTasks(tasksProvider.tasks);
                      },
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: Consumer<TasksProvider>(
                  builder: (context, tasksProvider, child) {
                    return ListView(
                      padding: const EdgeInsets.all(16.0),
                      children:
                          tasksProvider.groupedTasks.entries.map((entry) {
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
                                    onTap: () async {
                                      tasksProvider.switchTaskStatus(task);
                                      await HiveHelper.saveTasks(
                                        tasksProvider.tasks,
                                      );
                                      debugPrint(
                                        'Task tapped: ${task.description}',
                                      );
                                    },
                                    child: ListTile(
                                      title: Text(
                                        task.description,
                                        style: TextStyle(
                                          color:
                                              task.isCompleted
                                                  ? Colors.green
                                                  : Colors.red,
                                          fontSize: 14,
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
