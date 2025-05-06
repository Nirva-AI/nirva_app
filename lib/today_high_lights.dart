import 'package:flutter/material.dart';
import 'package:nirva_app/data_manager.dart';

class HighlightCard extends StatelessWidget {
  final HighlightData highlight;
  final Color backgroundColor;

  const HighlightCard({
    super.key,
    required this.highlight,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), // 卡片之间的间距
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor, // 背景色
        borderRadius: BorderRadius.circular(12), // 圆角
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            highlight.title.toUpperCase(), // 标题大写
            style: const TextStyle(
              color: Colors.black54, // 标题颜色较浅
              fontWeight: FontWeight.bold,
              fontSize: 12, // 标题字体较小
            ),
          ),
          const SizedBox(height: 8), // 标题和内容之间的间距
          Text(
            highlight.content,
            style: const TextStyle(
              color: Colors.black87, // 内容颜色较深
              fontSize: 14, // 内容字体较大
            ),
          ),
        ],
      ),
    );
  }
}

class TodayHighlights extends StatelessWidget {
  final List<HighlightData> highlights;

  const TodayHighlights({super.key, required this.highlights});

  @override
  Widget build(BuildContext context) {
    // 定义每个卡片的背景色
    final List<Color> backgroundColors = [
      const Color(0xFFEDE7F6), // 淡紫色
      const Color(0xFFF1F8E9), // 淡绿色
      const Color(0xFFFFF3E0), // 淡橙色
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today\'s Highlights',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...highlights.asMap().entries.map((entry) {
              final index = entry.key;
              final highlight = entry.value;
              return HighlightCard(
                highlight: highlight,
                backgroundColor:
                    backgroundColors[index % backgroundColors.length],
              );
            }),
          ],
        ),
      ),
    );
  }
}
