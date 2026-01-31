
import 'package:clinic_app/features/auth/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';



class SignupUseCase implements UseCase<String, SignupParams> {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(SignupParams params) async {
    try {
      final result = await repository.signup(
        name: params.name,
        email: params.email,
        phone: params.phone,
        password: params.password,
      );
      return Right(result);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
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