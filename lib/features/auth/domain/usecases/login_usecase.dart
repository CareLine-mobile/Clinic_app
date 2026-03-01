import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<Either<Failure, User>> call(LoginParams params) async {
    try {
      final user = await repository.login(
        email: params.email,
        password: params.password,
      );
      return Right(user);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }
}

class LoginParams {
  final String email;
  final String password;
  LoginParams({required this.email, required this.password});
}