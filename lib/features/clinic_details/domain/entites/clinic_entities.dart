// lib/features/clinics/domain/entities/clinic_entities.dart

import 'package:equatable/equatable.dart';

/// Doctor Entity (Domain Layer)
class Doctor extends Equatable {
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
  final List<DoctorAvailabilitySlot> availableSlots;
  final double consultationFee;

  const Doctor({
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
    required this.availableSlots,
    required this.consultationFee,
  });

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
    availableSlots,
    consultationFee,
  ];
}

/// Doctor Availability Slot Entity
class DoctorAvailabilitySlot extends Equatable {
  final DateTime dateTime;
  final String timeSlot;
  final bool isAvailable;
  final int bookedCount;
  final int maxBookings;

  const DoctorAvailabilitySlot({
    required this.dateTime,
    required this.timeSlot,
    required this.isAvailable,
    required this.bookedCount,
    required this.maxBookings,
  });

  bool get isFull => bookedCount >= maxBookings;

  @override
  List<Object?> get props => [
    dateTime,
    timeSlot,
    isAvailable,
    bookedCount,
    maxBookings,
  ];
}

/// Clinic Details Entity (Domain Layer)
class ClinicDetails extends Equatable {
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
  final bool isFavorite;
  final bool isOpen;
  final String openingHours;
  final List<String> services;
  final List<String> facilities;
  final List<String> insuranceAccepted;
  final List<Doctor> doctors;
  final List<Review> reviews;
  final ClinicStatistics statistics;
  final ContactInfo contactInfo;

  const ClinicDetails({
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
    required this.isFavorite,
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
    id,
    name,
    specialty,
    description,
    location,
    fullAddress,
    latitude,
    longitude,
    imageUrls,
    rating,
    reviewsCount,
    price,
    isFavorite,
    isOpen,
    openingHours,
    services,
    facilities,
    insuranceAccepted,
    doctors,
    reviews,
    statistics,
    contactInfo,
  ];
}

/// Review Entity
class Review extends Equatable {
  final String id;
  final String patientName;
  final String patientImageUrl;
  final double rating;
  final String comment;
  final DateTime date;
  final String doctorName;

  const Review({
    required this.id,
    required this.patientName,
    required this.patientImageUrl,
    required this.rating,
    required this.comment,
    required this.date,
    required this.doctorName,
  });

  @override
  List<Object?> get props => [
    id,
    patientName,
    patientImageUrl,
    rating,
    comment,
    date,
    doctorName,
  ];
}

/// Clinic Statistics Entity
class ClinicStatistics extends Equatable {
  final int totalVisits;
  final int totalBookings;
  final int totalDoctors;
  final int satisfactionRate;
  final Map<String, int> monthlyVisits;

  const ClinicStatistics({
    required this.totalVisits,
    required this.totalBookings,
    required this.totalDoctors,
    required this.satisfactionRate,
    required this.monthlyVisits,
  });

  @override
  List<Object?> get props => [
    totalVisits,
    totalBookings,
    totalDoctors,
    satisfactionRate,
    monthlyVisits,
  ];
}

/// Contact Info Entity
class ContactInfo extends Equatable {
  final String phone;
  final String email;
  final String website;
  final Map<String, String> socialMedia;

  const ContactInfo({
    required this.phone,
    required this.email,
    required this.website,
    required this.socialMedia,
  });

  @override
  List<Object?> get props => [
    phone,
    email,
    website,
    socialMedia,
  ];
}