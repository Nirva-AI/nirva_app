import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/providers/journal_files_provider.dart';
import 'package:nirva_app/providers/user_provider.dart';
import 'package:nirva_app/social_map_visualization.dart';
import 'dart:math';

class SocialConnectionsDetailsPage extends StatefulWidget {
  const SocialConnectionsDetailsPage({super.key});

  @override
  State<SocialConnectionsDetailsPage> createState() => _SocialConnectionsDetailsPageState();
}

class _SocialConnectionsDetailsPageState extends State<SocialConnectionsDetailsPage> {
  String? selectedPerson;
  String selectedPeriod = 'Day';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Social Connections',
          style: TextStyle(
            color: Color(0xFF0E3C26),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      backgroundColor: const Color(0xFFfaf9f5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            _buildSummaryCards(),
            const SizedBox(height: 32),
            
            // Social Map Visualization
            _buildSocialMapSection(),
            const SizedBox(height: 32),
            
            // Social Interactions Table
            _buildSocialInteractionsTable(),
            const SizedBox(height: 32),
            
            // Relationship Details
            _buildRelationshipDetails(),
            const SizedBox(height: 32),
            
            // Connection Insights
            _buildConnectionInsights(),
            const SizedBox(height: 32),
            
            // Relationship Recommendations
            _buildRelationshipRecommendations(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    // Use the actual data from the provided content
    final totalHours = 33.8;
    final totalConnections = 7;
    final positiveConnections = 5; // Michael, Sarah, Trent, Raj, Ashley
    final averageImpact = (positiveConnections / totalConnections * 100).round();

    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Total Hours',
            '${totalHours.toStringAsFixed(1)}h',
            Icons.access_time,
            const Color(0xFFB8C4D4), // Blue from insights
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Connections',
            '$totalConnections',
            Icons.people,
            const Color(0xFFC8D4B8), // Green from insights
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Positive Impact',
            '$averageImpact%',
            Icons.trending_up,
            const Color(0xFFfdd78c), // Yellow from insights
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      height: 120, // Fixed height to ensure all cards are the same size
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0E3C26),
                ),
              ),
            ],
          ),
          const Spacer(), // Push title to bottom
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMapSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Background pattern with diagonal stripes for entire container
          Positioned.fill(
            child: CustomPaint(
              painter: DiagonalStripesPainter(),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Social Map Visualization
                SizedBox(
                  height: 200,
                  child: SocialMapVisualization(
                    selectedPeriod: selectedPeriod,
                    selectedPerson: selectedPerson,
                    onPersonSelected: (person) {
                      setState(() {
                        selectedPerson = person;
                      });
                    },
                    height: 200,
                  ),
                ),
                // Person Insight Card (shown when a person is selected)
                if (selectedPerson != null) ...[
                  const SizedBox(height: 16),
                  _buildPersonInsightCard(),
                ],
                const SizedBox(height: 16),
                // Legend
                _buildLegend(),
                const SizedBox(height: 16),
                // Time Period Switcher
                _buildPeriodSwitcher(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialInteractionsTable() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Social Interactions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0E3C26),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Total time spent with others: 33.8 hours',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 20),
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFfaf9f5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Name',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0E3C26),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Hours',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0E3C26),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Energy Impact',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0E3C26),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Table Rows
          _buildTableRow('Michael', '8.5', 'Positive'),
          _buildTableRow('Sarah', '6.8', 'Positive'),
          _buildTableRow('Trent', '5.5', 'Positive'),
          _buildTableRow('Emma', '4.2', 'Neutral'),
          _buildTableRow('Raj', '3.7', 'Positive'),
          _buildTableRow('Ashley', '3.0', 'Positive'),
          _buildTableRow('Jason', '2.1', 'Negative'),
        ],
      ),
    );
  }

  Widget _buildTableRow(String name, String hours, String impact) {
    Color impactColor;
    switch (impact.toLowerCase()) {
      case 'positive':
        impactColor = const Color(0xFFC8D4B8); // Green
        break;
      case 'neutral':
        impactColor = const Color(0xFFfdd78c); // Yellow
        break;
      case 'negative':
        impactColor = const Color(0xFFe74c3c); // Red
        break;
      default:
        impactColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0E3C26),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              hours,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0E3C26),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: impactColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  impact,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0E3C26),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelationshipDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Relationship Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E3C26),
          ),
        ),
        const SizedBox(height: 16),
        _buildRelationshipCard(
          'Michael',
          '8.5',
          'Long-time friend who brings perspective and shared history. Conversations are effortless and restorative.',
          [
            'Schedule Regular Check-ins: Make time for your monthly calls even when busy.',
            'Share Your Growth: Keep them updated on your personal development.',
            'Plan That Trip: Follow through on your discussed travel plans.',
          ],
          'Positive',
        ),
        _buildRelationshipCard(
          'Sarah',
          '6.8',
          'Creative collaborator who inspires new ideas. Time flies during conversations about art and projects.',
          [
            'Schedule Making Sessions: Set aside time for collaborative creation.',
            'Share Inspirations: Continue exchanging creative resources.',
            'Celebrate Wins: Acknowledge each other\'s creative successes.',
          ],
          'Positive',
        ),
        _buildRelationshipCard(
          'Trent',
          '5.5',
          'Highly engaging, intellectually stimulating conversations. Covered a wide range of topics (work, philosophy, film, society). Shared cultural experience (movie) fostered connection. Provided a space for debate and idea exploration. The minor negative point (cafe anxiety/disappointment) was situational.',
          [
            'Acknowledge Commitments: Address things like listening to the record he gave you to show you value his gestures and follow through.',
            'Appreciate His Perspective: Even when disagreeing (like on AI ethics), acknowledge and show respect for his viewpoint to maintain positive discourse.',
            'Continue Shared Exploration: Lean into shared interests like film, exploring challenging ideas, and trying new experiences (restaurants, neighborhoods). Ask about his work/life updates proactively.',
          ],
          'Positive',
        ),
        _buildRelationshipCard(
          'Emma',
          '4.2',
          'Coworker with shared professional interests. Relationship is primarily work-focused but pleasant.',
          [
            'Set Clear Boundaries: Maintain professional focus while being friendly.',
            'Acknowledge Expertise: Continue to recognize and appreciate their skills.',
            'Find Common Interests: Look for non-work topics to deepen connection.',
          ],
          'Neutral',
        ),
        _buildRelationshipCard(
          'Raj',
          '3.7',
          'Wise mentor who provides guidance and perspective on career and personal growth.',
          [
            'Come Prepared: Make the most of conversations with specific questions.',
            'Express Gratitude: Acknowledge the value they bring to your life.',
            'Pay It Forward: Share lessons learned with others who might benefit.',
          ],
          'Positive',
        ),
        _buildRelationshipCard(
          'Ashley',
          '3.0',
          'Deep, supportive conversation. Vulnerability was met with understanding. Shared activities (park relaxation, tarot) felt healing and calming. Provided a safe space for reflection.',
          [
            'Reciprocate Support: Ensure you\'re actively listening and offering support for her challenges (job search, etc.) as she does for you.',
            'Follow Through: Act on plans discussed, like the library meet-up, to build reliability.',
            'Shared Fun: Continue exploring shared interests beyond processing difficulties, like the arts or potential future activities.',
          ],
          'Positive',
        ),
        _buildRelationshipCard(
          'Jason',
          '2.1',
          'Interactions often feel draining due to negativity and complaining. Limited shared interests.',
          [
            'Limit Duration: Keep interactions brief and purposeful.',
            'Redirect Conversations: Steer toward more positive topics when possible.',
            'Consider Distance: It may be healthy to reduce frequency of interaction.',
          ],
          'Negative',
        ),
      ],
    );
  }

  Widget _buildRelationshipCard(String name, String hours, String description, List<String> tips, String impact) {
    // Determine impact color
    Color impactColor;
    switch (impact.toLowerCase()) {
      case 'positive':
        impactColor = const Color(0xFFC8D4B8); // Green
        break;
      case 'neutral':
        impactColor = const Color(0xFFfdd78c); // Yellow
        break;
      case 'negative':
        impactColor = const Color(0xFFe74c3c); // Red
        break;
      default:
        impactColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0E3C26),
                ),
              ),
              Row(
                children: [
                  Text(
                    '$hours hours',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: impactColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'RELATIONSHIP TIPS:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0E3C26),
            ),
          ),
          const SizedBox(height: 8),
          ...tips.map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '• ',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E3C26),
                  ),
                ),
                Expanded(
                  child: Text(
                    tip,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }



  Widget _buildConnectionInsights() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Connection Insights',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0E3C26),
            ),
          ),
          const SizedBox(height: 16),
          _buildInsightItem(
            'Your social interactions have increased by 15% compared to last week.',
          ),
          const SizedBox(height: 16),
          _buildInsightItem(
            'Quality conversations with close friends contribute most to your positive energy.',
          ),
          const SizedBox(height: 16),
          _buildInsightItem(
            'Consider reaching out to connections you haven\'t spoken to recently.',
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6, right: 12),
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Color(0xFF0E3C26),
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF0E3C26),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRelationshipRecommendations() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Relationship Recommendations',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0E3C26),
            ),
          ),
          const SizedBox(height: 16),
          _buildRecommendationItem(
            'Schedule regular catch-ups with your closest connections',
            Icons.schedule,
            const Color(0xFFB8C4D4), // Blue from insights
          ),
          const SizedBox(height: 12),
          _buildRecommendationItem(
            'Try new activities with friends to strengthen bonds',
            Icons.explore,
            const Color(0xFFC8D4B8), // Green from insights
          ),
          const SizedBox(height: 12),
          _buildRecommendationItem(
            'Practice active listening in your conversations',
            Icons.hearing,
            const Color(0xFFfdd78c), // Yellow from insights
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(String text, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF0E3C26),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonInsightCard() {
    return Consumer<JournalFilesProvider>(
      builder: (context, journalProvider, child) {
        final socialMap = journalProvider.buildSocialMap();
        final entity = socialMap[selectedPerson!];
        
        if (entity == null) return const SizedBox.shrink();
        
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF0E3C26).withOpacity(0.15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      entity.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0E3C26),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPerson = null;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Color(0xFF0E3C26),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildInsightMetric(
                    'Time Spent',
                    '${entity.hours.toStringAsFixed(1)}h',
                    Icons.access_time,
                  ),
                  const SizedBox(width: 12),
                  _buildInsightMetric(
                    'Impact',
                    entity.impact,
                    Icons.trending_up,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                entity.discription,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
              // Add specific insights for Trent and Ashley
              if (selectedPerson?.toLowerCase() == 'trent' || selectedPerson?.toLowerCase() == 'ashley') ...[
                const SizedBox(height: 12),
                _buildSpecificInsights(),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildInsightMetric(String label, String value, IconData icon) {
    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0E3C26),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecificInsights() {
    if (selectedPerson?.toLowerCase() == 'trent') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Past Interactions:',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          _buildInsightBullet('Highly engaging, intellectually stimulating conversations.'),
          _buildInsightBullet('Covered a wide range of topics (work, philosophy, film, society).'),
          _buildInsightBullet('Shared cultural experience (movie) fostered connection.'),
          _buildInsightBullet('Provided a space for debate and idea exploration.'),
          _buildInsightBullet('The minor negative point (cafe anxiety/disappointment) was situational.'),
          const SizedBox(height: 8),
          Text(
            'TIPS FOR IMPROVING RELATIONSHIP:',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0E3C26),
            ),
          ),
          const SizedBox(height: 4),
          _buildInsightBullet('Address things like listening to the record he gave you to show you value his gestures and follow through.'),
          _buildInsightBullet('Even when disagreeing (like on AI ethics), acknowledge and show respect for his viewpoint to maintain positive discourse.'),
          _buildInsightBullet('Lean into shared interests like film, exploring challenging ideas, and trying new experiences (restaurants, neighborhoods). Ask about his work/life updates proactively.'),
        ],
      );
    } else if (selectedPerson?.toLowerCase() == 'ashley') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Past Interactions:',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          _buildInsightBullet('Supportive and emotionally nurturing conversations.'),
          _buildInsightBullet('Shared personal experiences and provided mutual support.'),
          _buildInsightBullet('Created a safe space for vulnerability and emotional expression.'),
          const SizedBox(height: 8),
          Text(
            'TIPS FOR IMPROVING RELATIONSHIP:',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0E3C26),
            ),
          ),
          const SizedBox(height: 4),
          _buildInsightBullet('Continue to be open and vulnerable in your conversations.'),
          _buildInsightBullet('Share your own experiences and challenges to deepen the connection.'),
          _buildInsightBullet('Plan activities that allow for meaningful one-on-one time.'),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildInsightBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[700],
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Energizing legend item
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFC8D4B8), // Light green - energizing
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'Energizing',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),
        // Neutral legend item
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFfdd78c), // Golden yellow - neutral
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'Neutral',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),
        // Draining legend item
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFe74c3c), // Red - draining
              ),
            ),
            const SizedBox(width: 6),
            Text(
              'Draining',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPeriodSwitcher() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ['Day', 'Week', 'Month'].map((period) {
          final isSelected = period == selectedPeriod;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedPeriod = period;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFe7bf57) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                period,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFF0E3C26),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
} 