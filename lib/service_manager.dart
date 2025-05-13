// ignore_for_file: non_constant_identifier_names
// 请注意，本页是为了对接python fastapi服务器的数据定义的代码，命名风格完全和服务器一致，所以关警告。不要修改命名风格。
// 这是一个数据管理器类，负责管理应用程序中的数据结构和数据
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:nirva_app/dio_service.dart';
import 'package:nirva_app/api.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';

// 管理全局数据的类
class ServiceManager {
  // 单例模式
  static final ServiceManager _instance = ServiceManager._internal();
  factory ServiceManager() => _instance;
  ServiceManager._internal();

  final DioService _dioService = DioService();

  APIEndpointConfiguration api_endpoints = APIEndpointConfiguration(
    LOGIN_URL: '',
    LOGOUT_URL: '',
    CHAT_ACTION_URL: '',
  );

  // API_ENDPOINTS_URL 是一个 getter 方法，用于获取 API 端点的 URL
  String get API_ENDPOINTS_URL {
    final String serverIpAddress = "127.0.0.1";
    final int serverPort = 8000;
    final String path = "http://$serverIpAddress:$serverPort/api_endpoints/v1/";
    return path;
  }

  // 配置 API 端点
  Future<bool> configureApiEndpoint() async {
    try {
      final response = await _dioService.safePost(API_ENDPOINTS_URL, data: {});
      final apiEndPointResponse = APIEndpointConfigurationResponse.fromJson(
        response.data!,
      );

      Logger().d(
        'apiEndPointResponse=\n${jsonEncode(apiEndPointResponse.toJson())}',
      );
      // 解析 API 端点配置
      api_endpoints = apiEndPointResponse.api_endpoints;
      return true;
    } on DioException catch (e) {
      // 处理 DioException
      debugPrint('Caught a DioException: ${e.message}');
      debugPrint('Response data: ${e.response?.data}');

      // 使用 switch 处理 DioException 的类型
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          debugPrint('Connection timeout occurred.');
          break;
        case DioExceptionType.badResponse:
          debugPrint(
            'Server responded with an error: ${e.response?.statusCode}',
          );
          break;
        case DioExceptionType.connectionError:
          debugPrint('Connection error occurred.');
          break;
        case DioExceptionType.receiveTimeout:
          debugPrint('Receive timeout occurred.');
          break;
        case DioExceptionType.sendTimeout:
          debugPrint('Send timeout occurred.');
          break;
        default:
          debugPrint('Unknown error occurred: ${e.message}');
          break;
      }
    } catch (e) {
      debugPrint('Caught an unknown error of type: ${e.runtimeType}');
      debugPrint('Error details: $e');
    }

    return false;
  }

  String apiEndPointsJson() {
    return jsonEncode(api_endpoints.toJson());
  }
}
