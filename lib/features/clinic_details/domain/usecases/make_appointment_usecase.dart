import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entites/appointment_request_entity.dart';
import '../repositories/clinic_repository.dart';

class MakeAppointmentUseCase {
  final ClinicRepository repository;

  MakeAppointmentUseCase(this.repository);

  Future<Either<Failure, void>> call(AppointmentRequestEntity request) {
    return repository.makeAppointment(request);
  }
}