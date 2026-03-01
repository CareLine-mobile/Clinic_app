
import 'dart:developer';

import 'package:clinic_app/core/api/base_api_services.dart';
import 'package:clinic_app/core/api/model/http_method.dart';
import 'package:clinic_app/features/user_data/user_repo.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioApiService extends BaseApiServices {
  final Dio _dio;

  DioApiService(this._dio) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = UserRepository().currentUser?.token;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
    // Add pretty logger to debug responses
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  @override
  Future<dynamic> request({
    required HttpMethod method,
    required String url,
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {

      final options = Options(
        method: method.name.toUpperCase(),  // ← Handles all HTTP methods
        headers: headers,
      );

      final response = await _dio.request(
        url,
        data: body,
        queryParameters: queryParams,
        options: options,
      );
      print('fjdofjdofdof $response');
      return response.data;

    } catch (e, stackTrace) {
      print('zyad');
      // Convert exception to custom exception and throw
      rethrow;
    }
  }


}
