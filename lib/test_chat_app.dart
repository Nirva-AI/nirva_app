import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nirva_app/assistant_chat_page.dart';
import 'package:nirva_app/nirva_api.dart';
import 'package:nirva_app/providers/user_provider.dart';
import 'package:logger/logger.dart';

class TestChatApp extends StatelessWidget {
  const TestChatApp({super.key});

  // 将初始化逻辑改为方法，接收 context 参数
  Future<bool> _initializeAPI(BuildContext context) async {
    try {
      // 在异步操作前获取所有需要 context 的数据
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final user = userProvider.user;

      // 然后进行异步操作
      final urlConfig = await NirvaAPI.getUrlConfig();
      if (urlConfig == null) {
        Logger().e('获取 URL 配置失败');
        return false;
      }

      Logger().i('API 初始化成功');

      final token = await NirvaAPI.login(user);
      if (token == null) {
        Logger().e('登录失败，未获取到 token');
        return false;
      }

      final refreshToken = await NirvaAPI.refreshToken();
      if (refreshToken == null) {
        Logger().e('刷新 token 失败');
        return false;
      }

      Logger().i('刷新 token 成功');

      return true;
    } catch (e) {
      Logger().e('API 初始化失败: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    return MaterialApp(
      title: 'Test Chat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: Scaffold(
        body: FutureBuilder<bool>(
          future: _initializeAPI(context), // 调用方法并传入 context
          builder: (context, snapshot) {
            return AssistantChatPage(textController: textController);
            //}
          },
        ),
      ),
    );
  }
}
