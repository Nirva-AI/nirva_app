// service/dio_service.dart
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class DioService {
  final Dio _dio =
      Dio(
          BaseOptions(
            //baseUrl: 'http://127.0.0.1:8000',
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 30),
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
