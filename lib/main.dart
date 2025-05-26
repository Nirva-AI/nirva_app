import 'package:flutter/material.dart';
import 'package:nirva_app/data_manager.dart';
import 'package:nirva_app/main_app.dart';
import 'package:nirva_app/test_data.dart';
//import 'package:nirva_app/test_chat_app.dart';
//import 'package:nirva_app/test_graph_view_app.dart';
//import 'package:nirva_app/test_calendar_app.dart';
import 'package:nirva_app/hive_manager.dart';
//import 'package:nirva_app/hive_data.dart';

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
}

Future<void> initializeApp() async {
  // 在这里执行任何需要的初始化操作，例如加载配置文件
  // 例如：await loadConfig();
  // 或者其他异步操作
  TestData.initializeTestData();

  // 测试 Hive 数据库
  await testHive();
}

Future<void> testHive() async {
  // 初始化 Hive
  //await HiveManager().deleteFromDisk(); // 清空之前的数据
  await HiveManager().initHive();

  // 测试存储和读取数据
  // final testHiveData = HiveTest(1, 'Test Name');
  // await HiveManager().saveHiveTest(testHiveData);

  // final retrievedData = HiveManager().getHiveTest(1);

  // if (retrievedData != null &&
  //     retrievedData.id == testHiveData.id &&
  //     retrievedData.name == testHiveData.name) {
  //   debugPrint('Hive 测试通过: 数据一致');
  // } else {
  //   debugPrint('Hive 测试失败: 数据不一致');
  // }

  // final diaryFavorites = DiaryFavorites(
  //   favoriteIds: DataManager().diaryFavoritesNotifier.value,
  // );
  // await HiveManager().saveDiaryFavorites(diaryFavorites);

  final retrievedFavorites = HiveManager().getDiaryFavorites();
  if (retrievedFavorites != null && retrievedFavorites.favoriteIds.isNotEmpty) {
    debugPrint('DiaryFavorites 测试通过: 收藏夹数据存在');
    DataManager().diaryFavoritesNotifier.value = retrievedFavorites.favoriteIds;
  } else {
    debugPrint('DiaryFavorites 测试失败: 收藏夹数据不存在或为空');
  }
}
