// ignore_for_file: non_constant_identifier_names
// 请注意，本页是为了对接python fastapi服务器的数据定义的代码，命名风格完全和服务器一致，所以关警告。不要修改命名风格。
// 这是一个数据管理器类，负责管理应用程序中的数据结构和数据
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:nirva_app/api.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:nirva_app/hive_object.dart';
import 'package:nirva_app/hive_manager.dart';

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

  // Dio 实例和配置（从DioService合并过来）
  final Dio _dio = Dio(
      BaseOptions(
        baseUrl: 'http://192.168.22.108:8000',
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

  URLConfigurationResponse _urlConfig = URLConfigurationResponse(
    api_version: '',
    endpoints: {},
    deprecated: false,
    notice: '',
  );

  String get loginUrl {
    return _urlConfig.endpoints['login'] ?? '';
  }

  String get logoutUrl {
    return _urlConfig.endpoints['logout'] ?? '';
  }

  String get chatActionUrl {
    return _urlConfig.endpoints['chat'] ?? '';
  }

  Token get userToken {
    // 从Hive中获取Token
    return HiveManager().getToken() ??
        Token(access_token: '', token_type: '', refresh_token: '');
  }

  // 从DioService合并过来的通用POST方法
  Future<Response<T>?> safePost<T>(
    String path,
    Token token, {
    Object? data,
    Map<String, dynamic>? query,
  }) async {
    Logger().d('POST Request - URL: $path, Data: $data');

    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: query,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${token.access_token}',
          },
        ),
      );

      if (response.statusCode == 200) {
        Logger().d('POST Response: ${response.data}');
        return response;
      } else {
        Logger().e('Error: ${response.statusCode}, ${response.statusMessage}');
        return null;
      }
    } on DioException catch (e) {
      Logger().e('POST Error: ${e.type}, ${e.message}');
      debugPrint('Response data: ${e.response?.data}');
      return null;
    } catch (e) {
      Logger().e('Unknown error during POST request: $e');
      return null;
    }
  }

  // 配置 API 端点, 后续可以写的复杂一些。
  Future<bool> getUrlConfig() async {
    try {
      // 将safeGet的实现直接合并到这里
      final response = await _dio.get<dynamic>("/config");
      _urlConfig = URLConfigurationResponse.fromJson(response.data!);

      Logger().d(
        '_url_configuration_response=\n${jsonEncode(_urlConfig.toJson())}',
      );
      return true;
    } on DioException catch (e) {
      // 处理 DioException
      Logger().e('GET Error: ${e.type}');
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
  Future<bool> login(String userName, String password) async {
    try {
      // 直接将_performLogin的逻辑合并到login方法中
      final response = await _dio.post<Map<String, dynamic>>(
        loginUrl,
        data: {
          'username': userName,
          'password': password,
          'grant_type': 'password',
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType, // OAuth2默认表单格式
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final token = Token(
          access_token: response.data!['access_token'] ?? '',
          token_type: response.data!['token_type'] ?? '',
          refresh_token: response.data!['refresh_token'] ?? '', // 新增字段
        );
        HiveManager().saveToken(token); // 保存到Hive中
        Logger().i('登录成功！令牌已获取');
        return true;
      } else {
        Logger().e('登录失败，请检查用户名和密码');
        return false;
      }
    } on DioException catch (e) {
      Logger().e('登录失败: ${e.message}');
      debugPrint('Caught a DioException during login: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Caught an unknown error during login: $e');
      return false;
    }
  }

  // 聊天请求
  Future<ChatActionResult> chatAction(String userName, String content) async {
    try {
      // 更改泛型参数为 Map<String, dynamic>
      final response = await safePost<Map<String, dynamic>>(
        chatActionUrl,
        userToken,
        data: ChatActionRequest(content: content).toJson(),
      );

      if (response == null || response.data == null) {
        Logger().e('Chat action failed: No response data');
        return ChatActionResult(success: false, message: '聊天请求失败，请稍后重试。');
      }

      // 手动将 Map 转换为 ChatActionResponse 对象
      final chatResponse = ChatActionResponse.fromJson(response.data!);

      Logger().d('Chat action response: ${jsonEncode(chatResponse.toJson())}');
      return ChatActionResult(success: true, message: chatResponse.message);
    } on DioException catch (e) {
      debugPrint('Caught a DioException during chat action: ${e.message}');
      return ChatActionResult(success: false, message: '网络错误，请稍后重试。');
    } catch (e) {
      debugPrint('Caught an unknown error during chat action: $e');
      return ChatActionResult(success: false, message: '未知错误，请稍后重试。');
    }
  }

  Future<bool> logout() async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        logoutUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${userToken.access_token}',
          },
        ),
      );

      if (response.statusCode == 200) {
        await HiveManager().deleteToken(); // 清除本地令牌
        Logger().i('登出成功！令牌已清除');
        return true;
      } else {
        Logger().e('登出失败，请稍后重试');
        return false;
      }
    } on DioException catch (e) {
      Logger().e('登出失败: ${e.message}');
      debugPrint('Caught a DioException during logout: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Caught an unknown error during logout: $e');
      return false;
    }
  }
}
