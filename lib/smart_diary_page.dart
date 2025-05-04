import 'package:flutter/material.dart';
import 'package:nirva_app/diary_entry.dart';
import 'package:nirva_app/data_manager.dart';
import 'package:nirva_app/quote_carousel.dart';

// 修改 SmartDiaryPage 组件
class SmartDiaryPage extends StatelessWidget {
  const SmartDiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取引言卡片数据
    final quotes = DataManager().currentDiary.quotes;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部引言卡片轮播
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: QuoteCarousel(quotes: quotes),
          ),
          // 日期标题
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              DataManager().currentDiary.date,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // 使用 ListView.builder 动态展示日记条目
          ListView.builder(
            shrinkWrap: true, // 使 ListView 适应父组件高度
            physics: const NeverScrollableScrollPhysics(), // 禁用内部滚动
            itemCount: DataManager().currentDiary.items.length,
            itemBuilder: (context, index) {
              final entry = DataManager().currentDiary.items[index];
              return DiaryEntry(diaryData: entry);
            },
          ),
        ],
      ),
    );
  }
}
