import 'package:flutter/material.dart';
import 'package:nirva_app/app_runtime_context.dart';
import 'package:nirva_app/utils.dart';

class LookingForwardTag {
  static const String doDifferentlyTomorrow = 'Do Differently Tomorrow';
  static const String continueWhatWorked = 'Continue What Worked';
  static const String top3PrioritiesTomorrow = 'Top 3 Priorities Tomorrow';
}

class ReflectionSummary extends StatelessWidget {
  const ReflectionSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final fullDateTime = Utils.fullDiaryDateTime(
      AppRuntimeContext().selectedDateTime,
    );
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.yellow[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '''$fullDateTime Reflections''',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            AppRuntimeContext()
                .currentJournalFile
                .daily_reflection
                .reflection_summary,
          ),
        ],
      ),
    );
  }
}

class ReflectionCard extends StatefulWidget {
  final String title;
  final String content;

  const ReflectionCard({super.key, required this.title, required this.content});

  @override
  State<ReflectionCard> createState() => _ReflectionCardState();
}

class _ReflectionCardState extends State<ReflectionCard> {
  bool _isExpanded = true; // 控制卡片是否展开

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            if (_isExpanded) ...[
              const SizedBox(height: 16),
              Text(
                widget.content,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded; // 切换展开/收起状态
                  });
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  backgroundColor: Colors.grey.shade200,
                ),
                child: Text(
                  _isExpanded ? 'Less' : 'Read More',
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoalCard extends StatefulWidget {
  final String title;
  final List<String> contents;

  const GoalCard({super.key, required this.title, required this.contents});

  @override
  State<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  // 添加一个全局的 key 用于获取 overlay
  //final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  String get parsedContent {
    if (widget.contents.isEmpty) {
      return '';
    }

    if (widget.contents.length == 1) {
      return widget.contents.first;
    }

    return widget.contents.map((content) => "- $content").join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.checklist, color: Colors.purple),
                  onPressed: _handleAddTask,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 8),
                Expanded(child: Text(parsedContent)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleAddTask() {
    _addTaskToTodoList().then((_) {
      if (mounted) {
        // 使用 SnackBar 替代自定义 overlay
        _showAddedNotification();
      }
    });
  }

  Future<void> _addTaskToTodoList() async {
    // 原有实现保持不变
    debugPrint('Task added: ${widget.title}');
    bool hasChanged = false;
    for (var content in widget.contents) {
      if (AppRuntimeContext().data.hasTask(widget.title, content)) {
        // 如果任务已存在，则不添加
        continue;
      }
      AppRuntimeContext().data.addTask(widget.title, content);
      hasChanged = true;
    }

    if (hasChanged) {
      await AppRuntimeContext().storage.saveTasks(
        AppRuntimeContext().data.tasks.value,
      );
    }
  }

  // 替换原有的 _showTopOverlay 方法
  void _showAddedNotification() {
    final snackBar = SnackBar(
      content: Text('"${widget.title}" has been added to your todo list.'),
      backgroundColor: Colors.grey.shade800,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      duration: const Duration(seconds: 2),
    );

    // 使用当前的 context，这是安全的，因为我们已经检查了 mounted
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class ReflectionsPage extends StatelessWidget {
  const ReflectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ReflectionSummary(),
            const SizedBox(height: 16),
            _buildReflectionCards(),
            const SizedBox(height: 16),
            _buildGoalCards(),
          ],
        ),
      ),
    );
  }

  Widget _buildReflectionCards() {
    final dailyReflection =
        AppRuntimeContext().currentJournalFile.daily_reflection;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildReflectionCard('Gratitude', dailyReflection.gratitude.toString()),
        _buildReflectionCard(
          'Challenges and Growth',
          dailyReflection.challenges_and_growth.toString(),
        ),
        _buildReflectionCard(
          'Learning and Insights',
          dailyReflection.learning_and_insights.toString(),
        ),
        _buildReflectionCard(
          'Connections and Relationships',
          dailyReflection.connections_and_relationships.toString(),
        ),
      ],
    );
  }

  Widget _buildReflectionCard(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: ReflectionCard(title: title, content: content),
    );
  }

  Widget _buildGoalCards() {
    final dailyReflection =
        AppRuntimeContext().currentJournalFile.daily_reflection;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Looking Forward',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        _buildGoalCard(LookingForwardTag.doDifferentlyTomorrow, [
          dailyReflection.looking_forward.do_differently_tomorrow,
        ]),
        _buildGoalCard(LookingForwardTag.continueWhatWorked, [
          dailyReflection.looking_forward.continue_what_worked,
        ]),
        _buildGoalCard(
          LookingForwardTag.top3PrioritiesTomorrow,
          dailyReflection.looking_forward.top_3_priorities_tomorrow,
        ),
      ],
    );
  }

  Widget _buildGoalCard(String title, List<String> contents) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GoalCard(title: title, contents: contents),
    );
  }
}
