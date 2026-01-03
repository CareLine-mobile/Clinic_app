class TimeSlotEntity {
  final String time; // e.g., "9:00 AM"
  final bool isAvailable;
  final bool isSelected;

  TimeSlotEntity({
    required this.time,
    this.isAvailable = true,
    this.isSelected = false,
  });
}
