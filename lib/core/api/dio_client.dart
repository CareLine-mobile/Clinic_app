
import 'package:clinic_app/core/api/base_api_services.dart';
import 'package:clinic_app/core/api/model/http_method.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';




class DioApiService extends BaseApiServices {
  final Dio _dio;

  DioApiService(this._dio) {
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


/*
class HttpApiService extends BaseApiServices {
  final http.Client _client;
  final String baseUrl;

  HttpApiService(this._client, {required this.baseUrl});

  @override
  Future<dynamic> request({
    required HttpMethod method,
    required String url,
    dynamic body,
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$url').replace(
        queryParameters: queryParams,
      );

      final defaultHeaders = {
        'Content-Type': 'application/json',
        ...?headers,
      };

      http.Response response;

      switch (method) {
        case HttpMethod.get:
          response = await _client.get(uri, headers: defaultHeaders);
          break;
        case HttpMethod.post:
          response = await _client.post(
            uri,
            headers: defaultHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case HttpMethod.put:
          response = await _client.put(
            uri,
            headers: defaultHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case HttpMethod.delete:
          response = await _client.delete(
            uri,
            headers: defaultHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case HttpMethod.patch:
          response = await _client.patch(
            uri,
            headers: defaultHeaders,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case HttpMethod.head:
          response = await _client.head(uri, headers: defaultHeaders);
          break;
      }

      // Handle successful response
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.body.isNotEmpty ? jsonDecode(response.body) : null;
      } else {
        // Create custom exception for bad response
        throw ServerException(
          _extractErrorMessage(
            response.body.isNotEmpty ? jsonDecode(response.body) : null,
          ),
          'HTTP_${response.statusCode}',
        );
      }
    } catch (e, stackTrace) {
      throw ErrorHandler.handleException(e, stackTrace);
    }
  }

  String _extractErrorMessage(dynamic data) {
    if (data == null) return '';
    if (data is Map<String, dynamic> && data.containsKey('message')) {
      return data['message'].toString();
    }
    if (data is String) return data;
    return '';
  }
}
 */