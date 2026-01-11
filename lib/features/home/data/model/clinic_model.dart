// lib/features/home/data/models/clinic_model.dart

import '../../domain/entities/clinic_summary.dart';

class ClinicModel extends ClinicSummary {
  const ClinicModel({
    required super.id,
    required super.name,
    required super.imageUrls,
    super.specialty,
    required super.reviewsCount,
    required super.location,
    required super.rating,
    required super.isOpen,
    required super.doctorsCount,
    super.isFavorite,
  });

  // From JSON - matches API response exactly
  factory ClinicModel.fromJson(Map<String, dynamic> json) {
    return ClinicModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      imageUrls: (json['image_urls'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      specialty: json['specialty'] as String?,
      reviewsCount: json['reviews_count'] as int? ?? 0,
      location: json['location'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      isOpen: json['is_open'] as bool? ?? true,
      doctorsCount: json['doctors_count'] as int? ?? 0,
      isFavorite: json['is_favorite'] as bool? ?? false,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image_urls': imageUrls,
      'specialty': specialty,
      'reviews_count': reviewsCount,
      'location': location,
      'rating': rating,
      'is_open': isOpen,
      'doctors_count': doctorsCount,
      'is_favorite': isFavorite,
    };
  }

  // Copy With
  @override
  ClinicModel copyWith({
    int? id,
    String? name,
    List<String>? imageUrls,
    String? specialty,
    int? reviewsCount,
    String? location,
    double? rating,
    bool? isOpen,
    int? doctorsCount,
    bool? isFavorite,
  }) {
    return ClinicModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrls: imageUrls ?? this.imageUrls,
      specialty: specialty ?? this.specialty,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      isOpen: isOpen ?? this.isOpen,
      doctorsCount: doctorsCount ?? this.doctorsCount,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  // To Entity
  ClinicSummary toEntity() {
    return ClinicSummary(
      id: id,
      name: name,
      imageUrls: imageUrls,
      specialty: specialty,
      reviewsCount: reviewsCount,
      location: location,
      rating: rating,
      isOpen: isOpen,
      doctorsCount: doctorsCount,
      isFavorite: isFavorite,
    );
  }

  // From Entity
  factory ClinicModel.fromEntity(ClinicSummary entity) {
    return ClinicModel(
      id: entity.id,
      name: entity.name,
      imageUrls: entity.imageUrls,
      specialty: entity.specialty,
      reviewsCount: entity.reviewsCount,
      location: entity.location,
      rating: entity.rating,
      isOpen: entity.isOpen,
      doctorsCount: entity.doctorsCount,
      isFavorite: entity.isFavorite,
    );
  }
}