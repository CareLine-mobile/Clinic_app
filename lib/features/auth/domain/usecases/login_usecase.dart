import 'package:clinic_app/features/auth/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    try {
      // Business logic: Call repository
      final user = await repository.login(
        email: params.email,
        password: params.password,
      );

      // Success - repository already cached the user
      return Right(user);

    } catch (e, stackTrace) {
      // Error handling: Convert exception to Failure
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }

}

class LoginParams {
  final String email;
  final String password;

  LoginParams({
    required this.email,
    required this.password,
  });
}
