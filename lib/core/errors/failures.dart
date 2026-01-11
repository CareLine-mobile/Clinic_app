// lib/core/errors/failures.dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class FailureMessageMapper {
  static String mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is NetworkFailure) {
      return failure.message;
    } else if (failure is CacheFailure) {
      return failure.message;
    } else {
      return 'حدث خطأ غير متوقع';
    }
  }

  static String getActionMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'تحقق من الاتصال بالإنترنت';
    } else if (failure is ServerFailure) {
      if (failure.message.contains('401') ||
          failure.message.contains('مصرح')) {
        return 'قم بتسجيل الدخول مرة أخرى';
      }
      return 'حاول مرة أخرى';
    }
    return 'حاول لاحقاً';
  }
}