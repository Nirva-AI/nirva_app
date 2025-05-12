import 'package:flutter/material.dart';
import 'package:nirva_app/main_app.dart';
import 'package:nirva_app/data_manager.dart';
import 'package:nirva_app/chat_manager.dart';
//import 'package:nirva_app/service_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 确保初始化完成

  //await ServiceManager().configureApiEndpoint();

  // 初始化其他模块
  DataManager().initialize();
  ChatManager().initialize();

  // 运行应用
  runApp(const MainApp());
}
