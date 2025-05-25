import 'package:flutter/material.dart';
import 'package:nirva_app/diary_entry_card.dart';
import 'package:nirva_app/data_manager.dart';
import 'package:nirva_app/quote_carousel.dart';
import 'package:nirva_app/week_calendar_widget.dart';

class SmartDiaryPage extends StatefulWidget {
  const SmartDiaryPage({super.key});

  @override
  State<SmartDiaryPage> createState() => _SmartDiaryPageState();
}

class _SmartDiaryPageState extends State<SmartDiaryPage> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DataManager().currentJournal.dateTime;
    _selectedDay = DataManager().currentJournal.dateTime;
  }

  void _updateSelectedDay(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

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

          // 周日历组件替代原来的日期标题
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: WeekCalendarWidget(
              focusedDay: _focusedDay,
              selectedDay: _selectedDay,
              onDaySelected: _updateSelectedDay,
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
