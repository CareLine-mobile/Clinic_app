import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../clinic_details/domain/entites/time_slot_entity.dart';
import '../../domain/entities/appointment_request_entity.dart';
import '../../domain/usecases/make_appointment_usecase.dart';

part 'booking_flow_state.dart';

class BookingFlowCubit extends Cubit<BookingFlowState> {
  final MakeAppointmentUseCase makeAppointmentUseCase;

  BookingFlowCubit({
    required this.makeAppointmentUseCase,
    required int clinicalId,
    required String doctorId,
    required String clinicName,
    required String doctorName,
    required List<TimeSlotEntity> availableSlots,
  }) : super(
    BookingFlowState(
      clinicalId: clinicalId,
      doctorId: doctorId,
      clinicName: clinicName,
      doctorName: doctorName,
      selectedDate: DateTime.now(),
      availableSlots: availableSlots,
    ),
  );

  void nextStep() {
    if (state.currentStep == 0 && !state.canProceedStep1) return;
    if (state.currentStep == 1 && !state.canProceedStep2) return;
    if (state.currentStep >= 2) return;
    emit(state.copyWith(currentStep: state.currentStep + 1, clearError: true));
  }

  void previousStep() {
    if (state.currentStep <= 0) return;
    emit(state.copyWith(currentStep: state.currentStep - 1, clearError: true));
  }

  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date, clearTime: true));
  }

  void selectSlot(TimeSlotEntity slot) {
    emit(state.copyWith(
      selectedTime: slot.timeSlot,
      selectedTimeFrom: slot.timeFrom,
    ));
  }

  void updatePatientName(String name) => emit(state.copyWith(patientName: name));
  void updatePatientPhone(String phone) => emit(state.copyWith(patientPhone: phone));
  void updateNotes(String notes) => emit(state.copyWith(notes: notes));

  Future<void> confirmBooking() async {
    if (state.selectedTimeFrom == null) return;

    emit(state.copyWith(isSubmitting: true, clearError: true));

    final result = await makeAppointmentUseCase(
      AppointmentRequestEntity(
        clinicalId: state.clinicalId,
        doctorId: state.doctorId,
        date: _formatDate(state.selectedDate),
        time: state.selectedTimeFrom!,
        notes: state.notes,
      ),
    );

    result.fold(
          (failure) => emit(state.copyWith(isSubmitting: false, errorMessage: failure.message)),
          (_) => emit(state.copyWith(isSubmitting: false, isSuccess: true)),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}