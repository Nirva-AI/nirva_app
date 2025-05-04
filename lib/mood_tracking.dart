import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MoodTracking extends StatelessWidget {
  const MoodTracking({super.key});

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
}
