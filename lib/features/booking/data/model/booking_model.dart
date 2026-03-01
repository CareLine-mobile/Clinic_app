import '../../domain/entities/booking_entity.dart';

class BookingListModel {
  final List<BookingModel> data;
  final int currentPage;
  final int lastPage;

  const BookingListModel({
    required this.data,
    required this.currentPage,
    required this.lastPage,
  });

  factory BookingListModel.fromJson(Map<String, dynamic> json) {
    return BookingListModel(
      data: (json['data'] as List)
          .map((e) => BookingModel.fromJson(e))
          .toList(),
      currentPage: json['current_page'],
      lastPage: json['last_page'],
    );
  }

  BookingListEntity toEntity() => BookingListEntity(
    data: data.map((e) => e.toEntity()).toList(),
    currentPage: currentPage,
    lastPage: lastPage,
  );
}

class BookingModel {
  final int id;
  final int clinicalId;
  final int doctorId;
  final String date;
  final String time;
  final int turnNumber;
  final String status;
  final String? notes;
  final ClinicalModel clinical;
  final DoctorModel doctor;

  const BookingModel({
    required this.id,
    required this.clinicalId,
    required this.doctorId,
    required this.date,
    required this.time,
    required this.turnNumber,
    required this.status,
    this.notes,
    required this.clinical,
    required this.doctor,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] is String ? int.parse(json['id']) : json['id'] ?? 0,
      clinicalId: json['clinical_id'] is String ? int.parse(json['clinical_id']) : json['clinical_id'] ?? 0,
      doctorId: json['doctor_id'] is String ? int.parse(json['doctor_id']) : json['doctor_id'] ?? 0,
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      turnNumber: json['turn_number'] is String ? int.parse(json['turn_number']) : json['turn_number'] ?? 0,
      status: json['status'] ?? '',
      notes: json['notes'],
      clinical: ClinicalModel.fromJson(json['clinical']),
      doctor: DoctorModel.fromJson(json['doctor']),
    );
  }

  BookingEntity toEntity() => BookingEntity(
    id: id,
    clinicalId: clinicalId,
    doctorId: doctorId,
    date: date,
    time: time,
    turnNumber: turnNumber,
    status: status,
    notes: notes,
    clinical: clinical.toEntity(),
    doctor: doctor.toEntity(),
  );
}

class ClinicalModel {
  final int id;
  final String name;
  final List<String> imageUrls;
  final String specialty;
  final int reviewsCount;
  final String location;
  final double rating;
  final bool isOpen;
  final int doctorsCount;

  const ClinicalModel({
    required this.id,
    required this.name,
    required this.imageUrls,
    required this.specialty,
    required this.reviewsCount,
    required this.location,
    required this.rating,
    required this.isOpen,
    required this.doctorsCount,
  });


  factory ClinicalModel.fromJson(Map<String, dynamic> json) {
    return ClinicalModel(
      id: json['id'] is String ? int.parse(json['id']) : json['id'] ?? 0,
      name: json['name'] ?? '',
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      specialty: json['specialty'] ?? '',
      reviewsCount: int.tryParse(json['reviews_count']?.toString() ?? '0') ?? 0,
      location: json['location'] ?? '',
      rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
      isOpen: json['is_open'] ?? false,
      doctorsCount: int.tryParse(json['doctors_count']?.toString() ?? '0') ?? 0,
    );
  }

  ClinicalEntity toEntity() => ClinicalEntity(
    id: id,
    name: name,
    imageUrls: imageUrls,
    specialty: specialty,
    reviewsCount: reviewsCount,
    location: location,
    rating: rating,
    isOpen: isOpen,
    doctorsCount: doctorsCount,
  );
}

class DoctorModel {
  final int id;
  final String name;
  final String specialty;

  const DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'],
      name: json['name'],
      specialty: json['specialty'],
    );
  }

  DoctorEntity toEntity() => DoctorEntity(
    id: id,
    name: name,
    specialty: specialty,
  );
}