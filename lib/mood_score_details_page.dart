import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nirva_app/data_manager.dart';
import 'package:nirva_app/utils.dart';

class MoodScoreDetailsPage extends StatelessWidget {
  const MoodScoreDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Score'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 包裹 TabBar、Mood Score 和折线图的 Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TabBar 模拟
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTab('Day', false),
                        _buildTab('Week', false),
                        _buildTab('Month', true),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Mood Score
                    const Center(
                      child: Text(
                        '85',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 折线图
                    SizedBox(
                      height: 200, // 为图表提供明确的高度
                      child: _buildLineChart(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Insights 卡片
            _buildInsightsCard(
              DataManager().moodScoreInsights.insights,
            ), // 传入数据
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey[200] : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.black : Colors.grey,
        ),
      ),
    );
  }

  // 提取图表部分为独立函数
  Widget _buildLineChart() {
    return Center(
      // 确保图表居中
      child: FractionallySizedBox(
        widthFactor: 0.90, // 宽度为原来的 85%
        heightFactor: 0.8, // 高度为原来的 60%
        child: LineChart(
          LineChartData(
            minY: 0, // 设置最小值为 0
            maxY: 100, // 设置最大值为 100
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true, // 确保左侧标题显示
                  interval: 25, // 设置刻度间隔为 25
                  reservedSize: 40, // 增加刻度区域的宽度
                  getTitlesWidget: (value, meta) {
                    if (value == 0 ||
                        value == 25 ||
                        value == 50 ||
                        value == 75 ||
                        value == 100) {
                      return Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32, // 为底部标题预留空间
                  interval: 1, // 设置刻度间隔为 1，与 FlSpot 的 x 值一致
                  getTitlesWidget: (value, meta) {
                    // 返回对应的月份标签
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0), // 添加顶部间距
                      child: Text(
                        _formatMonthTitle(value.toInt()),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: const [
                  FlSpot(0, 70),
                  FlSpot(1, 78),
                  FlSpot(2, 80),
                  FlSpot(3, 82),
                  FlSpot(4, 85),
                ],
                isCurved: true,
                color: Colors.purple,
                barWidth: 3,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(show: false),
                dotData: FlDotData(show: true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatMonthTitle(int widgetIndexValue) {
    // 获取当前月份
    DateTime dateTime = DataManager().moodScoreInsights.dateTime;
    final int currentMonth = dateTime.month;

    // 计算从当前月份开始的正序排列
    int startMonth = (currentMonth - 5) % 12; // 计算起始月份索引
    if (startMonth < 0) startMonth += 12; // 确保索引为正数
    int targetMonth = (startMonth + widgetIndexValue) % 12; // 计算目标月份索引
    return Utils.monthNames[targetMonth];
  }

  // 提取 Insights 卡片部分为独立函数
  Widget _buildInsightsCard(List<String> insights) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.info, size: 20, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  'Insights',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (insights.isNotEmpty)
              ...insights.map(
                (insight) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(insight, style: const TextStyle(fontSize: 14)),
                ),
              )
            else
              const Text(
                'No insights available.',
                style: TextStyle(fontSize: 14),
              ),
          ],
        ),
      ),
    );
  }
}
