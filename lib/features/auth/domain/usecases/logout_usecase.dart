// lib/features/auth/domain/usecases/logout_usecase.dart
// ============================================
import 'package:clinic_app/features/auth/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}