import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/doctor_repository.dart';

class RateDoctorUseCase {
  final DoctorRepository repository;

  RateDoctorUseCase(this.repository);

  Future<Either<Failure, double>> call(int doctorId, double rating) {
    return repository.rateDoctor(doctorId, rating);
  }
}
