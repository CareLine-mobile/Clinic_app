import '../../domain/entities/booking_entity.dart';

// ─── Clinical Model ──────────────────────────────────────────────────────────

class ClinicalModel extends ClinicalEntity {
  const ClinicalModel({
    required super.id,
    required super.name,
    required super.specialty,
    required super.location,
    super.thumbnailUrl,
    required super.rating,
    required super.reviewsCount,
  });

  factory ClinicalModel.fromJson(Map<String, dynamic> json) {
    final imageUrls = (json['image_urls'] as List<dynamic>?)
        ?.map((e) => e.toString().trim())
        .toList();

    return ClinicalModel(
      id: int.parse(json['id'].toString()),
      name: json['name'] as String,
      specialty: json['specialty'] as String,
      location: json['location'] as String,
      thumbnailUrl: imageUrls?.isNotEmpty == true ? imageUrls!.first : null,
      rating: double.parse(json['rating'].toString()),
      reviewsCount: int.parse(json['reviews_count'].toString()),
    );
  }
}

// ─── Doctor Model ────────────────────────────────────────────────────────────

class DoctorModel extends DoctorEntity {
  const DoctorModel({
    required super.id,
    required super.name,
    required super.specialty,
    super.imageUrl,
    required super.rating,
    super.experienceYears,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: int.parse(json['id'].toString()),
      name: json['name'] as String,
      specialty: json['specialty'] as String,
      imageUrl: (json['image_url'] as String?)?.trim(),
      rating: double.parse(json['rating'].toString()),
      experienceYears: json['experience_years'] != null
          ? int.parse(json['experience_years'].toString())
          : null,
    );
  }
}

// ─── Booking Model ───────────────────────────────────────────────────────────

class BookingModel extends BookingEntity {
  const BookingModel({
    required super.id,
    super.patientName,
    super.patientPhone,
    required super.date,
    required super.time,
    super.turnNumber,
    super.waitTurns,
    required super.status,
    super.notes,
    required super.clinical,
    required super.doctor,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: int.parse(json['id'].toString()),
      patientName: json['name'] as String?,
      patientPhone: json['phone'] as String?,
      date: json['date'] as String,
      time: json['time'] as String,
      waitTurns: json['wait_turns'] != null
          ? int.tryParse(json['wait_turns'].toString())
          : null,
      turnNumber: json['turn_number'] != null
          ? int.tryParse(json['turn_number'].toString())
          : null,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      clinical: ClinicalModel.fromJson(json['clinical'] as Map<String, dynamic>),
      doctor: DoctorModel.fromJson(json['doctor'] as Map<String, dynamic>),
    );
  }
}

// ─── Booking List Model ───────────────────────────────────────────────────────

class BookingListModel extends BookingListEntity {
  const BookingListModel({
    required super.data,
    required super.currentPage,
    required super.lastPage,
    required super.total,
  });

  /// Parses the nested paginator from the API:
  factory BookingListModel.fromJson(Map<String, dynamic> json) {
    // Handle case where meta might be missing entirely
    final meta = json['meta'] as Map<String, dynamic>?;

    // Get the list from 'data' key
    final rawList = json['data'] as List<dynamic>? ?? [];

    // Safely parse pagination with defaults
    final currentPage = meta != null
        ? (meta['current_page'] as num?)?.toInt() ?? 1
        : 1;

    final lastPage = meta != null
        ? (meta['last_page'] as num?)?.toInt() ?? 1
        : 1;

    final total = meta != null
        ? (meta['total'] as num?)?.toInt() ?? rawList.length
        : rawList.length;

    return BookingListModel(
      data: rawList
          .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: currentPage,
      lastPage: lastPage,
      total: total,
    );
  }
}

