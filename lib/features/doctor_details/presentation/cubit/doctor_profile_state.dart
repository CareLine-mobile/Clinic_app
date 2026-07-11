part of 'doctor_profile_cubit.dart';

sealed class DoctorProfileState extends Equatable {
  const DoctorProfileState();
}

// ── Initial ───────────────────────────────────────────────
class DoctorProfileInitial extends DoctorProfileState {
  const DoctorProfileInitial();
  @override
  List<Object?> get props => [];
}

// ── Loading ───────────────────────────────────────────────
class DoctorProfileLoading extends DoctorProfileState {
  const DoctorProfileLoading();
  @override
  List<Object?> get props => [];
}

// ── Loaded ────────────────────────────────────────────────
class DoctorProfileLoaded extends DoctorProfileState {
  final DoctorProfileEntity doctor;
  final bool isRatingLoading;

  const DoctorProfileLoaded({
    required this.doctor,
    this.isRatingLoading = false,
  });

  DoctorProfileLoaded copyWith({
    DoctorProfileEntity? doctor,
    bool? isRatingLoading,
  }) {
    return DoctorProfileLoaded(
      doctor: doctor ?? this.doctor,
      isRatingLoading: isRatingLoading ?? this.isRatingLoading,
    );
  }

  @override
  List<Object?> get props => [doctor, isRatingLoading];
}

// ── Error ─────────────────────────────────────────────────
class DoctorProfileError extends DoctorProfileState {
  final String message;
  const DoctorProfileError(this.message);
  @override
  List<Object?> get props => [message];
}

// ── Rating Success ────────────────────────────────────────
class DoctorRatingSuccess extends DoctorProfileState {
  final DoctorProfileEntity doctor;
  final double newRating;
  final double userRating;

  const DoctorRatingSuccess({
    required this.doctor,
    required this.newRating,
    required this.userRating,
  });

  @override
  List<Object?> get props => [doctor, newRating, userRating];
}

// ── Rating Error ──────────────────────────────────────────
class DoctorRatingError extends DoctorProfileState {
  final DoctorProfileEntity doctor;
  final String message;

  const DoctorRatingError({required this.doctor, required this.message});

  @override
  List<Object?> get props => [doctor, message];
}
