// lib/features/home/presentation/cubit/home_cubit.dart

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clinic_app/core/service/notification_permission_service.dart';
import 'package:clinic_app/features/home/domain/usecases/get_latest_clinics_usecase.dart';
import 'package:clinic_app/features/home/domain/usecases/get_nearby_clinics_usecase.dart';
import 'package:meta/meta.dart';
import '../../../../core/errors/failures.dart';
import '../../../favourite/domain/repositories/favourite_repository.dart';
import '../../../favourite/domain/usecases/toggle_favourite_usecase.dart';
import '../../domain/entities/clinic_summary.dart';
import '../../domain/usecases/get_clinics_usecase.dart';
import '../../../clinic_details/domain/usecases/toggle_favorite_usecase.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetClinicsUseCase getClinicsUseCase;
  final GetLatestClinicsUseCase getLatestClinicsUseCase;
  final GetNearByClinicsUseCase getNearByClinicsUseCase;

  // ── CHANGED: now uses the unified ToggleFavouriteUseCase ──────
  final ToggleFavouriteUseCase toggleFavouriteUseCase;

  // ── NEW: reactive singleton repo ─────────────────────────────
  final FavouriteRepository _favouriteRepository;
  StreamSubscription<Set<int>>? _favStreamSub;

  HomeCubit({
    required this.getClinicsUseCase,
    required this.getLatestClinicsUseCase,
    required this.getNearByClinicsUseCase,
    required this.toggleFavouriteUseCase,
    required FavouriteRepository favouriteRepository, // NEW param
  })  : _favouriteRepository = favouriteRepository,
        super(HomeInitial()) {
    // ── NEW: subscribe once — handles all cross-screen sync ───
    _favStreamSub = _favouriteRepository.favouriteIdsStream
        .listen(_onFavouriteIdsUpdated);
  }

  List<ClinicSummary> _allClinics = [];
  List<ClinicSummary> _featuredClinics = [];
  List<ClinicSummary> _nearbyClinics = [];
  int _currentPage = 1;
  bool _hasMorePages = true;
  bool _isLoadingMore = false;

  // ════════════════════════════════════════════════════════════
  // NEW: stream listener — fired by ANY screen's toggle
  // ════════════════════════════════════════════════════════════

  void _onFavouriteIdsUpdated(Set<int> ids) {
    print('🔴 HomeCubit stream fired with ids: $ids');
    print('🔴 Current state: $state');
    final current = state;
    if (current is! HomeLoaded) return;

    // Rebuild all three lists in one pass — one emit
    _featuredClinics = _applyFavIds(_featuredClinics, ids);
    _nearbyClinics   = _applyFavIds(_nearbyClinics, ids);
    _allClinics      = _applyFavIds(_allClinics, ids);

    emit(current.copyWith(
      featuredClinics: _featuredClinics,
      nearbyClinics:   _nearbyClinics,
      allClinics:      _allClinics,
    ));
  }

  List<ClinicSummary> _applyFavIds(List<ClinicSummary> list, Set<int> ids) {
    return list
        .map((c) => c.copyWith(isFavorite: ids.contains(c.id)))
        .toList();
  }

  // ════════════════════════════════════════════════════════════
  // INIT — same as before + seed repo after load
  // ════════════════════════════════════════════════════════════

  Future<void> initHome() async {
    emit(HomeLoading());
    await _requestPermissions();

    try {
      final results = await Future.wait([
        getLatestClinicsUseCase.call(),
        getNearByClinicsUseCase.call(),
        getClinicsUseCase.call(page: 1),
      ]);

      Failure? failure;

      results[0].fold(
            (f) => failure ??= f,
            (c) => _featuredClinics = c as List<ClinicSummary>,
      );
      results[1].fold(
            (_) {},
            (c) => _nearbyClinics = c as List<ClinicSummary>,
      );
      results[2].fold(
            (f) => failure ??= f,
            (c) {
          _allClinics   = c as List<ClinicSummary>;
          _currentPage  = 1;
          _hasMorePages = (c as List).isNotEmpty;
        },
      );

      if (failure != null && _allClinics.isEmpty) {
        emit(HomeError(failure: failure!));
        return;
      }

      // ── NEW: seed the reactive repo so FavouriteCubit starts ─
      // synced without an extra /favorites network call.
    //  print('featured fav: ${_featuredClinics.where((c) => c.isFavorite).length}');
   //   print('nearby fav: ${_nearbyClinics.where((c) => c.isFavorite).length}');

     // print('all fav: ${_allClinics[0].toString()}');
      _seedRepo();

      _emitLoadedState();
    } catch (e) {
      emit(HomeError(failure: ServerFailure(e.toString())));
    }
  }

  // ── NEW: collect isFavorite=true IDs and hand to repo ────────
  void _seedRepo() {

    final ids = {
      ..._featuredClinics.where((c) => c.isFavorite).map((c) => c.id),
      ..._nearbyClinics.where((c) => c.isFavorite).map((c) => c.id),
      ..._allClinics.where((c) => c.isFavorite).map((c) => c.id),
    };
    _favouriteRepository.seedFavouriteIds(ids);
  }

  // ════════════════════════════════════════════════════════════
  // REFRESH — same logic as before + re-seed
  // ════════════════════════════════════════════════════════════

  Future<void> refresh() async {
    try {
      final results = await Future.wait([
        getLatestClinicsUseCase.call(),
        getNearByClinicsUseCase.call(),
        getClinicsUseCase.call(page: 1),
      ]);

      results[0].fold((_) {}, (c) => _featuredClinics = c as List<ClinicSummary>);
      results[1].fold((_) {}, (c) => _nearbyClinics   = c as List<ClinicSummary>);
      results[2].fold((_) {}, (c) {
        _allClinics   = c as List<ClinicSummary>;
        _currentPage  = 1;
        _hasMorePages = (c as List).isNotEmpty;
      });

      _seedRepo(); // ← re-seed on pull-to-refresh too
      _emitLoadedState();
    } catch (_) {
      // Keep current state on refresh error
    }
  }

  // ════════════════════════════════════════════════════════════
  // LOAD MORE — unchanged
  // ════════════════════════════════════════════════════════════

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
            // ── Apply current fav state to newly loaded clinics ──
            final ids = _favouriteRepository.currentFavouriteIds;
            _allClinics.addAll(_applyFavIds(newClinics, ids));
          }
          _isLoadingMore = false;
          emit(currentState.copyWith(
            allClinics:   List.from(_allClinics),
            currentPage:  _currentPage,
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

  // ════════════════════════════════════════════════════════════
  // TOGGLE FAVOURITE — SIMPLIFIED
  // ════════════════════════════════════════════════════════════

  // ── BEFORE: manual optimistic update + rollback in this cubit ──
  //
  // ── AFTER: one line. The repository handles:
  //    • guard (no double-tap)
  //    • optimistic update
  //    • API call
  //    • rollback on failure
  //    • stream broadcast → _onFavouriteIdsUpdated() above updates the UI

  Future<void> toggleFavorite(int clinicId) async {
    await toggleFavouriteUseCase(clinicId);
    // That's it. No manual state patching needed here.
  }

  // ════════════════════════════════════════════════════════════
  // HELPERS
  // ════════════════════════════════════════════════════════════

  Future<void> _requestPermissions() async {
    NotificationPermissionService.requestPermission().ignore();
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
    _currentPage   = 1;
    _hasMorePages  = true;
    _isLoadingMore = false;
    emit(HomeInitial());
  }

  // ── NEW: cancel subscription — prevents memory leak ──────────
  @override
  Future<void> close() {
    _favStreamSub?.cancel();
    return super.close();
  }
}