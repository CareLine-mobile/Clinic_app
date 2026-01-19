

import 'package:clinic_app/features/clinic_details/domain/entites/doctor_entity.dart';

import 'time_slot_model.dart';

class DoctorModel extends DoctorEntity {
  const DoctorModel({
    required super.id,
    required super.name,
    required super.specialty,
    required super.imageUrl,
    required super.rating,
    required super.reviewsCount,
    required super.experienceYears,
    required super.qualifications,
    required super.bio,
    required super.languages,
    required super.consultationFee,
    required super.availableSlots,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      imageUrl: json['image_url'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewsCount: json['reviews_count'] ?? 0,
      experienceYears: json['experience_years'] ?? 0,
      qualifications: json['qualifications'] ?? '',
      bio: json['bio'] ?? '',
      languages: List<String>.from(json['languages'] ?? []),
      consultationFee: (json['consultation_fee'] ?? 0).toDouble(),
      availableSlots: (json['available_slots'] as List<dynamic>?)
          ?.map((slot) => TimeSlotModel.fromJson(slot))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'image_url': imageUrl,
      'rating': rating,
      'reviews_count': reviewsCount,
      'experience_years': experienceYears,
      'qualifications': qualifications,
      'bio': bio,
      'languages': languages,
      'consultation_fee': consultationFee,
      'available_slots': availableSlots
          .map((slot) => TimeSlotModel.fromEntity(slot).toJson())
          .toList(),
    };
  }

  factory DoctorModel.fromEntity(DoctorEntity entity) {
    return DoctorModel(
      id: entity.id,
      name: entity.name,
      specialty: entity.specialty,
      imageUrl: entity.imageUrl,
      rating: entity.rating,
      reviewsCount: entity.reviewsCount,
      experienceYears: entity.experienceYears,
      qualifications: entity.qualifications,
      bio: entity.bio,
      languages: entity.languages,
      consultationFee: entity.consultationFee,
      availableSlots: entity.availableSlots,
    );
  }
}
