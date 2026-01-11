// lib/features/clinics/data/models/clinic_models.dart
import 'package:flutter/material.dart';
import '../../domain/entites/clinic_entities.dart';


/// Doctor Model (Data Layer)
class DoctorModel extends Doctor {
  const DoctorModel({
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
    required super.availableSlots,
    required super.consultationFee,
  });

  // From JSON
  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as int,
      name: json['name'] as String,
      specialty: json['specialty'] as String,
      imageUrl: json['image_url'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewsCount: json['reviews_count'] as int,
      experienceYears: json['experience_years'] as int,
      qualifications: json['qualifications'] as String,
      bio: json['bio'] as String,
      languages: List<String>.from(json['languages'] as List),
      availableSlots: (json['available_slots'] as List)
          .map((slot) => DoctorAvailabilitySlotModel.fromJson(slot))
          .toList(),
      consultationFee: (json['consultation_fee'] as num).toDouble(),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'image_url': imageUrl,
      'rating': rating,
      'reviews_count': reviewsCount,
      'experience_years': experienceYears,
      'qualifications': qualifications,
      'bio': bio,
      'languages': languages,
      'available_slots': availableSlots
          .map((slot) => (slot as DoctorAvailabilitySlotModel).toJson())
          .toList(),
      'consultation_fee': consultationFee,
    };
  }

  // From Entity
  factory DoctorModel.fromEntity(Doctor entity) {
    return DoctorModel(
      id: entity.id,
      name: entity.name,
      specialty: entity.specialty,
      imageUrl: entity.imageUrl,
      rating: entity.rating,
      reviewsCount: entity.reviewsCount,
      experienceYears: entity.experienceYears,
      qualifications: entity.qualifications,
      bio: entity.bio,
      languages: entity.languages,
      availableSlots: entity.availableSlots,
      consultationFee: entity.consultationFee,
    );
  }
}

/// Doctor Availability Slot Model
class DoctorAvailabilitySlotModel extends DoctorAvailabilitySlot {
  const DoctorAvailabilitySlotModel({
    required super.dateTime,
    required super.timeSlot,
    required super.isAvailable,
    required super.bookedCount,
    required super.maxBookings,
  });

  factory DoctorAvailabilitySlotModel.fromJson(Map<String, dynamic> json) {
    return DoctorAvailabilitySlotModel(
      dateTime: DateTime.parse(json['date_time'] as String),
      timeSlot: json['time_slot'] as String,
      isAvailable: json['is_available'] as bool,
      bookedCount: json['booked_count'] as int,
      maxBookings: json['max_bookings'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date_time': dateTime.toIso8601String(),
      'time_slot': timeSlot,
      'is_available': isAvailable,
      'booked_count': bookedCount,
      'max_bookings': maxBookings,
    };
  }
}

/// Clinic Details Model (Data Layer)
class ClinicDetailsModel extends ClinicDetails {
  final Color accentColor;

  const ClinicDetailsModel({
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
    required super.isFavorite,
    required super.isOpen,
    required super.openingHours,
    required super.services,
    required super.facilities,
    required super.insuranceAccepted,
    required super.doctors,
    required super.reviews,
    required super.statistics,
    required super.contactInfo,
    required this.accentColor,
  });

  factory ClinicDetailsModel.fromJson(Map<String, dynamic> json) {
    return ClinicDetailsModel(
      id: json['id'] as int,
      name: json['name'] as String,
      specialty: json['specialty'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      fullAddress: json['full_address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      imageUrls: List<String>.from(json['image_urls'] as List),
      rating: (json['rating'] as num).toDouble(),
      reviewsCount: json['reviews_count'] as int,
      price: (json['price'] as num).toDouble(),
      isFavorite: json['is_favorite'] as bool? ?? false,
      isOpen: json['is_open'] as bool,
      openingHours: json['opening_hours'] as String,
      services: List<String>.from(json['services'] as List),
      facilities: List<String>.from(json['facilities'] as List),
      insuranceAccepted: List<String>.from(json['insurance_accepted'] as List),
      doctors: (json['doctors'] as List)
          .map((doctor) => DoctorModel.fromJson(doctor))
          .toList(),
      reviews: (json['reviews'] as List)
          .map((review) => ReviewModel.fromJson(review))
          .toList(),
      statistics: ClinicStatisticsModel.fromJson(json['statistics']),
      contactInfo: ContactInfoModel.fromJson(json['contact_info']),
      accentColor: Color(int.parse(json['accent_color'] as String, radix: 16)),
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
      'is_favorite': isFavorite,
      'is_open': isOpen,
      'opening_hours': openingHours,
      'services': services,
      'facilities': facilities,
      'insurance_accepted': insuranceAccepted,
      'doctors': doctors
          .map((doctor) => (doctor as DoctorModel).toJson())
          .toList(),
      'reviews': reviews
          .map((review) => (review as ReviewModel).toJson())
          .toList(),
      'statistics': (statistics as ClinicStatisticsModel).toJson(),
      'contact_info': (contactInfo as ContactInfoModel).toJson(),
      'accent_color': accentColor.value.toRadixString(16),
    };
  }

  ClinicDetailsModel copyWith({
    int? id,
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
    List<Doctor>? doctors,
    List<Review>? reviews,
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
class ReviewModel extends Review {
  const ReviewModel({
    required super.id,
    required super.patientName,
    required super.patientImageUrl,
    required super.rating,
    required super.comment,
    required super.date,
    required super.doctorName,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      patientName: json['patient_name'] as String,
      patientImageUrl: json['patient_image_url'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      date: DateTime.parse(json['date'] as String),
      doctorName: json['doctor_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_name': patientName,
      'patient_image_url': patientImageUrl,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
      'doctor_name': doctorName,
    };
  }
}

/// Clinic Statistics Model
class ClinicStatisticsModel extends ClinicStatistics {
  const ClinicStatisticsModel({
    required super.totalVisits,
    required super.totalBookings,
    required super.totalDoctors,
    required super.satisfactionRate,
    required super.monthlyVisits,
  });

  factory ClinicStatisticsModel.fromJson(Map<String, dynamic> json) {
    return ClinicStatisticsModel(
      totalVisits: json['total_visits'] as int,
      totalBookings: json['total_bookings'] as int,
      totalDoctors: json['total_doctors'] as int,
      satisfactionRate: json['satisfaction_rate'] as int,
      monthlyVisits: Map<String, int>.from(json['monthly_visits'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_visits': totalVisits,
      'total_bookings': totalBookings,
      'total_doctors': totalDoctors,
      'satisfaction_rate': satisfactionRate,
      'monthly_visits': monthlyVisits,
    };
  }
}

/// Contact Info Model
class ContactInfoModel extends ContactInfo {
  const ContactInfoModel({
    required super.phone,
    required super.email,
    required super.website,
    required super.socialMedia,
  });

  factory ContactInfoModel.fromJson(Map<String, dynamic> json) {
    return ContactInfoModel(
      phone: json['phone'] as String,
      email: json['email'] as String,
      website: json['website'] as String,
      socialMedia: Map<String, String>.from(json['social_media'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'email': email,
      'website': website,
      'social_media': socialMedia,
    };
  }
}