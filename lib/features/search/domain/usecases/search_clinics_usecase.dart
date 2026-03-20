// lib/features/search/domain/usecases/search_clinics_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../home/domain/entities/clinic_summary.dart';
import '../repositories/search_repository.dart';

class SearchClinicsUseCase {
  final SearchRepository repository;

  SearchClinicsUseCase(this.repository);

  Future<Either<Failure, List<ClinicSummary>>> call({
    required String query,
  }) =>
      repository.searchClinics(query: query);
}