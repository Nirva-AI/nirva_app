//import 'dart:io'; // 用于获取应用的文档目录
import 'package:path_provider/path_provider.dart'; // 用于获取平台相关的存储路径
import 'package:hive/hive.dart';
import 'package:nirva_app/hive_data.dart';

class HiveManager {
  // 单例模式
  // 可重置的单例模式
  static HiveManager? _instance;

  static HiveManager get instance {
    _instance ??= HiveManager._internal();
    return _instance!;
  }

  factory HiveManager() => instance;

  HiveManager._internal();

  // 清空所有 Box 的数据并关闭所有 Box
  Future<void> deleteFromDisk() async {
    await Hive.deleteFromDisk();
  }

  //static const String _hiveTestBox = 'hiveTestBox';
  static const String _diaryFavoritesBox = 'diaryFavoritesBox';
  static const String _diaryFavoritesKey = 'favorites';

  // 初始化 Hive
  Future<void> initHive() async {
    // 获取应用的文档目录
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path); // 初始化 Hive 并设置存储路径

    // 初始化 HiveTest 的 Box
    //await initHiveTest();
    // 初始化 DiaryFavorites 的 Box
    await initDiaryFavorites();
  }

  // Future<void> initHiveTest() async {
  //   // 确保 Hive 已经初始化
  //   if (!Hive.isAdapterRegistered(0)) {
  //     Hive.registerAdapter(HiveTestAdapter());
  //   }
  //   if (!Hive.isBoxOpen(_hiveTestBox)) {
  //     await Hive.openBox<HiveTest>(_hiveTestBox);
  //   }
  // }

  // // 写入数据
  // Future<void> saveHiveTest(HiveTest hiveTest) async {
  //   final box = Hive.box<HiveTest>(_hiveTestBox);
  //   await box.put(hiveTest.id, hiveTest);
  // }

  // // 读取数据
  // HiveTest? getHiveTest(int id) {
  //   final box = Hive.box<HiveTest>(_hiveTestBox);
  //   return box.get(id);
  // }

  // 初始化 DiaryFavorites 的 Box
  Future<void> initDiaryFavorites() async {
    // 确保 Hive 已经初始化
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(DiaryFavoritesAdapter());
    }
    if (!Hive.isBoxOpen(_diaryFavoritesBox)) {
      await Hive.openBox<DiaryFavorites>(_diaryFavoritesBox);
    }
  }

  // 保存 DiaryFavorites 数据
  Future<void> saveDiaryFavorites(DiaryFavorites diaryFavorites) async {
    final box = Hive.box<DiaryFavorites>(_diaryFavoritesBox);
    await box.put(_diaryFavoritesKey, diaryFavorites); // 使用固定的 key 保存
  }

  // 获取 DiaryFavorites 数据
  DiaryFavorites? getDiaryFavorites() {
    final box = Hive.box<DiaryFavorites>(_diaryFavoritesBox);
    return box.get(_diaryFavoritesKey); // 使用固定的 key 获取
  }
}
