import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String patientName;
  final String patientImageUrl;
  final double rating;
  final String comment;
  final DateTime date;
  final String doctorName;

  const ReviewEntity({
    required this.id,
    required this.patientName,
    required this.patientImageUrl,
    required this.rating,
    required this.comment,
    required this.date,
    required this.doctorName,
  });

  // Business Logic
  bool get isRecentReview {
    final daysDifference = DateTime.now().difference(date).inDays;
    return daysDifference <= 30;
  }

  @override
  List<Object?> get props => [
    id, patientName, patientImageUrl,
    rating, comment, date, doctorName,
  ];
}