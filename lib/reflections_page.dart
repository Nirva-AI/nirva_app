import 'package:flutter/material.dart';
import 'package:nirva_app/date_and_summary.dart';
import 'package:nirva_app/data_manager.dart';
import 'package:nirva_app/data.dart';

class ReflectionCard extends StatelessWidget {
  final Reflection data;

  const ReflectionCard({super.key, required this.data});

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
              data.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...data.items.map(
              (item) => Row(
                children: [
                  const Icon(Icons.circle, size: 8, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoalReflectionCard extends StatelessWidget {
  final Reflection data;

  const GoalReflectionCard({super.key, required this.data});

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
                    data.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.checklist, color: Colors.purple),
                  onPressed: () {
                    _showTopOverlay(context, data);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...data.items.map(
              (item) => Row(
                children: [
                  const Icon(Icons.circle, size: 8, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 封装的 _showTopOverlay 函数
  void _showTopOverlay(BuildContext context, Reflection data) {
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
                      '"${data.title}" and ${data.items.length} tasks have been added to your todo list.',
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
            const DateAndSummary(),
            const SizedBox(height: 16),
            _buildPersonalReflections(),
            const SizedBox(height: 16),
            _buildDetailedInsights(),
            const SizedBox(height: 16),
            _buildGoals(),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalReflections() {
    final personalReflections =
        DataManager().currentJournalEntry.selfReflections;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🌟 Personal Reflections',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...personalReflections.map(
          (reflection) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ReflectionCard(data: reflection),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedInsights() {
    final detailedInsights = DataManager().currentJournalEntry.detailedInsights;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📖 Detailed Insights',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...detailedInsights.map(
          (insight) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ReflectionCard(data: insight),
          ),
        ),
      ],
    );
  }

  Widget _buildGoals() {
    final goals = DataManager().currentJournalEntry.goals;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🎯 I can consider pursuing the following goals:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...goals.map(
          (goal) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: GoalReflectionCard(data: goal),
          ),
        ),
      ],
    );
  }
}
