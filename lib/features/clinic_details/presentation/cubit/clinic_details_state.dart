part of 'clinic_details_cubit.dart';

abstract class ClinicDetailsState extends Equatable {
  const ClinicDetailsState();

  @override
  List<Object?> get props => [];
}

class ClinicDetailsInitial extends ClinicDetailsState {}

class ClinicDetailsLoading extends ClinicDetailsState {}

class ClinicDetailsError extends ClinicDetailsState {
  final String message;
  const ClinicDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}

// ─── Main loaded state — carries ALL UI state ─────────────────────────────────

class ClinicDetailsLoaded extends ClinicDetailsState {
  final ClinicEntity clinic;

  // UI state
  final DateTime selectedDate;
  final DoctorEntity? selectedDoctor;
  final String? selectedTime;
  final String? selectedTimeFrom;
  final int selectedTabIndex;
  final bool isAppBarTransparent;

  // Booking flow
  final int bookingStep;
  final String? patientName;
  final String? patientPhone;
  final String? bookingNotes;

  // Async flags
  final bool isFavoriteLoading;
  final bool isSubmittingReview;
  final String? reviewErrorMessage;
  final String? reviewSuccessMessage;

  // Promo Code
  final String? couponCode;
  final bool isCouponLoading;
  final CouponEntity? appliedCoupon;
  final String? couponError;
  final String? bookingErrorMessage;

  const ClinicDetailsLoaded({
    required this.clinic,
    required this.selectedDate,
    this.selectedDoctor,
    this.selectedTime,
    this.selectedTimeFrom,
    this.selectedTabIndex = 0,
    this.isAppBarTransparent = true,
    this.bookingStep = 0,
    this.patientName,
    this.patientPhone,
    this.bookingNotes,
    this.isFavoriteLoading = false,
    this.isSubmittingReview = false,
    this.reviewErrorMessage,
    this.reviewSuccessMessage,
    this.couponCode,
    this.isCouponLoading = false,
    this.appliedCoupon,
    this.couponError,
    this.bookingErrorMessage,
  });

  ClinicDetailsLoaded copyWith({
    ClinicEntity? clinic,
    DateTime? selectedDate,
    Object? selectedDoctor = _sentinel,
    Object? selectedTime = _sentinel,
    Object? selectedTimeFrom = _sentinel,
    int? selectedTabIndex,
    bool? isAppBarTransparent,
    int? bookingStep,
    Object? patientName = _sentinel,
    Object? patientPhone = _sentinel,
    Object? bookingNotes = _sentinel,
    bool? isFavoriteLoading,
    bool? isSubmittingReview,
    Object? reviewErrorMessage = _sentinel,
    Object? reviewSuccessMessage = _sentinel,
    Object? couponCode = _sentinel,
    bool? isCouponLoading,
    Object? appliedCoupon = _sentinel,
    Object? couponError = _sentinel,
    Object? bookingErrorMessage = _sentinel,
  }) {
    return ClinicDetailsLoaded(
      clinic: clinic ?? this.clinic,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedDoctor:
      selectedDoctor == _sentinel ? this.selectedDoctor : selectedDoctor as DoctorEntity?,
      selectedTime:
      selectedTime == _sentinel ? this.selectedTime : selectedTime as String?,
      selectedTimeFrom:
      selectedTimeFrom == _sentinel ? this.selectedTimeFrom : selectedTimeFrom as String?,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      isAppBarTransparent: isAppBarTransparent ?? this.isAppBarTransparent,
      bookingStep: bookingStep ?? this.bookingStep,
      patientName:
      patientName == _sentinel ? this.patientName : patientName as String?,
      patientPhone:
      patientPhone == _sentinel ? this.patientPhone : patientPhone as String?,
      bookingNotes:
      bookingNotes == _sentinel ? this.bookingNotes : bookingNotes as String?,
      isFavoriteLoading: isFavoriteLoading ?? this.isFavoriteLoading,
      isSubmittingReview: isSubmittingReview ?? this.isSubmittingReview,
      reviewErrorMessage: reviewErrorMessage == _sentinel
          ? this.reviewErrorMessage
          : reviewErrorMessage as String?,
      reviewSuccessMessage: reviewSuccessMessage == _sentinel
          ? this.reviewSuccessMessage
          : reviewSuccessMessage as String?,
      couponCode: couponCode == _sentinel ? this.couponCode : couponCode as String?,
      isCouponLoading: isCouponLoading ?? this.isCouponLoading,
      appliedCoupon: appliedCoupon == _sentinel ? this.appliedCoupon : appliedCoupon as CouponEntity?,
      couponError: couponError == _sentinel ? this.couponError : couponError as String?,
      bookingErrorMessage: bookingErrorMessage == _sentinel ? this.bookingErrorMessage : bookingErrorMessage as String?,
    );
  }

  // Computed
  bool get canProceedStep1 => selectedTime != null;
  bool get canProceedStep2 =>
      patientName != null &&
          patientName!.trim().isNotEmpty &&
          patientPhone != null &&
          patientPhone!.trim().isNotEmpty;

  List<TimeSlotEntity> get slotsForSelectedDay {
    if (selectedDoctor == null) return [];
    final dayName = _dayName(selectedDate.weekday);
    return selectedDoctor!.availableSlots
        .where((s) => s.day.toLowerCase().trim() == dayName)
        .toList();
  }

  @override
  List<Object?> get props => [
    clinic,
    selectedDate,
    selectedDoctor,
    selectedTime,
    selectedTimeFrom,
    selectedTabIndex,
    isAppBarTransparent,
    bookingStep,
    patientName,
    patientPhone,
    bookingNotes,
    isFavoriteLoading,
    isSubmittingReview,
    reviewErrorMessage,
    reviewSuccessMessage,
    couponCode,
    isCouponLoading,
    appliedCoupon,
    couponError,
    bookingErrorMessage,
  ];
}

// ─── Booking states ───────────────────────────────────────────────────────────

// في clinic_details_state.dart
class BookingLoading extends ClinicDetailsLoaded {
  const BookingLoading({
    required super.clinic,
    required super.selectedDate,
    super.selectedDoctor,
    super.selectedTime,
    super.selectedTimeFrom,
    super.patientName,
    super.patientPhone,
    super.bookingNotes,
  }) : super(
    selectedTabIndex: 0,
    isAppBarTransparent: false,
    isFavoriteLoading: false,
    bookingStep: 2,
  );
}

class BookingSuccess extends ClinicDetailsState {
  final String message;
  const BookingSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class BookingError extends ClinicDetailsState {
  final String message;
  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}

// Sentinel — lets copyWith distinguish "not passed" from "explicitly null"
const Object _sentinel = Object();

String _dayName(int weekday) {
  const days = {
    1: 'monday',
    2: 'tuesday',
    3: 'wednesday',
    4: 'thursday',
    5: 'friday',
    6: 'saturday',
    7: 'sunday',
  };
  return days[weekday] ?? '';
}