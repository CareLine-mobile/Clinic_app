// lib/features/auth/domain/usecases/signup_usecase.dart
// ============================================
import 'package:clinic_app/features/auth/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';



class SignupUseCase implements UseCase<String, SignupParams> {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(SignupParams params) async {
    return await repository.signup(
      name: params.name,
      email: params.email,
      phone: params.phone,
      password: params.password,
    );
  }
}

class SignupParams {
  final String name;
  final String email;
  final String phone;
  final String password;

  SignupParams({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });
}