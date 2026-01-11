// ============================================
// lib/features/clinics/domain/usecases/book_appointment_usecase.dart
import 'package:clinic_app/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

import '../repositories/clinic_repository.dart';

class BookAppointmentUseCase {
  final ClinicRepository repository;

  BookAppointmentUseCase(this.repository);

  Future<Either<Failure, bool>> call(BookingParams params) async {
    return await repository.bookAppointment(params);
  }
}

class BookingParams {
  final int clinicId;
  final int doctorId;
  final DateTime date;
  final String timeSlot;

  BookingParams({
    required this.clinicId,
    required this.doctorId,
    required this.date,
    required this.timeSlot,
  });
}