import 'package:flutter/material.dart';
import 'package:nirva_app/assistant_chat_page.dart';
import 'package:nirva_app/chat_manager.dart';
import 'package:nirva_app/service_manager.dart';
import 'package:nirva_app/data_manager.dart';

class TestChatApp extends StatelessWidget {
  TestChatApp({super.key});

  // 缓存初始化结果
  final Future<bool> _initFuture = ServiceManager().get_url_config().then((
    isApiConfigurationSuccessful,
  ) async {
    if (!isApiConfigurationSuccessful) {
      return false;
    }
    return await ServiceManager().login(DataManager().userName);
  });

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
        //appBar: AppBar(title: const Text('测试对话')),
        body: FutureBuilder<bool>(
          future: _initFuture, // 使用缓存的 Future
          builder: (context, snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   // 显示加载指示器
            //   return const Center(child: CircularProgressIndicator());
            // } else if (snapshot.hasError || !(snapshot.data ?? false)) {
            //   // 显示错误信息
            //   return const Center(child: Text('API 初始化失败'));
            // } else {
            // API 初始化成功，显示 AssistantChatPage
            return AssistantChatPage(
              chatMessages: chatMessages,
              textController: textController,
            );
            //}
          },
        ),
      ),
    );
  }
}
