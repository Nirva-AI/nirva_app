import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// 第二个日历组件
class WeekCalendarWidget extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Function(DateTime, DateTime) onDaySelected;

  const WeekCalendarWidget({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2000, 1, 1),
      lastDay: DateTime.utc(2100, 12, 31),
      focusedDay: focusedDay,
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      onDaySelected: onDaySelected,
      calendarFormat: CalendarFormat.week, // 设置为周视图
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Color(0xFFFFD700), // 金黄色背景
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        todayTextStyle: TextStyle(
          color: Colors.black, // 今日文字颜色
          fontWeight: FontWeight.bold,
        ),
        selectedTextStyle: TextStyle(
          color: Colors.black, // 选中日期文字颜色
          fontWeight: FontWeight.bold,
        ),
        defaultTextStyle: TextStyle(
          color: Colors.black, // 默认文字颜色
        ),
        weekendTextStyle: TextStyle(
          color: Colors.black, // 周末文字颜色
        ),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false, // 隐藏格式切换按钮
        titleCentered: true, // 标题居中
        titleTextStyle: TextStyle(
          color: Colors.black, // 标题文字颜色
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: Colors.black, // 左箭头颜色
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: Colors.black, // 右箭头颜色
        ),
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          color: Colors.black, // 工作日文字颜色
        ),
        weekendStyle: TextStyle(
          color: Colors.black, // 周末文字颜色
        ),
      ),
    );
  }
}
