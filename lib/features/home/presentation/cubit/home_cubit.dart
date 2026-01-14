import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/clinic_summary.dart';
import '../../domain/usecases/get_clinics_usecase.dart';
import '../../../clinic_details/domain/usecases/toggle_favorite_usecase.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetClinicsUseCase getClinicsUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;

  HomeCubit({
    required this.getClinicsUseCase,
    required this.toggleFavoriteUseCase,
  }) : super(HomeInitial());

  List<ClinicSummary> _allClinics = [];
  int _currentPage = 1;
  bool _hasMorePages = true;
  bool _isLoadingMore = false;
  List<ClinicSummary> _featuredClinics = [];
  List<ClinicSummary> _nearbyClinics = [];

  /// Load initial clinics (page 1)
  Future<void> loadClinics() async {
    emit(HomeLoading());

    final result = await getClinicsUseCase.call(page: 1);

    result.fold(
          (failure) {
        emit(HomeError(failure: failure));
      },
          (clinics) {
        _allClinics = clinics;
        _nearbyClinics = [];
        _currentPage = 1;
        _hasMorePages = true;

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
  }

  /// Load initial clinics (page 1)
  Future<void> latestClinics() async {
    emit(HomeLoading());

    final result = await getClinicsUseCase.callLatestClinics();

    result.fold(
          (failure) {
        emit(HomeError(failure: failure));
      },
          (clinics) {
        _featuredClinics = clinics;
        _nearbyClinics = [];
        _currentPage = 1;
        _hasMorePages = true;

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
          _currentPage--;
          _isLoadingMore = false;
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

    // Optimistic update
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

    // Call API
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
}