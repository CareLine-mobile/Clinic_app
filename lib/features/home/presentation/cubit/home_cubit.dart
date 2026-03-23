// lib/features/home/presentation/cubit/home_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:clinic_app/core/service/notification_permission_service.dart';
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

  List<ClinicSummary> _allClinics = [];
  List<ClinicSummary> _featuredClinics = [];
  List<ClinicSummary> _nearbyClinics = [];
  int _currentPage = 1;
  bool _hasMorePages = true;
  bool _isLoadingMore = false;

  // ════════════════════════════════════════════════════════════════
  // INIT — permissions first, then data
  // ════════════════════════════════════════════════════════════════

  Future<void> initHome() async {
    emit(HomeLoading());

    // ─── Ask permissions on every launch (non-blocking) ──────────
    await _requestPermissions();

    // ─── Load all data concurrently ──────────────────────────────
    try {
      final results = await Future.wait([
        getLatestClinicsUseCase.call(),
        getNearByClinicsUseCase.call(), // returns [] if location denied
        getClinicsUseCase.call(page: 1),
      ]);

      Failure? failure;

      results[0].fold((f) => failure ??= f, (c) => _featuredClinics = c as List<ClinicSummary>);
      // ─── Nearby: empty list is fine — not a failure ───────────
      results[1].fold((_) {}, (c) => _nearbyClinics = c as List<ClinicSummary>);
      results[2].fold(
            (f) => failure ??= f,
            (c) {
          _allClinics = c as List<ClinicSummary>;
          _currentPage = 1;
          _hasMorePages = (c).isNotEmpty;
        },
      );

      // Only show error if the critical data (all clinics) failed
      if (failure != null && _allClinics.isEmpty) {
        emit(HomeError(failure: failure!));
      } else {
        _emitLoadedState();
      }
    } catch (e) {
      emit(HomeError(failure: ServerFailure(e.toString())));
    }
  }

  /// Ask notification + location permissions silently on every launch
  Future<void> _requestPermissions() async {
    // Fire and forget — don't await result, don't block UI
    NotificationPermissionService.requestPermission().ignore();
    // Location permission is handled inside GetNearByClinicsUseCase
  }

  // ════════════════════════════════════════════════════════════════
  // REFRESH
  // ════════════════════════════════════════════════════════════════

  Future<void> refresh() async {
    try {
      final results = await Future.wait([
        getLatestClinicsUseCase.call(),
        getNearByClinicsUseCase.call(), // graceful — returns [] if denied
        getClinicsUseCase.call(page: 1),
      ]);

      results[0].fold((_) {}, (c) => _featuredClinics = c as List<ClinicSummary>);
      results[1].fold((_) {}, (c) => _nearbyClinics  = c as List<ClinicSummary>);
      results[2].fold((_) {}, (c) {
        _allClinics  = c as List<ClinicSummary>;
        _currentPage = 1;
        _hasMorePages = (c).isNotEmpty;
      });

      _emitLoadedState();
    } catch (_) {
      // Keep current state on refresh error
    }
  }

  // ════════════════════════════════════════════════════════════════
  // LOAD MORE
  // ════════════════════════════════════════════════════════════════

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

  // ════════════════════════════════════════════════════════════════
  // TOGGLE FAVORITE
  // ════════════════════════════════════════════════════════════════

  Future<void> toggleFavorite(int clinicId) async {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    final updatedFeatured = _updateClinicFavorite(_featuredClinics, clinicId);
    final updatedNearby   = _updateClinicFavorite(_nearbyClinics, clinicId);
    final updatedAll      = _updateClinicFavorite(_allClinics, clinicId);

    _featuredClinics = updatedFeatured;
    _nearbyClinics   = updatedNearby;
    _allClinics      = updatedAll;

    emit(currentState.copyWith(
      featuredClinics: updatedFeatured,
      nearbyClinics: updatedNearby,
      allClinics: updatedAll,
    ));

    final result = await toggleFavoriteUseCase(clinicId.toString());

    result.fold(
          (_) {
        // Rollback
        _featuredClinics = _updateClinicFavorite(updatedFeatured, clinicId);
        _nearbyClinics   = _updateClinicFavorite(updatedNearby, clinicId);
        _allClinics      = _updateClinicFavorite(updatedAll, clinicId);
        emit(currentState.copyWith(
          featuredClinics: _featuredClinics,
          nearbyClinics: _nearbyClinics,
          allClinics: _allClinics,
        ));
      },
          (_) => null,
    );
  }

  // ════════════════════════════════════════════════════════════════
  // HELPERS
  // ════════════════════════════════════════════════════════════════

  List<ClinicSummary> _updateClinicFavorite(
      List<ClinicSummary> clinics,
      int clinicId,
      ) {
    return clinics.map((c) {
      return c.id == clinicId ? c.copyWith(isFavorite: !c.isFavorite) : c;
    }).toList();
  }

  void _emitLoadedState() {
    emit(HomeLoaded(
      featuredClinics: List.from(_featuredClinics),
      nearbyClinics:   List.from(_nearbyClinics),
      allClinics:      List.from(_allClinics),
      currentPage:     _currentPage,
      hasMorePages:    _hasMorePages,
      isLoadingMore:   false,
    ));
  }

  void reset() {
    _allClinics.clear();
    _featuredClinics.clear();
    _nearbyClinics.clear();
    _currentPage  = 1;
    _hasMorePages = true;
    _isLoadingMore = false;
    emit(HomeInitial());
  }
}