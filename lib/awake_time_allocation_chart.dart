import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nirva_app/data_manager.dart';
import 'package:nirva_app/awake_time_allocation_details_page.dart'; // 导入新页面

final Map<String, Color> awakeTimeColors = {};

class AwakeTimeAllocationChart extends StatelessWidget {
  const AwakeTimeAllocationChart({super.key});

  Color _getColor(String label) {
    if (awakeTimeColors.containsKey(label)) {
      return awakeTimeColors[label]!;
    } else {
      final color = Color(
        (math.Random().nextDouble() * 0xFFFFFF).toInt(),
      ).withAlpha(255);
      awakeTimeColors[label] = color;
      return color;
    }
  }

  @override
  Widget build(BuildContext context) {
    final awakeTimeAllocationDataList =
        DataManager().currentJournal.awakeTimeActions;
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
                const Text(
                  'Awake Time Allocation',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: 8,
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            interval: 2,
                            getTitlesWidget: (value, meta) {
                              if (value >= 0 && value <= 8 && value % 2 == 0) {
                                return Text(
                                  '${value.toInt()}h',
                                  style: const TextStyle(fontSize: 12),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              if (value.toInt() >= 0 &&
                                  value.toInt() <
                                      awakeTimeAllocationDataList.length) {
                                return Text(
                                  awakeTimeAllocationDataList[value.toInt()]
                                      .label,
                                  style: const TextStyle(fontSize: 10),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      barGroups:
                          awakeTimeAllocationDataList
                              .asMap()
                              .entries
                              .map(
                                (entry) => BarChartGroupData(
                                  x: entry.key,
                                  barRods: [
                                    BarChartRodData(
                                      toY: entry.value.value,
                                      color: _getColor(entry.value.label),
                                      width: 15,
                                    ),
                                  ],
                                ),
                              )
                              .toList(),
                      gridData: FlGridData(show: false),
                      borderData: FlBorderData(show: false),
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
                      builder:
                          (context) => const AwakeTimeAllocationDetailsPage(),
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
}
