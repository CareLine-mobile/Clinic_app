import 'package:clinic_app/features/auth/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    final result = await repository.login(
      email: params.email,
      password: params.password,
    );

    return result.fold(
          (failure) => Left(failure),
          (user) async {
        // Save user locally after successful login
        await repository.saveUserLocally(user);
        return Right(user);
      },
    );
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
