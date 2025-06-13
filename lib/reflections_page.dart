import 'package:flutter/material.dart';
import 'package:nirva_app/app_runtime_context.dart';
import 'package:nirva_app/utils.dart';
import 'package:nirva_app/data.dart';

class LookingForwardTag {
  static const String doDifferentlyTomorrow = 'Do Differently Tomorrow';
  static const String continueWhatWorked = 'Continue What Worked';
  static const String top3PrioritiesTomorrow = 'Top 3 Priorities Tomorrow';
}

class ReflectionSummary extends StatelessWidget {
  const ReflectionSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final fullDateTime = Utils.fullFormatEventDateTime(
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              widget.content,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
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
        _buildReflectionCard(
          'Gratitude',
          _parseGratitudeContent(dailyReflection.gratitude),
        ),
        _buildReflectionCard(
          'Challenges and Growth',
          _parseChallengesContent(dailyReflection.challenges_and_growth),
        ),
        _buildReflectionCard(
          'Learning and Insights',
          _parseLearningContent(dailyReflection.learning_and_insights),
        ),
        _buildReflectionCard(
          'Connections and Relationships',
          _parseConnectionsContent(
            dailyReflection.connections_and_relationships,
          ),
        ),
      ],
    );
  }

  String _parseGratitudeContent(Gratitude gratitude) {
    if (gratitude.toString().isEmpty) {
      return 'N/A';
    }

    final StringBuffer buffer = StringBuffer();

    // Gratitude summary
    if (gratitude.gratitude_summary.isNotEmpty) {
      buffer.writeln('📝 Things I\'m grateful for:');
      for (var item in gratitude.gratitude_summary) {
        buffer.writeln('• $item');
      }
      buffer.writeln();
    }

    // Gratitude details
    if (gratitude.gratitude_details.isNotEmpty) {
      buffer.writeln('💭 Gratitude details:');
      buffer.writeln(gratitude.gratitude_details);
      buffer.writeln();
    }

    // Win summary
    if (gratitude.win_summary.isNotEmpty) {
      buffer.writeln('🏆 Today\'s wins:');
      for (var item in gratitude.win_summary) {
        buffer.writeln('• $item');
      }
      buffer.writeln();
    }

    // Win details
    if (gratitude.win_details.isNotEmpty) {
      buffer.writeln('✨ Win details:');
      buffer.writeln(gratitude.win_details);
      buffer.writeln();
    }

    // Feel alive moments
    if (gratitude.feel_alive_moments.isNotEmpty) {
      buffer.writeln('⚡ Moments I felt alive:');
      buffer.writeln(gratitude.feel_alive_moments);
    }

    return buffer.toString().trim();
  }

  String _parseChallengesContent(ChallengesAndGrowth challenges) {
    if (challenges.toString().isEmpty) {
      return 'N/A';
    }

    final StringBuffer buffer = StringBuffer();

    // Growth summary
    if (challenges.growth_summary.isNotEmpty) {
      buffer.writeln('🌱 Areas of growth:');
      for (var item in challenges.growth_summary) {
        buffer.writeln('• $item');
      }
      buffer.writeln();
    }

    // Obstacles faced
    if (challenges.obstacles_faced.isNotEmpty) {
      buffer.writeln('🧗 Obstacles faced:');
      buffer.writeln(challenges.obstacles_faced);
      buffer.writeln();
    }

    // Unfinished intentions
    if (challenges.unfinished_intentions.isNotEmpty) {
      buffer.writeln('📝 Unfinished intentions:');
      buffer.writeln(challenges.unfinished_intentions);
      buffer.writeln();
    }

    // Contributing factors
    if (challenges.contributing_factors.isNotEmpty) {
      buffer.writeln('🔍 Contributing factors:');
      buffer.writeln(challenges.contributing_factors);
    }

    return buffer.toString().trim();
  }

  String _parseLearningContent(LearningAndInsights learning) {
    if (learning.toString().isEmpty) {
      return 'N/A';
    }

    final StringBuffer buffer = StringBuffer();

    // New knowledge
    if (learning.new_knowledge.isNotEmpty) {
      buffer.writeln('💡 New knowledge:');
      buffer.writeln(learning.new_knowledge);
      buffer.writeln();
    }

    // Self discovery
    if (learning.self_discovery.isNotEmpty) {
      buffer.writeln('🔮 Self discovery:');
      buffer.writeln(learning.self_discovery);
      buffer.writeln();
    }

    // Insights about others
    if (learning.insights_about_others.isNotEmpty) {
      buffer.writeln('👥 Insights about others:');
      buffer.writeln(learning.insights_about_others);
      buffer.writeln();
    }

    // Broader lessons
    if (learning.broader_lessons.isNotEmpty) {
      buffer.writeln('🌍 Broader lessons:');
      buffer.writeln(learning.broader_lessons);
    }

    return buffer.toString().trim();
  }

  String _parseConnectionsContent(ConnectionsAndRelationships connections) {
    if (connections.toString().isEmpty) {
      return 'N/A';
    }

    final StringBuffer buffer = StringBuffer();

    // Meaningful interactions
    if (connections.meaningful_interactions.isNotEmpty) {
      buffer.writeln('🤝 Meaningful interactions:');
      buffer.writeln(connections.meaningful_interactions);
      buffer.writeln();
    }

    // Notable about people
    if (connections.notable_about_people.isNotEmpty) {
      buffer.writeln('✨ Notable observations:');
      buffer.writeln(connections.notable_about_people);
      buffer.writeln();
    }

    // Follow up needed
    if (connections.follow_up_needed.isNotEmpty) {
      buffer.writeln('📅 Follow-up needed:');
      buffer.writeln(connections.follow_up_needed);
    }

    return buffer.toString().trim();
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
