// ignore_for_file: non_constant_identifier_names
import 'dart:convert';
import 'package:nirva_app/api_models.dart';
import 'package:logger/logger.dart';
import 'package:dio/dio.dart';
import 'package:nirva_app/hive_object.dart';
import 'package:nirva_app/app_runtime_context.dart';
import 'package:uuid/uuid.dart'; // 添加此行引入uuid包

class APIs {
  // 获取 URL 配置，故意不抓留给外面抓。
  static Future<URLConfigurationResponse?> getUrlConfig() async {
    final appRuntimeContext = AppRuntimeContext();
    final response = await appRuntimeContext.appserviceDio.get<dynamic>(
      "/config",
    );
    final url_configuration_response = URLConfigurationResponse.fromJson(
      response.data!,
    );
    appRuntimeContext.urlConfig.setup(url_configuration_response);
    return url_configuration_response;
  }

  // 登录方法
  static Future<UserToken?> login() async {
    final appRuntimeContext = AppRuntimeContext();
    final response = await appRuntimeContext.appserviceDio
        .post<Map<String, dynamic>>(
          appRuntimeContext.urlConfig.loginUrl,
          data: {
            'username': appRuntimeContext.data.user.username,
            'password': appRuntimeContext.data.user.password,
            'grant_type': 'password',
          },
          options: Options(
            contentType: Headers.formUrlEncodedContentType, // OAuth2默认表单格式
          ),
        );

    if (response.statusCode != 200) {
      Logger().e('登录请求失败: ${response.statusCode}, ${response.statusMessage}');
      return null;
    }

    if (response.data == null) {
      Logger().e('登录请求没有返回数据');
      return null;
    }

    final userToken = UserToken(
      access_token: response.data!['access_token'] ?? '',
      token_type: response.data!['token_type'] ?? '',
      refresh_token: response.data!['refresh_token'] ?? '', // 新增字段
    );
    appRuntimeContext.storage.saveUserToken(userToken); // 保存到Hive中
    Logger().i('登录成功！令牌已获取');
    return userToken;
  }

  // 登出方法，故意不抓留给外面抓。
  static Future<bool> logout() async {
    final appRuntimeContext = AppRuntimeContext();
    final response = await appRuntimeContext.appserviceDio.post<
      Map<String, dynamic>
    >(
      appRuntimeContext.urlConfig.logoutUrl,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${appRuntimeContext.storage.getUserToken().access_token}',
        },
      ),
    );

    if (response.statusCode != 200) {
      Logger().e('登出请求失败: ${response.statusCode}, ${response.statusMessage}');
      return false;
    }

    await appRuntimeContext.storage.deleteUserToken(); // 清除本地令牌
    Logger().i('登出成功！令牌已清除');
    return true;
  }

  // 刷新访问令牌，故意不抓留给外面抓。
  static Future<UserToken?> refreshToken() async {
    final appRuntimeContext = AppRuntimeContext();
    if (appRuntimeContext.storage.getUserToken().refresh_token.isEmpty) {
      Logger().e("没有可用的刷新令牌，无法刷新访问令牌。");
      return null;
    }

    // 发送刷新令牌请求
    final response = await appRuntimeContext.appserviceDio
        .post<Map<String, dynamic>>(
          appRuntimeContext.urlConfig.refreshUrl,
          // 使用表单数据格式发送
          data: FormData.fromMap({
            'refresh_token':
                appRuntimeContext.storage.getUserToken().refresh_token,
          }),
          options: Options(contentType: Headers.formUrlEncodedContentType),
        );

    if (response.statusCode != 200) {
      Logger().e('令牌刷新请求失败: ${response.statusCode}, ${response.statusMessage}');
      return null;
    }
    if (response.data == null) {
      Logger().e('令牌刷新请求没有返回数据');
      return null;
    }

    // 创建新的 Token 实例并保存到 Hive
    final newToken = UserToken(
      access_token: response.data!["access_token"],
      token_type:
          appRuntimeContext.storage
              .getUserToken()
              .token_type, // 保持原有的 token_type
      refresh_token: response.data!["refresh_token"],
    );

    // 保存更新后的令牌
    await appRuntimeContext.storage.saveUserToken(newToken);
    Logger().i("令牌刷新成功！");
    return newToken;
  }

  // 简单的post请求方法
  static Future<Response<T>?> simplePost<T>(
    String path,
    UserToken userToken, {
    Object? data,
    Map<String, dynamic>? query,
  }) async {
    Logger().d('POST Request - URL: $path, Data: $data');
    final appRuntimeContext = AppRuntimeContext();
    final response = await appRuntimeContext.appserviceDio.post<T>(
      path,
      data: data,
      queryParameters: query,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userToken.access_token}',
        },
      ),
    );

    if (response.statusCode != 200) {
      Logger().e('Error: ${response.statusCode}, ${response.statusMessage}');
      return null;
    }

    Logger().d('POST Response: ${response.data}');
    return response;
  }

  // 简单的get请求方法
  static Future<Response<T>?> simpleGet<T>(
    String path,
    UserToken userToken, {
    Map<String, dynamic>? query,
  }) async {
    Logger().d('GET Request - URL: $path, Query: $query');
    final appRuntimeContext = AppRuntimeContext();
    final response = await appRuntimeContext.appserviceDio.get<T>(
      path,
      queryParameters: query,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userToken.access_token}',
        },
      ),
    );

    if (response.statusCode != 200) {
      Logger().e('Error: ${response.statusCode}, ${response.statusMessage}');
      return null;
    }

    Logger().d('GET Response: ${response.data}');
    return response;
  }

  // 安全POST请求方法 - 自动处理授权过期并重试, 内部会只抓取401错误
  static Future<Response<T>?> safePost<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
  }) async {
    final appRuntimeContext = AppRuntimeContext();
    final userToken = appRuntimeContext.storage.getUserToken();

    try {
      // 首次尝试发送请求
      return await simplePost<T>(path, userToken, data: data, query: query);
    } on DioException catch (e) {
      // 捕获 401 未授权错误
      if (e.response?.statusCode == 401 && userToken.refresh_token.isNotEmpty) {
        Logger().w('授权已过期，尝试刷新令牌...');

        // 尝试刷新令牌
        final newToken = await refreshToken();
        if (newToken != null) {
          Logger().i('令牌刷新成功，重新发送请求');
          // 使用新令牌重新尝试请求
          return await simplePost<T>(path, newToken, data: data, query: query);
        }
      }

      // 其他类型的 DioException，直接抛出
      Logger().e('请求失败: ${e.message}');
      rethrow;
    }
  }

  // 安全GET请求方法 - 自动处理授权过期并重试, 内部会只抓取401错误
  static Future<Response<T>?> safeGet<T>(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    final appRuntimeContext = AppRuntimeContext();
    final userToken = appRuntimeContext.storage.getUserToken();

    try {
      // 首次尝试发送请求
      return await simpleGet<T>(path, userToken, query: query);
    } on DioException catch (e) {
      // 捕获 401 未授权错误
      if (e.response?.statusCode == 401 && userToken.refresh_token.isNotEmpty) {
        Logger().w('授权已过期，尝试刷新令牌...');

        // 尝试刷新令牌
        final newToken = await refreshToken();
        if (newToken != null) {
          Logger().i('令牌刷新成功，重新发送请求');
          // 使用新令牌重新尝试请求
          return await simpleGet<T>(path, newToken, query: query);
        }
      }

      // 其他类型的 DioException，直接抛出
      Logger().e('请求失败: ${e.message}');
      rethrow;
    }
  }

  // 聊天请求, 故意不抓留给外面抓。
  static Future<ChatActionResponse?> chat(String content) async {
    final appRuntimeContext = AppRuntimeContext();
    final uuid = Uuid(); // 创建UUID生成器实例

    final chatActionRequest = ChatActionRequest(
      human_message: ChatMessage(
        id: uuid.v4(), // 使用uuid生成唯一ID
        role: MessageRole.human,
        content: content,
        time_stamp: DateTime.now().toIso8601String(),
      ),
      chat_history: appRuntimeContext.chat.messages.value,
    );

    // 添加详细日志，查看完整请求体
    final requestJson = chatActionRequest.toJson();
    Logger().d('Chat request payload: ${jsonEncode(requestJson)}');

    final response = await safePost<Map<String, dynamic>>(
      appRuntimeContext.urlConfig.chatActionUrl,
      data: chatActionRequest.toJson(),
    );

    if (response == null || response.data == null) {
      Logger().e('Chat action failed: No response data');
      return null;
    }

    final chatResponse = ChatActionResponse.fromJson(response.data!);
    Logger().d('Chat action response: ${jsonEncode(chatResponse.toJson())}');
    appRuntimeContext.chat.appendConversation([
      chatActionRequest.human_message,
      chatResponse.ai_message,
    ]);
    return chatResponse; // 这里返回null是因为没有实现具体的聊天逻辑
  }
}
