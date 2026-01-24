// lib/features/auth/domain/usecases/get_current_user_usecase.dart
// ============================================
import 'package:clinic_app/features/auth/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';


class GetCurrentUserUseCase implements UseCase<User?, NoParams> {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, User?>> call(NoParams params) async {
    return await repository.getCachedUser();
  }
}