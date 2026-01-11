// lib/features/home/domain/usecases/get_featured_clinics_usecase.dart
// Use this when backend adds separate featured endpoint
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/clinic_summary.dart';
import '../repositories/home_repository.dart';

class GetFeaturedClinicsUseCase {
  final HomeRepository repository;

  GetFeaturedClinicsUseCase(this.repository);

  Future<Either<Failure, List<ClinicSummary>>> call({int page = 1}) async {
    return await repository.getFeaturedClinics(page: page);
  }
}


