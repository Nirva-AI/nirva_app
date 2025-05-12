// ignore_for_file: non_constant_identifier_names
// 请注意，本页是为了对接python fastapi服务器的数据定义的代码，命名风格完全和服务器一致，所以关警告。不要修改命名风格。
// 这是一个数据管理器类，负责管理应用程序中的数据结构和数据
import 'package:nirva_app/logger.dart';
import 'dart:convert';
import 'package:nirva_app/dio_service.dart';
import 'package:nirva_app/api.dart';

// 管理全局数据的类
class ServiceManager {
  // 单例模式
  static final ServiceManager _instance = ServiceManager._internal();
  factory ServiceManager() => _instance;
  ServiceManager._internal();

  APIEndpointConfiguration api_endpoints = APIEndpointConfiguration(
    LOGIN_URL: '',
    LOGOUT_URL: '',
    CHAT_ACTION_URL: '',
  );

  Future<void> postAPIEndPointConfiguration() async {
    //使用示例
    final String serverIpAddress = "192.168.192.135";
    final int serverPort = 8000;
    final String path = "http://$serverIpAddress:$serverPort/api_endpoints/v1/";
    final response = await DioService().safePost(path, data: {});
    final apiEndPointResponse = APIEndpointConfigurationResponse.fromJson(
      response.data!,
    );

    Logger.d(
      'apiEndPointResponse=\n${jsonEncode(apiEndPointResponse.toJson())}',
    );

    //api_endpoints = apiEndPointResponse.api_endpoints;
    Logger.d(
      'api_endpoints=\n${jsonEncode(apiEndPointResponse.api_endpoints.toJson())}',
    );

    api_endpoints = apiEndPointResponse.api_endpoints;
  }
}
