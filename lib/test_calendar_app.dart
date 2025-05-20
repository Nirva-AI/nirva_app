import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: const Text('测试日历!')));
  }
}
