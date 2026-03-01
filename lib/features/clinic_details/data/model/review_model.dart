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
    return ReviewModel(
      id: json['id']?.toString() ?? '',
      patientName: json['patient_name'] ?? '',
      patientImageUrl: json['patient_image_url'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['comment'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      doctorName: json['doctor_name'] ?? '',
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
}