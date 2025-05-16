import 'package:flutter/material.dart';
import 'package:nirva_app/data_manager.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/guided_reflection_page.dart'; // 导入新页面

class DiaryDetailsPage extends StatelessWidget {
  final DiaryEntry diaryData;

  const DiaryDetailsPage({super.key, required this.diaryData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56.0), // 自定义 AppBar 高度
        child: AppBar(
          backgroundColor: Colors.white, // 背景颜色
          elevation: 0, // 去除阴影
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            // IconButton(
            //   icon: const Icon(Icons.star_border, color: Colors.black),
            //   onPressed: () {
            //     // 星形按钮点击事件
            //     debugPrint('Star button pressed');
            //   },
            // ),
            // IconButton(
            //   icon: const Icon(Icons.share, color: Colors.black),
            //   onPressed: () {
            //     // 分享按钮点击事件
            //     debugPrint('Share button pressed');
            //   },
            // ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Text(
              diaryData.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // 时间与地点
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  diaryData.time,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  diaryData.location,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 日期
            Text(
              DataManager().currentJournalEntry.formattedDate, // 示例日期，可动态替换
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            // 描述文本
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  diaryData.content,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // 底部按钮
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // 跳转到 GuidedReflectionPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GuidedReflectionPage(),
                    ),
                  );
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
                  'Reflect on this',
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
