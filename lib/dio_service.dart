// service/dio_service.dart
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class DioService {
  static final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: 'http://127.0.0.1:8000',
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 3),
          ),
        )
        ..interceptors.add(
          LogInterceptor(
            request: true,
            requestHeader: true,
            responseHeader: true,
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onError: (error, handler) {
              Logger().e('Dio Error: ${error.message}');
              return handler.next(error);
            },
          ),
        );

  Future<Response<T>> safePost<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
  }) async {
    try {
      return await _dio.post<T>(path, data: data, queryParameters: query);
    } on DioException catch (e) {
      Logger().e('POST Error: ${e.type}');
      rethrow;
    }
  }
}

// 最佳实践：
// 创建 dio_interceptors 目录存放自定义拦截器
// 使用 dio_http_cache 实现缓存
// 配合 pretty_dio_logger 增强日志
// 使用 CancelToken 实现请求取消
