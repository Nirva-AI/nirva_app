import 'package:flutter/material.dart';
//import 'package:nirva_app/main_app.dart';
import 'package:nirva_app/fill_test_data.dart';
// import 'package:nirva_app/test_chat_app.dart';
import 'package:nirva_app/test_graph_view_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 确保初始化完成

  // 执行异步操作，例如加载配置文件
  await initializeApp();

  // 运行核心应用
  //runApp(const MainApp());
  // 如果需要测试应用，可以取消下面的注释，下面会进入测试应用，隔离主应用进行专项测试
  //runApp(TestChatApp());
  // 如果需要测试图形视图，可以取消下面的注释，下面会进入测试应用，隔离主应用进行专项测试
  runApp(TestGraphViewApp());
}

Future<void> initializeApp() async {
  // 在这里执行任何需要的初始化操作，例如加载配置文件
  // 例如：await loadConfig();
  // 或者其他异步操作
  FillTestData.fillTestData();
}
