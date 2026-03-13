// lib/features/booking/domain/usecases/cancel_booking_usecase.dart
import 'package:clinic_app/core/errors/result_handler.dart';
import '../repositories/review_repository.dart';

// ─── Cancel booking ─────────────────────────────────────────────────────────

class CancelBookingUseCase {
  final MyBookingRepository _repository;

  const CancelBookingUseCase(this._repository);

  ResultVoid call(int bookingId) => _repository.cancelBooking(bookingId);
}