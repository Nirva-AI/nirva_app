import 'package:flutter/material.dart';
import 'package:nirva_app/data.dart';
import 'package:nirva_app/archived_highlights_page.dart'; // 导入新页面
import 'package:nirva_app/app_runtime_context.dart';

class TodayHighlightsCard extends StatelessWidget {
  const TodayHighlightsCard({super.key});

  /// 生成单个高亮卡片的方法
  Widget _buildHighlightCard(Highlight highlight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), // 卡片之间的间距
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(highlight.color), // 背景色
        borderRadius: BorderRadius.circular(12), // 圆角
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            highlight.category.toUpperCase(), // 标题大写
            style: const TextStyle(
              color: Colors.black54, // 标题颜色较浅
              fontWeight: FontWeight.bold,
              fontSize: 12, // 标题字体较小
            ),
          ),
          const SizedBox(height: 8), // 标题和内容之间的间距
          Text(
            highlight.content,
            style: const TextStyle(
              color: Colors.black87, // 内容颜色较深
              fontSize: 14, // 内容字体较大
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final highlights = AppRuntimeContext().data.currentJournal.highlights;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 修改这里：使用Row让文本和图标在同一行
            Row(
              children: [
                const Text(
                  'Today\'s Highlights',
                  style: TextStyle(fontSize: 16),
                ),
                const Spacer(), // 添加Spacer使图标靠右
                IconButton(
                  icon: const Icon(Icons.arrow_forward, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArchivedHighlightsPage(),
                      ),
                    );
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...highlights.asMap().entries.map((entry) {
              final highlight = entry.value;
              return _buildHighlightCard(highlight);
            }),
          ],
        ),
      ),
    );
  }
}
