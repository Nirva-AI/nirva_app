import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/providers/journal_files_provider.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/energy_level_details_page.dart';
import 'package:nirva_app/mood_score_details_page.dart';
import 'package:nirva_app/stress_level_details_page.dart';

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
                builder: (context) => const EnergyLevelDetailsPage(),
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
                builder: (context) => const StressLevelDetailsPage(),
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
    final moodScore = journalFilesProvider.currentJournalFile.moodScoreAverage;
    final energyLevel = journalFilesProvider.currentJournalFile.energyLevelAverage;
    final stressLevel = journalFilesProvider.currentJournalFile.stressLevelAverage;

    // Calculate scores based on requirements:
    // Energy and mood use current data * 10
    // Stress use (10 - current stress data) * 10
    final energyScore = 41.0; // Hardcoded for now
    final moodScoreCalculated = 91.0; // Hardcoded for now
    final stressScore = ((10.0 - stressLevel) * 10.0).clamp(0.0, 100.0);

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