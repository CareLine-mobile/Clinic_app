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
  final int turnNumber;
  final String status;
  final String? notes;
  final ClinicalEntity clinical;
  final DoctorEntity doctor;

  const BookingEntity({
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

  bool get isConfirmed => status == 'confirmed';
  bool get isCancelled => status == 'cancelled';
  bool get isPending => status == 'pending';

  @override
  List<Object?> get props => [
    id,
    clinicalId,
    doctorId,
    date,
    time,
    turnNumber,
    status,
    notes,
    clinical,
    doctor,
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
    id,
    name,
    imageUrls,
    specialty,
    reviewsCount,
    location,
    rating,
    isOpen,
    doctorsCount,
  ];
}

class DoctorEntity extends Equatable {
  final int id;
  final String name;
  final String specialty;

  const DoctorEntity({
    required this.id,
    required this.name,
    required this.specialty,
  });

  @override
  List<Object?> get props => [id, name, specialty];
}