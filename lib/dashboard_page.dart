import 'package:flutter/material.dart';
import 'package:nirva_app/data_manager.dart';
import 'package:nirva_app/stress_level_card.dart';
import 'package:nirva_app/energy_level_card.dart';
import 'package:nirva_app/mood_tracking_card.dart';
import 'package:nirva_app/social_map_view.dart';
import 'package:nirva_app/awake_time_allocation_card.dart';
import 'package:nirva_app/today_highlights_panel.dart';
import 'package:nirva_app/mood_score_card.dart';
//import 'package:nirva_app/mood_details_page.dart';

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
              _buildMoodScoreCardAndStressLevelCard(),
              const SizedBox(height: 16),
              _buildEnergyLevelCard(),
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

  Widget _buildMoodScoreCardAndStressLevelCard() {
    final currentDiary = DataManager().currentJournal;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        MoodScoreCard(data: currentDiary.moodScore),
        StressLevelCard(data: currentDiary.stressLevel),
      ],
    );
  }

  Widget _buildEnergyLevelCard() {
    return const EnergyLevelCard();
  }

  Widget _buildMoodTracking() {
    return const MoodTrackingCard();
  }

  Widget _buildAwakeTimeAllocation() {
    return const AwakeTimeAllocationCard();
  }

  Widget _buildSocialMap() {
    return const SocialMapView();
  }

  Widget _buildHighlights() {
    final highlights = DataManager().currentJournal.highlights;
    return TodayHighlightsPanel(highlights: highlights);
  }
}
