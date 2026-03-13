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
    // Use first image_url as thumbnail
    final imageUrls = json['image_urls'] as List<dynamic>?;
    final thumbnail = imageUrls?.isNotEmpty == true
        ? (imageUrls!.first as String).trim()
        : null;

    return ClinicalModel(
      id: json['id'] as int,
      name: json['name'] as String,
      specialty: json['specialty'] as String,
      location: json['location'] as String,
      thumbnailUrl: thumbnail,
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
      id: json['id'] as int,
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
    required super.status,
    super.notes,
    required super.clinical,
    required super.doctor,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as int,
      patientName: json['name'] as String?,
      patientPhone: json['phone'] as String?,
      date: json['date'] as String,
      time: json['time'] as String,
      turnNumber: json['turn_number'] != null
          ? int.parse(json['turn_number'].toString())
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
  /// response['data']['data'] → list of bookings
  factory BookingListModel.fromJson(Map<String, dynamic> json) {
    final paginator = json; // already unwrapped from response['data']
    final rawList = paginator['data'] as List<dynamic>;

    return BookingListModel(
      data: rawList
          .map((e) => BookingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: paginator['current_page'] as int,
      lastPage: paginator['last_page'] as int,
      total: paginator['total'] as int,
    );
  }
}

