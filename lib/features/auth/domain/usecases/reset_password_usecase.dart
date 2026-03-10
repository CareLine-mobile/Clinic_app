// lib/features/auth/domain/usecases/reset_password_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;
  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String email,
    required String otp,
    required String newPassword,
  }) => repository.resetPassword(
    email: email,
    otp: otp,
    newPassword: newPassword,
  );
}