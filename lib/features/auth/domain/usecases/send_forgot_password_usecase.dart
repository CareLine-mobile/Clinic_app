// lib/features/auth/domain/usecases/send_forgot_password_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class SendForgotPasswordUseCase {
  final AuthRepository repository;
  SendForgotPasswordUseCase(this.repository);

  Future<Either<Failure, void>> call({required String email}) =>
      repository.sendForgotPassword(email: email);
}