// import '../../../home/domain/entities/clinic_summary.dart';
//
// /// Maps the /favorites API response to the shared domain entity.
// /// ⚠️ Adjust JSON keys to match your actual backend response.
// class FavouriteClinicModel {
//   final int id;
//   final String name;
//   final String? specialty;
//   final String specialties;
//   final String location;
//   final String rating;
//   final int reviewsCount;
//   final int doctorsCount;
//   final bool isOpen;
//   final List<String> images;
//
//   const FavouriteClinicModel({
//     required this.id,
//     required this.name,
//     this.specialty,
//     required this.specialties,
//     required this.location,
//     required this.rating,
//     required this.reviewsCount,
//     required this.doctorsCount,
//     required this.isOpen,
//     required this.images,
//   });
//
//   factory FavouriteClinicModel.fromJson(Map<String, dynamic> json) {
//     return FavouriteClinicModel(
//       id: json['id'] as int,
//       name: (json['name'] as String?) ?? '',
//       specialty: json['specialty'] as String?,
//       specialties: json['specialties'] as String? ?? 'عام',
//       location: (json['address'] as String?) ??
//           (json['location'] as String?) ??
//           '',
//       rating: (json['rating'] ?? '0').toString(),
//       reviewsCount:
//       (json['reviews_count'] ?? json['reviewsCount'] ?? 0) as int,
//       doctorsCount:
//       (json['doctors_count'] ?? json['doctorsCount'] ?? 0) as int,
//       isOpen: (json['is_open'] ?? json['isOpen'] ?? false) as bool,
//       images: _toStringList(json['images']),
//     );
//   }
//
//   static List<String> _toStringList(dynamic value) {
//     if (value == null) return [];
//     if (value is List) return value.map((e) => e.toString()).toList();
//     return [];
//   }
//
//   /// ⚠️ Match the named params to your actual ClinicSummary constructor.
//   ClinicSummary toEntity() => ClinicSummary(
//     id: id,
//     name: name,
//     specialty: specialty,
//     location: location,
//     rating: rating,
//     reviewsCount: reviewsCount,
//     doctorsCount: doctorsCount,
//     isFavorite: true, // always true — it came from the favourites endpoint
//     isOpen: isOpen,
//     images: images,
//   );
// }