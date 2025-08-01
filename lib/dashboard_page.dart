import 'package:flutter/material.dart';
import 'package:nirva_app/awake_time_allocation_card.dart';
import 'package:nirva_app/mood_tracking_card.dart';
import 'package:nirva_app/social_map_card.dart';
import 'package:nirva_app/dashboard_score_component.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfaf9f5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              const Text(
                'Insights',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0E3C26),
                ),
              ),
              const SizedBox(height: 32),
              
              // New score components at the top
              const DashboardScoresRow(),
              const SizedBox(height: 550),
              
              // Dashboard content
              _buildMoodTrackingCard(),
              const SizedBox(height: 24),
              _buildAwakeTimeAllocationCard(),
              const SizedBox(height: 24),
              _buildSocialMapCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoodTrackingCard() {
    return const MoodTrackingCard();
  }

  Widget _buildAwakeTimeAllocationCard() {
    return const AwakeTimeAllocationCard();
  }

  Widget _buildSocialMapCard() {
    return const SocialMapCard();
  }
}
