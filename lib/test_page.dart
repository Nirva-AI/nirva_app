import 'package:flutter/material.dart';
import 'package:nirva_app/data_manager.dart';

// 修改 TestPage 组件
class TestPage extends StatelessWidget {
  final DiaryItem diaryData;

  const TestPage({super.key, required this.diaryData});

  @override
  Widget build(BuildContext context) {
    // 拼接卡片的所有文本内容
    final cardContent = '''
Time: ${diaryData.time}
Title: ${diaryData.title}
Description: ${diaryData.description}
Tags: ${diaryData.tags.join(', ')}
Location: ${diaryData.location}
''';
    return Scaffold(
      appBar: AppBar(
        title: const Text('测试页面'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(cardContent, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
