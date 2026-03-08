// lib/features/booking/domain/entities/booking_entity.dart

import 'package:equatable/equatable.dart';

class BookingListEntity extends Equatable {
  final List<BookingEntity> data;
  final int currentPage;
  final int lastPage;

  const BookingListEntity({
    required this.data,
    required this.currentPage,
    required this.lastPage,
  });

  bool get hasNextPage => currentPage < lastPage;

  @override
  List<Object?> get props => [data, currentPage, lastPage];
}

class BookingEntity extends Equatable {
  final int id;
  final int clinicalId;
  final int doctorId;
  final String date;
  final String time;
  final int? turnNumber;      // nullable — API returns null when pending
  final String status;
  final String? notes;
  final String? patientName;  // nullable — API returns null
  final String? patientPhone; // nullable — API returns null
  final ClinicalEntity clinical;
  final BookingDoctorEntity doctor;

  const BookingEntity({
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

  bool get isConfirmed => status == 'confirmed';
  bool get isCancelled => status == 'cancelled';
  bool get isPending   => status == 'pending';

  @override
  List<Object?> get props => [
    id, clinicalId, doctorId, date, time,
    turnNumber, status, notes, patientName, patientPhone,
    clinical, doctor,
  ];
}

class ClinicalEntity extends Equatable {
  final int id;
  final String name;
  final List<String> imageUrls;
  final String specialty;
  final int reviewsCount;
  final String location;
  final double rating;
  final bool isOpen;
  final int doctorsCount;

  const ClinicalEntity({
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

  String? get thumbnailUrl => imageUrls.isNotEmpty ? imageUrls.first : null;

  @override
  List<Object?> get props => [
    id, name, imageUrls, specialty,
    reviewsCount, location, rating, isOpen, doctorsCount,
  ];
}

class BookingDoctorEntity extends Equatable {
  final int id;
  final String name;
  final String specialty;

  const BookingDoctorEntity({
    required this.id,
    required this.name,
    required this.specialty,
  });

  @override
  List<Object?> get props => [id, name, specialty];
}