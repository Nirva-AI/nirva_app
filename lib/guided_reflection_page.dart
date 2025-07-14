import 'package:flutter/material.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/app_service.dart'; // 确保导入 DataManager

class GuidedReflectionPage extends StatelessWidget {
  final EventAnalysis eventData; // 新增参数

  final TextEditingController _textController =
      TextEditingController(); // 添加控制器

  GuidedReflectionPage({super.key, required this.eventData});

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
                controller: _textController, // 绑定控制器
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
            const Spacer(), // 添加 Spacer 将按钮向上推
            // 保存按钮
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // 保存按钮点击事件
                  final content = _textController.text; // 获取输入框内容
                  AppService().notesProvider.updateNote(
                    eventData, // 使用 eventData
                    content,
                  ); // 保存到 NotesProvider
                  debugPrint('Save button pressed: $content'); // 打印保存内容
                  Navigator.pop(context); // 返回到 DiaryDetailsPage
                  await AppService().hiveManager.saveNotes(
                    AppService().notesProvider.notes,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // 按钮背景颜色
                  minimumSize: const Size(
                    double.infinity,
                    42,
                  ), // 设置按钮宽度为最大，固定高度
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32, // 与 'Edit notes' 按钮一致
                    vertical: 12, // 与 'Edit notes' 按钮一致
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      24,
                    ), // 与 'Edit notes' 按钮一致
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 36), // 调整按钮与底部的间距
          ],
        ),
      ),
    );
  }
}
