import 'package:flutter/material.dart';
import 'package:nirva_app/app_runtime_context.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/mood_score_details_page.dart';

class MoodScoreCard extends StatelessWidget {
  const MoodScoreCard({super.key});

  @override
  Widget build(BuildContext context) {
    final moodScore = AppRuntimeContext().currentJournalFile.moodScoreAverage;

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
                  Text('Mood Score', style: const TextStyle(fontSize: 16)),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MoodScoreDetailsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                moodScore.toStringAsFixed(1), // 显示分数，保留一位小数
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              //const SizedBox(height: 8),
              // Row(
              //   children: [
              //     Icon(
              //       changeColor == Colors.green
              //           ? Icons.arrow_upward
              //           : Icons.arrow_downward,
              //       color: changeColor,
              //       size: 16,
              //     ),
              //     Text(
              //       _formatChange(data.change),
              //       style: TextStyle(color: changeColor),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
