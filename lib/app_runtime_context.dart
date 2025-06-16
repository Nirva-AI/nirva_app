// 这是一个数据管理器类，负责管理应用程序中的数据结构和数据
import 'package:nirva_app/runtime_data.dart';
import 'package:nirva_app/nirva_chat.dart';
import 'package:nirva_app/hive_storage.dart';
import 'package:nirva_app/url_configuration.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:nirva_app/data.dart';

// 管理全局数据的类
class AppRuntimeContext {
  // 可重置的单例模式
  static AppRuntimeContext? _instance;
  static AppRuntimeContext get instance {
    _instance ??= AppRuntimeContext._internal();
    return _instance!;
  }

  factory AppRuntimeContext() => instance;
  AppRuntimeContext._internal();

  // 清空数据
  static void clear() {
    _instance = AppRuntimeContext._internal();
  }

  // 当前选中的日期时间
  DateTime _selectedDateTime = DateTime.now();

  // 当前的日记文件
  JournalFile? _currentJournalFile;

  // 空的日记文件实例
  final emptyJournalFile = JournalFile.createEmpty();

  // 数据管理器实例
  final RuntimeData _data = RuntimeData();

  // 聊天管理器实例
  final NirvaChat _chat = NirvaChat();

  // Hive 存储实例
  final HiveStorage _storage = HiveStorage();

  // URL 配置实例
  final URLConfiguration _urlConfig = URLConfiguration();

  // 用于基础app服务的 Dio 实例
  final Dio _appserviceDio = Dio(
      BaseOptions(
        baseUrl: 'http://192.168.192.123:8000',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 30),
      ),
    )
    ..interceptors.addAll([
      LogInterceptor(request: true, requestHeader: true, responseHeader: true),
      InterceptorsWrapper(
        onError: (error, handler) {
          Logger().e('Dio Error: ${error.message}');
          return handler.next(error);
        },
      ),
    ]);

  RuntimeData get data {
    return _data;
  }

  NirvaChat get chat {
    return _chat;
  }

  HiveStorage get storage {
    return _storage;
  }

  URLConfiguration get urlConfig {
    return _urlConfig;
  }

  Dio get appserviceDio {
    return _appserviceDio;
  }

  // 清除对话历史!
  Future<void> clearChatHistory() async {
    chat.chatHistory.value = [];
    await AppRuntimeContext().storage.clearChatHistory();
  }

  // 获取当前的日记文件。
  JournalFile get currentJournalFile {
    return _currentJournalFile ?? emptyJournalFile;
  }

  //
  DateTime get selectedDateTime {
    return _selectedDateTime;
  }

  //
  void selectDateTime(DateTime dateTime) {
    _selectedDateTime = dateTime;
    _onActiveJournalFile();
  }

  //
  void addJournalFile(JournalFile journalFile) {
    _data.setupJournalFiles(journalFiles + [journalFile]);
    _onActiveJournalFile();
  }

  //
  void initializeJournalFiles(List<JournalFile> files) {
    _data.setupJournalFiles(files);
    _onActiveJournalFile();
  }

  //
  void _onActiveJournalFile() {
    _currentJournalFile = null;
    for (var journalFile in journalFiles) {
      if (journalFile.time_stamp ==
          JournalFile.dateTimeToKey(_selectedDateTime)) {
        _currentJournalFile = journalFile;
      }
    }
  }

  //
  List<JournalFile> get journalFiles {
    // 获取所有的日记文件
    return _data.journalFiles.value;
  }

  //
  // 获取当前的社交地图
  Map<String, SocialEntity> buildSocialMap() {
    // 获取全局社交实体的映射
    final Map<String, SocialEntity> map = {};
    for (var journalFile in journalFiles) {
      Map<String, SocialEntity> subMap = journalFile.socialEntities;
      for (var key in subMap.keys) {
        if (!map.containsKey(key)) {
          map[key] = subMap[key]!;
        } else {
          // 如果已经存在，则合并
          map[key]!.merge(subMap[key]!);
        }
      }
    }
    return map;
  }

  // 获取全局社交地图
  double getTotalSocialHours() {
    // 计算全局社交时间
    double totalHours = 0;
    final global = buildSocialMap();
    for (var entity in global.values) {
      totalHours += entity.hours;
    }
    return totalHours;
  }
}
