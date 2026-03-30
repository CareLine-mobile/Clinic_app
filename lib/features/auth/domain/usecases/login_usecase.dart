// lib/features/auth/domain/usecases/login_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<Either<Failure, User>> call(LoginParams params) =>
      repository.login(email: params.email, password: params.password);
}

class LoginParams {
  final String email;
  final String password;
  LoginParams({required this.email, required this.password});
}