//import 'dart:io'; // 用于获取应用的文档目录
import 'package:path_provider/path_provider.dart'; // 用于获取平台相关的存储路径
import 'package:hive/hive.dart';
import 'package:nirva_app/hive_data.dart';

class HiveManager {
  // 单例模式
  HiveManager._privateConstructor();
  static final HiveManager instance = HiveManager._privateConstructor();

  static const String _boxName = 'hiveTestBox';

  // 初始化 Hive
  Future<void> initHive() async {
    // 获取应用的文档目录
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path); // 初始化 Hive 并设置存储路径

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(HiveTestAdapter());
    }
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<HiveTest>(_boxName);
    }
  }

  // 写入数据
  Future<void> saveHiveTest(HiveTest hiveTest) async {
    final box = Hive.box<HiveTest>(_boxName);
    await box.put(hiveTest.id, hiveTest);
  }

  // 读取数据
  HiveTest? getHiveTest(int id) {
    final box = Hive.box<HiveTest>(_boxName);
    return box.get(id);
  }
}
