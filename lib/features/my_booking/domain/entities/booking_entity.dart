import 'package:equatable/equatable.dart';

class BookingEntity extends Equatable {
  final int id;
  final String? patientName;
  final String? patientPhone;
  final String date;
  final String time;
  final int? turnNumber;
  final int? waitTurns;
  final String status; // 'pending' | 'confirmed' | 'cancelled' | 'completed'
  final String? notes;
  final bool hasFollowUp;
  final bool isFollowUp;
  final ClinicalEntity clinical;
  final DoctorEntity doctor;

  const BookingEntity({
    required this.id,
    this.patientName,
    this.patientPhone,
    required this.date,
    required this.time,
    this.turnNumber,
    this.waitTurns,
    required this.status,
    this.notes,
    this.hasFollowUp = false,
    this.isFollowUp = false,
    required this.clinical,
    required this.doctor,
  });

  bool get isPending   => status == 'pending';
  bool get isConfirmed => status == 'confirmed';
  bool get isCancelled => status == 'cancelled';
  bool get isCompleted => status == 'completed';

  bool get canReview   => isCompleted;
  bool get canCancel   => isPending;
  bool get hasQueue => waitTurns != null && waitTurns! > 0;


  @override
  List<Object?> get props => [
    id, patientName, patientPhone, date, time,
    turnNumber, status, notes, hasFollowUp, isFollowUp,
    clinical, doctor, waitTurns
  ];
}

class ClinicalEntity extends Equatable {
  final int id;
  final String name;
  final String? specialty;
  final String? location;
  final String? thumbnailUrl;
  final double rating;
  final int reviewsCount;

  const ClinicalEntity({
    required this.id,
    required this.name,
    this.specialty,
    this.location,
    this.thumbnailUrl,
    required this.rating,
    required this.reviewsCount,
  });

  @override
  List<Object?> get props => [id, name, specialty, location, thumbnailUrl, rating, reviewsCount];
}

class DoctorEntity extends Equatable {
  final int id;
  final String name;
  final String specialty;
  final String? imageUrl;
  final double rating;
  final int? experienceYears;

  const DoctorEntity({
    required this.id,
    required this.name,
    required this.specialty,
    this.imageUrl,
    required this.rating,
    this.experienceYears,
  });

  @override
  List<Object?> get props => [id, name, specialty, imageUrl, rating, experienceYears];
}

class BookingListEntity extends Equatable {
  final List<BookingEntity> data;
  final int currentPage;
  final int lastPage;
  final int total;

  const BookingListEntity({
    required this.data,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  bool get hasNextPage => currentPage < lastPage;

  @override
  List<Object?> get props => [data, currentPage, lastPage, total];
}