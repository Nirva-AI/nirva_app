import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nirva_app/app_runtime_context.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/mood_tracking_details_page.dart'; // 导入新页面

// mood_labels: List[str] = Field(
//       description="Identify 1 to 3 mood labels that best describe user_name's personal mood during this event, based on their speech and reactions. Choose from: peaceful, energized, engaged, disengaged, happy, sad, anxious, stressed, relaxed, excited, bored, frustrated, content, neutral. The first label should be the most dominant mood for user_name. If only one strong mood is evident for user_name, use only that one label. If user_name's mood is unclear or mixed without a dominant feeling, use 'neutral'. These labels should reflect user_name's state, not the general atmosphere or the mood of other people involved, unless it clearly dictates user_name's mood."
//   )

class MoodTrackingCard extends StatelessWidget {
  const MoodTrackingCard({super.key});

  @override
  Widget build(BuildContext context) {
    final sections =
        AppRuntimeContext().currentJournalFile.moodTracking.map((entry) {
          return PieChartSectionData(
            value: entry.percentage.toDouble(),
            color: Color(entry.color),
            radius: 30, // 保持合适的扇形半径
            title: '', // 移除内部标题
            badgeWidget: _buildBadge(
              entry.name,
              entry.percentage,
              //moodColors[entry.key.name]!,
              Color(entry.color), // 使用颜色值
            ),
            badgePositionPercentageOffset: 2.5, // 调整标签位置，远离圆环
            showTitle: false, // 不显示内部标题
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
            // 修改部分：将标题和按钮放在同一行
            Row(
              children: [
                const Text('Mood Tracking', style: TextStyle(fontSize: 16)),
                const Spacer(), // 添加Spacer将按钮推到最右侧
                IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MoodTrackingDetailsPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 240, // 增加高度以容纳标签和图表
              child: Padding(
                padding: const EdgeInsets.all(20.0), // 添加内边距，给标签留出空间
                child: PieChart(
                  PieChartData(
                    sections: sections,
                    sectionsSpace: 2, // 扇形之间的间距
                    centerSpaceRadius: 40, // 增大中心空白半径
                    pieTouchData: PieTouchData(enabled: false), // 禁用触摸交互
                  ),
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
        color: color.withAlpha((0.2 * 255).toInt()),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        '$mood ${(percentage * 100).toInt()}%',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
