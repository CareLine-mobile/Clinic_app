import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../clinic_details/domain/entites/clinic_entities.dart';

part 'clinics_state.dart';

// lib/features/clinics/presentation/cubit/clinic_ui_cubit.da

class ClinicUiCubit extends Cubit<ClinicUiState> {
  ClinicUiCubit()
      : super(ClinicUiState(
    selectedDate: DateTime.now(),
  ));

  void selectDate(DateTime date) {
    emit(state.copyWith(
      selectedDate: date,
      clearDoctor: true, // Clear doctor when date changes
    ));
  }

  void selectDoctor(Doctor? doctor) {
    emit(state.copyWith(selectedDoctor: doctor));
  }

  void changeTab(int index) {
    emit(state.copyWith(selectedTabIndex: index));
  }

  void updateAppBarTransparency(bool isTransparent) {
    if (state.isAppBarTransparent != isTransparent) {
      emit(state.copyWith(isAppBarTransparent: isTransparent));
    }
  }
}