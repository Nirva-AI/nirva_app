import 'package:flutter/material.dart';
import 'package:nirva_app/month_calendar_widget.dart';
import 'package:nirva_app/app_runtime_context.dart';

class MonthCalendarPage extends StatelessWidget {
  final DateTime initialFocusedDay;
  final DateTime? initialSelectedDay;
  final Function(DateTime, DateTime) onDaySelected;

  const MonthCalendarPage({
    super.key,
    required this.initialFocusedDay,
    required this.initialSelectedDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    // 示例：标记特定日期为红色
    Set<DateTime> journalDates = {};
    var allJournalFiles = AppRuntimeContext().journalFiles;
    for (var file in allJournalFiles) {
      DateTime date = DateTime.parse(file.time_stamp);
      journalDates.add(date);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // 返回上一页
          },
        ),
      ),
      body: Center(
        child: MonthCalendarWidget(
          focusedDay: initialFocusedDay,
          selectedDay: initialSelectedDay,
          onDaySelected: (selectedDay, focusedDay) {
            onDaySelected(selectedDay, focusedDay);
            Navigator.pop(context); // 选中日期后返回上一页
          },
          redMarkedDays: journalDates, // 传入需要标红的日期
        ),
      ),
    );
  }
}
