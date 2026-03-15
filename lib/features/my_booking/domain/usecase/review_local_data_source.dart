import 'package:clinic_app/features/my_booking/data/data_sources/review_local_data_source.dart';

// ─── Check if reviewed ────────────────────────────────────────────────────────

class IsClinicReviewedUseCase {
  final ReviewLocalDataSource _local;
  const IsClinicReviewedUseCase(this._local);

  Future<bool> call(int clinicId) => _local.isReviewed(clinicId);
}

// ─── Mark as reviewed ─────────────────────────────────────────────────────────

class MarkClinicReviewedUseCase {
  final ReviewLocalDataSource _local;
  const MarkClinicReviewedUseCase(this._local);

  Future<void> call(int clinicId) => _local.markAsReviewed(clinicId);
}