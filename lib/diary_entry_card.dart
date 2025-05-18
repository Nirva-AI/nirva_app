import 'package:flutter/material.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/diary_details_page.dart';
import 'package:nirva_app/data_manager.dart';

class DiaryEntryCard extends StatefulWidget {
  final DiaryEntry diaryData;

  const DiaryEntryCard({super.key, required this.diaryData});

  @override
  State<DiaryEntryCard> createState() => _DiaryEntryCardState();
}

class _DiaryEntryCardState extends State<DiaryEntryCard> {
  late ValueNotifier<List<String>> favoriteNotifier;

  @override
  void initState() {
    super.initState();
    favoriteNotifier = DataManager().diaryFavoritesNotifier;
    favoriteNotifier.addListener(_onFavoriteChanged);
  }

  @override
  void dispose() {
    favoriteNotifier.removeListener(_onFavoriteChanged);
    super.dispose();
  }

  void _onFavoriteChanged() {
    if (mounted) {
      setState(() {}); // 刷新 UI
    }
  }

  bool get isFavoriteDiaryEntry {
    return DataManager().isFavoriteDiaryEntry(widget.diaryData);
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
                        isFavoriteDiaryEntry ? Icons.star : Icons.star_border,
                        color:
                            isFavoriteDiaryEntry ? Colors.amber : Colors.grey,
                      ),
                      onPressed: () {
                        DataManager().toggleFavoriteDiaryEntry(
                          widget.diaryData,
                        );
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
                              label: Text(tag.name),
                              backgroundColor: Colors.blue.shade100,
                            ),
                          )
                          .toList(),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      widget.diaryData.location.name,
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
