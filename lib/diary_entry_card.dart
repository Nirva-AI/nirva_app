import 'package:flutter/material.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/diary_details_page.dart';
//import 'package:nirva_app/data_manager.dart';

class DiaryEntryCard extends StatefulWidget {
  final DiaryEntry diaryData;

  const DiaryEntryCard({super.key, required this.diaryData});

  @override
  State<DiaryEntryCard> createState() => _DiaryEntryCardState();
}

class _DiaryEntryCardState extends State<DiaryEntryCard> {
  late bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    // 初始化 isStarred，假设 DiaryEntry 中有一个字段表示星标状态
    isFavorite = false; // 或者从 widget.diaryData 中获取初始值
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiaryDetailsPage(diaryData: widget.diaryData),
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
                  getFormattedTime(),
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.diaryData.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.star : Icons.star_border,
                        color: isFavorite ? Colors.amber : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isFavorite = !isFavorite;
                          debugPrint('Star button pressed: $isFavorite');
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.diaryData.summary,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  children:
                      widget.diaryData.tags
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
                      widget.diaryData.location,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getFormattedTime() {
    final startTime = widget.diaryData.beginTime;
    final endTime = widget.diaryData.endTime;

    String formattedStartTime = '${startTime.hour}:${startTime.minute}';
    String formattedEndTime = '${endTime.hour}:${endTime.minute}';

    return '$formattedStartTime - $formattedEndTime';
  }
}
