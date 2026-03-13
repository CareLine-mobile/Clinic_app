
import '../../domain/entites/review_entity.dart';

class ReviewModel extends ReviewEntity {
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
    // Extract doctor info from nested object
    final doctorData = json['doctor'] as Map<String, dynamic>?;
    final doctorName = doctorData != null
        ? doctorData['name'] as String? ?? ''
        : json['doctor_name'] as String? ?? '';
    final doctorId = doctorData != null
        ? doctorData['id'] as int?
        : json['doctor_id'] as int?;

    // Parse date safely
    DateTime parsedDate;
    try {
      final dateString = json['date'] as String?;
      parsedDate = dateString != null
          ? DateTime.parse(dateString)
          : DateTime.now();
    } catch (e) {
      parsedDate = DateTime.now();
    }

    return ReviewModel(
      id: json['id']?.toString() ?? '',
      patientName: json['patient_name'] as String? ?? '',
      patientImageUrl: json['patient_image_url'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      comment: json['comment'] as String? ?? '',
      date: parsedDate,
      doctorName: doctorName,

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

  factory ReviewModel.fromEntity(ReviewEntity entity) {
    return ReviewModel(
      id: entity.id,
      patientName: entity.patientName,
      patientImageUrl: entity.patientImageUrl,
      rating: entity.rating,
      comment: entity.comment,
      date: entity.date,
      doctorName: entity.doctorName,
    );
  }

  // Helper to convert to entity
  ReviewEntity toEntity() => this;
}