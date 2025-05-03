import 'package:flutter/material.dart';

class GuidedReflectionPage extends StatelessWidget {
  const GuidedReflectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Guided Reflection'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 返回到 DiaryDetailsPage
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 问题提示
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.purple.shade100, // 浅紫色背景
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Text(
                'How did you feel about this experience? What have you learned?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            // 输入框
            Expanded(
              child: TextField(
                maxLines: null, // 支持多行输入
                decoration: InputDecoration(
                  hintText: 'Write your reflection...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.mic, color: Colors.purple),
                    onPressed: () {
                      // 语音输入按钮点击事件
                      debugPrint('Voice input button pressed');
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 保存按钮
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // 保存按钮点击事件
                  debugPrint('Save button pressed');
                  Navigator.pop(context); // 返回到 DiaryDetailsPage
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // 按钮背景颜色
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
