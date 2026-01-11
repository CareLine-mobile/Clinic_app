// ==================== dio_client.dart ====================
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'endpoints.dart';

class DioClient {
  static Dio getDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Endpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Add interceptors
    dio.interceptors.add(_getLoggerInterceptor());
    dio.interceptors.add(_getAuthInterceptor());

    return dio;
  }

  static PrettyDioLogger _getLoggerInterceptor() {
    return PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    );
  }

  static InterceptorsWrapper _getAuthInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add token if available
        // final token = await getToken();
        // if (token != null) {
        //   options.headers['Authorization'] = 'Bearer $token';
        // }
        return handler.next(options);
      },
      onError: (error, handler) {
        // Handle token expiration
        if (error.response?.statusCode == 401) {
          // Navigate to login or refresh token
        }
        return handler.next(error);
      },
    );
  }
}