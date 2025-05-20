import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TestCalendarApp extends StatelessWidget {
  const TestCalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Calendar App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const TestCalendarView(),
    );
  }
}

class TestCalendarView extends StatefulWidget {
  const TestCalendarView({super.key});

  @override
  State<TestCalendarView> createState() => _TestCalendarViewState();
}

class _TestCalendarViewState extends State<TestCalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('测试日历!')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildFirstCalendar(),
            const SizedBox(height: 16.0), // 添加间距
            _buildSecondCalendar(),
          ],
        ),
      ),
    );
  }

  // 封装第一个 TableCalendar
  Widget _buildFirstCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2000, 1, 1),
      lastDay: DateTime.utc(2100, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.orange,
          shape: BoxShape.circle,
        ),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
    );
  }

  // 封装第二个 TableCalendar
  Widget _buildSecondCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2000, 1, 1),
      lastDay: DateTime.utc(2100, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      calendarFormat: CalendarFormat.week, // 设置为周视图
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Color(0xFFFFD700), // 金黄色背景
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Color(0xFFFFD700), // 金黄色背景
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
