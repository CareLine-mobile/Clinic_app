// doctor_profile_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/doctor_profile_entity.dart';
import '../../domain/usecases/get_doctor_details_usecase.dart';
import '../../domain/usecases/rate_doctor_usecase.dart';

part 'doctor_profile_state.dart';

class DoctorProfileCubit extends Cubit<DoctorProfileState> {
  final GetDoctorDetailsUseCase getDoctorDetailsUseCase;
  final RateDoctorUseCase rateDoctorUseCase;

  DoctorProfileCubit({
    required this.getDoctorDetailsUseCase,
    required this.rateDoctorUseCase,
  }) : super(const DoctorProfileInitial());

  // ── Convenience getter ─────────────────────────────────
  DoctorProfileLoaded? get _loaded =>
      state is DoctorProfileLoaded ? state as DoctorProfileLoaded : null;

  // ── Load doctor ────────────────────────────────────────
  Future<void> loadDoctor(int doctorId) async {
    emit(const DoctorProfileLoading());
    final result = await getDoctorDetailsUseCase(doctorId);
    result.fold(
      (failure) => emit(DoctorProfileError(failure.message)),
      (doctor) => emit(DoctorProfileLoaded(doctor: doctor)),
    );
  }

  // ── Rate doctor ────────────────────────────────────────
  Future<void> rateDoctor(double rating) async {
    final s = _loaded;
    if (s == null) return;

    final doctorId = int.tryParse(s.doctor.id);
    if (doctorId == null) return;

    emit(s.copyWith(isRatingLoading: true));

    final result = await rateDoctorUseCase(doctorId, rating);
    result.fold(
      (failure) {
        emit(s.copyWith(isRatingLoading: false));
        emit(DoctorRatingError(
          doctor: s.doctor,
          message: failure.message,
        ));
      },
      (newRating) {
        // Update the doctor's rating in the loaded state
        emit(DoctorRatingSuccess(
          doctor: s.doctor,
          newRating: newRating,
          userRating: rating,
        ));
      },
    );
  }
}
