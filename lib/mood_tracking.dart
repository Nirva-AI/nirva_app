import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MoodData {
  final String mood;
  final double moodValue;
  final double moodPercentage;
  MoodData(this.mood, this.moodValue, this.moodPercentage);
}

class MoodMapData {
  final List<MoodData> moods;
  MoodMapData(this.moods);

  Map<String, double> get data {
    final Map<String, double> moodMap = {};
    for (var mood in moods) {
      moodMap[mood.mood] = mood.moodPercentage;
    }
    return moodMap;
  }
}

MoodMapData moodMapData = MoodMapData([
  MoodData('Happy', 0.5, 50),
  MoodData('Calm', 0.3, 30),
  MoodData('Stressed', -0.9, 10),
  MoodData('Focused', -0.5, 10),
]);

class MoodTracking extends StatelessWidget {
  const MoodTracking({super.key});

  Color _getMoodColor(double moodValue) {
    if (moodValue <= -0.8) {
      return Colors.red;
    } else if (moodValue <= -0.4) {
      return Colors.orange;
    } else if (moodValue <= 0.0) {
      return Colors.yellow;
    } else if (moodValue <= 0.4) {
      return Colors.green;
    } else {
      return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Color> moodColors = {
      for (var mood in moodMapData.moods)
        mood.mood: _getMoodColor(mood.moodValue),
    };

    final sections =
        moodMapData.data.entries.map((entry) {
          return PieChartSectionData(
            value: entry.value.toDouble(),
            color: moodColors[entry.key] ?? Colors.grey,
            radius: 60, // 控制扇形半径
            badgeWidget: _buildBadge(
              entry.key,
              entry.value,
              moodColors[entry.key]!,
            ),
            badgePositionPercentageOffset: 1.2, // 控制文字位置在外围
          );
        }).toList();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Mood Tracking', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  sectionsSpace: 2, // 扇形之间的间距
                  centerSpaceRadius: 40, // 中心空白半径
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String mood, double percentage, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(
          (0.2 * 255).toInt(),
        ), // 使用 withAlpha 替代 withOpacity
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        '$mood ${percentage.toInt()}%',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
