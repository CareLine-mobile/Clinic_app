import 'package:equatable/equatable.dart';
import 'package:clinic_app/features/clinic_details/domain/entites/time_slot_entity.dart';
import 'package:clinic_app/features/clinic_details/domain/entites/review_entity.dart';

class ClinicalInfoEntity extends Equatable {
  final int id;
  final String name;
  final String location;
  final String categoryId;

  const ClinicalInfoEntity({
    required this.id,
    required this.name,
    required this.location,
    required this.categoryId,
  });

  @override
  List<Object?> get props => [id, name, location, categoryId];
}

class DoctorProfileEntity extends Equatable {
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
  final ClinicalInfoEntity? clinical;
  final List<ReviewEntity> reviews;

  const DoctorProfileEntity({
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
    this.clinical,
    this.reviews = const [],
  });

  bool get hasAvailableSlots => availableSlots.any((slot) => slot.isAvailable);

  @override
  List<Object?> get props => [
        id,
        name,
        specialty,
        imageUrl,
        rating,
        reviewsCount,
        experienceYears,
        qualifications,
        bio,
        languages,
        consultationFee,
        availableSlots,
        clinical,
        reviews,
      ];
}
