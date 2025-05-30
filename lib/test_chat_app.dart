import 'package:flutter/material.dart';
import 'package:nirva_app/assistant_chat_page.dart';
import 'package:nirva_app/apis.dart';
//import 'package:nirva_app/app_runtime_context.dart';
import 'package:logger/logger.dart';

class TestChatApp extends StatelessWidget {
  TestChatApp({super.key});

  // 缓存初始化结果
  final Future<bool> _initFuture = Future(() async {
    try {
      // 使用 APIs.getUrlConfig() 替代 ServiceProvider().getUrlConfig()
      final urlConfig = await APIs.getUrlConfig();
      if (urlConfig == null) {
        Logger().e('获取 URL 配置失败');
        return false;
      }

      Logger().i('API 初始化成功');

      final token = await APIs.login();
      if (token == null) {
        Logger().e('登录失败，未获取到 token');
        return false;
      }

      // final refreshToken = await APIs.refreshToken();
      // if (!refreshToken) {
      //   Logger().e('刷新 token 失败');
      //   return false;
      // }

      // Logger().i('刷新 token 成功');

      // final logout = await APIs.logout();
      // if (!logout) {
      //   Logger().e('登出失败');
      //   return false;
      // }
      // Logger().i('登出成功');

      return true;
    } catch (e) {
      Logger().e('API 初始化失败: $e');
      return false;
    }
  });

  @override
  Widget build(BuildContext context) {
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
              //chatMessages: chatMessages,
              textController: textController,
            );
            //}
          },
        ),
      ),
    );
  }
}
