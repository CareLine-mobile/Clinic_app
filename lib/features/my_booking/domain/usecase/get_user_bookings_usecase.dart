import 'package:clinic_app/features/my_booking/domain/repositories/review_repository.dart';
import '../../../../../../core/errors/result_handler.dart';
import '../entities/booking_entity.dart';
// ─── Get user bookings ──────────────────────────────────────────────────────

class GetUserBookingsUseCase {
  final MyBookingRepository _repository;

  const GetUserBookingsUseCase(this._repository);

  ResultFuture<BookingListEntity> call({int page = 1}) =>
      _repository.getUserBookings(page: page);
}



