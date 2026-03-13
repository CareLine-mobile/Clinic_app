import 'package:clinic_app/core/errors/result_handler.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../../clinic_details/domain/entites/review_entity.dart';
import '../repositories/review_repository.dart';

// ─── Create review ──────────────────────────────────────────────────────────

class CreateReviewParams {
  final int clinicId;
  final int bookingId;
  final double rating;
  final String comment;
  final int? doctorId;

  const CreateReviewParams({
    required this.clinicId,
    required this.bookingId,
    required this.rating,
    required this.comment,
    this.doctorId,
  });
}

class CreateReviewUseCase {
  final MyBookingRepository _repository;

  const CreateReviewUseCase(this._repository);

  ResultVoid call(CreateReviewParams params) => _repository.createReview(
    clinicId: params.clinicId,
    bookingId: params.bookingId,
    rating: params.rating,
    comment: params.comment,
    doctorId: params.doctorId,
  );
}