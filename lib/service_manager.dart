// ignore_for_file: non_constant_identifier_names
// 请注意，本页是为了对接python fastapi服务器的数据定义的代码，命名风格完全和服务器一致，所以关警告。不要修改命名风格。
// 这是一个数据管理器类，负责管理应用程序中的数据结构和数据
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:nirva_app/dio_service.dart';
import 'package:nirva_app/api.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';

class ChatActionResult {
  final bool success;
  final String message;

  ChatActionResult({required this.success, required this.message});
}

// 管理全局数据的类
class ServiceManager {
  static ServiceManager? _instance;

  static ServiceManager get instance {
    _instance ??= ServiceManager._internal();
    return _instance!;
  }

  factory ServiceManager() => instance;

  ServiceManager._internal();

  final DioService _dioService = DioService();

  URLConfigurationResponse _url_configuration_response =
      URLConfigurationResponse(
        api_version: '',
        endpoints: {},
        deprecated: false,
        notice: '',
      );

  String get login_url {
    return _url_configuration_response.endpoints['login'] ?? '';
  }

  String get logout_url {
    return _url_configuration_response.endpoints['logout'] ?? '';
  }

  String get chat_action_url {
    return _url_configuration_response.endpoints['chat'] ?? '';
  }

  // 配置 API 端点, 后续可以写的复杂一些。
  Future<bool> get_url_config() async {
    try {
      final response = await _dioService.safeGet("/config");
      _url_configuration_response = URLConfigurationResponse.fromJson(
        response.data!,
      );

      Logger().d(
        '_url_configuration_response=\n${jsonEncode(_url_configuration_response.toJson())}',
      );
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

  // 登录请求
  Future<bool> login(String userName) async {
    try {
      final response = await _dioService.safePost(
        login_url,
        data: LoginRequest(user_name: userName).toJson(),
      );

      final loginResponse = LoginResponse.fromJson(response.data!);

      if (loginResponse.error == 0) {
        Logger().d('Login successful: ${loginResponse.message}');
        return true;
      } else {
        Logger().e('Login failed: ${loginResponse.message}');
        return false;
      }
    } on DioException catch (e) {
      debugPrint('Caught a DioException during login: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Caught an unknown error during login: $e');
      return false;
    }
  }

  // 登出请求
  Future<bool> logout(String userName) async {
    try {
      final response = await _dioService.safePost(
        logout_url,
        data: LogoutRequest(user_name: userName).toJson(),
      );

      final logoutResponse = LogoutResponse.fromJson(response.data!);

      if (logoutResponse.error == 0) {
        Logger().d('Logout successful: ${logoutResponse.message}');
        return true;
      } else {
        Logger().e('Logout failed: ${logoutResponse.message}');
        return false;
      }
    } on DioException catch (e) {
      debugPrint('Caught a DioException during logout: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Caught an unknown error during logout: $e');
      return false;
    }
  }

  // 聊天请求
  Future<ChatActionResult> chatAction(String userName, String content) async {
    try {
      final response = await _dioService.safePost(
        chat_action_url,
        data: ChatActionRequest(user_name: userName, content: content).toJson(),
      );

      final chatActionResponse = ChatActionResponse.fromJson(response.data!);

      if (chatActionResponse.error == 0) {
        Logger().d('Chat action successful: ${chatActionResponse.message}');
        return ChatActionResult(
          success: true,
          message: chatActionResponse.message,
        );
      } else {
        Logger().e('Chat action failed: ${chatActionResponse.message}');
        return ChatActionResult(
          success: false,
          message: chatActionResponse.message,
        );
      }
    } on DioException catch (e) {
      debugPrint('Caught a DioException during chat action: ${e.message}');
      return ChatActionResult(success: false, message: '网络错误，请稍后重试。');
    } catch (e) {
      debugPrint('Caught an unknown error during chat action: $e');
      return ChatActionResult(success: false, message: '未知错误，请稍后重试。');
    }
  }
}
