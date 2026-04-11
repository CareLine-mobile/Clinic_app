import 'package:equatable/equatable.dart';

class AppointmentRequestEntity extends Equatable {
  final String clinicalId;
  final String doctorId;
  final String date;
  final String time;
  final String name;
  final String phone;
  final String? notes;

  const AppointmentRequestEntity({
    required this.clinicalId,
    required this.doctorId,
    required this.date,
    required this.time,
    required this.name,
    required this.phone,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'clinical_id': int.tryParse(clinicalId) ?? 0,
    'doctor_id': int.tryParse(doctorId) ?? 0,
    'date': date,
    'time': time,
    'name': name,
    'phone': phone,
    if (notes != null && notes!.isNotEmpty) 'notes': notes,
  };

  @override
  List<Object?> get props => [clinicalId, doctorId, date, time, name, phone, notes];
}