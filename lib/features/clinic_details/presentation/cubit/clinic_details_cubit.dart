import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../domain/entites/clinic_entities.dart';
import '../../domain/usecases/get_clinic_details_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';

part 'clinic_details_state.dart';

class ClinicDetailsCubit extends Cubit<ClinicDetailsState> {
  final GetClinicDetailsUseCase getClinicDetailsUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;


  ClinicDetailsCubit({
    required this.getClinicDetailsUseCase,
    required this.toggleFavoriteUseCase,
  }) : super(ClinicDetailsInitial());

  // Current clinic data
  ClinicEntity? _currentClinic;

  Future<void> loadClinicDetails(int clinicId) async {
    emit(ClinicDetailsLoading());

    final result = await getClinicDetailsUseCase(clinicId);

    result.fold(
          (failure) => emit(ClinicDetailsError(failure.message)),
          (clinic) {
        _currentClinic = clinic;
        emit(ClinicDetailsLoaded(
          clinic: clinic,
        ));
      },
    );
  }

  Future<void> toggleFavorite() async {
    if (_currentClinic == null) return;

    final currentState = state;
    if (currentState is! ClinicDetailsLoaded) return;

    // Optimistic update
    emit(currentState.copyWith(isFavorite: !currentState.clinic.isOpen));

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



  void resetBookingState() {
    if (_currentClinic != null) {
      emit(ClinicDetailsLoaded(
        clinic: _currentClinic!,
      ));
    }
  }
}