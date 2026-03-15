import 'package:clinic_app/features/user_data/user_repo.dart';

class ReviewRequestModel {
  final double rating;
  final String comment;
  final int? doctorId;
  final String? patientName;
  final String? patientImageUrl;

  const ReviewRequestModel({
    required this.rating,
    required this.comment,
    this.doctorId,
    this.patientName,
    this.patientImageUrl,
  });

  /// Pulls patient info from UserRepository automatically
  factory ReviewRequestModel.fromParams({
    required double rating,
    required String comment,
    int? doctorId,
  }) {
    final user = UserRepository().currentUser;
    return ReviewRequestModel(
      rating: rating,
      comment: comment,
      doctorId: doctorId,
      patientName: user?.name,
      patientImageUrl: user?.avatar ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'rating': rating,
    'comment': comment,
    if (doctorId != null) 'doctor_id': doctorId,
    if (patientName != null) 'patient_name': patientName,
    if (patientImageUrl != null) 'patient_image_url': patientImageUrl,
  };
}