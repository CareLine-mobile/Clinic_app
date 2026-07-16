import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import '../../../favourite/domain/repositories/favourite_repository.dart';
import '../../../favourite/domain/usecases/toggle_favourite_usecase.dart';
import '../../domain/entites/clinic_entities.dart';
import '../../domain/entites/doctor_entity.dart';
import '../../domain/entites/time_slot_entity.dart';
import '../../domain/entites/appointment_request_entity.dart';
import '../../domain/entites/coupon_entity.dart';
import '../../domain/usecases/get_clinic_details_usecase.dart';
import '../../domain/usecases/make_appointment_usecase.dart';
import '../../domain/usecases/apply_coupon_usecase.dart';

part 'clinic_details_state.dart';

class ClinicDetailsCubit extends Cubit<ClinicDetailsState> {
  final GetClinicDetailsUseCase getClinicDetailsUseCase;
  final ToggleFavouriteUseCase toggleFavoriteUseCase;
  final MakeAppointmentUseCase makeAppointmentUseCase;
  final ApplyCouponUseCase applyCouponUseCase;
  final FavouriteRepository _favouriteRepository;
  StreamSubscription<Set<int>>? _favStreamSub;

  ClinicDetailsCubit({
    required this.getClinicDetailsUseCase,
    required this.toggleFavoriteUseCase,
    required this.makeAppointmentUseCase,
    required this.applyCouponUseCase,
    required FavouriteRepository favouriteRepository,
  }) :  _favouriteRepository = favouriteRepository ,super(ClinicDetailsInitial()){
    _favStreamSub = _favouriteRepository.favouriteIdsStream.listen(_onFavouriteIdsUpdated);

  }
    void _onFavouriteIdsUpdated(Set<int> ids) {

      final s = _loaded;
      if (s == null) return;

      final clinicId = int.tryParse(s.clinic.id);
      if (clinicId == null) return;

      final isFav = ids.contains(clinicId);

      // Only emit if the value actually changed (avoids unnecessary rebuilds)
      if (s.clinic.isFavorite == isFav) return;

      emit(s.copyWith(
        clinic: s.clinic.copyWith(isFavorite: isFav),
      ));

    }
  // Convenience getter — null-safe access to the loaded state
  ClinicDetailsLoaded? get _loaded =>
      state is ClinicDetailsLoaded ? state as ClinicDetailsLoaded : null;

  // ── Load ──────────────────────────────────────────────────

  Future<void> loadClinicDetails(int clinicId) async {
    emit(ClinicDetailsLoading());
    final result = await getClinicDetailsUseCase(clinicId);
    result.fold(
          (failure) => emit(ClinicDetailsError(failure.message)),
          (clinic) => emit(ClinicDetailsLoaded(
        clinic: clinic,
        selectedDate: DateTime.now(),
      )),
    );
  }

  // ── Favorite ──────────────────────────────────────────────

  Future<void> toggleFavorite() async {
    final s = _loaded;
    if (s == null) return;

    emit(s.copyWith(isFavoriteLoading: true));

    final result = await toggleFavoriteUseCase  (int.parse(s.clinic.id));
    result.fold(
          (failure) {
        emit(s.copyWith(isFavoriteLoading: false));
        emit(ClinicDetailsError(failure.message));
      },
          (_) => emit(s.copyWith(isFavoriteLoading: false)),
    );
  }

  // ── Date / Doctor / Slot selection ────────────────────────

  /// Used from BookingTab — resets doctor + slot because a new date
  /// means the user should re-pick a doctor for that day.
  void selectDate(DateTime date) {
    final s = _loaded;
    if (s == null) return;
    emit(s.copyWith(
      selectedDate: date,
      selectedDoctor: null,
      selectedTime: null,
      selectedTimeFrom: null,
    ));
  }

  /// Used from BookingDateTimePage — date changes but doctor is already
  /// locked in, so we only reset the time slot.
  void selectDateInBookingFlow(DateTime date) {
    final s = _loaded;
    if (s == null) return;
    emit(s.copyWith(
      selectedDate: date,
      selectedTime: null,
      selectedTimeFrom: null,
    ));
  }

  void selectDoctor(DoctorEntity doctor) {
    final s = _loaded;
    if (s == null) return;
    // Reset slot when doctor changes
    emit(s.copyWith(
      selectedDoctor: doctor,
      selectedTime: null,
      selectedTimeFrom: null,
      bookingStep: 0,
    ));
  }

  void selectTimeSlot(TimeSlotEntity slot) {
    final s = _loaded;
    if (s == null) return;
    emit(s.copyWith(
      selectedTime: slot.timeSlot,
      selectedTimeFrom: slot.timeFrom,
    ));
  }

  // ── Tab / AppBar ──────────────────────────────────────────

  void changeTab(int index) {
    final s = _loaded;
    if (s == null) return;
    emit(s.copyWith(selectedTabIndex: index));
  }

  void updateAppBarTransparency(bool isTransparent) {
    final s = _loaded;
    if (s == null || s.isAppBarTransparent == isTransparent) return;
    emit(s.copyWith(isAppBarTransparent: isTransparent));
  }

  // ── Promo Code ──────────────────────────────────────────────

  Future<void> applyCoupon(String code) async {
    final s = _loaded;
    if (s == null) return;
    
    if (code.trim().isEmpty) {
      emit(s.copyWith(
        couponError: 'doctorProfile.couponEmpty'.tr(),
        appliedCoupon: null,
      ));
      return;
    }

    emit(s.copyWith(isCouponLoading: true, couponError: null, couponCode: code));

    final result = await applyCouponUseCase(code, s.clinic.id);
    result.fold(
      (failure) => emit(s.copyWith(
        isCouponLoading: false,
        couponError: failure.message,
        appliedCoupon: null,
      )),
      (couponData) => emit(s.copyWith(
        isCouponLoading: false,
        appliedCoupon: couponData,
        couponError: null,
        couponCode: code,
      )),
    );
  }

  // ── Booking flow ──────────────────────────────────────────

  void nextBookingStep() {
    final s = _loaded;
    if (s == null) return;
    if (s.bookingStep == 0 && !s.canProceedStep1) return;
    if (s.bookingStep == 1 && !s.canProceedStep2) return;
    if (s.bookingStep >= 2) return;
    emit(s.copyWith(bookingStep: s.bookingStep + 1, bookingErrorMessage: null));
  }

  void previousBookingStep() {
    final s = _loaded;
    if (s == null || s.bookingStep <= 0) return;
    emit(s.copyWith(bookingStep: s.bookingStep - 1, bookingErrorMessage: null));
  }

  void resetBookingFlow() {
    final s = _loaded;
    if (s == null) return;
    emit(s.copyWith(
      bookingStep: 0,
      selectedDoctor: null,
      selectedTime: null,
      selectedTimeFrom: null,
      patientName: null,
      patientPhone: null,
      bookingNotes: null,
      couponCode: null,
      appliedCoupon: null,
      couponError: null,
      bookingErrorMessage: null,
    ));
  }

  void updatePatientName(String name) {
    final s = _loaded;
    if (s == null) return;
    emit(s.copyWith(patientName: name));
  }

  void updatePatientPhone(String phone) {
    final s = _loaded;
    if (s == null) return;
    emit(s.copyWith(patientPhone: phone));
  }

  void updateBookingNotes(String notes) {
    final s = _loaded;
    if (s == null) return;
    emit(s.copyWith(bookingNotes: notes));
  }

  Future<void> confirmBooking() async {
    var s = _loaded;
    if (s == null) return;

    // Clear previous error
    emit(s.copyWith(bookingErrorMessage: null));
    s = _loaded!;

    if (s.selectedTimeFrom == null ||
        s.selectedDoctor == null ||
        s.clinic.id.isEmpty ||
        s.patientName == null ||
        s.patientPhone == null) {
      emit(s.copyWith(bookingErrorMessage: 'Missing required booking information'));
      return;
    }

    emit(BookingLoading(
      clinic: s.clinic,
      selectedDate: s.selectedDate,
      selectedDoctor: s.selectedDoctor,
      selectedTime: s.selectedTime,
      selectedTimeFrom: s.selectedTimeFrom,
      patientName: s.patientName,
      patientPhone: s.patientPhone,
      bookingNotes: s.bookingNotes,
    ));

    final result = await makeAppointmentUseCase(
      AppointmentRequestEntity(
        clinicalId: s.clinic.id,
        doctorId: s.selectedDoctor!.id,
        date: _formatDate(s.selectedDate),
        time: s.selectedTimeFrom!,
        name: s.patientName!,
        phone: s.patientPhone!,
        notes: s.bookingNotes,
        coupon: s.appliedCoupon != null ? s.couponCode : null,
      ),
    );

    result.fold(
      (failure) => emit(s!.copyWith(bookingErrorMessage: failure.message)),
      (_) {
        emit(s!.copyWith(
          bookingStep: 0,
          selectedDoctor: null,
          selectedTime: null,
          selectedTimeFrom: null,
          patientName: null,
          patientPhone: null,
          bookingNotes: null,
          couponCode: null,
          appliedCoupon: null,
          couponError: null,
          bookingErrorMessage: null,
        ));
        emit(const BookingSuccess('Appointment booked successfully'));
      },
    );
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}