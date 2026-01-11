// ==================== home_repository.dart ====================
import 'package:clinic_app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';


import '../entities/clinic_summary.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<ClinicSummary>>> getFeaturedClinics();
  Future<Either<Failure, List<ClinicSummary>>> getNearbyClinics();
  Future<Either<Failure, List<ClinicSummary>>> getAllClinics({int page = 1});
  Future<Either<Failure, Unit>> toggleFavorite(int clinicId);
  Future<Either<Failure, Unit>> bookAppointment(int clinicId);
}