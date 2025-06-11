import 'package:flutter/material.dart';
import 'package:nirva_app/app_runtime_context.dart';
import 'package:nirva_app/data.dart';
//import 'package:nirva_app/stress_level_details_page.dart'; // 导入新页面

class StressLevelCard extends StatelessWidget {
  const StressLevelCard({super.key});

  @override
  Widget build(BuildContext context) {
    final stressLevel =
        AppRuntimeContext().currentJournalFile.stressLevelAverage;

    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 两端对齐
                children: [
                  Text('Stress Level', style: const TextStyle(fontSize: 16)),
                  // IconButton(
                  //   icon: const Icon(Icons.arrow_forward, color: Colors.black),
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => StressLevelDetailsPage(),
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                stressLevel.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
