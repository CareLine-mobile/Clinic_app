// ==================== home_repository.dart ====================
import 'package:clinic_app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import '../entities/clinic_summary.dart';


abstract class HomeRepository {
  /// Get all clinics with pagination - Throws exceptions on error
  Future<List<ClinicSummary>> getAllClinics({int page = 1});

  /// Get latest clinics - Throws exceptions on error
  Future<List<ClinicSummary>> latestClinics();

  /// Get featured clinics - Throws exceptions on error
  Future<List<ClinicSummary>> getFeaturedClinics({int page = 1});

  /// Get nearby clinics - Throws exceptions on error
  Future<List<ClinicSummary>> nearbyClinics({
    required double latitude,
    required double longitude,
  });

  /// Toggle favorite status - Throws exceptions on error
  Future<void> toggleFavorite(int clinicId);
}