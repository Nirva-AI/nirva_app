import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// 第二个日历组件
class WeekCalendarWidget extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Function(DateTime, DateTime) onDaySelected;
  // 新增参数: 需要标红的日期集合
  final Set<DateTime> redMarkedDays;

  const WeekCalendarWidget({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    this.redMarkedDays = const {}, // 默认为空集合
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
      // 添加日期构建器
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          // 检查当前日期是否需要标红
          bool isRedMarked = redMarkedDays.any((d) => isSameDay(day, d));

          if (isRedMarked) {
            return Container(
              margin: const EdgeInsets.all(4.0),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${day.day}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }
          return null; // 返回null使用默认样式
        },
      ),
    );
  }
}

/*

*/
