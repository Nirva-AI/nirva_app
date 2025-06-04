import 'package:flutter/material.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/diary_details_page.dart';
import 'package:nirva_app/app_runtime_context.dart';
import 'package:nirva_app/hive_object.dart';

class DiaryEntryCard extends StatefulWidget {
  //final DiaryEntry diaryData;
  final Event eventData;

  const DiaryEntryCard({
    super.key,
    //required this.diaryData,
    required this.eventData,
  });

  @override
  State<DiaryEntryCard> createState() => _DiaryEntryCardState();
}

class _DiaryEntryCardState extends State<DiaryEntryCard> {
  late ValueNotifier<List<String>> favoritesNotifier;

  @override
  void initState() {
    super.initState();
    favoritesNotifier = AppRuntimeContext().data.favorites;
    favoritesNotifier.addListener(_onFavoriteChanged);
  }

  @override
  void dispose() {
    favoritesNotifier.removeListener(_onFavoriteChanged);
    super.dispose();
  }

  void _onFavoriteChanged() {
    if (mounted) {
      setState(() {}); // 刷新 UI
    }

    // 将收藏夹数据存储到 Hive
    final diaryFavorites = Favorites(favoriteIds: favoritesNotifier.value);

    // 异步保存，不阻塞当前线程
    AppRuntimeContext().storage.saveFavorites(diaryFavorites).catchError((
      error,
    ) {
      debugPrint('保存收藏夹数据失败: $error');
    });
  }

  bool get isFavorite {
    return AppRuntimeContext().data.checkFavorite(widget.eventData);

    //return AppRuntimeContext().data.checkIfDiaryIsFavorite(widget.diaryData);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => DiaryDetailsPage(
                  //diaryData: widget.diaryData,
                  eventData: widget.eventData,
                ),
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
                  widget.eventData.time_range,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.eventData.event_title,
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
                        AppRuntimeContext().data.switchEventFavoriteStatus(
                          widget.eventData,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.eventData.one_sentence_summary,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  children:
                      widget.eventData.topic_labels
                          .map(
                            (topicLabel) => Chip(
                              label: Text(topicLabel),
                              backgroundColor: Colors.blue.shade50,
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
                      widget.eventData.location,
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

  // String getFormattedTime() {
  //   final startTime = widget.diaryData.beginTime;
  //   final endTime = widget.diaryData.endTime;

  //   String formattedStartTime = '${startTime.hour}:${startTime.minute}';
  //   String formattedEndTime = '${endTime.hour}:${endTime.minute}';

  //   return '$formattedStartTime - $formattedEndTime';
  // }
}
