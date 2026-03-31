import 'package:equatable/equatable.dart';
import 'doctor_entity.dart';
import 'review_entity.dart';
import 'clinic_statistics_entity.dart';
import 'contact_info_entity.dart';

class ClinicEntity extends Equatable {
  final String id;
  final String name;
  final String specialty;
  final String description;
  final String location;
  final String fullAddress;
  final double latitude;
  final double longitude;
  final List<String> imageUrls;
  final double rating;
  final int reviewsCount;
  final double price;
  final bool isOpen;
  final bool isFavorite;
  final String openingHours;
  final List<String> services;
  final List<String> facilities;
  final List<String> insuranceAccepted;
  final List<DoctorEntity> doctors;
  final List<ReviewEntity> reviews;
  final ClinicStatisticsEntity statistics;
  final ContactInfoEntity contactInfo;

  const ClinicEntity({
    required this.id,
    required this.name,
    required this.specialty,
    required this.description,
    required this.location,
    required this.fullAddress,
    required this.latitude,
    required this.longitude,
    required this.imageUrls,
    required this.rating,
    required this.reviewsCount,
    required this.price,
    required this.isOpen,
    required this.isFavorite,
    required this.openingHours,
    required this.services,
    required this.facilities,
    required this.insuranceAccepted,
    required this.doctors,
    required this.reviews,
    required this.statistics,
    required this.contactInfo,
  });
  ClinicEntity copyWith({
    String? id,
    String? name,
    String? specialty,
    String? description,
    String? location,
    String? fullAddress,
    double? latitude,
    double? longitude,
    List<String>? imageUrls,
    double? rating,
    int? reviewsCount,
    double? price,
    bool? isOpen,
    bool? isFavorite,
    String? openingHours,
    List<String>? services,
    List<String>? facilities,
    List<String>? insuranceAccepted,
    List<DoctorEntity>? doctors,
    List<ReviewEntity>? reviews,
    ClinicStatisticsEntity? statistics,
    ContactInfoEntity? contactInfo,
  }) {
    return ClinicEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      description: description ?? this.description,
      location: location ?? this.location,
      fullAddress: fullAddress ?? this.fullAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imageUrls: imageUrls ?? this.imageUrls,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      price: price ?? this.price,
      isOpen: isOpen ?? this.isOpen,
      isFavorite: isFavorite ?? this.isFavorite,
      openingHours: openingHours ?? this.openingHours,
      services: services ?? this.services,
      facilities: facilities ?? this.facilities,
      insuranceAccepted: insuranceAccepted ?? this.insuranceAccepted,
      doctors: doctors ?? this.doctors,
      reviews: reviews ?? this.reviews,
      statistics: statistics ?? this.statistics,
      contactInfo: contactInfo ?? this.contactInfo,
    );
  }
  @override
  List<Object?> get props => [
    id, name, specialty, description, location, fullAddress,
    latitude, longitude, imageUrls, rating, reviewsCount, price,
    isOpen, openingHours, services, facilities, insuranceAccepted,
    doctors, reviews, statistics, contactInfo,isFavorite
  ];
}