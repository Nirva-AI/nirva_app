import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyReflectionPage extends StatefulWidget {
  const DailyReflectionPage({super.key});

  @override
  State<DailyReflectionPage> createState() => _DailyReflectionPageState();
}

class _DailyReflectionPageState extends State<DailyReflectionPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfaf9f5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFfaf9f5),
        surfaceTintColor: const Color(0xFFfaf9f5),
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined, color: Color(0xFF0E3C26)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Daily Reflection',
          style: TextStyle(
            color: Color(0xFF0E3C26),
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Georgia',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            _buildHeaderSection(),
            const SizedBox(height: 24),
            
            // Personal Reflections section
            _buildPersonalReflectionsSection(),
            const SizedBox(height: 32),
            
            // Detailed Insights section
            _buildDetailedInsightsSection(),
            const SizedBox(height: 32),
            
            // Goals section
            _buildGoalsSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('EEEE, MMMM d').format(DateTime.now()),
          style: const TextStyle(
            fontSize: 20,
            color: Color(0xFF0E3C26),
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Today was a day of deep conversations with friends, self-reflection, and cultural experiences. My emotions fluctuated between relaxation, joy, reflection, slight anxiety, and nostalgia.',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF0E3C26),
            fontFamily: 'Georgia',
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalReflectionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personal Reflections',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E3C26),
            fontFamily: 'Georgia',
          ),
        ),
        const SizedBox(height: 20),
        
        _buildReflectionCard(
          'I am feeling grateful for:',
          [
            'Deep conversations with friends who listen and share wisdom',
            'Access to art and film that opens my eyes to different perspectives',
            'The privilege to contemplate my future on my own terms',
          ],
          'grateful',
        ),
        const SizedBox(height: 16),
        
        _buildReflectionCard(
          'I can celebrate:',
          [
            'Making time for meaningful connections despite a busy schedule',
            'Being open to different cultural experiences and perspectives',
            'Taking steps to consider my future options thoughtfully',
          ],
          'celebrate',
        ),
        const SizedBox(height: 16),
        
        _buildReflectionCard(
          'I can do better at:',
          [
            'Finding better balance between solitude and social connection',
            'Being more productive with my free time instead of oversleeping',
            'Managing feelings of envy about others\' lives more constructively',
          ],
          'better',
        ),
      ],
    );
  }

  Widget _buildReflectionCard(String title, List<String> items, String key) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0E3C26),
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 12),
                ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 8, right: 12),
                        decoration: const BoxDecoration(
                          color: Color(0xFF0E3C26),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF0E3C26),
                            fontFamily: 'Georgia',
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedInsightsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detailed Insights',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E3C26),
            fontFamily: 'Georgia',
          ),
        ),
        const SizedBox(height: 20),
        
        _buildInsightCard(
          'Relationships',
          [
            'Deep conversations with friends provide invaluable emotional support and perspective.',
            'I value authentic connections but feel frustrated by unpredictable dating experiences.',
            'Being \'ghosted\' after meaningful connections is a recurring pattern that causes confusion.',
          ],
          'relationships',
        ),
        const SizedBox(height: 16),
        
        _buildInsightCard(
          'Self-Discovery',
          [
            'I\'m contemplating the balance between solitude and social connection in my life.',
            'When I have excess free time, I tend toward unproductive behaviors like oversleeping.',
            'I feel both curious about and envious of others\' stable family lives.',
          ],
          'self_discovery',
        ),
        const SizedBox(height: 16),
        
        _buildInsightCard(
          'Future Planning',
          [
            'I\'m considering egg freezing and planning to make decisions about children by age 40.',
            'Financial considerations and family support are important factors in my fertility decisions.',
            'I\'m open to alternative pathways to parenthood beyond traditional routes.',
          ],
          'future_planning',
        ),
        const SizedBox(height: 16),
        
        _buildInsightCard(
          'Cultural Perspectives',
          [
            'Art and film provide windows into different cultural and historical experiences.',
            'My family background gives me a unique perspective on political events like Tiananmen Square.',
            'I\'m exploring philosophical concepts from different cultures like Tibetan Buddhist compassion.',
          ],
          'cultural',
        ),
      ],
    );
  }

  Widget _buildInsightCard(String title, List<String> items, String key) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0E3C26),
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(height: 12),
                ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 8, right: 12),
                        decoration: const BoxDecoration(
                          color: Color(0xFF0E3C26),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF0E3C26),
                            fontFamily: 'Georgia',
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'I can consider pursuing the following goals:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E3C26),
            fontFamily: 'Georgia',
          ),
        ),
        const SizedBox(height: 20),
        
        _buildGoalCard(
          'Deepen meaningful relationships',
          [
            'Schedule monthly deep conversations with close friends',
            'Join a community group aligned with my interests',
            'Practice active listening techniques',
          ],
        ),
        const SizedBox(height: 16),
        
        _buildGoalCard(
          'Explore fertility options',
          [
            'Research egg freezing clinics and costs',
            'Schedule consultation with fertility specialist',
            'Create financial plan for family planning options',
          ],
        ),
        const SizedBox(height: 16),
        
        _buildGoalCard(
          'Expand cultural understanding',
          [
            'Watch one international film per week',
            'Read books from diverse cultural perspectives',
            'Attend cultural events in my community',
          ],
        ),
      ],
    );
  }

  Widget _buildGoalCard(String title, List<String> todos) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0E3C26),
                fontFamily: 'Georgia',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'To-Do',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0E3C26),
                fontFamily: 'Georgia',
              ),
            ),
            const SizedBox(height: 8),
            ...todos.map((todo) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 8, right: 12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF0E3C26),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      todo,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF0E3C26),
                        fontFamily: 'Georgia',
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
} 