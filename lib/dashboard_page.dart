import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // 用于绘制图表
import 'package:nirva_app/data_manager.dart'; // 假设你有一个数据模型文件
import 'package:nirva_app/score_card.dart'; // 假设你有一个 ScoreCard 组件

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
    final dashboardData = DataManager().dashboardData;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ScoreCard(data: dashboardData.moodScore),
        ScoreCard(data: dashboardData.stressLevel),
      ],
    );
  }

  Widget _buildEnergyLevelChart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Energy Level', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 1),
                        FlSpot(1, 2),
                        FlSpot(2, 1.5),
                        FlSpot(3, 2.8),
                        FlSpot(4, 2),
                        FlSpot(5, 3),
                      ],
                      isCurved: true,
                      color: Colors.purple,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodTracking() {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Chip(label: Text('Day')),
                Chip(label: Text('Week')),
                Chip(label: Text('Month')),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: 40,
                      color: Colors.green,
                      title: 'Happy 40%',
                    ),
                    PieChartSectionData(
                      value: 30,
                      color: Colors.purple,
                      title: 'Calm 30%',
                    ),
                    PieChartSectionData(
                      value: 10,
                      color: Colors.red,
                      title: 'Stressed 10%',
                    ),
                    PieChartSectionData(
                      value: 20,
                      color: Colors.blue,
                      title: 'Focused 20%',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAwakeTimeAllocation() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Awake Time Allocation', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [BarChartRodData(toY: 8, color: Colors.purple)],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [BarChartRodData(toY: 2, color: Colors.green)],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [BarChartRodData(toY: 3, color: Colors.red)],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialMap() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Social Map', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Center(
              child: Text('Social Map Placeholder'), // 替换为实际社交图实现
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlights() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Today\'s Highlights', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            _buildHighlightCard(
              'ACHIEVEMENT',
              'Completed your morning meditation streak - 7 days!',
              Colors.purple,
            ),
            const SizedBox(height: 8),
            _buildHighlightCard(
              'INSIGHT',
              'You\'re most productive between 9-11 AM.',
              Colors.green,
            ),
            const SizedBox(height: 8),
            _buildHighlightCard(
              'SOCIAL',
              'You\'ve connected with 3 friends this week.',
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightCard(String title, String content, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // 使用正确的命名参数调用 .withValues()
        color: color.withValues(
          red: color.r / 255.0, // 将 0-255 转换为 0.0-1.0
          green: color.g / 255.0,
          blue: color.b / 255.0,
          alpha: 0.1, // 设置透明度
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(content),
        ],
      ),
    );
  }
}
