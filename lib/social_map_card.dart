import 'package:flutter/material.dart';
import 'package:nirva_app/data_manager.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/social_map_page.dart'; // 添加导入

class SocialMapCard extends StatefulWidget {
  const SocialMapCard({super.key});

  @override
  State<SocialMapCard> createState() => _SocialMapCardState();
}

class _SocialMapCardState extends State<SocialMapCard> {
  int selectedEntityIndex = -1;

  void selectEntity(int index) {
    setState(() {
      selectedEntityIndex = index;
    });
  }

  void closeDetails() {
    setState(() {
      selectedEntityIndex = -1;
    });
  }

  String _formatTips(List<String> tipsList) {
    String tips = '';
    for (String tip in tipsList) {
      tips += '• $tip\n';
    }
    return tips;
  }

  @override
  Widget build(BuildContext context) {
    final List<SocialEntity> socialEntities =
        DataManager().currentJournal.socialMap.socialEntities;

    if (selectedEntityIndex >= 0 &&
        selectedEntityIndex < socialEntities.length) {
      return _buildDetailsView(socialEntities[selectedEntityIndex]);
    }

    return _buildListView(socialEntities);
  }

  Widget _buildDetailsView(SocialEntity entity) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  entity.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'Time: ${entity.hours} hours',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(entity.description),
            const SizedBox(height: 16),
            const Text(
              'TIPS FOR IMPROVING RELATIONSHIP:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(_formatTips(entity.tips)),
            const SizedBox(height: 16),
            TextButton(
              onPressed: closeDetails,
              style: TextButton.styleFrom(foregroundColor: Colors.purple),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(List<SocialEntity> socialEntities) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Social Map', style: TextStyle(fontSize: 16)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.black),
                  onPressed: () {
                    debugPrint('Social Map arrow button clicked');
                    // 添加导航到新页面的逻辑
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SocialMapPage(),
                      ),
                    );
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(socialEntities.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: () => selectEntity(index),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        '${socialEntities[index].name}:${socialEntities[index].hours}',
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
