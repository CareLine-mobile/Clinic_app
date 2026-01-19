import '../../domain/entites/clinic_entities.dart';
import '../../domain/entites/social_media_entity.dart';
import 'clinic_statistics_model.dart';
import 'contact_info_model.dart';
import 'doctor_model.dart';
import 'review_model.dart';

class ClinicModel extends ClinicEntity {
  const ClinicModel({
    required super.id,
    required super.name,
    required super.specialty,
    required super.description,
    required super.location,
    required super.fullAddress,
    required super.latitude,
    required super.longitude,
    required super.imageUrls,
    required super.rating,
    required super.reviewsCount,
    required super.price,
    required super.isOpen,
    required super.openingHours,
    required super.services,
    required super.facilities,
    required super.insuranceAccepted,
    required super.doctors,
    required super.reviews,
    required super.statistics,
    required super.contactInfo,
  });

  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      fullAddress: json['full_address'] ?? '',
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      rating: (json['rating'] ?? 0).toDouble(),
      reviewsCount: json['reviews_count'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      isOpen: json['is_open'] ?? false,
      openingHours: json['opening_hours'] ?? '',
      services: List<String>.from(json['services'] ?? []),
      facilities: List<String>.from(json['facilities'] ?? []),
      insuranceAccepted: List<String>.from(json['insurance_accepted'] ?? []),
      doctors: (json['doctors'] as List<dynamic>?)
          ?.map((doctor) => DoctorModel.fromJson(doctor))
          .toList() ??
          [],
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((review) => ReviewModel.fromJson(review))
          .toList() ??
          [],
      statistics: ClinicStatisticsModel.fromJson(json['statistics'] ?? {}),
      contactInfo: ContactInfoModel.fromJson(json['contact_info'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'description': description,
      'location': location,
      'full_address': fullAddress,
      'latitude': latitude,
      'longitude': longitude,
      'image_urls': imageUrls,
      'rating': rating,
      'reviews_count': reviewsCount,
      'price': price,
      'is_open': isOpen,
      'opening_hours': openingHours,
      'services': services,
      'facilities': facilities,
      'insurance_accepted': insuranceAccepted,
      'doctors': doctors
          .map((doctor) => DoctorModel.fromEntity(doctor).toJson())
          .toList(),
      'reviews': reviews
          .map((review) => ReviewModel.fromEntity(review).toJson())
          .toList(),
      'statistics': ClinicStatisticsModel.fromEntity(statistics).toJson(),
      'contact_info': ContactInfoModel.fromEntity(contactInfo).toJson(),
    };
  }

  factory ClinicModel.fromEntity(ClinicEntity entity) {
    return ClinicModel(
      id: entity.id,
      name: entity.name,
      specialty: entity.specialty,
      description: entity.description,
      location: entity.location,
      fullAddress: entity.fullAddress,
      latitude: entity.latitude,
      longitude: entity.longitude,
      imageUrls: entity.imageUrls,
      rating: entity.rating,
      reviewsCount: entity.reviewsCount,
      price: entity.price,
      isOpen: entity.isOpen,
      openingHours: entity.openingHours,
      services: entity.services,
      facilities: entity.facilities,
      insuranceAccepted: entity.insuranceAccepted,
      doctors: entity.doctors,
      reviews: entity.reviews,
      statistics: entity.statistics,
      contactInfo: entity.contactInfo,
    );
  }
}

