// lib/features/auth/domain/usecases/google_login_usecase.dart
import 'package:clinic_app/core/errors/failures.dart';
import 'package:clinic_app/features/auth/domain/entities/user.dart';
import 'package:clinic_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';


class GoogleLoginUseCase {
  final AuthRepository repository;

  GoogleLoginUseCase(this.repository);

  Future<Either<Failure, User>> call() => repository.googleLogin();
}