part of 'clinic_details_cubit.dart';


@immutable
sealed class ClinicDetailsState {}

final class ClinicDetailsInitial extends ClinicDetailsState {}

class ClinicDetailsLoading extends ClinicDetailsState {}

class ClinicDetailsLoaded extends ClinicDetailsState {
  final ClinicEntity clinic;

  ClinicDetailsLoaded({required this.clinic});

  List<Object?> get props => [clinic];

  ClinicDetailsLoaded copyWith({
    ClinicEntity? clinic,
    bool? isFavorite,
  }) {
    return ClinicDetailsLoaded(
      clinic: clinic ?? this.clinic,
    );
  }
}

class ClinicDetailsError extends ClinicDetailsState {
  final String message;
  ClinicDetailsError(this.message);

  List<Object?> get props => [message];
}

class BookingInProgress extends ClinicDetailsState {}

class BookingSuccess extends ClinicDetailsState {
  final String message;
  BookingSuccess(this.message);

  List<Object?> get props => [message];
}

class BookingError extends ClinicDetailsState {
  final String message;
  BookingError(this.message);

  List<Object?> get props => [message];
}