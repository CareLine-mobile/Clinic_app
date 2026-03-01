
// lib/features/clinics/domain/usecases/toggle_favorite_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/clinic_repository.dart';

class ToggleFavoriteUseCase {
  final ClinicRepository repository;

  ToggleFavoriteUseCase(this.repository);

  Future<Either<Failure, bool>> call(String clinicId) async {
    try {
      final result = await repository.toggleFavorite(clinicId);
      return Right(result);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }
}