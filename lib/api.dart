// ignore_for_file: non_constant_identifier_names
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:nirva_app/api_models.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:nirva_app/hive_object.dart';
import 'package:nirva_app/app_runtime_context.dart';

class APIs {
  // 获取 URL 配置
  static Future<URLConfigurationResponse?> getUrlConfig() async {
    final appRuntimeContext = AppRuntimeContext();
    try {
      final response = await appRuntimeContext.dio.get<dynamic>("/config");
      final url_configuration_response = URLConfigurationResponse.fromJson(
        response.data!,
      );
      appRuntimeContext.urlConfig.setup(url_configuration_response);
      return url_configuration_response;
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          Logger().e('Connection timeout occurred.');
          break;
        case DioExceptionType.badResponse:
          Logger().e(
            'Server responded with an error: ${e.response?.statusCode}',
          );
          break;
        case DioExceptionType.connectionError:
          Logger().e('Connection error occurred.');
          break;
        case DioExceptionType.receiveTimeout:
          Logger().e('Receive timeout occurred.');
          break;
        case DioExceptionType.sendTimeout:
          Logger().e('Send timeout occurred.');
          break;
        default:
          Logger().e('Unknown error occurred: ${e.message}');
          break;
      }
      // 重新抛出异常以便上层处理
      rethrow;
    } catch (e) {
      Logger().e('Caught an unknown error of type: ${e.runtimeType}');
      Logger().e('Error details: $e');
      rethrow;
    }
  }

  // 登录方法
  static Future<Token?> login() async {
    final appRuntimeContext = AppRuntimeContext();
    try {
      // 直接将_performLogin的逻辑合并到login方法中
      final response = await appRuntimeContext.dio.post<Map<String, dynamic>>(
        appRuntimeContext.urlConfig.loginUrl,
        data: {
          'username': appRuntimeContext.data.user.name,
          'password': appRuntimeContext.data.user.password,
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
        appRuntimeContext.storage.saveToken(token); // 保存到Hive中
        Logger().i('登录成功！令牌已获取');
        return token;
      } else {
        Logger().e('登录失败，请检查用户名和密码');
        return null;
      }
    } on DioException catch (e) {
      Logger().e('登录失败: ${e.message}');
      debugPrint('Caught a DioException during login: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Caught an unknown error during login: $e');
      rethrow;
    }
  }

  // 刷新令牌
  static Future<bool> logout() async {
    final appRuntimeContext = AppRuntimeContext();
    try {
      final response = await appRuntimeContext.dio.post<Map<String, dynamic>>(
        appRuntimeContext.urlConfig.logoutUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer ${appRuntimeContext.storage.getToken().access_token}',
          },
        ),
      );

      if (response.statusCode == 200) {
        await appRuntimeContext.storage.deleteToken(); // 清除本地令牌
        Logger().i('登出成功！令牌已清除');
        return true;
      } else {
        Logger().e('登出失败，请稍后重试');
        return false;
      }
    } on DioException catch (e) {
      Logger().e('登出失败: ${e.message}');
      debugPrint('Caught a DioException during logout: ${e.message}');
      rethrow;
    } catch (e) {
      debugPrint('Caught an unknown error during logout: $e');
      rethrow;
    }
  }

  // 刷新访问令牌
  static Future<bool> refreshToken() async {
    final appRuntimeContext = AppRuntimeContext();
    try {
      // 检查是否有可用的刷新令牌
      if (appRuntimeContext.storage.getToken().refresh_token.isEmpty) {
        Logger().e("没有可用的刷新令牌，无法刷新访问令牌。");
        return false;
      }

      // 发送刷新令牌请求
      final response = await appRuntimeContext.dio.post<Map<String, dynamic>>(
        appRuntimeContext.urlConfig.refreshUrl,
        data: {
          "refresh_token": appRuntimeContext.storage.getToken().refresh_token,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        // 创建新的 Token 实例并保存到 Hive
        final newToken = Token(
          access_token: response.data!["access_token"],
          token_type:
              appRuntimeContext.storage
                  .getToken()
                  .token_type, // 保持原有的 token_type
          refresh_token: response.data!["refresh_token"],
        );

        // 保存更新后的令牌
        await appRuntimeContext.storage.saveToken(newToken);
        Logger().i("令牌刷新成功！");
        return true;
      } else {
        Logger().e("令牌刷新失败：${response.statusCode}");
        return false;
      }
    } on DioException catch (e) {
      Logger().e("令牌刷新失败：${e.message}");
      debugPrint('Caught a DioException during token refresh: ${e.message}');
      rethrow;
    } catch (e) {
      Logger().e("令牌刷新过程中出现未知错误：$e");
      debugPrint('Caught an unknown error during token refresh: $e');
      rethrow;
    }
  }

  // 安全的POST请求方法
  static Future<Response<T>?> safePost<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
  }) async {
    Logger().d('POST Request - URL: $path, Data: $data');
    final appRuntimeContext = AppRuntimeContext();
    try {
      // 初始请求
      var response = await appRuntimeContext.dio.post<T>(
        path,
        data: data,
        queryParameters: query,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer ${appRuntimeContext.storage.getToken().access_token}',
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
      if (e.response?.statusCode == 401 &&
          appRuntimeContext.storage.getToken().refresh_token.isNotEmpty) {
        Logger().i("令牌已过期，尝试刷新...");

        // 尝试刷新令牌
        bool refreshSuccess = await refreshToken();

        if (refreshSuccess) {
          Logger().i("令牌刷新成功，重新尝试请求");
          // 获取刷新后的令牌
          Token newToken = appRuntimeContext.storage.getToken();

          // 使用新令牌重新发送请求
          try {
            var newResponse = await appRuntimeContext.dio.post<T>(
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
  Future<Response<T>?> safeGet<T>(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    Logger().d('GET Request - URL: $path, Query: $query');
    final appRuntimeContext = AppRuntimeContext();
    try {
      // 初始请求
      var response = await appRuntimeContext.dio.get<T>(
        path,
        queryParameters: query,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer ${appRuntimeContext.storage.getToken().access_token}',
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
      if (e.response?.statusCode == 401 &&
          appRuntimeContext.storage.getToken().refresh_token.isNotEmpty) {
        Logger().i("令牌已过期，尝试刷新...");

        // 尝试刷新令牌
        bool refreshSuccess = await refreshToken();

        if (refreshSuccess) {
          Logger().i("令牌刷新成功，重新尝试请求");
          // 获取刷新后的令牌
          Token newToken = appRuntimeContext.storage.getToken();

          // 使用新令牌重新发送请求
          try {
            var newResponse = await appRuntimeContext.dio.get<T>(
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

  // 聊天请求?
  static Future<ChatActionResponse?> chat(String content) async {
    final appRuntimeContext = AppRuntimeContext();
    try {
      // 更改泛型参数为 Map<String, dynamic>
      final response = await safePost<Map<String, dynamic>>(
        appRuntimeContext.urlConfig.chatActionUrl,
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
      rethrow;
    } catch (e) {
      debugPrint('Caught an unknown error during chat action: $e');
      rethrow;
    }
  }
}
