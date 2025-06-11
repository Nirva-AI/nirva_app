import 'package:flutter/material.dart';

class TestChartApp extends StatelessWidget {
  const TestChartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '测试图表',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TestChartPage(),
    );
  }
}

class TestChartPage extends StatefulWidget {
  const TestChartPage({super.key});

  @override
  State<TestChartPage> createState() => _TestChartPageState();
}

class _TestChartPageState extends State<TestChartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('测试图表')),
      body: const Center(child: Text('测试图表页面')),
    );
  }
}
