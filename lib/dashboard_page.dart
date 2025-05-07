import 'package:flutter/material.dart';
import 'package:nirva_app/data_manager.dart';
import 'package:nirva_app/score_card.dart';
import 'package:nirva_app/energy_level_chart.dart';
import 'package:nirva_app/mood_tracking.dart';
import 'package:nirva_app/social_map.dart';
import 'package:nirva_app/awake_time_allocation_chart.dart';
import 'package:nirva_app/today_high_lights.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildScoreCards(),
              const SizedBox(height: 16),
              _buildEnergyLevelChart(),
              const SizedBox(height: 16),
              _buildMoodTracking(),
              const SizedBox(height: 16),
              _buildAwakeTimeAllocation(),
              const SizedBox(height: 16),
              _buildSocialMap(),
              const SizedBox(height: 16),
              _buildHighlights(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCards() {
    final currentDiary = DataManager().currentJournalEntry;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ScoreCard(data: currentDiary.moodScore),
        ScoreCard(data: currentDiary.stressLevel),
      ],
    );
  }

  Widget _buildEnergyLevelChart() {
    return const EnergyLevelChart();
  }

  Widget _buildMoodTracking() {
    return const MoodTracking();
  }

  Widget _buildAwakeTimeAllocation() {
    return const AwakeTimeAllocationChart();
  }

  Widget _buildSocialMap() {
    return const SocialMap();
  }

  Widget _buildHighlights() {
    final highlights = DataManager().currentJournalEntry.highlights;
    return TodayHighlights(highlights: highlights);
  }
}
