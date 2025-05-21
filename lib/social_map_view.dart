import 'package:flutter/material.dart';
import 'package:nirva_app/data_manager.dart';
import 'package:nirva_app/data.dart';

class SocialMapView extends StatefulWidget {
  const SocialMapView({super.key});

  @override
  State<SocialMapView> createState() => _SocialMapViewState();
}

class _SocialMapViewState extends State<SocialMapView> {
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
                      'Time: ${entity.timeSpent}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(entity.details),
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
            const Text(
              'Social Map',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                        '${socialEntities[index].name}:${socialEntities[index].timeSpent}',
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
