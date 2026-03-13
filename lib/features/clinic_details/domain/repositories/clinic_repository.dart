// lib/features/clinics/domain/repositories/clinic_repository.dart
import 'package:clinic_app/features/clinic_details/domain/entites/appointment_request_entity.dart';
import 'package:clinic_app/features/clinic_details/domain/entites/clinic_entities.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entites/time_slot_entity.dart';

abstract class ClinicRepository {
  Future<Either<Failure, ClinicEntity>> getClinicDetails(int clinicId, {String? day});

  Future<Either<Failure, List<TimeSlotEntity>>> getDoctorSlots(int doctorId, String day);

  Future<Either<Failure, void>> makeAppointment(AppointmentRequestEntity request);

  Future<Either<Failure, bool>> toggleFavorite(String clinicId);
}