// ==================== api_service.dart ====================
import 'package:clinic_app/core/api/endpoints.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ApiService {
  final Dio _dio;
  ApiService(this._dio) {
    _configureDio();
    _setupInterceptors();
  }

  void _configureDio() {
    _dio.options = BaseOptions(
      baseUrl: Endpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
  }

  void _setupInterceptors() {
    _dio.interceptors.addAll([
      // 1. Log Interceptor (للمساعدة في التطوير وتتبع الطلبات)
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),

      // 2. Custom Wrapper (للمعالجة المخصصة للأخطاء أو الـ Auth)
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // مثال: إضافة التوكن إذا كان موجوداً في SharedPreferences
          // options.headers['Authorization'] = 'Bearer YOUR_TOKEN';
          return handler.next(options);
        },
        onError: (error, handler) {
          debugPrint('API Error: ${error.message}');
          return handler.next(error);
        },
      ),
    ]);
  }

  Future<Response> get(
      String path, {
        Map<String, dynamic>? queryParameters,
      }) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  Future<Response> post(
      String path, {
        dynamic data,
      }) async {
    return await _dio.post(path, data: data);
  }

  Future<Response> put(
      String path, {
        dynamic data,
      }) async {
    return await _dio.put(path, data: data);
  }

  Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }
}
