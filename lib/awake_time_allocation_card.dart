import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:nirva_app/app_runtime_context.dart';
//import 'package:nirva_app/awake_time_allocation_details_page.dart';
import 'package:nirva_app/data.dart';

class AwakeTimeAllocationCard extends StatelessWidget {
  const AwakeTimeAllocationCard({super.key});

  static const double _minY = 0;
  static const double _maxY = 8;
  static const double _interval = 2;

  String _formatLeftTitle(double value) {
    if (value >= 0 && value <= 8 && value % 2 == 0) {
      return '${value.toInt()}h';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final awakeTimeAllocations =
        AppRuntimeContext().currentJournalFile.awakeTimeAllocation;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Awake Time Allocation',
                  style: TextStyle(fontSize: 16),
                ),
                // const Spacer(),
                // IconButton(
                //   icon: const Icon(Icons.arrow_forward, color: Colors.black),
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => AwakeTimeAllocationDetailsPage(),
                //       ),
                //     );
                //   },
                //   padding: EdgeInsets.zero,
                //   constraints: const BoxConstraints(),
                // ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  minY: _minY,
                  maxY: _maxY,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: _interval,
                        getTitlesWidget: (value, meta) {
                          String title = _formatLeftTitle(value);
                          if (title.isNotEmpty) {
                            return Text(
                              title,
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
                              value.toInt() < awakeTimeAllocations.length) {
                            return Text(
                              awakeTimeAllocations[value.toInt()].name,
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
                      awakeTimeAllocations
                          .asMap()
                          .entries
                          .map(
                            (entry) => BarChartGroupData(
                              x: entry.key,
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value.minutes / 60,
                                  color: Color(entry.value.color),
                                  width: 15,
                                  borderRadius: BorderRadius.zero,
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
      ),
    );
  }
}
