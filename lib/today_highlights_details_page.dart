import 'package:flutter/material.dart';
import 'package:nirva_app/data.dart';

class TodayHighlightsDetailsPage extends StatelessWidget {
  final highlightGroups = [
    HighlightGroup(
      beginTime: DateTime(2025, 5, 9),
      endTime: DateTime(2025, 5, 15),
      highlights: [
        Highlight(
          category: 'Achievement',
          content: 'Completed 5 meditation sessions',
        ),
        Highlight(
          category: 'Insight',
          content:
              'Your stress levels were 20% lower when you exercised in the morning',
        ),
        Highlight(
          category: 'Social',
          content: 'Connected with 4 friends this week',
        ),
      ],
    ),
    HighlightGroup(
      beginTime: DateTime(2025, 5, 2),
      endTime: DateTime(2025, 5, 8),
      highlights: [
        Highlight(
          category: 'Achievement',
          content: 'Completed 3 meditation sessions',
        ),
        Highlight(
          category: 'Insight',
          content:
              'Your stress levels were 15% lower when you exercised in the morning',
        ),
        Highlight(
          category: 'Social',
          content: 'Connected with 2 friends this week',
        ),
      ],
    ),
  ];

  TodayHighlightsDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Archived Highlights'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
