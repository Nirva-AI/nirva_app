import 'package:flutter/material.dart';

class SocialMapPage extends StatelessWidget {
  const SocialMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Holistic Social Map'),
        // AppBar 自动包含返回按钮，不需要额外添加
      ),
      body: const Center(
        child: Text('Holistic Social Map', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
