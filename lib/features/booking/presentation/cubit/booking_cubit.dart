import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repository/booking_repository.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepository repository;

  BookingCubit(this.repository) : super(BookingInitial());

  Future<void> loadBookingData() async {
    try {
      emit(BookingLoading());
      final dates = await repository.getBookingDates();
      // Select the first date by default
      final initialDate = dates.first.date;
      final timeSlots = await repository.getTimeSlots(initialDate);

      // Deselect all times initially? Or select none.
      // Assuming mock data has one selected, we should probably reset it or respect it.
      // Let's reset selections for clean state.
      // For this UI demo, let's just use the data as is but clean up selections logic here.
      
      emit(BookingLoaded(
        dates: dates,
        timeSlots: timeSlots,
        selectedDate: initialDate,
        selectedTime: null, // No time selected initially
      ));
    } catch (e) {
      emit(BookingError("Failed to load booking data"));
    }
  }

  Future<void> selectDate(DateTime date) async {
    final currentState = state;
    if (currentState is BookingLoaded) {
      if (currentState.selectedDate == date) return;

      emit(BookingLoading()); // fast loading or just update
      // Real app might fetch specific slots for this date
      final timeSlots = await repository.getTimeSlots(date);
      
      emit(currentState.copyWith(
        selectedDate: date,
        timeSlots: timeSlots,
        selectedTime: null, // Reset time on date change
      ));
    }
  }

  void selectTime(String time) {
    final currentState = state;
    if (currentState is BookingLoaded) {
      emit(currentState.copyWith(selectedTime: time));
    }
  }

  void updatePatientDetails({required String name, required String phone}) {
    final currentState = state;
    if (currentState is BookingLoaded) {
      emit(currentState.copyWith(patientName: name, patientPhone: phone));
    }
  }

  void nextStep() {
    final currentState = state;
    if (currentState is BookingLoaded) {
      if (currentState.currentStep < 2) {
        emit(currentState.copyWith(currentStep: currentState.currentStep + 1));
      }
    }
  }

  void previousStep() {
    final currentState = state;
    if (currentState is BookingLoaded) {
      if (currentState.currentStep > 0) {
        emit(currentState.copyWith(currentStep: currentState.currentStep - 1));
      }
    }
  }
}
