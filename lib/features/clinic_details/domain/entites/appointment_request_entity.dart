// In domain/entites/appointment_request_entity.dart
import 'package:equatable/equatable.dart';

class AppointmentRequestEntity extends Equatable {
  final String clinicalId;
  final String doctorId;
  final String date;
  final String time;
  final String? notes;

  const AppointmentRequestEntity({
    required this.clinicalId,
    required this.doctorId,
    required this.date,
    required this.time,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'clinical_id': clinicalId,
    'doctor_id': doctorId,
    'date': date,
    'time': time,
    if (notes != null) 'notes': notes,
  };

  @override
  List<Object?> get props => [clinicalId, doctorId, date, time, notes];
}