import 'package:flutter/material.dart';
import 'package:nirva_app/test_page.dart';

// 修改 DiaryEntry 组件
class DiaryEntry extends StatelessWidget {
  final String time;
  final String title;
  final String description;
  final List<String> tags;
  final String location;

  const DiaryEntry({
    super.key,
    required this.time,
    required this.title,
    required this.description,
    required this.tags,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    // 拼接卡片的所有文本内容
    final cardContent = '''
Time: $time
Title: $title
Description: $description
Tags: ${tags.join(', ')}
Location: $location
''';

    return GestureDetector(
      onTap: () {
        // 跳转到 TestPage，并传递卡片内容
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TestPage(content: cardContent),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  children:
                      tags
                          .map(
                            (tag) => Chip(
                              label: Text(tag),
                              backgroundColor: Colors.blue.shade100,
                            ),
                          )
                          .toList(),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      location,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const Icon(Icons.star_border), // 收藏按钮
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
