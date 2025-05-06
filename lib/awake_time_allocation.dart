import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AwakeTimeAllocation extends StatelessWidget {
  const AwakeTimeAllocation({super.key});

  @override
  Widget build(BuildContext context) {
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
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 8, // 设置纵轴最大值为 8
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 2, // 设置刻度间隔为 2
                        getTitlesWidget: (value, meta) {
                          // 仅显示 0 到 maxY 范围内的整数刻度
                          if (value >= 0 && value <= 8 && value % 2 == 0) {
                            return Text(
                              '${value.toInt()}h',
                              style: const TextStyle(fontSize: 12),
                            );
                          }
                          return const SizedBox.shrink(); // 不显示其他值
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text(
                                'Work',
                                style: TextStyle(fontSize: 12),
                              );
                            case 1:
                              return const Text(
                                'Exercise',
                                style: TextStyle(fontSize: 12),
                              );
                            case 2:
                              return const Text(
                                'Social',
                                style: TextStyle(fontSize: 12),
                              );
                            case 3:
                              return const Text(
                                'Learning',
                                style: TextStyle(fontSize: 12),
                              );
                            case 4:
                              return const Text(
                                'Self-care',
                                style: TextStyle(fontSize: 12),
                              );
                            case 5:
                              return const Text(
                                'Other',
                                style: TextStyle(fontSize: 12),
                              );
                            default:
                              return const Text('');
                          }
                        },
                      ),
                    ),
                  ),
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
                    BarChartGroupData(
                      x: 3,
                      barRods: [BarChartRodData(toY: 3, color: Colors.orange)],
                    ),
                    BarChartGroupData(
                      x: 4,
                      barRods: [BarChartRodData(toY: 1, color: Colors.yellow)],
                    ),
                    BarChartGroupData(
                      x: 5,
                      barRods: [
                        BarChartRodData(toY: 4, color: Colors.blueGrey),
                      ],
                    ),
                  ],
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
