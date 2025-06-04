import 'package:flutter/material.dart';
import 'package:nirva_app/app_runtime_context.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/guided_reflection_page.dart';
import 'package:nirva_app/utils.dart';

class EventDetailsPage extends StatefulWidget {
  final Event eventData;

  const EventDetailsPage({super.key, required this.eventData});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  bool get isFavorite {
    return AppRuntimeContext().data.checkFavorite(widget.eventData);
  }

  void _toggleFavorite() {
    setState(() {
      AppRuntimeContext().data.switchEventFavoriteStatus(widget.eventData);
      //AppRuntimeContext().data.switchDiaryFavoriteStatus(widget.diaryData);
      debugPrint(
        'Star button pressed: ${isFavorite ? "Added to favorites" : "Removed from favorites"}',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final fullDateTime = Utils.fullDiaryDateTime(
      AppRuntimeContext().data.currentJournal.dateTime,
    );
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                isFavorite ? Icons.star : Icons.star_border,
                color: isFavorite ? Colors.amber : Colors.black,
              ),
              onPressed: _toggleFavorite,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.eventData.event_title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          //_getFormattedTime(),
                          widget.eventData.time_range,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.eventData.location,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      fullDateTime,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.eventData.first_person_narrative,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 16),
                    const Divider(
                      color: Colors.grey,
                      thickness: 1.0,
                      height: 16.0,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'My Notes',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ValueListenableBuilder(
                      valueListenable: AppRuntimeContext().data.notes,
                      builder: (context, List<Note> notes, _) {
                        final note = notes.firstWhere(
                          (element) => element.id == widget.eventData.event_id,
                          orElse: () => Note(id: '', content: ''),
                        );
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            note.content.isNotEmpty ? note.content : '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 32.0),
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => GuidedReflectionPage(
                      //diaryData: widget.diaryData,
                      eventData: widget.eventData,
                    ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: const Text(
            'Edit notes',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
