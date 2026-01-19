part of 'clinic_ui_cubit.dart';

@immutable
sealed class ClinicsState {}

final class ClinicsInitial extends ClinicsState {}

class ClinicUiState {
  final DateTime selectedDate;
  final DoctorEntity? selectedDoctor;
  final int selectedTabIndex;
  final bool isAppBarTransparent;

  const ClinicUiState({
    required this.selectedDate,
    this.selectedDoctor,
    this.selectedTabIndex = 0,
    this.isAppBarTransparent = true,
  });

  ClinicUiState copyWith({
    DateTime? selectedDate,
    DoctorEntity? selectedDoctor,
    bool clearDoctor = false,
    int? selectedTabIndex,
    bool? isAppBarTransparent,
  }) {
    return ClinicUiState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedDoctor: clearDoctor ? null : (selectedDoctor ?? this.selectedDoctor),
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      isAppBarTransparent: isAppBarTransparent ?? this.isAppBarTransparent,
    );
  }
}