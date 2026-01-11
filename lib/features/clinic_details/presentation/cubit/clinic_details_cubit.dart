import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../domain/entites/clinic_entities.dart';
import '../../domain/usecases/book_appointment_usecase.dart';
import '../../domain/usecases/get_clinic_details_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';

part 'clinic_details_state.dart';

class ClinicDetailsCubit extends Cubit<ClinicDetailsState> {
  final GetClinicDetailsUseCase getClinicDetailsUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;
  final BookAppointmentUseCase bookAppointmentUseCase;

  ClinicDetailsCubit({
    required this.getClinicDetailsUseCase,
    required this.toggleFavoriteUseCase,
    required this.bookAppointmentUseCase,
  }) : super(ClinicDetailsInitial());

  // Current clinic data
  ClinicDetails? _currentClinic;

  Future<void> loadClinicDetails(int clinicId) async {
    emit(ClinicDetailsLoading());

    final result = await getClinicDetailsUseCase(clinicId);

    result.fold(
          (failure) => emit(ClinicDetailsError(failure.message)),
          (clinic) {
        _currentClinic = clinic;
        emit(ClinicDetailsLoaded(
          clinic: clinic,
          isFavorite: clinic.isFavorite,
        ));
      },
    );
  }

  Future<void> toggleFavorite() async {
    if (_currentClinic == null) return;

    final currentState = state;
    if (currentState is! ClinicDetailsLoaded) return;

    // Optimistic update
    emit(currentState.copyWith(isFavorite: !currentState.isFavorite));

    final result = await toggleFavoriteUseCase(_currentClinic!.id);

    result.fold(
          (failure) {
        // Revert on error
        emit(currentState);
        emit(ClinicDetailsError(failure.message));
      },
          (success) {
        // Update was successful, keep the new state
      },
    );
  }

  Future<void> bookAppointment({
    required int doctorId,
    required DateTime date,
    required String timeSlot,
  }) async {
    if (_currentClinic == null) return;

    emit(BookingInProgress());

    final params = BookingParams(
      clinicId: _currentClinic!.id,
      doctorId: doctorId,
      date: date,
      timeSlot: timeSlot,
    );

    final result = await bookAppointmentUseCase(params);

    result.fold(
          (failure) {
        emit(BookingError(failure.message));
        // Return to loaded state
        if (_currentClinic != null) {
          emit(ClinicDetailsLoaded(
            clinic: _currentClinic!,
            isFavorite: _currentClinic!.isFavorite,
          ));
        }
      },
          (success) {
        emit(BookingSuccess('تم الحجز بنجاح!'));
        // Return to loaded state after delay
        Future.delayed(const Duration(seconds: 2), () {
          if (_currentClinic != null) {
            emit(ClinicDetailsLoaded(
              clinic: _currentClinic!,
              isFavorite: _currentClinic!.isFavorite,
            ));
          }
        });
      },
    );
  }

  void resetBookingState() {
    if (_currentClinic != null) {
      emit(ClinicDetailsLoaded(
        clinic: _currentClinic!,
        isFavorite: _currentClinic!.isFavorite,
      ));
    }
  }
}