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
    required super.isFavorite,
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
      latitude: double.tryParse(json['lat']?.toString() ?? json['latitude']?.toString() ?? '0') ?? 0.0,
      longitude: double.tryParse(json['lng']?.toString() ?? json['longitude']?.toString() ?? '0') ?? 0.0,
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
      reviewsCount: int.tryParse(json['reviews_count']?.toString() ?? '0') ?? 0,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      isOpen: json['is_open'] ?? false,
      isFavorite: json['is_favourite'] ?? false,
      openingHours: json['opening_hours'] is List
          ? (json['opening_hours'] as List).map((e) {
              final day = e['day']?.toString().toLowerCase() ?? '';
              final timeFrom = e['time_from']?.toString() ?? '';
              final timeTo = e['time_to']?.toString() ?? '';
              
              String translateDay(String d) {
                switch (d) {
                  case 'saturday': return 'السبت';
                  case 'sunday': return 'الأحد';
                  case 'monday': return 'الاثنين';
                  case 'tuesday': return 'الثلاثاء';
                  case 'wednesday': return 'الأربعاء';
                  case 'thursday': return 'الخميس';
                  case 'friday': return 'الجمعة';
                  default: return d;
                }
              }

              String formatTime(String t) {
                if (t.isEmpty) return '';
                try {
                  final parts = t.split(':');
                  if (parts.length >= 2) {
                    int h = int.parse(parts[0]);
                    int m = int.parse(parts[1]);
                    String p = h >= 12 ? 'م' : 'ص';
                    h = h > 12 ? h - 12 : (h == 0 ? 12 : h);
                    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $p';
                  }
                } catch (_) {}
                return t;
              }

              return '${translateDay(day)}: ${formatTime(timeFrom)} - ${formatTime(timeTo)}';
            }).join('\n')
          : json['opening_hours']?.toString() ?? '',
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
      isFavorite: entity.isFavorite,
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
