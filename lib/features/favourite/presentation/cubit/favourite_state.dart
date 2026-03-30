part of 'favourite_cubit.dart';

sealed class FavouriteState extends Equatable {
  const FavouriteState();
  @override
  List<Object?> get props => [];
}

final class FavouriteInitial extends FavouriteState {
  const FavouriteInitial();
}

final class FavouriteLoading extends FavouriteState {
  const FavouriteLoading();
}

final class FavouriteLoaded extends FavouriteState {
  final List<ClinicSummary> clinics;
  const FavouriteLoaded({required this.clinics});

  FavouriteLoaded copyWith({List<ClinicSummary>? clinics}) =>
      FavouriteLoaded(clinics: clinics ?? this.clinics);

  @override
  List<Object?> get props => [clinics];
}

final class FavouriteEmpty extends FavouriteState {
  const FavouriteEmpty();
}

final class FavouriteError extends FavouriteState {
  final Failure failure;
  const FavouriteError(this.failure);

  @override
  List<Object?> get props => [failure];
}

/// User is not logged in — show a login prompt, never fetch from API.
final class FavouriteUnauthenticated extends FavouriteState {
  const FavouriteUnauthenticated();
}