class TimeSlotBookingEntity {
  final String time; // e.g., "9:00 AM"
  final bool isAvailable;
  final bool isSelected;

  TimeSlotBookingEntity({
    required this.time,
    this.isAvailable = true,
    this.isSelected = false,
  });
}
