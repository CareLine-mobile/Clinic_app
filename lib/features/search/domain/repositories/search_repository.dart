// lib/features/search/domain/repositories/search_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../home/domain/entities/clinic_summary.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<ClinicSummary>>> searchClinics({
    required String query,
  });
}