import '../../domain/entities/booking_date_entity.dart';
import '../../domain/entities/time_slot_entity.dart';
import '../../domain/repository/booking_repository.dart';
import '../datasources/booking_mock_datasource.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingMockDataSource dataSource;

  BookingRepositoryImpl(this.dataSource);

  @override
  Future<List<BookingDateEntity>> getBookingDates() {
    return dataSource.getBookingDates();
  }

  @override
  Future<List<TimeSlotEntity>> getTimeSlots(DateTime date) {
    // In a real app, we'd fetch based on date. Here just return dummy list.
    return dataSource.getTimeSlots();
  }
}
