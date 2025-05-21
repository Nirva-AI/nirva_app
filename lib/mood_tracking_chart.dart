import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nirva_app/data_manager.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/mood_tracking_details_page.dart'; // 导入新页面

class MoodTrackingChart extends StatelessWidget {
  const MoodTrackingChart({super.key});

  // 因为情绪是线性能规划的，负面～正面，所以就用一个数值来在几个色块里挑选。
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
    //final moodTracker = DataManager().activePersonal.moodMap;

    final Map<String, Color> moodColors = {
      for (var mood in DataManager().currentJournal.moods)
        mood.name: _getMoodColor(mood.moodValue),
    };

    final sections =
        DataManager().currentJournal.moodMap.entries.map((entry) {
          return PieChartSectionData(
            value: entry.value.toDouble(),
            color: moodColors[entry.key] ?? Colors.grey,
            radius: 25, // 缩小扇形半径
            badgeWidget: _buildBadge(
              entry.key,
              entry.value,
              moodColors[entry.key]!,
            ),
            badgePositionPercentageOffset: 2.0, // 调整文字位置稍远离饼图
          );
        }).toList();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
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
                      centerSpaceRadius: 50, // 增大中心空白半径，缩小饼图面积
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MoodTrackingDetailsPage(),
                    ),
                  );
                },
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
