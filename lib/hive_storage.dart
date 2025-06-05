//import 'dart:io'; // 用于获取应用的文档目录
import 'package:path_provider/path_provider.dart'; // 用于获取平台相关的存储路径
import 'package:hive/hive.dart';
import 'package:nirva_app/hive_object.dart';

class HiveStorage {
  // 现有的常量定义
  static const String _favoritesBox = 'favoritesBox';
  static const String _favoritesKey = 'favorites';

  // 新增 Token 相关的常量定义
  static const String _userTokenBox = 'userTokenBox';
  static const String _userTokenKey = 'userToken';

  Future<void> _initialize() async {
    // 获取应用的文档目录
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path); // 初始化 Hive 并设置存储路径
  }

  //清空所有 Box 的数据并关闭所有 Box
  Future<void> deleteFromDisk() async {
    await _initialize(); // 确保 Hive 已经初始化
    await Hive.deleteBoxFromDisk(_favoritesBox);
    await Hive.deleteBoxFromDisk(_userTokenBox);
    await Hive.close(); // 关闭所有打开的 Box
    await Hive.deleteFromDisk();
  }

  // 初始化 Hive
  Future<void> initializeAdapters() async {
    await _initialize(); // 确保 Hive 已经初始化
    // 并发初始化所有 Box
    await Future.wait([_initFavorites(), _initUserToken()]);
  }

  // 初始化 DiaryFavorites 的 Box
  Future<void> _initFavorites() async {
    // 确保 Hive 已经初始化
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(FavoritesAdapter());
    }
    if (!Hive.isBoxOpen(_favoritesBox)) {
      await Hive.openBox<Favorites>(_favoritesBox);
    }
  }

  // 新增: 初始化 Token 的 Box
  Future<void> _initUserToken() async {
    // 确保 Hive 已经初始化
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(UserTokenAdapter());
    }
    if (!Hive.isBoxOpen(_userTokenBox)) {
      await Hive.openBox<UserToken>(_userTokenBox);
    }
  }

  // 保存 DiaryFavorites 数据
  Future<void> saveFavorites(Favorites diaryFavorites) async {
    final box = Hive.box<Favorites>(_favoritesBox);
    await box.put(_favoritesKey, diaryFavorites); // 使用固定的 key 保存
  }

  // 获取 DiaryFavorites 数据
  Favorites? getFavorites() {
    final box = Hive.box<Favorites>(_favoritesBox);
    return box.get(_favoritesKey); // 使用固定的 key 获取
  }

  // 新增: 保存 Token 数据
  Future<void> saveUserToken(UserToken token) async {
    final box = Hive.box<UserToken>(_userTokenBox);
    await box.put(_userTokenKey, token); // 使用固定的 key 保存
  }

  // 新增: 获取 Token 数据
  UserToken getUserToken() {
    final box = Hive.box<UserToken>(_userTokenBox);
    final res = box.get(_userTokenKey); // 使用固定的 key 获取
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
    final box = Hive.box<UserToken>(_userTokenBox);
    await box.delete(_userTokenKey);
  }

  // 获取所有 Hive 数据的统计信息和内容
  Map<String, dynamic> getAllData() {
    final Map<String, dynamic> data = {};

    // 获取收藏夹数据
    if (Hive.isBoxOpen(_favoritesBox)) {
      final favBox = Hive.box<Favorites>(_favoritesBox);
      final favorites = favBox.get(_favoritesKey);
      data['favorites'] = favorites;
    }

    // 获取用户令牌数据
    if (Hive.isBoxOpen(_userTokenBox)) {
      final tokenBox = Hive.box<UserToken>(_userTokenBox);
      final token = tokenBox.get(_userTokenKey);
      data['userToken'] = token;
    }

    return data;
  }
}
