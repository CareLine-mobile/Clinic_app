import 'package:dartz/dartz.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failures.dart';
import '../../../user_data/user_repo.dart';
import '../repositories/auth_repository.dart';

class DeleteAccountUseCase {
  final AuthRepository repository;


  DeleteAccountUseCase(this.repository, );

  Future<Either<Failure, void>> call() async {
    try {
      // 1. Logout from API
      await repository.deleteAccount();

      // 2. Clear local user
      await UserRepository().clearUser();

      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
}