// 这是一个数据管理器类，负责管理应用程序中的数据结构和数据
// import 'package:nirva_app/data.dart';
// import 'package:flutter/foundation.dart';
import 'package:nirva_app/runtime_data.dart';
import 'package:nirva_app/nirva_chat.dart';

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

  RuntimeData get data {
    return _data;
  }

  NirvaChat get chat {
    return _chat;
  }
}
