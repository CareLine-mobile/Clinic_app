class BookingDateEntity {
  final DateTime date;
  final bool isSelected;

  BookingDateEntity({
    required this.date,
    this.isSelected = false,
  });
}
