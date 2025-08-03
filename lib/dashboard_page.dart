import 'package:flutter/material.dart';
import 'package:nirva_app/social_map_card.dart';
import 'package:nirva_app/dashboard_score_component.dart';
import 'package:nirva_app/trends_card.dart';
import 'package:nirva_app/mood_trend_card.dart';
import 'package:nirva_app/energy_trend_card.dart';
import 'package:nirva_app/awake_time_allocation_trend_card.dart';

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
              const SizedBox(height: 24),
              
              // Trends section
              const Text(
                'Trends',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0E3C26),
                ),
              ),
              const SizedBox(height: 20),
              const TrendsCard(),
              const SizedBox(height: 24),
              const MoodTrendCard(),
              const SizedBox(height: 24),
              const EnergyTrendCard(),
              const SizedBox(height: 24),
              const AwakeTimeAllocationTrendCard(),
              const SizedBox(height: 24),
              
              // Dashboard content
              _buildSocialMapCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialMapCard() {
    return const SocialMapCard();
  }
}
