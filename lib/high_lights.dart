import 'package:flutter/material.dart';
import 'package:nirva_app/data_manager.dart';

class HighlightCard extends StatelessWidget {
  final HighlightCardData highlight;

  const HighlightCard({super.key, required this.highlight});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8), // 添加间距
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey, // 使用透明度
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            highlight.title,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(highlight.content),
        ],
      ),
    );
  }
}

class Highlights extends StatelessWidget {
  final List<HighlightCardData> highlights;

  const Highlights({super.key, required this.highlights});

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
            const Text('Today\'s Highlights', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ...highlights.map(
              (highlight) => HighlightCard(highlight: highlight),
            ),
          ],
        ),
      ),
    );
  }
}
