import 'package:flutter/material.dart';
import 'package:nirva_app/diary_entry_card.dart';
import 'package:nirva_app/data_manager.dart';
import 'package:nirva_app/quote_carousel.dart';
import 'package:nirva_app/week_calendar_widget.dart';
import 'package:nirva_app/month_calendar_page.dart';

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

          // 添加日期标题栏组件
          _buildDateHeader(),

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

  void _updateSelectedDay(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  // 提取的日期标题栏组件函数
  Widget _buildDateHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      height: 56.0,
      decoration: BoxDecoration(
        color: Color(0xFFF9F9F7),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 日历图标（左侧）
          IconButton(
            icon: const Icon(
              Icons.calendar_today_outlined,
              color: Colors.purple,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => MonthCalendarPage(
                        initialFocusedDay: _focusedDay,
                        initialSelectedDay: _selectedDay,
                        onDaySelected: _updateSelectedDay,
                      ),
                ),
              );
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36.0, minHeight: 36.0),
          ),

          // 右侧图标组
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.star_border_outlined),
                onPressed: () => debugPrint('点击了收藏图标'),
                color: Colors.grey,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(minWidth: 36.0, minHeight: 36.0),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => debugPrint('点击了搜索图标'),
                color: Colors.grey,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(minWidth: 36.0, minHeight: 36.0),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
