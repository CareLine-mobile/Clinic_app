import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, String>> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  });

  Future<Either<Failure, void>> reSendOtp({
    required String email,
  });

  Future<Either<Failure, User>> verifyOtp({
    required String email,
    required String otp,
  });

  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  });

  Future<Either<Failure, void>> sendForgotPassword({
    required String email,
  });

  Future<void> logout();
}