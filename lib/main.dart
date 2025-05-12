import 'package:flutter/material.dart';
import 'package:nirva_app/main_app.dart';
import 'package:nirva_app/data_manager.dart';
import 'package:nirva_app/chat_manager.dart';
//import 'package:nirva_app/utils.dart';
import 'package:nirva_app/dio_service.dart';
import 'package:nirva_app/api.dart';
import 'dart:convert';
import 'package:nirva_app/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 确保初始化完成

  //使用示例
  final String serverIpAddress = "192.168.192.135";
  final int serverPort = 8000;
  final String path = "http://$serverIpAddress:$serverPort/api_endpoints/v1/";
  final response = await DioService().safePost(path, data: {});
  final apiEndPointResponse = APIEndpointConfigurationResponse.fromJson(
    response.data!,
  );

  String apiEndPointResponseJson = jsonEncode(apiEndPointResponse.toJson());
  Logger.d('apiEndPointResponseJson=\n$apiEndPointResponseJson');

  // 使用 Utils 类的静态方法读取并解析 JSON 文件
  // final Map<String, dynamic> jsonData = await Utils.loadJsonAsset(
  //   'assets/test.json',
  // );
  // debugPrint(jsonData.toString()); // 打印解析后的 Map 数据

  // 初始化其他模块
  DataManager().initialize();
  //await DataManager().loadTestData();
  ChatManager().initialize();

  // 运行应用
  runApp(const MainApp());
}
