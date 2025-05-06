import 'package:flutter/material.dart';

class SocialMap extends StatefulWidget {
  const SocialMap({super.key});

  @override
  State<SocialMap> createState() => _SocialMapState();
}

class _SocialMapState extends State<SocialMap> {
  int? selectedFriendIndex; // 当前选中的朋友索引

  final List<String> friends = [
    'Ashley',
    'Trent',
    'Charlie',
    'Diana',
    'Eve',
    'Frank',
  ];

  final Map<String, String> friendDetails = {
    'Ashley':
        'Deep, supportive conversation. Vulnerability was met with understanding.',
    'Trent':
        'Shared a fun hiking trip. Great teamwork and mutual encouragement.',
    'Charlie':
        'Had a long discussion about books and movies. Discovered shared interests.',
    'Diana':
        'Enjoyed a relaxing day at the park. Shared thoughts and future plans.',
    'Eve': 'Worked together on a project. Built trust and understanding.',
    'Frank': 'Played board games. Lots of laughter and bonding moments.',
  };

  final Map<String, String> friendTimes = {
    'Ashley': '~3 hours',
    'Trent': '~2 hours',
    'Charlie': '~1.5 hours',
    'Diana': '~4 hours',
    'Eve': '~2.5 hours',
    'Frank': '~3.5 hours',
  };

  void selectFriend(int index) {
    setState(() {
      selectedFriendIndex = index;
    });
  }

  void closeDetails() {
    setState(() {
      selectedFriendIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (selectedFriendIndex != null) {
      // 显示详细信息视图
      final friendName = friends[selectedFriendIndex!];
      final details = friendDetails[friendName] ?? 'No details available.';
      final time = friendTimes[friendName] ?? 'Unknown';

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
                    friendName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Time: $time',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 4),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(details),
              const SizedBox(height: 8),
              const Text(
                '• Reciprocate Support: Ensure you\'re actively listening and offering support.\n'
                '• Follow Through: Act on plans discussed to build reliability.\n'
                '• Shared Fun: Explore shared interests beyond difficulties.',
              ),
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

    // 显示按钮列表视图
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
                children: List.generate(friends.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ElevatedButton(
                      onPressed: () => selectFriend(index),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(friends[index]),
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
