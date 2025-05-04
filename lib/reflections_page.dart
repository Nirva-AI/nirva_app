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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🌟 Personal Reflections',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ReflectionCard(
          data: ReflectionData(
            title: 'I am feeling grateful for:',
            items: [
              'Deep conversations with friends who listen and share wisdom',
              'Access to art and film that opens my eyes to different perspectives',
              'The privilege to contemplate my future on my own terms',
            ],
          ),
        ),
        const SizedBox(height: 8),
        ReflectionCard(
          data: ReflectionData(
            title: 'I can celebrate:',
            items: [
              'Making time for meaningful connections despite a busy schedule',
              'Being open to different cultural experiences and perspectives',
              'Taking steps to consider my future options thoughtfully',
            ],
          ),
        ),
        const SizedBox(height: 8),
        ReflectionCard(
          data: ReflectionData(
            title: 'I can do better at:',
            items: [
              'Finding better balance between solitude and social connection',
              'Being more productive with my free time instead of oversleeping',
              'Managing feelings of envy about others\' lives more constructively',
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedInsights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '📖 Detailed Insights',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ReflectionCard(
          data: ReflectionData(
            title: 'Relationships',
            items: [
              'Deep conversations with friends provide invaluable emotional support and perspective.',
              'I value authentic connections but feel frustrated by unpredictable dating experiences.',
              'Being \'ghosted\' after meaningful connections is a recurring pattern that causes confusion.',
            ],
          ),
        ),
        const SizedBox(height: 8),
        ReflectionCard(
          data: ReflectionData(
            title: 'Self-Discovery',
            items: [
              'I\'m contemplating the balance between solitude and social connection in my life.',
              'When I have excess free time, I tend toward unproductive behaviors like oversleeping.',
              'I feel both curious about and envious of others\' stable family lives.',
            ],
          ),
        ),
        const SizedBox(height: 8),
        ReflectionCard(
          data: ReflectionData(
            title: 'Future Planning',
            items: [
              'I\'m considering egg freezing and planning to make decisions about children by age 40.',
              'Financial considerations and family support are important factors in my fertility decisions.',
              'I\'m open to alternative pathways to parenthood beyond traditional routes.',
            ],
          ),
        ),
        const SizedBox(height: 8),
        ReflectionCard(
          data: ReflectionData(
            title: '🌍 Cultural Perspectives',
            items: [
              'Art and film provide windows into different cultural and historical experiences.',
              'My family background gives me a unique perspective on political events like Tiananmen Square.',
              'I\'m exploring philosophical concepts from different cultures like Tibetan Buddhist compassion.',
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGoals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //const SizedBox(height: 16),
        const Text(
          '🎯 I can consider pursuing the following goals:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ReflectionCard(
          data: ReflectionData(
            title: 'Deepen meaningful relationships',
            items: [
              'Schedule monthly deep conversations with close friends',
              'Join a community group aligned with my interests',
              'Practice active listening techniques',
            ],
          ),
        ),
        const SizedBox(height: 8),
        ReflectionCard(
          data: ReflectionData(
            title: 'Explore fertility options',
            items: [
              'Research egg freezing clinics and costs',
              'Schedule consultation with fertility specialist',
              'Create financial plan for family planning options',
            ],
          ),
        ),
        const SizedBox(height: 8),
        ReflectionCard(
          data: ReflectionData(
            title: 'Expand cultural understanding',
            items: [
              'Watch one international film per week',
              'Read books from diverse cultural perspectives',
            ],
          ),
        ),
      ],
    );
  }
}
