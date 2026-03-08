// lib/features/booking/data/models/booking_model.dart

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
      currentPage: json['current_page'] as int,
      lastPage:    json['last_page'] as int,
      data: (json['data'] as List)
          .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  BookingListEntity toEntity() => BookingListEntity(
    data:        data.map((e) => e.toEntity()).toList(),
    currentPage: currentPage,
    lastPage:    lastPage,
  );
}

class BookingModel {
  final int id;
  final int clinicalId;
  final int doctorId;
  final String date;
  final String time;
  final int? turnNumber;
  final String status;
  final String? notes;
  final String? patientName;
  final String? patientPhone;
  final ClinicalModel clinical;
  final DoctorModel doctor;

  const BookingModel({
    required this.id,
    required this.clinicalId,
    required this.doctorId,
    required this.date,
    required this.time,
    this.turnNumber,
    required this.status,
    this.notes,
    this.patientName,
    this.patientPhone,
    required this.clinical,
    required this.doctor,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id:           _parseInt(json['id'])!,
      clinicalId:   _parseInt(json['clinical_id'])!,
      doctorId:     _parseInt(json['doctor_id'])!,
      date:         json['date'] as String,
      time:         json['time'] as String,
      turnNumber:   _parseInt(json['turn_number']),   // nullable
      status:       json['status'] as String,
      notes:        json['notes'] as String?,
      patientName:  json['name'] as String?,          // nullable
      patientPhone: json['phone'] as String?,         // nullable
      clinical:     ClinicalModel.fromJson(json['clinical'] as Map<String, dynamic>),
      doctor:       DoctorModel.fromJson(json['doctor'] as Map<String, dynamic>),
    );
  }

  BookingEntity toEntity() => BookingEntity(
    id:           id,
    clinicalId:   clinicalId,
    doctorId:     doctorId,
    date:         date,
    time:         time,
    turnNumber:   turnNumber,
    status:       status,
    notes:        notes,
    patientName:  patientName,
    patientPhone: patientPhone,
    clinical:     clinical.toEntity(),
    doctor:       doctor.toEntity(),
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
      id:           _parseInt(json['id'])!,
      name:         json['name'] as String,
      imageUrls:    List<String>.from(json['image_urls'] as List? ?? []),
      specialty:    json['specialty'] as String,
      reviewsCount: _parseInt(json['reviews_count']) ?? 0,
      location:     json['location'] as String,
      rating:       _parseDouble(json['rating']) ?? 0.0,
      isOpen:       json['is_open'] as bool? ?? false,
      doctorsCount: _parseInt(json['doctors_count']) ?? 0,
    );
  }

  ClinicalEntity toEntity() => ClinicalEntity(
    id:           id,
    name:         name,
    imageUrls:    imageUrls,
    specialty:    specialty,
    reviewsCount: reviewsCount,
    location:     location,
    rating:       rating,
    isOpen:       isOpen,
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
      id:        _parseInt(json['id'])!,
      name:      json['name'] as String,
      specialty: json['specialty'] as String,
    );
  }

  BookingDoctorEntity toEntity() => BookingDoctorEntity(
    id:        id,
    name:      name,
    specialty: specialty,
  );
}

// ── Helpers ───────────────────────────────────────────────────────────────
// API returns IDs and numbers sometimes as strings, sometimes as int

int? _parseInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  return int.tryParse(v.toString());
}

double? _parseDouble(dynamic v) {
  if (v == null) return null;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  return double.tryParse(v.toString());
}