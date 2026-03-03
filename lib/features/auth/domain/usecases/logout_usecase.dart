import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    try {
      await repository.logout();
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}