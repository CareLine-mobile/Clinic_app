import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';
import '../../../user_data/user_repo.dart';  // <-- Import UserRepository

class LogoutUseCase {
  final AuthRepository repository;


  LogoutUseCase(this.repository, );

  Future<Either<Failure, void>> call() async {
    try {
      // 1. Logout from API
      await repository.logout();

      // 2. Clear local user
      await UserRepository().clearUser();

      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}