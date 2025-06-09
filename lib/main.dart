import 'package:flutter/material.dart';
import 'package:nirva_app/app_runtime_context.dart';
//import 'package:nirva_app/hive_object.dart';
import 'package:nirva_app/main_app.dart';
import 'package:nirva_app/test_data.dart';
//import 'package:nirva_app/test_chat_app.dart';
//import 'package:nirva_app/test_graph_view_app.dart';
//import 'package:nirva_app/test_calendar_app.dart';
//import 'package:nirva_app/hive_data.dart';
//import 'package:nirva_app/test_file_access_app.dart'; // 添加这一行

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 确保初始化完成

  // 执行异步操作，例如加载配置文件
  await initializeApp();

  // 运行核心应用
  runApp(const MainApp());
  //如果需要测试应用，可以取消下面的注释，下面会进入测试应用，隔离主应用进行专项测试
  //runApp(TestChatApp());
  //如果需要测试图形视图，可以取消下面的注释，下面会进入测试应用，隔离主应用进行专项测试
  //runApp(TestGraphViewApp());
  //如果需要测试日历视图，可以取消下面的注释，下面会进入测试应用，隔离主应用进行专项测试
  //runApp(const TestCalendarApp());
  //如果需要测试iOS文件应用访问，可以取消下面的注释
  //runApp(const TestFileAccessApp());
}

Future<void> initializeApp() async {
  // 在这里执行任何需要的初始化操作，例如加载配置文件
  // 例如：await loadConfig();
  // 或者其他异步操作
  await TestData.initializeTestData();

  // 测试 Hive 数据库
  await testHive();
}

Future<void> testHive() async {
  // 初始化 Hive
  await AppRuntimeContext().storage.deleteFromDisk(); // 清空之前的数据
  await AppRuntimeContext().storage.initializeAdapters();

  final retrievedFavorites = AppRuntimeContext().storage.getFavorites();
  if (retrievedFavorites != null && retrievedFavorites.favoriteIds.isNotEmpty) {
    debugPrint('DiaryFavorites 测试通过: 收藏夹数据存在');
    AppRuntimeContext().data.favorites.value = retrievedFavorites.favoriteIds;
  } else {
    debugPrint('DiaryFavorites 测试失败: 收藏夹数据不存在或为空');
  }

  final storageChatHistory = AppRuntimeContext().storage.getChatHistory();
  AppRuntimeContext().chat.chatHistory.value = storageChatHistory; // 清空之前的聊天记录
}
