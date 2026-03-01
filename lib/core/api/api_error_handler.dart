import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../errors/exceptions.dart';
import '../utils/app_constans.dart';

class ApiErrorHandler {
  // ── Server message → translation key mapping ─────────────
  static const Map<String, String> _serverMessageMap = {
    // Auth
    'invalid credentials.':          'errors.server.invalidCredentials',
    'unauthenticated':              'errors.server.unauthorized',
    'unauthorized':                 'errors.server.unauthorized',
    'email already taken':          'errors.server.emailTaken',
    'email has already been taken': 'errors.server.emailTaken',
    'the email has already been taken': 'errors.server.emailTaken',
    'user not found':               'errors.server.userNotFound',
    'wrong password':               'errors.server.invalidCredentials',
    'please verify your email first.':         'errors.server.accountNotVerified',
    'token expired':                'errors.server.tokenExpired',
    'token is invalid':             'errors.server.tokenExpired',

    // General
    'server error':                 'errors.server.internal',
    'too many requests':            'errors.server.tooManyRequests',
    'validation error':             'errors.server.invalidData',
    'not found':                    'errors.server.notFound',
    'forbidden':                    'errors.server.forbidden',
  };

  /// Translates a raw server message to a localized string.
  /// Falls back to the original message if no mapping found.
  static String translateMessage(String serverMessage) {
    if (serverMessage.isEmpty) return serverMessage;

    final key = _serverMessageMap[serverMessage.toLowerCase().trim()];
    if (key != null) return key.tr();

    // No mapping found — return as-is (already readable English)
    return serverMessage;
  }

  // ── DioException handler ──────────────────────────────────

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
      return ServerException('errors.network.noResponse'.tr(), 'NO_RESPONSE');
    }

    final statusCode = response.statusCode ?? 0;
    final rawMessage = _extractErrorMessage(response.data);
    final message = translateMessage(rawMessage); // ← translate here

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
      // ── message field ──────────────────────────────────────
      if (data.containsKey('message') && data['message'] != null) {
        final msg = data['message'].toString();
        // ignore generic success messages that slip through on errors
        if (msg.isNotEmpty && msg.toLowerCase() != 'ok') return msg;
      }

      // ── error field ────────────────────────────────────────
      if (data.containsKey('error')) {
        final error = data['error'];
        if (error is String) return error;
        if (error is Map && error.containsKey('message')) {
          return error['message'].toString();
        }
      }

      // ── errors field (validation: {"email": [...], "phone": [...]}) ──
      if (data.containsKey('errors')) {
        final errors = data['errors'];

        if (errors is Map && errors.isNotEmpty) {
          // ✅ Collect ALL field errors and join them
          final messages = <String>[];
          for (final entry in errors.entries) {
            final value = entry.value;
            if (value is List && value.isNotEmpty) {
              messages.add(value.first.toString());
            } else if (value is String) {
              messages.add(value);
            }
          }
          if (messages.isNotEmpty) return messages.join('\n');
        }

        if (errors is List && errors.isNotEmpty) {
          return errors.first.toString();
        }
      }
    }

    if (data is String && data.isNotEmpty) return data;

    return '';
  }
}