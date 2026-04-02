// lib/features/search/presentation/cubit/search_cubit.dart

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/utils/debouncer.dart';
import '../../../favourite/domain/repositories/favourite_repository.dart';
import '../../../favourite/domain/usecases/toggle_favourite_usecase.dart';
import '../../../home/domain/entities/clinic_summary.dart';
import '../../domain/model/search_filter.dart';
import '../../domain/usecases/search_clinics_usecase.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchClinicsUseCase searchClinicsUseCase;
  final ToggleFavouriteUseCase toggleFavouriteUseCase;
  final FavouriteRepository _favouriteRepository;
  final Debouncer _debouncer;

  String _lastQuery = '';
  StreamSubscription<Set<int>>? _favStreamSub;

  SearchCubit({
    required this.searchClinicsUseCase,
    required this.toggleFavouriteUseCase,
    required FavouriteRepository favouriteRepository,
    Debouncer? debouncer,
  })  : _favouriteRepository = favouriteRepository,
        _debouncer = debouncer ?? Debouncer(),
        super(const SearchInitial()) {
    _favStreamSub = _favouriteRepository.favouriteIdsStream
        .listen(_onFavouriteIdsUpdated);
  }

  // ── Stream handler ───────────────────────────────────────
  void _onFavouriteIdsUpdated(Set<int> ids) {
    if (state is! SearchLoaded) return;
    final current = state as SearchLoaded;

    emit(current.copyWith(
      allClinics: _applyFavIds(current.allClinics, ids),
      filteredClinics: _applyFavIds(current.filteredClinics, ids),
    ));
  }

  List<ClinicSummary> _applyFavIds(List<ClinicSummary> list, Set<int> ids) =>
      list.map((c) => c.copyWith(isFavorite: ids.contains(c.id))).toList();

  // ── Search ───────────────────────────────────────────────
  void onSearchQueryChanged(String query) {
    final trimmed = query.trim();
    _lastQuery = trimmed;

    if (trimmed.isEmpty) {
      _debouncer.cancel();
      emit(const SearchInitial());
      return;
    }
    _debouncer(() => _search(trimmed));
  }

  Future<void> _search(String query) async {
    if (isClosed) return;
    emit(const SearchLoading());

    final result = await searchClinicsUseCase(query: query);
    if (isClosed) return;

    result.fold(
          (failure) => emit(SearchError(failure.message)),
          (clinics) {
        if (clinics.isEmpty) {
          emit(const SearchEmpty());
        } else {
          // ── Bug 3 fix: stamp current repo fav state onto results ──
          final ids = _favouriteRepository.currentFavouriteIds;
          final stamped = _applyFavIds(clinics, ids);
          emit(SearchLoaded.fromClinics(stamped));
        }
      },
    );
  }

  // ── Filters ──────────────────────────────────────────────
  void toggleIsOpen(bool? value) => _updateFilter(
        (f) => f.copyWith(isOpen: value),
  );

  void setMinRating(double? rating) => _updateFilter(
        (f) => f.copyWith(minRating: rating),
  );

  void clearFilters() => _updateFilter((_) => const SearchFilter.empty());

  void _updateFilter(SearchFilter Function(SearchFilter) updater) {
    final current = state;
    if (current is! SearchLoaded) return;
    // ── Bug 2 fix: removed _seedRepo() — it was corrupting shared repo state ──
    emit(current.withFilter(updater(current.filter)));
  }

  // ── Toggle ───────────────────────────────────────────────
  Future<void> toggleFavorite(int clinicId) async {
    // Repo handles optimistic update + stream broadcast →
    // _onFavouriteIdsUpdated above syncs search, HomeCubit and
    // FavouriteCubit receive the same emission automatically.
    await toggleFavouriteUseCase(clinicId);
  }

  void retry() {
    if (_lastQuery.isEmpty) return;
    _search(_lastQuery);
  }

  // ── Bug 1 fix: cancel subscription to prevent memory leak ──
  @override
  Future<void> close() {
    _favStreamSub?.cancel();
    _debouncer.dispose();
    return super.close();
  }
}