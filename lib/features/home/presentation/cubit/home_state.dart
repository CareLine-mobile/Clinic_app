// ==================== home_state.dart ====================
part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<ClinicSummary> featuredClinics;
  final List<ClinicSummary> nearbyClinics;
  final List<ClinicSummary> allClinics;
  final ClinicSummary? lastBooking; // Added missing field

  HomeLoaded({
    required this.featuredClinics,
    required this.nearbyClinics,
    required this.allClinics,
    this.lastBooking,
  });

  HomeLoaded copyWith({
    List<ClinicSummary>? featuredClinics,
    List<ClinicSummary>? nearbyClinics,
    List<ClinicSummary>? allClinics,
    ClinicSummary? lastBooking,
  }) {
    return HomeLoaded(
      featuredClinics: featuredClinics ?? this.featuredClinics,
      nearbyClinics: nearbyClinics ?? this.nearbyClinics,
      allClinics: allClinics ?? this.allClinics,
      lastBooking: lastBooking ?? this.lastBooking,
    );
  }
}

class HomeError extends HomeState {
  final String message;
  final String actionMessage;

  HomeError({
    required this.message,
    required this.actionMessage,
  });
}

// Remove these states - they break the loaded state pattern
// Use HomeLoaded with error flags or show errors via listener instead

class HomeBookingInProgress extends HomeState {}

class HomeBookingSuccess extends HomeState {}

class HomeBookingError extends HomeState {
  final String message;

  HomeBookingError({required this.message});
}