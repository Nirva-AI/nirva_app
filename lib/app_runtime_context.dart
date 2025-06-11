// 这是一个数据管理器类，负责管理应用程序中的数据结构和数据
import 'package:nirva_app/runtime_data.dart';
import 'package:nirva_app/nirva_chat.dart';
import 'package:nirva_app/hive_storage.dart';
import 'package:nirva_app/url_configuration.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:nirva_app/data.dart';
import 'dart:convert';
import 'package:nirva_app/hive_object.dart';
import 'package:nirva_app/utils.dart';

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

  // 数据管理器实例
  final RuntimeData _data = RuntimeData();

  // 聊天管理器实例
  final NirvaChat _chat = NirvaChat();

  // Hive 存储实例
  final HiveStorage _storage = HiveStorage();

  // URL 配置实例
  final URLConfiguration _urlConfig = URLConfiguration();

  //static const String _baseUrl = 'http://192.168.192.100:8000';

  // 用于基础app服务的 Dio 实例
  final Dio _appserviceDio = Dio(
      BaseOptions(
        baseUrl: 'http://192.168.192.104:8000',
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
    final currentDate = _data.selectedDateTime;

    // 读一下试试
    final makeStorageKeyDateTime = DateTime(
      currentDate.year,
      currentDate.month,
      currentDate.day,
    );
    final journalFileStorage = _storage.getJournalFile(
      Utils.formatDateTimeToIso(makeStorageKeyDateTime),
    );
    if (journalFileStorage == null) {
      return JournalFile.createEmpty();
    }
    return journalStorageToJournalFile(journalFileStorage);
  }

  // 将 JournalFileStorage 转换为 JournalFile
  JournalFile journalStorageToJournalFile(
    JournalFileStorage journalFileStorage,
  ) {
    final jsonDecode =
        json.decode(journalFileStorage.content) as Map<String, dynamic>;
    return JournalFile.fromJson(jsonDecode);
  }

  //
  List<JournalFile> get allJournalFiles {
    final index = _storage.getJournalIndex();
    if (index.files.isEmpty) {
      return [];
    }

    List<JournalFile> ret = [];
    for (var fileMeta in index.files) {
      final journalFileStorage = _storage.getJournalFile(fileMeta.fileName);
      if (journalFileStorage != null) {
        final journalFile = journalStorageToJournalFile(journalFileStorage);
        ret.add(journalFile);
      } else {
        Logger().w('Journal file not found: ${fileMeta.fileName}');
      }
    }

    return ret;
  }

  //
  // 获取当前的社交地图
  Map<String, SocialEntity2> genGlobalSocialEntitiesMap() {
    // 获取全局社交实体的映射
    final Map<String, SocialEntity2> map = {};
    for (var journalFile in allJournalFiles) {
      Map<String, SocialEntity2> subMap = journalFile.socialEntities;
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
    final global = genGlobalSocialEntitiesMap();
    for (var entity in global.values) {
      totalHours += entity.hours;
    }
    return totalHours;
  }
}
