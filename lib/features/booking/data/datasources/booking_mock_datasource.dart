import '../../domain/entities/booking_date_entity.dart';
import '../../domain/entities/time_slot_entity.dart';

class BookingMockDataSource {
  Future<List<BookingDateEntity>> getBookingDates() async {
    // Generate dates (e.g., next 7 days)
    final now = DateTime.now();
    return List.generate(7, (index) {
      return BookingDateEntity(
        date: now.add(Duration(days: index)),
        isSelected: index == 0, // Select the first one by default or handle in cubit
      );
    });
  }

  Future<List<TimeSlotBookingEntity>> getTimeSlots() async {
    // Dummy time slots matching the image
    return [
      TimeSlotBookingEntity(time: "9:00 AM", isAvailable: true),
      TimeSlotBookingEntity(time: "9:30 AM", isAvailable: true),
      TimeSlotBookingEntity(time: "10:00 AM", isAvailable: false), // Greyed out in image? Maybe.
      TimeSlotBookingEntity(time: "10:30 AM", isAvailable: true),
      TimeSlotBookingEntity(time: "11:00 AM", isAvailable: true, isSelected: true), // Example selected
      TimeSlotBookingEntity(time: "11:30 AM", isAvailable: false),
      TimeSlotBookingEntity(time: "2:00 PM", isAvailable: true),
      TimeSlotBookingEntity(time: "2:30 PM", isAvailable: true),
      TimeSlotBookingEntity(time: "3:00 PM", isAvailable: true),
      TimeSlotBookingEntity(time: "3:30 PM", isAvailable: false),
      TimeSlotBookingEntity(time: "4:00 PM", isAvailable: true),
      TimeSlotBookingEntity(time: "4:30 PM", isAvailable: true),
    ];
  }
}
