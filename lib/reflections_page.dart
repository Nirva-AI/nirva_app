import 'package:flutter/material.dart';
import 'package:nirva_app/app_runtime_context.dart';
import 'package:nirva_app/utils.dart';

class ReflectionSummary extends StatelessWidget {
  const ReflectionSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final fullDateTime = Utils.fullDiaryDateTime(
      AppRuntimeContext().data.selectedDateTime,
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

class GoalCard extends StatelessWidget {
  final String title;
  final String content;

  const GoalCard({super.key, required this.title, required this.content});

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // 两端对齐
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.checklist, color: Colors.purple),
                  onPressed: () {
                    _showTopOverlay(context, title, content);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                const SizedBox(width: 8),
                Expanded(child: Text(content)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 封装的 _showTopOverlay 函数
  void _showTopOverlay(BuildContext context, String title, String content) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: kToolbarHeight, // 设置为 AppBar 的高度
            left: 16, // 添加左右边距
            right: 16,
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0), // 设置圆角
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.1 * 255).toInt()),
                      blurRadius: 8.0,
                      offset: const Offset(0, 4), // 阴影偏移
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Added to todo list',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '"$title" and $content tasks have been added to your todo list.',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );

    // 显示 Overlay
    overlay.insert(overlayEntry);

    // 自动移除 Overlay
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
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
        _buildGoalCard(
          'Do Differently Tomorrow',
          dailyReflection.looking_forward.do_differently_tomorrow,
        ),
        _buildGoalCard(
          'Continue What Worked',
          dailyReflection.looking_forward.continue_what_worked,
        ),
        _buildGoalCard(
          "Top 3 Priorities Tomorrow",
          dailyReflection.looking_forward.top_3_priorities_tomorrow.join(', '),
        ),
      ],
    );
  }

  Widget _buildGoalCard(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GoalCard(title: title, content: content),
    );
  }
}
