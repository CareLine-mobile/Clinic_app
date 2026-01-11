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
  final int currentPage;
  final bool hasMorePages;
  final bool isLoadingMore;

  HomeLoaded({
    required this.featuredClinics,
    required this.nearbyClinics,
    required this.allClinics,
    this.currentPage = 1,
    this.hasMorePages = true,
    this.isLoadingMore = false,
  });

  HomeLoaded copyWith({
    List<ClinicSummary>? featuredClinics,
    List<ClinicSummary>? nearbyClinics,
    List<ClinicSummary>? allClinics,
    int? currentPage,
    bool? hasMorePages,
    bool? isLoadingMore,
  }) {
    return HomeLoaded(
      featuredClinics: featuredClinics ?? this.featuredClinics,
      nearbyClinics: nearbyClinics ?? this.nearbyClinics,
      allClinics: allClinics ?? this.allClinics,
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
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