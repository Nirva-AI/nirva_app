import 'package:flutter/material.dart';
// import 'package:nirva_app/data_manager.dart';
// import 'package:nirva_app/data.dart';
import 'package:nirva_app/social_map_page.dart'; // 添加导入

class SocialMapGraphCard extends StatefulWidget {
  const SocialMapGraphCard({super.key});

  @override
  State<SocialMapGraphCard> createState() => _SocialMapGraphCardState();
}

class _SocialMapGraphCardState extends State<SocialMapGraphCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 标题和箭头
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Social Map', style: TextStyle(fontSize: 16)),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    debugPrint('Social Map arrow clicked!');
                    // 添加导航到新页面的逻辑
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SocialMapPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
