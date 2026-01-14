
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../errors/exceptions.dart';
import '../utils/app_constans.dart';

/// Handles API-specific errors and converts them to exceptions
class ApiErrorHandler {
  static Exception handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          'errors.network.timeout'.tr(),
          ErrorMessages.connectionTimeout,
        );

      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);

      case DioExceptionType.cancel:
        return NetworkException(
          'errors.network.cancelled'.tr(),
          ErrorMessages.requestCancelled,
        );

      case DioExceptionType.connectionError:
        return NetworkException(
          'errors.network.connection'.tr(),
          ErrorMessages.networkError,
        );

      case DioExceptionType.badCertificate:
        return NetworkException(
          'errors.network.certificate'.tr(),
          'CERTIFICATE_ERROR',
        );

      case DioExceptionType.unknown:
      return NetworkException(
          'errors.network.serverConnection'.tr(),
          'CONNECTION_ERROR',
        );
    }
  }

  static Exception _handleResponseError(Response? response) {
    if (response == null) {
      return ServerException(
        'errors.network.noResponse'.tr(),
        'NO_RESPONSE',
      );
    }

    final statusCode = response.statusCode ?? 0;
    final message = _extractErrorMessage(response.data);

    switch (statusCode) {
      case 400:
        return ServerException(
          message.isNotEmpty ? message : 'errors.server.badRequest'.tr(),
          ErrorMessages.badRequest,
        );

      case 401:
        return UnauthorizedException(
          message.isNotEmpty ? message : 'errors.server.unauthorized'.tr(),
          ErrorMessages.unauthorized,
        );

      case 403:
        return ServerException(
          message.isNotEmpty ? message : 'errors.server.forbidden'.tr(),
          ErrorMessages.forbidden,
        );

      case 404:
        return ServerException(
          message.isNotEmpty ? message : 'errors.server.notFound'.tr(),
          ErrorMessages.notFound,
        );

      case 422:
        return ValidationException(
          message.isNotEmpty ? message : 'errors.server.invalidData'.tr(),
          ErrorMessages.unexpectedError,
        );

      case 500:
      case 502:
      case 503:
        return ServerException(
          'errors.server.internal'.tr(),
          ErrorMessages.serverError,
        );

      default:
        return ServerException(
          message.isNotEmpty ? message : 'errors.server.unexpected'.tr(),
          'HTTP_$statusCode',
        );
    }
  }

  static String _extractErrorMessage(dynamic data) {
    if (data == null) return '';

    if (data is Map<String, dynamic>) {
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
}