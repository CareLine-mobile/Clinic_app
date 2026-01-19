import '../entities/booking_date_entity.dart';
import '../entities/time_slot_entity.dart';

abstract class BookingRepository {
  Future<List<BookingDateEntity>> getBookingDates();
  Future<List<TimeSlotBookingEntity>> getTimeSlots(DateTime date);
}
