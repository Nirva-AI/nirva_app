import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/providers/journal_files_provider.dart';
import 'package:nirva_app/providers/mental_state_provider.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/energy_insights_page.dart';
import 'package:nirva_app/mood_score_details_page.dart';
import 'package:nirva_app/stress_insights_page.dart';

class PartialRingPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double score;

  PartialRingPainter({
    required this.color,
    required this.strokeWidth,
    required this.score,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    
    // Calculate sweep angle proportionally based on score (0-100)
    // Max sweep angle is 5.2 radians (when score = 100)
    // Min sweep angle is 0 radians (when score = 0)
    final maxSweepAngle = 5.2;
    final sweepAngle = (score / 100.0) * maxSweepAngle;
    
    // Draw thick arc with inner glow
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth * 3.0  // Make it even thicker
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.inner, 2);  // Inner glow effect
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      2.1, // Start angle
      sweepAngle,  // Dynamic sweep angle based on score
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DashboardScoreComponent extends StatelessWidget {
  final String label;
  final double score;
  final IconData icon;
  final Color color;

  const DashboardScoreComponent({
    super.key,
    required this.label,
    required this.score,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the appropriate detail page based on the label
        switch (label.toLowerCase()) {
          case 'energy':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EnergyInsightsPage(),
              ),
            );
            break;
          case 'mood':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MoodScoreDetailsPage(),
              ),
            );
            break;
          case 'stress':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const StressInsightsPage(),
              ),
            );
            break;
        }
      },
      child: Container(
        height: 80, // Increased height to ensure label visibility
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none, // Prevent clipping of positioned children
          children: [
            // Partial ring (rendered first, at the bottom)
            CustomPaint(
              size: const Size(80, 80),
              painter: PartialRingPainter(
                color: Colors.grey.shade600,
                strokeWidth: 1,
                score: score,
              ),
            ),
            // Score text (rendered after border, so it's above)
            Text(
              score.toStringAsFixed(0),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0E3C26),
              ),
            ),
            // Bottom icon (rendered after circle, so it's above)
            Positioned(
              bottom: -6,
              child: Icon(
                icon,
                color: Colors.grey.shade600,
                size: 26,
              ),
            ),
            // Label below the bottom icon (rendered last, so it's at the top)
            Positioned(
              bottom: -22,
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardScoresRow extends StatelessWidget {
  const DashboardScoresRow({super.key});

  @override
  Widget build(BuildContext context) {
    final journalFilesProvider = Provider.of<JournalFilesProvider>(context);
    final mentalStateProvider = Provider.of<MentalStateProvider>(context);
    
    // Get current mental state scores from the latest valid timeline data point
    // Skip any 0 values at the end (backend bug)
    final timeline = mentalStateProvider.timeline24h;
    double energyScore = 50.0;
    double stressScore = 30.0;
    
    // Find the last non-zero data point
    print('Dashboard - Checking timeline for non-zero values:');
    for (int i = timeline.length - 1; i >= 0 && i >= timeline.length - 10; i--) {
      print('  Point $i: energy=${timeline[i].energyScore}, stress=${timeline[i].stressScore}, time=${timeline[i].timestamp}');
      if (timeline[i].energyScore != 0.0 || timeline[i].stressScore != 0.0) {
        energyScore = timeline[i].energyScore;
        stressScore = timeline[i].stressScore;
        print('  --> Using this point!');
        break;
      }
    }
    
    // Debug logging
    print('Dashboard - timeline points: ${timeline.length}');
    if (timeline.isNotEmpty) {
      print('Dashboard - last point: ${timeline.last}');
    }
    print('Dashboard - energyScore: $energyScore, stressScore: $stressScore');
    
    // For mood, use journal average if available, otherwise default
    final moodScoreCalculated = journalFilesProvider.currentJournalFile.moodScoreAverage > 0 
        ? journalFilesProvider.currentJournalFile.moodScoreAverage 
        : 70.0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DashboardScoreComponent(
            label: 'Energy',
            score: energyScore,
            icon: Icons.energy_savings_leaf_outlined,
            color: Colors.orange,
          ),
          DashboardScoreComponent(
            label: 'Mood',
            score: moodScoreCalculated,
            icon: Icons.wb_sunny_outlined,
            color: Colors.blue,
          ),
          DashboardScoreComponent(
            label: 'Stress',
            score: stressScore,
            icon: Icons.spa_outlined,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
} 