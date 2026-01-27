// lib/features/home/presentation/cubit/home_cubit.dart
// ============================================

import 'package:bloc/bloc.dart';
import 'package:clinic_app/features/home/domain/usecases/get_latest_clinics_usecase.dart';
import 'package:clinic_app/features/home/domain/usecases/get_nearby_clinics_usecase.dart';
import 'package:meta/meta.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/clinic_summary.dart';
import '../../domain/usecases/get_clinics_usecase.dart';
import '../../../clinic_details/domain/usecases/toggle_favorite_usecase.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetClinicsUseCase getClinicsUseCase;
  final GetLatestClinicsUseCase getLatestClinicsUseCase;
  final GetNearByClinicsUseCase getNearByClinicsUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;

  HomeCubit({
    required this.getClinicsUseCase,
    required this.getLatestClinicsUseCase,
    required this.getNearByClinicsUseCase,
    required this.toggleFavoriteUseCase,
  }) : super(HomeInitial());

  // Private state
  List<ClinicSummary> _allClinics = [];
  List<ClinicSummary> _featuredClinics = [];
  List<ClinicSummary> _nearbyClinics = [];
  int _currentPage = 1;
  bool _hasMorePages = true;
  bool _isLoadingMore = false;

  // ============================================
  // INIT HOME - Load All Data at Once
  // ============================================

  /// Initialize home screen by loading all data concurrently
  Future<void> initHome() async {
    emit(HomeLoading());

    try {
      // Load all data concurrently
      final results = await Future.wait([
        getLatestClinicsUseCase.call(),
        getNearByClinicsUseCase.call(),
        getClinicsUseCase.call(page: 1),
      ]);

      // Extract results
      final featuredResult = results[0];
      final nearbyResult = results[1];
      final allClinicsResult = results[2];

      // Check for any failures
      Failure? failure;

      featuredResult.fold(
            (f) => failure ??= f,
            (clinics) => _featuredClinics = clinics,
      );

      nearbyResult.fold(
            (f) => failure ??= f,
            (clinics) => _nearbyClinics = clinics,
      );

      allClinicsResult.fold(
            (f) => failure ??= f,
            (clinics) {
          _allClinics = clinics;
          _currentPage = 1;
          _hasMorePages = clinics.isNotEmpty;
        },
      );

      // Emit state based on results
      if (failure != null) {
        emit(HomeError(failure: failure!));
      } else {
        _emitLoadedState();
      }
    } catch (e) {
      emit(HomeError(
        failure: ServerFailure('حدث خطأ غير متوقع: ${e.toString()}'),
      ));
    }
  }

  // ============================================
  // LOAD CLINICS - With Refresh Support
  // ============================================

  /// Load all clinics (page 1)
  /// [isRefresh] - if true, keeps old data visible during loading
  Future<void> loadClinics({bool isRefresh = false}) async {
    if (!isRefresh) {
      emit(HomeLoading());
    }

    final result = await getClinicsUseCase.call(page: 1);

    result.fold(
          (failure) {
        if (!isRefresh) {
          emit(HomeError(failure: failure));
        }
        // If refresh, keep current state
      },
          (clinics) {
        _allClinics = clinics;
        _currentPage = 1;
        _hasMorePages = clinics.isNotEmpty;
        _emitLoadedState();
      },
    );
  }

  /// Load latest/featured clinics
  /// [isRefresh] - if true, keeps old data visible during loading
  Future<void> loadLatestClinics({bool isRefresh = false}) async {
    if (!isRefresh) {
      emit(HomeLoading());
    }

    final result = await getLatestClinicsUseCase.call();

    result.fold(
          (failure) {
        if (!isRefresh) {
          emit(HomeError(failure: failure));
        }
      },
          (clinics) {
        _featuredClinics = clinics;
        _emitLoadedState();
      },
    );
  }

  /// Load nearby clinics
  /// [isRefresh] - if true, keeps old data visible during loading
  Future<void> loadNearByClinics({bool isRefresh = false}) async {
    if (!isRefresh) {
      emit(HomeLoading());
    }

    final result = await getNearByClinicsUseCase.call();

    result.fold(
          (failure) {
        if (!isRefresh) {
          emit(HomeError(failure: failure));
        }
      },
          (clinics) {
        _nearbyClinics = clinics;
        _emitLoadedState();
      },
    );
  }

  // ============================================
  // REFRESH - Reload All Data
  // ============================================

  /// Refresh all data (for pull-to-refresh)
  /// Keeps old data visible while loading new data
  Future<void> refresh() async {
    try {
      // Load all data concurrently with isRefresh = true
      final results = await Future.wait([
        getLatestClinicsUseCase.call(),
        getNearByClinicsUseCase.call(),
        getClinicsUseCase.call(page: 1),
      ]);

      // Extract results
      final featuredResult = results[0];
      final nearbyResult = results[1];
      final allClinicsResult = results[2];

      // Update data without showing loading state
      featuredResult.fold(
            (failure) {
          // Log error but don't show error state
          print('Failed to refresh featured clinics: ${failure.message}');
        },
            (clinics) => _featuredClinics = clinics,
      );

      nearbyResult.fold(
            (failure) {
          print('Failed to refresh nearby clinics: ${failure.message}');
        },
            (clinics) => _nearbyClinics = clinics,
      );

      allClinicsResult.fold(
            (failure) {
          print('Failed to refresh all clinics: ${failure.message}');
        },
            (clinics) {
          _allClinics = clinics;
          _currentPage = 1;
          _hasMorePages = clinics.isNotEmpty;
        },
      );

      // Emit updated state (instant swap)
      _emitLoadedState();
    } catch (e) {
      print('Refresh error: $e');
      // Keep current state on error
    }
  }

  // ============================================
  // LOAD MORE CLINICS - Pagination
  // ============================================

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
          }
          _isLoadingMore = false;
          emit(currentState.copyWith(
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

  // ============================================
  // TOGGLE FAVORITE
  // ============================================

  /// Toggle favorite for a clinic (optimistic update)
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
    final result = await toggleFavoriteUseCase(clinicId.toString());

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

  // ============================================
  // HELPER METHODS
  // ============================================

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

  /// Helper method to emit loaded state
  void _emitLoadedState() {
    emit(HomeLoaded(
      featuredClinics: List.from(_featuredClinics),
      nearbyClinics: List.from(_nearbyClinics),
      allClinics: List.from(_allClinics),
      currentPage: _currentPage,
      hasMorePages: _hasMorePages,
      isLoadingMore: false,
    ));
  }

  /// Reset state
  void reset() {
    _allClinics.clear();
    _featuredClinics.clear();
    _nearbyClinics.clear();
    _currentPage = 1;
    _hasMorePages = true;
    _isLoadingMore = false;
    emit(HomeInitial());
  }
}