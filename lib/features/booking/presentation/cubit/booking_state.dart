import '../../domain/entities/booking_date_entity.dart';
import '../../domain/entities/time_slot_entity.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final List<BookingDateEntity> dates;
  final List<TimeSlotEntity> timeSlots;
  final DateTime selectedDate;
  final String? selectedTime;
  final int currentStep;
  final String? patientName;
  final String? patientPhone;

  BookingLoaded({
    required this.dates,
    required this.timeSlots,
    required this.selectedDate,
    this.selectedTime,
    this.currentStep = 0,
    this.patientName,
    this.patientPhone,
  });

  BookingLoaded copyWith({
    List<BookingDateEntity>? dates,
    List<TimeSlotEntity>? timeSlots,
    DateTime? selectedDate,
    String? selectedTime,
    int? currentStep,
    String? patientName,
    String? patientPhone,
  }) {
    return BookingLoaded(
      dates: dates ?? this.dates,
      timeSlots: timeSlots ?? this.timeSlots,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      currentStep: currentStep ?? this.currentStep,
      patientName: patientName ?? this.patientName,
      patientPhone: patientPhone ?? this.patientPhone,
    );
  }
}

class BookingError extends BookingState {
  final String message;

  BookingError(this.message);
}
