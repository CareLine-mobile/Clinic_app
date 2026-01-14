// lib/features/home/domain/usecases/get_clinics_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/clinic_summary.dart';
import '../repositories/home_repository.dart';

class GetClinicsUseCase {
  final HomeRepository repository;

  GetClinicsUseCase(this.repository);

  Future<Either<Failure, List<ClinicSummary>>> call({int page = 1}) async {
    return await repository.getAllClinics(page: page);
  }

  Future<Either<Failure, List<ClinicSummary>>> callLatestClinics() async {
    return await repository.latestClinics();
  }
}
