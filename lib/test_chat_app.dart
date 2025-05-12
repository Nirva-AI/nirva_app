import 'package:flutter/material.dart';

class TestChatApp extends StatelessWidget {
  const TestChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Chat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('测试对话')),
        body: Center(child: Text('测试对话', style: TextStyle(fontSize: 24))),
      ),
    );
  }
}
