import 'package:flutter/material.dart';
import 'package:nirva_app/month_calendar_widget.dart';
import 'package:nirva_app/week_calendar_widget.dart';

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

  void _updateSelectedDay(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('测试日历!')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            MonthCalendarWidget(
              focusedDay: _focusedDay,
              selectedDay: _selectedDay,
              onDaySelected: _updateSelectedDay,
            ),
            const SizedBox(height: 16.0), // 添加间距
            WeekCalendarWidget(
              focusedDay: _focusedDay,
              selectedDay: _selectedDay,
              onDaySelected: _updateSelectedDay,
            ),
          ],
        ),
      ),
    );
  }
}
