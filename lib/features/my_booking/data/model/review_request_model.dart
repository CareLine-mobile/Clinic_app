// ─── Review Request Model ─────────────────────────────────────────────────────

class ReviewRequestModel {
  final double rating;
  final String comment;
  final int? doctorId;

  const ReviewRequestModel({
    required this.rating,
    required this.comment,
    this.doctorId,
  });

  Map<String, dynamic> toJson() => {
    'rating': rating,
    'comment': comment,
    if (doctorId != null) 'doctor_id': doctorId,
  };
}