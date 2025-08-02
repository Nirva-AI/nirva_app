import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/journal_details_page.dart';
import 'package:nirva_app/providers/favorites_provider.dart';
import 'package:nirva_app/hive_helper.dart';

class EventCard extends StatelessWidget {
  final EventAnalysis eventData;

  const EventCard({super.key, required this.eventData});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        final isFavorite = favoritesProvider.checkFavorite(eventData);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => JournalDetailsPage(
                      //diaryData: widget.diaryData,
                      eventData: eventData,
                    ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
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
                      eventData.time_range,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            eventData.event_title,
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
                            favoritesProvider.switchEventFavoriteStatus(
                              eventData,
                            );

                            // 异步保存，不阻塞当前线程
                            HiveHelper.saveFavoriteIds(
                              favoritesProvider.favoriteIds,
                            ).catchError((error) {
                              debugPrint('保存收藏夹数据失败: $error');
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      eventData.one_sentence_summary,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      children:
                          eventData.topic_labels
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
                          eventData.location,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
