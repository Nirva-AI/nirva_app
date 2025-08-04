import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/providers/journal_files_provider.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/social_map_page.dart';
import 'package:nirva_app/social_connections_details_page.dart';
import 'package:nirva_app/social_map_visualization.dart';
import 'dart:math';

class SocialMapTrendCard extends StatefulWidget {
  const SocialMapTrendCard({super.key});

  @override
  State<SocialMapTrendCard> createState() => _SocialMapTrendCardState();
}

class _SocialMapTrendCardState extends State<SocialMapTrendCard> {
  String _selectedPeriod = 'Day';
  String? _selectedPerson;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFf0ebd8),
            Color(0xFFece6d2),
            Color(0xFFe8e2cc),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chart Container with Period Switcher
          Container(
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
                          selectedPeriod: _selectedPeriod,
                          selectedPerson: _selectedPerson,
                          onPersonSelected: (person) {
                            setState(() {
                              _selectedPerson = person;
                            });
                          },
                          height: 200,
                        ),
                      ),
                      // Person Insight Card (shown when a person is selected)
                      if (_selectedPerson != null) ...[
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
          ),
          const SizedBox(height: 24),
          
          // Description
          _buildDescription(),
        ],
      ),
    );
  }







  Widget _buildPeriodSwitcher() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: ['Day', 'Week', 'Month'].map((period) {
          final isSelected = period == _selectedPeriod;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedPeriod = period;
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

  Widget _buildDescription() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Social Connections',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0E3C26),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Track your relationships and social interactions over time. Click on a person to see detailed insights about your connection.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Detail button
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SocialConnectionsDetailsPage(),
              ),
            );
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_outward_outlined,
              color: Color(0xFF0E3C26),
              size: 16,
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
        final entity = socialMap[_selectedPerson!];
        
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
                        _selectedPerson = null;
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
                  _buildInsightItem(
                    'Time Spent',
                    '${entity.hours.toStringAsFixed(1)}h',
                    Icons.access_time,
                  ),
                  const SizedBox(width: 12),
                  _buildInsightItem(
                    'Impact',
                    entity.impact,
                    Icons.trending_up,
                  ),
                ],
              ),

              // Add specific insights for Trent and Ashley
              if (_selectedPerson?.toLowerCase() == 'trent' || _selectedPerson?.toLowerCase() == 'ashley') ...[
                const SizedBox(height: 12),
                _buildSpecificInsights(),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildInsightItem(String label, String value, IconData icon) {
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
    if (_selectedPerson?.toLowerCase() == 'trent') {
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
    } else if (_selectedPerson?.toLowerCase() == 'ashley') {
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
          _buildInsightBullet('Deep, supportive conversation. Vulnerability was met with understanding.'),
          _buildInsightBullet('Shared activities (park relaxation, tarot) felt healing and calming.'),
          _buildInsightBullet('Provided a safe space for reflection.'),
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
          _buildInsightBullet('Ensure you\'re actively listening and offering support for her challenges (job search, etc.) as she does for you.'),
          _buildInsightBullet('Act on plans discussed, like the library meet-up, to build reliability.'),
          _buildInsightBullet('Continue exploring shared interests beyond processing difficulties, like the arts or potential future activities.'),
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
} 