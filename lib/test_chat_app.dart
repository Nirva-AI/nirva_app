import 'package:flutter/material.dart';
import 'package:nirva_app/assistant_chat_panel.dart';
import 'package:nirva_app/chat_manager.dart';
import 'package:nirva_app/service_manager.dart';

class TestChatApp extends StatelessWidget {
  const TestChatApp({super.key});

  Future<bool> _initializeApi() async {
    return await ServiceManager().configureApiEndpoint();
  }

  @override
  Widget build(BuildContext context) {
    final chatMessages = ChatManager().getMessages();
    final textController = TextEditingController();

    return MaterialApp(
      title: 'Test Chat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('测试对话')),
        body: FutureBuilder<bool>(
          future: _initializeApi(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // 显示加载指示器
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || !(snapshot.data ?? false)) {
              // 显示错误信息
              return const Center(child: Text('API 初始化失败'));
            } else {
              // API 初始化成功，显示 AssistantChatPanel
              return AssistantChatPanel(
                chatMessages: chatMessages,
                textController: textController,
                //onSend: (message) {},
              );
            }
          },
        ),
      ),
    );
  }
}
