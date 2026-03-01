part of 'booking_flow_cubit.dart';

class BookingFlowState extends Equatable {
  final int currentStep;
  final int clinicalId;
  final String doctorId;
  final String clinicName;
  final String doctorName;

  // Step 1
  final DateTime selectedDate;
  final String? selectedTime;
  final String? selectedTimeFrom;
  final List<TimeSlotEntity> availableSlots;

  // Step 2
  final String? patientName;
  final String? patientPhone;
  final String? notes;

  // Submission
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  const BookingFlowState({
    this.currentStep = 0,
    required this.clinicalId,
    required this.doctorId,
    required this.clinicName,
    required this.doctorName,
    required this.selectedDate,
    this.selectedTime,
    this.selectedTimeFrom,
    required this.availableSlots,
    this.patientName,
    this.patientPhone,
    this.notes,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  List<TimeSlotEntity> get slotsForSelectedDay {
    final dayName = _dayName(selectedDate.weekday);
    return availableSlots.where((s) => s.day.toLowerCase() == dayName).toList();
  }

  List<DateTime> get availableDates {
    final today = DateTime.now();
    return List.generate(14, (i) => today.add(Duration(days: i)));
  }

  bool get canProceedStep1 => selectedTime != null;
  bool get canProceedStep2 =>
      patientName != null &&
          patientName!.trim().isNotEmpty &&
          patientPhone != null &&
          patientPhone!.trim().isNotEmpty;

  BookingFlowState copyWith({
    int? currentStep,
    DateTime? selectedDate,
    String? selectedTime,
    String? selectedTimeFrom,
    List<TimeSlotEntity>? availableSlots,
    String? patientName,
    String? patientPhone,
    String? notes,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
    bool clearError = false,
    bool clearTime = false,
  }) {
    return BookingFlowState(
      currentStep: currentStep ?? this.currentStep,
      clinicalId: clinicalId,
      doctorId: doctorId,
      clinicName: clinicName,
      doctorName: doctorName,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: clearTime ? null : (selectedTime ?? this.selectedTime),
      selectedTimeFrom: clearTime ? null : (selectedTimeFrom ?? this.selectedTimeFrom),
      availableSlots: availableSlots ?? this.availableSlots,
      patientName: patientName ?? this.patientName,
      patientPhone: patientPhone ?? this.patientPhone,
      notes: notes ?? this.notes,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  String _dayName(int weekday) {
    const days = {
      1: 'monday', 2: 'tuesday', 3: 'wednesday',
      4: 'thursday', 5: 'friday', 6: 'saturday', 7: 'sunday',
    };
    return days[weekday] ?? '';
  }

  @override
  List<Object?> get props => [
    currentStep, clinicalId, doctorId, clinicName, doctorName,
    selectedDate, selectedTime, selectedTimeFrom, availableSlots,
    patientName, patientPhone, notes,
    isSubmitting, isSuccess, errorMessage,
  ];
}