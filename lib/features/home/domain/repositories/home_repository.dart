// ==================== home_repository.dart ====================
import 'package:clinic_app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../entities/clinic_summary.dart';


abstract class HomeRepository {
  /// Get all clinics with pagination
  Future<Either<Failure, List<ClinicSummary>>> getAllClinics({int page = 1});

  /// Get featured clinics todo:: (for future use when backend splits data)
  Future<Either<Failure, List<ClinicSummary>>> getFeaturedClinics({int page = 1});

  /// Get nearby clinics todo:: (for future use when backend adds this)
  Future<Either<Failure, List<ClinicSummary>>> getNearbyClinics({int page = 1});

  /// todo:: Toggle favorite status
  Future<Either<Failure, Unit>> toggleFavorite(int clinicId);
}
