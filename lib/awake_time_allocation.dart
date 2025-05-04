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
}
