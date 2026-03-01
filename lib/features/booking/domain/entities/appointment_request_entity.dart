import 'package:equatable/equatable.dart';

class AppointmentRequestEntity extends Equatable {
  final int clinicalId;
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

  @override
  List<Object?> get props => [clinicalId, doctorId, date, time, notes];
}