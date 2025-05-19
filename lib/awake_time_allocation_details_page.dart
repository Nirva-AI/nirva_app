import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AwakeTimeAllocationDetailsPage extends StatelessWidget {
  const AwakeTimeAllocationDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Awake Time Allocation'),
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
            // TabBar 模拟
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTab('Day', true),
                _buildTab('Week', false),
                _buildTab('Month', false),
              ],
            ),
            const SizedBox(height: 16),

            // 折线图
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text('Sat', style: TextStyle(fontSize: 12));
                            case 1:
                              return const Text('Sun', style: TextStyle(fontSize: 12));
                            case 2:
                              return const Text('Mon', style: TextStyle(fontSize: 12));
                            case 3:
                              return const Text('Tue', style: TextStyle(fontSize: 12));
                            case 4:
                              return const Text('Wed', style: TextStyle(fontSize: 12));
                            case 5:
                              return const Text('Thu', style: TextStyle(fontSize: 12));
                            case 6:
                              return const Text('Fri', style: TextStyle(fontSize: 12));
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 2),
                        FlSpot(1, 3),
                        FlSpot(2, 8),
                        FlSpot(3, 7),
                        FlSpot(4, 7),
                        FlSpot(5, 6),
                        FlSpot(6, 5),
                      ],
                      isCurved: true,
                      color: Colors.purple, // Work
                      barWidth: 3,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                      dotData: FlDotData(show: true),
                    ),
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 1),
                        FlSpot(1, 2),
                        FlSpot(2, 3),
                        FlSpot(3, 4),
                        FlSpot(4, 4),
                        FlSpot(5, 3),
                        FlSpot(6, 3),
                      ],
                      isCurved: true,
                      color: Colors.green, // Exercise
                      barWidth: 3,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                      dotData: FlDotData(show: true),
                    ),
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 1),
                        FlSpot(1, 1.5),
                        FlSpot(2, 2),
                        FlSpot(3, 2.5),
                        FlSpot(4, 3),
                        FlSpot(5, 3.5),
                        FlSpot(6, 4),
                      ],
                      isCurved: true,
                      color: Colors.pink, // Social
                      barWidth: 3,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                      dotData: FlDotData(show: true),
                    ),
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 0.5),
                        FlSpot(1, 1),
                        FlSpot(2, 1.5),
                        FlSpot(3, 2),
                        FlSpot(4, 2.5),
                        FlSpot(5, 3),
                        FlSpot(6, 3.5),
                      ],
                      isCurved: true,
                      color: Colors.orange, // Learning
                      barWidth: 3,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                      dotData: FlDotData(show: true),
                    ),
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 0.5),
                        FlSpot(1, 0.8),
                        FlSpot(2, 1),
                        FlSpot(3, 1.2),
                        FlSpot(4, 1.5),
                        FlSpot(5, 1.8),
                        FlSpot(6, 2),
                      ],
                      isCurved: true,
                      color: Colors.yellow, // Self-Care
                      barWidth: 3,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Insights 卡片
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.info, size: 20, color: Colors.grey),
                        SizedBox(width: 8),
                        Text(
                          'Insights',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Work takes up the majority of your awake hours this day.',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Self-care and exercise time has increased compared to previous periods.',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Consider increasing learning activities to meet your personal growth goals.',
                      style: TextStyle(fontSize: 14),
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
}
