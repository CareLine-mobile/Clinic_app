import 'package:clinic_app/features/clinic_details/data/model/time_slot_model.dart';
import 'package:clinic_app/features/clinic_details/data/model/review_model.dart';
import 'package:clinic_app/features/doctor_details/domain/entities/doctor_profile_entity.dart';

class ClinicalInfoModel extends ClinicalInfoEntity {
  const ClinicalInfoModel({
    required super.id,
    required super.name,
    required super.location,
    required super.categoryId,
  });

  factory ClinicalInfoModel.fromJson(Map<String, dynamic> json) {
    return ClinicalInfoModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      categoryId: json['category_id']?.toString() ?? '',
    );
  }
}

class DoctorProfileModel extends DoctorProfileEntity {
  const DoctorProfileModel({
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
    super.clinical,
    super.reviews,
  });

  factory DoctorProfileModel.fromJson(Map<String, dynamic> json) {
    final clinicalJson = json['clinical'];
    return DoctorProfileModel(
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
              ?.map((s) => TimeSlotModel.fromJson(s))
              .toList() ??
          [],
      clinical: clinicalJson != null
          ? ClinicalInfoModel.fromJson(clinicalJson)
          : null,
      reviews: (json['reviews'] as List<dynamic>?)
              ?.map((r) => ReviewModel.fromJson(r))
              .toList() ??
          [],
    );
  }
}
