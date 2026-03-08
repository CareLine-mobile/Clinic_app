import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../booking/domain/entities/booking_entity.dart';
import '../../domain/entites/clinic_entities.dart';
import '../../domain/entites/doctor_entity.dart';
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

  ClinicEntity? _currentClinic;

  // ── UI state ──────────────────────────────────────────────
  DateTime _selectedDate = DateTime.now();
  DoctorEntity? _selectedDoctor;
  int _selectedTabIndex = 0;
  bool _isAppBarTransparent = true;

  DateTime get selectedDate => _selectedDate;
  DoctorEntity? get selectedDoctor => _selectedDoctor;
  int get selectedTabIndex => _selectedTabIndex;
  bool get isAppBarTransparent => _isAppBarTransparent;

  // ── Data methods ──────────────────────────────────────────
  Future<void> loadClinicDetails(int clinicId) async {
    emit(ClinicDetailsLoading());
    final result = await getClinicDetailsUseCase(clinicId);
    result.fold(
          (failure) => emit(ClinicDetailsError(failure.message)),
          (clinic) {
        _currentClinic = clinic;
        emit(ClinicDetailsLoaded(clinic: clinic));
      },
    );
  }

  Future<void> toggleFavorite() async {
    if (_currentClinic == null) return;
    final currentState = state;
    if (currentState is! ClinicDetailsLoaded) return;

    emit(currentState.copyWith(isFavorite: !currentState.clinic.isOpen));
    final result = await toggleFavoriteUseCase(_currentClinic!.id);
    result.fold(
          (failure) {
        emit(currentState);
        emit(ClinicDetailsError(failure.message));
      },
          (_) {},
    );
  }

  void resetBookingState() {
    if (_currentClinic != null) {
      emit(ClinicDetailsLoaded(clinic: _currentClinic!));
    }
  }

  // ── UI methods ────────────────────────────────────────────
  void selectDate(DateTime date) {
    _selectedDate = date;
    _selectedDoctor = null; // Clear doctor when date changes
    _emitCurrentLoaded();
  }

  void selectDoctor(DoctorEntity? doctor) {
    _selectedDoctor = doctor;
    _emitCurrentLoaded();
  }

  void changeTab(int index) {
    _selectedTabIndex = index;
    _emitCurrentLoaded();
  }

  void updateAppBarTransparency(bool isTransparent) {
    if (_isAppBarTransparent != isTransparent) {
      _isAppBarTransparent = isTransparent;
      _emitCurrentLoaded();
    }
  }

  void _emitCurrentLoaded() {
    if (state is ClinicDetailsLoaded) {
      emit((state as ClinicDetailsLoaded).copyWith());
    }
  }
}