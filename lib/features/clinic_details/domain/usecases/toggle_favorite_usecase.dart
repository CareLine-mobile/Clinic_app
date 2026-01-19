
// lib/features/clinics/domain/usecases/toggle_favorite_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/clinic_repository.dart';

class ToggleFavoriteUseCase {
  final ClinicRepository repository;

  ToggleFavoriteUseCase(this.repository);

  Future<Either<Failure, bool>> call(String clinicId) async {
    return await repository.toggleFavorite(clinicId);
  }
}