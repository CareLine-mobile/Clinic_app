import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/doctor_profile_entity.dart';
import '../repositories/doctor_repository.dart';

class GetDoctorDetailsUseCase {
  final DoctorRepository repository;

  GetDoctorDetailsUseCase(this.repository);

  Future<Either<Failure, DoctorProfileEntity>> call(int doctorId) {
    return repository.getDoctorDetails(doctorId);
  }
}
