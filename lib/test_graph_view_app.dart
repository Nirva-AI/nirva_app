import 'package:flutter/material.dart';

class TestGraphViewApp extends StatelessWidget {
  const TestGraphViewApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Graph View App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const TestGraphView(), // 使用新的 TestGraphView 类
    );
  }
}

class TestGraphView extends StatelessWidget {
  const TestGraphView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('测试图形视图')),
      body: const Center(child: Text('这是一个测试图形视图')),
    );
  }
}
