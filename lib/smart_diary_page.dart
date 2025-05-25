import 'package:flutter/material.dart';
import 'package:nirva_app/diary_entry_card.dart';
import 'package:nirva_app/data_manager.dart';
import 'package:nirva_app/quote_carousel.dart';
import 'package:nirva_app/utils.dart';

class SmartDiaryPage extends StatelessWidget {
  const SmartDiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部引言卡片轮播
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: QuoteCarousel(quotes: DataManager().currentJournal.quotes),
          ),
          // 日期标题
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              Utils.fullDiaryDateTime(DataManager().currentJournal.dateTime),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // 使用 ListView.builder 动态展示日记条目
          ListView.builder(
            shrinkWrap: true, // 使 ListView 适应父组件高度
            physics: const NeverScrollableScrollPhysics(), // 禁用内部滚动
            itemCount: DataManager().currentJournal.diaryEntries.length,
            itemBuilder: (context, index) {
              final entry = DataManager().currentJournal.diaryEntries[index];
              return DiaryEntryCard(diaryData: entry);
            },
          ),
        ],
      ),
    );
  }
}
