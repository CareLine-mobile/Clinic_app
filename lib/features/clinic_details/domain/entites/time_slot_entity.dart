import 'package:equatable/equatable.dart';

class TimeSlotEntity extends Equatable {
  final int id;
  final String day;
  final String timeSlot;
  final String timeFrom;
  final String timeTo;
  final bool isBooked;
  final int bookedCount;
  final int maxBookings;

  const TimeSlotEntity({
    required this.id,
    required this.day,
    required this.timeSlot,
    required this.timeFrom,
    required this.timeTo,
    required this.isBooked,
    required this.bookedCount,
    required this.maxBookings,
  });

  // Business Logic
  bool get isAvailable => !isBooked && bookedCount < maxBookings;

  int get remainingSlots => maxBookings - bookedCount;

  double get availabilityPercentage =>
      (remainingSlots / maxBookings) * 100;

  @override
  List<Object?> get props => [
    id, day, timeSlot, timeFrom, timeTo,
    isBooked, bookedCount, maxBookings,
  ];
}