// lib/features/home/domain/entities/clinic_summary.dart

import 'package:equatable/equatable.dart';

class ClinicSummary extends Equatable {
  final int id;
  final String name;
  final List<String> imageUrls;
  final String? specialty;
  final int reviewsCount;
  final String location;
  final double rating;
  final bool isOpen;
  final int doctorsCount;
  final bool isFavorite;

  const ClinicSummary({
    required this.id,
    required this.name,
    required this.imageUrls,
    this.specialty,
    required this.reviewsCount,
    required this.location,
    required this.rating,
    required this.isOpen,
    required this.doctorsCount,
    this.isFavorite = false,
  });

  // Helper getters for UI
  String get firstImageUrl => imageUrls.isNotEmpty
      ? imageUrls.first
      : 'https://via.placeholder.com/400x300?text=No+Image';

  bool get hasSpecialty => specialty != null && specialty!.isNotEmpty;

  String get displaySpecialty => specialty ?? 'عام';

  // CopyWith method
  ClinicSummary copyWith({
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
    return ClinicSummary(
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
    isFavorite,
  ];

  @override
  bool get stringify => true;
}