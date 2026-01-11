// ==================== result_handler.dart ====================
import 'package:dartz/dartz.dart';
import '../errors/failures.dart';
import 'error_handler.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef ResultVoid = Future<Either<Failure, Unit>>;

class ResultHandler {
  static Future<Either<Failure, T>> handle<T>(
      Future<T> Function() function,
      ) async {
    try {
      final result = await function();
      return Right(result);
    } catch (error) {
      return Left(ErrorHandler.handleException(error));
    }
  }

  static Future<Either<Failure, Unit>> handleVoid(
      Future<void> Function() function,
      ) async {
    try {
      await function();
      return const Right(unit);
    } catch (error) {
      return Left(ErrorHandler.handleException(error));
    }
  }
}
