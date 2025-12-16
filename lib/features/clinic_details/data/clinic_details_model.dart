// lib/features/clinics/data/model/clinic_details_model.dart

import 'package:flutter/material.dart';

/// Doctor Model
class DoctorModel {
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

  DoctorModel({
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

  DoctorModel copyWith({
    String? id,
    String? name,
    String? specialty,
    String? imageUrl,
    double? rating,
    int? reviewsCount,
    int? experienceYears,
    String? qualifications,
    String? bio,
    List<String>? languages,
    List<DoctorAvailabilitySlot>? availableSlots,
    double? consultationFee,
  }) {
    return DoctorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      experienceYears: experienceYears ?? this.experienceYears,
      qualifications: qualifications ?? this.qualifications,
      bio: bio ?? this.bio,
      languages: languages ?? this.languages,
      availableSlots: availableSlots ?? this.availableSlots,
      consultationFee: consultationFee ?? this.consultationFee,
    );
  }
}

/// Doctor Availability Slot
class DoctorAvailabilitySlot {
  final DateTime dateTime;
  final String timeSlot; // e.g., "10:00 ص"
  final bool isAvailable;
  final int bookedCount;
  final int maxBookings;

  DoctorAvailabilitySlot({
    required this.dateTime,
    required this.timeSlot,
    required this.isAvailable,
    required this.bookedCount,
    required this.maxBookings,
  });

  bool get isFull => bookedCount >= maxBookings;
}

/// Clinic Details Model
class ClinicDetailsModel {
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
  final Color accentColor;
  final bool isFavorite;
  final bool isOpen;
  final String openingHours;
  final List<String> services;
  final List<String> facilities;
  final List<String> insuranceAccepted;
  final List<DoctorModel> doctors;
  final List<ReviewModel> reviews;
  final ClinicStatistics statistics;
  final ContactInfo contactInfo;

  ClinicDetailsModel({
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
    required this.accentColor,
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

  ClinicDetailsModel copyWith({
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
    Color? accentColor,
    bool? isFavorite,
    bool? isOpen,
    String? openingHours,
    List<String>? services,
    List<String>? facilities,
    List<String>? insuranceAccepted,
    List<DoctorModel>? doctors,
    List<ReviewModel>? reviews,
    ClinicStatistics? statistics,
    ContactInfo? contactInfo,
  }) {
    return ClinicDetailsModel(
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
      accentColor: accentColor ?? this.accentColor,
      isFavorite: isFavorite ?? this.isFavorite,
      isOpen: isOpen ?? this.isOpen,
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
}

/// Review Model
class ReviewModel {
  final String id;
  final String patientName;
  final String patientImageUrl;
  final double rating;
  final String comment;
  final DateTime date;
  final String doctorName;

  ReviewModel({
    required this.id,
    required this.patientName,
    required this.patientImageUrl,
    required this.rating,
    required this.comment,
    required this.date,
    required this.doctorName,
  });
}

/// Clinic Statistics
class ClinicStatistics {
  final int totalVisits;
  final int totalBookings;
  final int totalDoctors;
  final int satisfactionRate; // percentage
  final Map<String, int> monthlyVisits; // month -> count

  ClinicStatistics({
    required this.totalVisits,
    required this.totalBookings,
    required this.totalDoctors,
    required this.satisfactionRate,
    required this.monthlyVisits,
  });
}

/// Contact Info
class ContactInfo {
  final String phone;
  final String email;
  final String website;
  final Map<String, String> socialMedia; // platform -> url

  ContactInfo({
    required this.phone,
    required this.email,
    required this.website,
    required this.socialMedia,
  });
}