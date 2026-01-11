// lib/features/clinics/domain/repositories/clinic_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entites/clinic_entities.dart';
import '../usecases/book_appointment_usecase.dart';

abstract class ClinicRepository {
  Future<Either<Failure, ClinicDetails>> getClinicDetails(int clinicId);
  Future<Either<Failure, List<Doctor>>> getDoctors(int clinicId);
  Future<Either<Failure, bool>> toggleFavorite(int clinicId);
  Future<Either<Failure, bool>> bookAppointment(BookingParams params);
}
