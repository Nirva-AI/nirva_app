import 'package:flutter/material.dart';
import 'package:nirva_app/data_manager.dart';
import 'package:nirva_app/diary_details_page.dart';

// 修改 DiaryEntry 组件
class DiaryEntry extends StatelessWidget {
  final DiaryItem diaryData;

  const DiaryEntry({super.key, required this.diaryData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 跳转到 TestPage，并传递卡片内容
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiaryDetailsPage(diaryData: diaryData),
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
                  diaryData.time,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  diaryData.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  diaryData.description,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  children:
                      diaryData.tags
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
                      diaryData.location,
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
