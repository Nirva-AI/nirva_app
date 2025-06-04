//import 'dart:io'; // 用于获取应用的文档目录
import 'package:path_provider/path_provider.dart'; // 用于获取平台相关的存储路径
import 'package:hive/hive.dart';
import 'package:nirva_app/hive_object.dart';

class HiveStorage {
  // 现有的常量定义
  static const String _diaryFavoritesBox = 'diaryFavoritesBox';
  static const String _diaryFavoritesKey = 'favorites';

  // 新增 Token 相关的常量定义
  static const String _tokenBox = 'userTokenBox';
  static const String _tokenKey = 'userToken';

  //清空所有 Box 的数据并关闭所有 Box
  Future<void> deleteFromDisk() async {
    await Hive.deleteFromDisk();
  }

  // 初始化 Hive
  Future<void> initialize() async {
    // 获取应用的文档目录
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path); // 初始化 Hive 并设置存储路径

    // 并发初始化所有 Box
    await Future.wait([_initFavorites(), _initUserToken()]);
  }

  // 初始化 DiaryFavorites 的 Box
  Future<void> _initFavorites() async {
    // 确保 Hive 已经初始化
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(FavoritesAdapter());
    }
    if (!Hive.isBoxOpen(_diaryFavoritesBox)) {
      await Hive.openBox<Favorites>(_diaryFavoritesBox);
    }
  }

  // 新增: 初始化 Token 的 Box
  Future<void> _initUserToken() async {
    // 确保 Hive 已经初始化
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(UserTokenAdapter());
    }
    if (!Hive.isBoxOpen(_tokenBox)) {
      await Hive.openBox<UserToken>(_tokenBox);
    }
  }

  // 保存 DiaryFavorites 数据
  Future<void> saveFavorites(Favorites diaryFavorites) async {
    final box = Hive.box<Favorites>(_diaryFavoritesBox);
    await box.put(_diaryFavoritesKey, diaryFavorites); // 使用固定的 key 保存
  }

  // 获取 DiaryFavorites 数据
  Favorites? getFavorites() {
    final box = Hive.box<Favorites>(_diaryFavoritesBox);
    return box.get(_diaryFavoritesKey); // 使用固定的 key 获取
  }

  // 新增: 保存 Token 数据
  Future<void> saveUserToken(UserToken token) async {
    final box = Hive.box<UserToken>(_tokenBox);
    await box.put(_tokenKey, token); // 使用固定的 key 保存
  }

  // 新增: 获取 Token 数据
  UserToken getUserToken() {
    final box = Hive.box<UserToken>(_tokenBox);
    final res = box.get(_tokenKey); // 使用固定的 key 获取
    if (res == null) {
      return UserToken(
        access_token: '',
        token_type: '',
        refresh_token: '',
      ); // 返回一个默认的 Token 对象
    }
    return res;
  }

  // 新增: 删除 Token 数据 (登出时使用)
  Future<void> deleteUserToken() async {
    final box = Hive.box<UserToken>(_tokenBox);
    await box.delete(_tokenKey);
  }
}
