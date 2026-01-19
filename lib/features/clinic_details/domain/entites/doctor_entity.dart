import 'package:equatable/equatable.dart';
import 'time_slot_entity.dart';

class DoctorEntity extends Equatable {
  final String id;
  final String name;
  final String specialty;
  final String imageUrl;
  final double rating;
  final int reviewsCount;
  final int experienceYears;
  final String qualifications;
  final String bio;
  final List<String> languages;
  final double consultationFee;
  final List<TimeSlotEntity> availableSlots;

  const DoctorEntity({
    required this.id,
    required this.name,
    required this.specialty,
    required this.imageUrl,
    required this.rating,
    required this.reviewsCount,
    required this.experienceYears,
    required this.qualifications,
    required this.bio,
    required this.languages,
    required this.consultationFee,
    required this.availableSlots,
  });

  // Business Logic
  bool get hasAvailableSlots =>
      availableSlots.any((slot) => slot.isAvailable);

  int get totalAvailableSlots =>
      availableSlots.where((slot) => slot.isAvailable).length;

  @override
  List<Object?> get props => [
    id, name, specialty, imageUrl, rating, reviewsCount,
    experienceYears, qualifications, bio, languages,
    consultationFee, availableSlots,
  ];
}