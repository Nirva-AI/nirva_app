import 'package:flutter/material.dart';
import 'package:nirva_app/main_app.dart';
//import 'package:nirva_app/test_chat_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 确保初始化完成

  // 执行异步操作，例如加载配置文件
  await initializeApp();

  // 运行应用
  //runApp(const TestChatApp());
  runApp(const MainApp());
}

Future<void> initializeApp() async {
  // 在这里执行任何需要的初始化操作，例如加载配置文件
  // 例如：await loadConfig();
  // 或者其他异步操作
}
