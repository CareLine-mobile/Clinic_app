// lib/features/clinics/domain/repositories/clinic_repository.dart
import 'package:clinic_app/features/clinic_details/domain/entites/clinic_entities.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entites/time_slot_entity.dart';


abstract class ClinicRepository {
  Future<ClinicEntity> getClinicDetails(int clinicId);

  Future< List<TimeSlotEntity>> getDoctorSlots(int clinicId, String day);


  Future<bool> toggleFavorite(String clinicId);

}
