import 'package:flutter/material.dart';
import 'package:nirva_app/date_and_summary.dart';
import 'package:nirva_app/reflection_card.dart';
import 'package:nirva_app/data_manager.dart';

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
    final personalReflections = DataManager().currentDiary.personalReflections;

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
    final detailedInsights = DataManager().currentDiary.detailedInsights;

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
    final goals = DataManager().currentDiary.goals;

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
            child: ReflectionCard(data: goal),
          ),
        ),
      ],
    );
  }
}
