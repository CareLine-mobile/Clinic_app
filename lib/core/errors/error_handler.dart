import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import '../utils/app_constans.dart';
import 'exceptions.dart';
import 'failures.dart';


class ErrorHandler {
  /// Convert exceptions to failures
  static Failure handleException(Object error, [StackTrace? stackTrace]) {
    // Log error for debugging/analytics
    _logError(error, stackTrace);

    if (error is ServerException) {
      return ServerFailure(error.message, error.code);
    } else if (error is NetworkException) {
      return NetworkFailure(error.message, error.code);
    } else if (error is CacheException) {
      return CacheFailure(error.message, error.code);
    } else if (error is ValidationException) {
      return ValidationFailure(error.message, error.code);
    } else if (error is UnauthorizedException) {
      return UnauthorizedFailure(error.message, error.code);
    } else if (error is DioException) {
      return _handleDioError(error);
    } else {
      return ServerFailure(
        'errors.server.unexpected'.tr(),
        'UNKNOWN_ERROR',
      );
    }
  }

  static Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkFailure(
          'errors.network.timeout'.tr(),
          ErrorMessages.connectionTimeout,
        );

      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);

      case DioExceptionType.cancel:
        return NetworkFailure(
          'errors.network.cancelled'.tr(),
          ErrorMessages.nearbyClinicsError,
        );

      case DioExceptionType.connectionError:
        return NetworkFailure(
          'errors.network.connection'.tr(),
          ErrorMessages.networkError,
        );

      case DioExceptionType.badCertificate:
        return NetworkFailure(
          'errors.network.certificate'.tr(),
          'CERTIFICATE_ERROR',
        );

      case DioExceptionType.unknown:
      return NetworkFailure(
          'errors.network.serverConnection'.tr(),
          'CONNECTION_ERROR',
        );
    }
  }

  static Failure _handleResponseError(Response? response) {

    if (response == null) {

      return ServerFailure(
        'errors.network.noResponse'.tr(),
        'NO_RESPONSE',
      );
    }

    final statusCode = response.statusCode ?? 0;
    final message = _extractErrorMessage(response.data);

    switch (statusCode) {
      case 400:
        print('dsfdsfdsfdsfdsfdsfdsfdsf');
        return ServerFailure(
          message.isNotEmpty ? message : 'errors.server.badRequest'.tr(),
          ErrorMessages.badRequest,
        );

      case 401:
        return UnauthorizedFailure(
          message.isNotEmpty ? message : 'errors.server.unauthorized'.tr(),
          ErrorMessages.unauthorized,
        );

      case 403:
        return ServerFailure(
          message.isNotEmpty ? message : 'errors.server.forbidden'.tr(),
          ErrorMessages.forbidden,
        );

      case 404:
        return ServerFailure(
          message.isNotEmpty ? message : 'errors.server.notFound'.tr(),
          ErrorMessages.notFound,
        );

      case 422:
        return ValidationFailure(
          message.isNotEmpty ? message : 'errors.server.invalidData'.tr(),
          ErrorMessages.unexpectedError,
        );

      case 500:
      case 502:
      case 503:
        return ServerFailure(
          'errors.server.internal'.tr(),
          ErrorMessages.serverError,
        );

      default:
        return ServerFailure(
          message.isNotEmpty ? message : 'errors.server.unexpected'.tr(),
          'HTTP_$statusCode',
        );
    }
  }

  static String _extractErrorMessage(dynamic data) {
    if (data == null) return '';

    if (data is Map<String, dynamic>) {
      // Try different API error response formats
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
        if (errors is Map && errors.isNotEmpty) {
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            return firstError.first.toString();
          }
          return firstError.toString();
        }
        if (errors is List && errors.isNotEmpty) {
          return errors.first.toString();
        }
      }
    }

    if (data is String) return data;

    return '';
  }

  static void _logError(Object error, StackTrace? stackTrace) {
    // TODO: Implement logging (Firebase Crashlytics, Sentry, etc.)
     print('Error: $error');
     if (stackTrace != null) print('StackTrace: $stackTrace');
  }
}


