import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/doctor_profile_entity.dart';

abstract class DoctorRepository {
  Future<Either<Failure, DoctorProfileEntity>> getDoctorDetails(int doctorId);
  Future<Either<Failure, double>> rateDoctor(int doctorId, double rating);
}
