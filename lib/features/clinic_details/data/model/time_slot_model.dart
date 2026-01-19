
import '../../domain/entites/time_slot_entity.dart';

class TimeSlotModel extends TimeSlotEntity {
  const TimeSlotModel({
    required super.id,
    required super.day,
    required super.timeSlot,
    required super.timeFrom,
    required super.timeTo,
    required super.isBooked,
    required super.bookedCount,
    required super.maxBookings,
  });

  // From JSON
  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      id: json['id'] ?? 0,
      day: json['day'] ?? '',
      timeSlot: json['time_slot'] ?? '',
      timeFrom: json['time_from'] ?? '',
      timeTo: json['time_to'] ?? '',
      isBooked: json['is_booked'] ?? false,
      bookedCount: json['booked_count'] ?? 0,
      maxBookings: json['max_bookings'] ?? 5,
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day': day,
      'time_slot': timeSlot,
      'time_from': timeFrom,
      'time_to': timeTo,
      'is_booked': isBooked,
      'booked_count': bookedCount,
      'max_bookings': maxBookings,
    };
  }

  // From Entity (if needed)
  factory TimeSlotModel.fromEntity(TimeSlotEntity entity) {
    return TimeSlotModel(
      id: entity.id,
      day: entity.day,
      timeSlot: entity.timeSlot,
      timeFrom: entity.timeFrom,
      timeTo: entity.timeTo,
      isBooked: entity.isBooked,
      bookedCount: entity.bookedCount,
      maxBookings: entity.maxBookings,
    );
  }
}
