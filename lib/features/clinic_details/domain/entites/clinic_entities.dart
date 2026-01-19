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
    required this.openingHours,
    required this.services,
    required this.facilities,
    required this.insuranceAccepted,
    required this.doctors,
    required this.reviews,
    required this.statistics,
    required this.contactInfo,
  });

  @override
  List<Object?> get props => [
    id, name, specialty, description, location, fullAddress,
    latitude, longitude, imageUrls, rating, reviewsCount, price,
    isOpen, openingHours, services, facilities, insuranceAccepted,
    doctors, reviews, statistics, contactInfo,
  ];
}