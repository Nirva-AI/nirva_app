import 'package:flutter/material.dart';
import 'package:nirva_app/data_manager.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/guided_reflection_page.dart';

class DiaryDetailsPage extends StatefulWidget {
  final DiaryEntry diaryData;

  const DiaryDetailsPage({super.key, required this.diaryData});

  @override
  State<DiaryDetailsPage> createState() => _DiaryDetailsPageState();
}

class _DiaryDetailsPageState extends State<DiaryDetailsPage> {
  bool get isFavoriteDiaryEntry {
    return DataManager().isFavoriteDiaryEntry(widget.diaryData);
  }

  void _toggleFavorite() {
    setState(() {
      DataManager().toggleFavoriteDiaryEntry(widget.diaryData);
      debugPrint(
        'Star button pressed: ${isFavoriteDiaryEntry ? "Added to favorites" : "Removed from favorites"}',
      );
    });
  }

  String _getFormattedTime() {
    final startTime = widget.diaryData.beginTime;
    final endTime = widget.diaryData.endTime;

    String formattedStartTime = '${startTime.hour}:${startTime.minute}';
    String formattedEndTime = '${endTime.hour}:${endTime.minute}';

    return '$formattedStartTime - $formattedEndTime';
  }

  String _getNotesContent() {
    return "Today I spent a wonderful morning at the park with Ashley, whom I met at the intensive outpatient program (IOP). I explained my recording experiment project to her, discussing how it helps with objective memory review. We had an in-depth conversation about dating experiences and my recent frustrations with being 'ghosted' after what seemed like promising connections. We reflected on solitude and socializing. I realized that on weekdays, I barely interact with people, and long periods of solitude (like the past five days) don't feel very healthy, though I do enjoy alone time. When I have free time, I tend to become lazy, sleep too much, and feel like I'm wasting time. Ashley shared her struggles with similar feelings. I also mentioned visiting a friend who just had a baby, finding the baby cute, and feeling somewhat envious of her stable life situation. The most relaxing part was when Ashley demonstrated a Nepalese singing bowl and showed her crystal collection. She explained the meanings of various crystals (moonstone, carnelian, amethyst, etc.) and did a tarot reading for me about my 'fertility journey.' We also had an in-depth discussion about my fertility plans - waiting until 40 to decide about having children, the financial costs, and my mother's supportive attitude.";
  }

  @override
  Widget build(BuildContext context) {
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
                isFavoriteDiaryEntry ? Icons.star : Icons.star_border,
                color: isFavoriteDiaryEntry ? Colors.amber : Colors.black,
              ),
              onPressed: _toggleFavorite,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.diaryData.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    _getFormattedTime(),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    widget.diaryData.location.name,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                DataManager().currentJournalEntry.formattedDate,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Text(
                widget.diaryData.content,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.grey, thickness: 1.0, height: 16.0),
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  _getNotesContent(),
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GuidedReflectionPage(),
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
