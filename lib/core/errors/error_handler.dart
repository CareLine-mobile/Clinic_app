// ==================== error_handler.dart ====================
import 'package:dio/dio.dart';
import '../errors/exceptions.dart';
import '../errors/failures.dart';

class ErrorHandler {
  static Failure handleException(Object error) {
    if (error is ServerException) {
      return ServerFailure(error.message);
    } else if (error is CacheException) {
      return CacheFailure(error.message);
    } else if (error is NetworkException) {
      return NetworkFailure(error.message);
    } else if (error is DioException) {
      return _handleDioError(error);
    } else {
      return ServerFailure('حدث خطأ غير متوقع');
    }
  }

  static Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure('انتهت مهلة الاتصال. تحقق من الإنترنت');

      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);

      case DioExceptionType.cancel:
        return NetworkFailure('تم إلغاء الطلب');

      case DioExceptionType.connectionError:
        return NetworkFailure('لا يوجد اتصال بالإنترنت');

      case DioExceptionType.badCertificate:
        return NetworkFailure('خطأ في شهادة الأمان');

      case DioExceptionType.unknown:
      default:
        return NetworkFailure('خطأ في الاتصال بالخادم');
    }
  }

  static Failure _handleResponseError(Response? response) {
    if (response == null) {
      return ServerFailure('لا يوجد استجابة من الخادم');
    }

    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    // Extract error message from response
    String message = _extractErrorMessage(data);

    switch (statusCode) {
      case 400:
        return ServerFailure(message.isEmpty ? 'طلب غير صالح' : message);
      case 401:
        return ServerFailure('غير مصرح. يرجى تسجيل الدخول');
      case 403:
        return ServerFailure('ليس لديك صلاحية للوصول');
      case 404:
        return ServerFailure('البيانات المطلوبة غير موجودة');
      case 422:
        return ServerFailure(message.isEmpty ? 'بيانات غير صحيحة' : message);
      case 500:
      case 502:
      case 503:
        return ServerFailure('خطأ في الخادم. حاول لاحقاً');
      default:
        return ServerFailure(
          message.isEmpty ? 'حدث خطأ (كود: $statusCode)' : message,
        );
    }
  }

  static String _extractErrorMessage(dynamic data) {
    if (data == null) return '';

    if (data is Map<String, dynamic>) {
      // Common API error formats
      if (data.containsKey('message')) {
        return data['message'].toString();
      }
      if (data.containsKey('error')) {
        final error = data['error'];
        if (error is String) return error;
        if (error is Map && error.containsKey('message')) {
          return error['message'].toString();
        }
      }
      if (data.containsKey('errors')) {
        final errors = data['errors'];
        if (errors is Map) {
          // Laravel validation errors format
          return errors.values.first.toString();
        }
        if (errors is List && errors.isNotEmpty) {
          return errors.first.toString();
        }
      }
    }

    if (data is String) return data;

    return '';
  }
}