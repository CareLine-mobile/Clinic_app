// ==================== MODELS ====================
import 'dart:ui';

class ClinicModel {
  final String id;
  final String name;
  final String specialty;
  final String location;
  final String imageUrl;
  final double rating;
  final int reviewsCount;
  final String nextAppointment;
  final double price;
  final int doctorsCount;
  final Color accentColor;
  final bool isFavorite;
  final bool isOpen;
  final List<String> availableTimes;

  ClinicModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.location,
    required this.imageUrl,
    required this.rating,
    required this.reviewsCount,
    required this.nextAppointment,
    required this.price,
    required this.accentColor,
    required this.doctorsCount,
    this.isFavorite = false,
    this.isOpen = true,
    this.availableTimes = const [],
  });

  ClinicModel copyWith({
    String? id,
    String? name,
    String? specialty,
    String? location,
    String? imageUrl,
    double? rating,
    int? reviewsCount,
    int? doctorsCount,
    String? nextAppointment,
    double? price,
    Color? accentColor,
    bool? isFavorite,
    bool? isOpen,
    List<String>? availableTimes,
  }) {
    return ClinicModel(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      nextAppointment: nextAppointment ?? this.nextAppointment,
      price: price ?? this.price,
      accentColor: accentColor ?? this.accentColor,
      isFavorite: isFavorite ?? this.isFavorite,
      isOpen: isOpen ?? this.isOpen,
      availableTimes: availableTimes ?? this.availableTimes,
      doctorsCount: doctorsCount ?? this.doctorsCount,
    );
  }
}