class AppointmentRequestModel {
  final int clinicalId;
  final String doctorId;
  final String date;
  final String time;
  final String? notes;

  const AppointmentRequestModel({
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
}