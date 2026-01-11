import 'package:bloc/bloc.dart';
import 'package:clinic_app/features/clinic_details/domain/usecases/toggle_favorite_usecase.dart';
import 'package:meta/meta.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/clinic_summary.dart';
import '../../domain/usecases/get_clinics_usecase.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetClinicsUseCase getClinicsUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;

  HomeCubit({
    required this.getClinicsUseCase,
    required this.toggleFavoriteUseCase,
  }) : super(HomeInitial());

  // Pagination state
  List<ClinicSummary> _allClinics = [];
  int _currentPage = 1;
  bool _hasMorePages = true;
  bool _isLoadingMore = false;

  // Separate lists for different sections (for future use)
  List<ClinicSummary> _featuredClinics = [];
  List<ClinicSummary> _nearbyClinics = [];

  /// Load initial clinics (page 1)
  Future<void> loadClinics() async {
    emit(HomeLoading());

    try {
      final result = await getClinicsUseCase(page: 1);

      result.fold(
            (failure) {
          final message = FailureMessageMapper.mapFailureToMessage(failure);
          final action = FailureMessageMapper.getActionMessage(failure);
          emit(HomeError(message: message, actionMessage: action));
        },
            (clinics) {
          _allClinics = clinics;
          _currentPage = 1;
          _hasMorePages = true; // Will be updated when backend sends pagination info

          // For now, treat all clinics as featured
          // When backend adds nearby, we can split them
          _featuredClinics = clinics;
          _nearbyClinics = [];

          emit(HomeLoaded(
            featuredClinics: _featuredClinics,
            nearbyClinics: _nearbyClinics,
            allClinics: _allClinics,
            currentPage: _currentPage,
            hasMorePages: _hasMorePages,
            isLoadingMore: false,
          ));
        },
      );
    } catch (e) {
      emit(HomeError(
        message: 'حدث خطأ غير متوقع',
        actionMessage: 'حاول مرة أخرى',
      ));
    }
  }

  /// Load more clinics (pagination)
  Future<void> loadMoreClinics() async {
    final currentState = state;
    if (currentState is! HomeLoaded) return;
    if (_isLoadingMore || !_hasMorePages) return;

    _isLoadingMore = true;
    emit(currentState.copyWith(isLoadingMore: true));

    try {
      _currentPage++;
      final result = await getClinicsUseCase(page: _currentPage);

      result.fold(
            (failure) {
          // Revert page number on failure
          _currentPage--;
          _isLoadingMore = false;

          // Keep showing current data, just stop loading
          emit(currentState.copyWith(isLoadingMore: false));
        },
            (newClinics) {
          if (newClinics.isEmpty) {
            _hasMorePages = false;
          } else {
            _allClinics.addAll(newClinics);
            _featuredClinics.addAll(newClinics);
          }

          _isLoadingMore = false;

          emit(currentState.copyWith(
            featuredClinics: List.from(_featuredClinics),
            allClinics: List.from(_allClinics),
            currentPage: _currentPage,
            hasMorePages: _hasMorePages,
            isLoadingMore: false,
          ));
        },
      );
    } catch (e) {
      _currentPage--;
      _isLoadingMore = false;
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  /// Toggle favorite for a clinic
  Future<void> toggleFavorite(int clinicId) async {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    // Optimistic Update
    final updatedFeatured = _updateClinicFavorite(_featuredClinics, clinicId);
    final updatedNearby = _updateClinicFavorite(_nearbyClinics, clinicId);
    final updatedAll = _updateClinicFavorite(_allClinics, clinicId);

    _featuredClinics = updatedFeatured;
    _nearbyClinics = updatedNearby;
    _allClinics = updatedAll;

    emit(currentState.copyWith(
      featuredClinics: updatedFeatured,
      nearbyClinics: updatedNearby,
      allClinics: updatedAll,
    ));

    // Call UseCase
    final result = await toggleFavoriteUseCase(clinicId);

    result.fold(
          (failure) {
        // Rollback on failure
        final revertedFeatured = _updateClinicFavorite(updatedFeatured, clinicId);
        final revertedNearby = _updateClinicFavorite(updatedNearby, clinicId);
        final revertedAll = _updateClinicFavorite(updatedAll, clinicId);

        _featuredClinics = revertedFeatured;
        _nearbyClinics = revertedNearby;
        _allClinics = revertedAll;

        emit(currentState.copyWith(
          featuredClinics: revertedFeatured,
          nearbyClinics: revertedNearby,
          allClinics: revertedAll,
        ));
      },
          (_) => null,
    );
  }

  /// Helper method to update clinic favorite status
  List<ClinicSummary> _updateClinicFavorite(
      List<ClinicSummary> clinics,
      int clinicId,
      ) {
    return clinics.map((clinic) {
      if (clinic.id == clinicId) {
        return clinic.copyWith(isFavorite: !clinic.isFavorite);
      }
      return clinic;
    }).toList();
  }

  /// Refresh data (pull to refresh)
  Future<void> refresh() async {
    _currentPage = 1;
    _hasMorePages = true;
    _allClinics.clear();
    _featuredClinics.clear();
    _nearbyClinics.clear();
    await loadClinics();
  }

  /// Split clinics into featured and nearby when backend adds this
  /// Call this method when you get the split data from backend
  void updateWithSeparateLists({
    List<ClinicSummary>? featured,
    List<ClinicSummary>? nearby,
  }) {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    if (featured != null) _featuredClinics = featured;
    if (nearby != null) _nearbyClinics = nearby;
    _allClinics = [..._featuredClinics, ..._nearbyClinics];

    emit(currentState.copyWith(
      featuredClinics: _featuredClinics,
      nearbyClinics: _nearbyClinics,
      allClinics: _allClinics,
    ));
  }
}