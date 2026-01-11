// lib/features/home/domain/usecases/get_nearby_clinics_usecase.dart
// Use this when backend adds nearby clinics feature
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/clinic_summary.dart';
import '../repositories/home_repository.dart';

class GetNearbyClinicsUseCase {
  final HomeRepository repository;

  GetNearbyClinicsUseCase(this.repository);

  Future<Either<Failure, List<ClinicSummary>>> call({int page = 1}) async {
    return await repository.getNearbyClinics(page: page);
  }
}