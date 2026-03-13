import '../../../../../../core/errors/result_handler.dart';
import '../entities/booking_entity.dart';

abstract class MyBookingRepository {
  /// Fetch paginated list of user bookings
  ResultFuture<BookingListEntity> getUserBookings({int page = 1});

  /// Cancel a pending booking
  ResultVoid cancelBooking(int bookingId);

  /// Submit a review for a completed booking
  ResultVoid createReview({
    required int clinicId,
    required int bookingId,
    required double rating,
    required String comment,
    int? doctorId,
  });
}