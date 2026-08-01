import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class AppleLoginUseCase {
  final AuthRepository repository;

  AppleLoginUseCase(this.repository);

  Future<Either<Failure, User>> call() => repository.appleLogin();
}
