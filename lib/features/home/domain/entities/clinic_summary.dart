// lib/features/home/domain/entities/clinic_summary.dart

import 'package:equatable/equatable.dart';

class ClinicSummary extends Equatable {
  final int id;
  final String name;
  final List<String> imageUrls;
  final String? specialty;
  final String reviewsCount;
  final String location;
  final String rating;
  final bool isOpen;
  final String doctorsCount;
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
      : 'https://systass.org/placeholder-2-1-png/';

  bool get hasSpecialty => specialty != null && specialty!.isNotEmpty;

  String get displaySpecialty => specialty ?? 'عام';

  // CopyWith method
  ClinicSummary copyWith({
    int? id,
    String? name,
    List<String>? imageUrls,
    String? specialty,
    String? reviewsCount,
    String? location,
    String? rating,
    bool? isOpen,
    String? doctorsCount,
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
  String toString() {
    return 'ClinicSummary{id: $id, name: $name, isFavorite: $isFavorite}';
  }

  @override
  bool get stringify => true;
}