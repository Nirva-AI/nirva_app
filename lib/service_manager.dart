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
        baseUrl: 'http://192.168.2.67:8000',
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

  String get refreshUrl {
    return _urlConfig.endpoints['refresh'] ?? '';
  }

  Token get userToken {
    // 从Hive中获取Token
    return HiveManager().getToken() ??
        Token(access_token: '', token_type: '', refresh_token: '');
  }

  // 安全的POST请求方法
  Future<Response<T>?> _safePost<T>(
    String path,
    Token token, {
    Object? data,
    Map<String, dynamic>? query,
  }) async {
    Logger().d('POST Request - URL: $path, Data: $data');

    try {
      // 初始请求
      var response = await _dio.post<T>(
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
      // 处理401错误（令牌过期）
      if (e.response?.statusCode == 401 && token.refresh_token.isNotEmpty) {
        Logger().i("令牌已过期，尝试刷新...");

        // 尝试刷新令牌
        bool refreshSuccess = await _refreshToken();

        if (refreshSuccess) {
          Logger().i("令牌刷新成功，重新尝试请求");
          // 获取刷新后的令牌
          Token newToken = userToken;

          // 使用新令牌重新发送请求
          try {
            var newResponse = await _dio.post<T>(
              path,
              data: data,
              queryParameters: query,
              options: Options(
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer ${newToken.access_token}',
                },
              ),
            );

            if (newResponse.statusCode == 200) {
              Logger().d('使用新令牌的 POST Response: ${newResponse.data}');
              return newResponse;
            } else {
              Logger().e(
                '使用新令牌请求仍然失败: ${newResponse.statusCode}, ${newResponse.statusMessage}',
              );
              return null;
            }
          } catch (retryError) {
            Logger().e('使用新令牌重试失败: $retryError');
            return null;
          }
        } else {
          Logger().e("令牌刷新失败");
          return null;
        }
      }

      // 其他类型的错误
      Logger().e('POST Error: ${e.type}, ${e.message}');
      debugPrint('Response data: ${e.response?.data}');
      return null;
    } catch (e) {
      Logger().e('Unknown error during POST request: $e');
      return null;
    }
  }

  // 安全的GET请求方法
  // ignore: unused_element
  Future<Response<T>?> _safeGet<T>(
    String path,
    Token token, {
    Map<String, dynamic>? query,
  }) async {
    Logger().d('GET Request - URL: $path, Query: $query');

    try {
      // 初始请求
      var response = await _dio.get<T>(
        path,
        queryParameters: query,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${token.access_token}',
          },
        ),
      );

      if (response.statusCode == 200) {
        Logger().d('GET Response: ${response.data}');
        return response;
      } else {
        Logger().e('Error: ${response.statusCode}, ${response.statusMessage}');
        return null;
      }
    } on DioException catch (e) {
      // 处理401错误（令牌过期）
      if (e.response?.statusCode == 401 && token.refresh_token.isNotEmpty) {
        Logger().i("令牌已过期，尝试刷新...");

        // 尝试刷新令牌
        bool refreshSuccess = await _refreshToken();

        if (refreshSuccess) {
          Logger().i("令牌刷新成功，重新尝试请求");
          // 获取刷新后的令牌
          Token newToken = userToken;

          // 使用新令牌重新发送请求
          try {
            var newResponse = await _dio.get<T>(
              path,
              queryParameters: query,
              options: Options(
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer ${newToken.access_token}',
                },
              ),
            );

            if (newResponse.statusCode == 200) {
              Logger().d('使用新令牌的 GET Response: ${newResponse.data}');
              return newResponse;
            } else {
              Logger().e(
                '使用新令牌请求仍然失败: ${newResponse.statusCode}, ${newResponse.statusMessage}',
              );
              return null;
            }
          } catch (retryError) {
            Logger().e('使用新令牌重试失败: $retryError');
            return null;
          }
        } else {
          Logger().e("令牌刷新失败");
          return null;
        }
      }

      // 其他类型的错误
      Logger().e('GET Error: ${e.type}, ${e.message}');
      debugPrint('Response data: ${e.response?.data}');
      return null;
    } catch (e) {
      Logger().e('Unknown error during GET request: $e');
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

  // 刷新访问令牌
  Future<bool> _refreshToken() async {
    try {
      // 检查是否有可用的刷新令牌
      if (userToken.refresh_token.isEmpty) {
        Logger().e("没有可用的刷新令牌，无法刷新访问令牌。");
        return false;
      }

      // 发送刷新令牌请求
      final response = await _dio.post<Map<String, dynamic>>(
        refreshUrl,
        data: {"refresh_token": userToken.refresh_token},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        // 创建新的 Token 实例并保存到 Hive
        final newToken = Token(
          access_token: response.data!["access_token"],
          token_type: userToken.token_type, // 保持原有的 token_type
          refresh_token: response.data!["refresh_token"],
        );

        // 保存更新后的令牌
        await HiveManager().saveToken(newToken);
        Logger().i("令牌刷新成功！");
        return true;
      } else {
        Logger().e("令牌刷新失败：${response.statusCode}");
        return false;
      }
    } on DioException catch (e) {
      Logger().e("令牌刷新失败：${e.message}");
      debugPrint('Caught a DioException during token refresh: ${e.message}');
      return false;
    } catch (e) {
      Logger().e("令牌刷新过程中出现未知错误：$e");
      debugPrint('Caught an unknown error during token refresh: $e');
      return false;
    }
  }

  // 聊天请求?
  Future<ChatActionResponse?> chat(String userName, String content) async {
    try {
      // 更改泛型参数为 Map<String, dynamic>
      final response = await _safePost<Map<String, dynamic>>(
        chatActionUrl,
        userToken,
        data: ChatActionRequest(content: content).toJson(),
      );

      if (response == null || response.data == null) {
        Logger().e('Chat action failed: No response data');
        return null;
      }

      // 手动将 Map 转换为 ChatActionResponse 对象
      final chatResponse = ChatActionResponse.fromJson(response.data!);

      Logger().d('Chat action response: ${jsonEncode(chatResponse.toJson())}');
      return chatResponse;
    } on DioException catch (e) {
      debugPrint('Caught a DioException during chat action: ${e.message}');
      return null;
    } catch (e) {
      debugPrint('Caught an unknown error during chat action: $e');
      return null;
    }
  }
}
