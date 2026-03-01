import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/appointment_request_entity.dart';
import '../repository/booking_repository.dart';

class MakeAppointmentUseCase {
  final BookingRepository repository;

  MakeAppointmentUseCase(this.repository);

  Future<Either<Failure, void>> call(AppointmentRequestEntity request) {
    return repository.makeAppointment(request);
  }
}