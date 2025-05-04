import 'package:flutter/material.dart';

class SocialMap extends StatelessWidget {
  const SocialMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Social Map', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Center(
              child: Text('Social Map Placeholder'), // 替换为实际社交图实现
            ),
          ],
        ),
      ),
    );
  }
}
