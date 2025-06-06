// 这是一个数据管理器类，负责管理应用程序中的数据结构和数据
// import 'package:nirva_app/data.dart';
// import 'package:flutter/foundation.dart';
import 'package:nirva_app/runtime_data.dart';
import 'package:nirva_app/nirva_chat.dart';
import 'package:nirva_app/hive_storage.dart';
import 'package:nirva_app/url_configuration.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

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

  // Dio 实例和配置（从DioService合并过来）
  final Dio _appserviceDio = Dio(
      BaseOptions(
        baseUrl: 'http://192.168.2.70:8000',
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
}
