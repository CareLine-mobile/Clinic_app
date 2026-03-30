import 'dart:async';

import 'package:clinic_app/core/errors/failures.dart';
import 'package:clinic_app/features/home/domain/entities/clinic_summary.dart';
import 'package:clinic_app/features/user_data/user_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/favourite_repository.dart';
import '../../domain/usecases/get_favourites_usecase.dart';
import '../../domain/usecases/toggle_favourite_usecase.dart';

part 'favourite_state.dart';

class FavouriteCubit extends Cubit<FavouriteState> {
  final GetFavouritesUseCase _getFavouritesUseCase;
  final ToggleFavouriteUseCase _toggleFavouriteUseCase;
  final FavouriteRepository _favouriteRepository;
  final UserRepository _userRepository;

  StreamSubscription<Set<int>>? _streamSub;

  FavouriteCubit({
    required GetFavouritesUseCase getFavouritesUseCase,
    required ToggleFavouriteUseCase toggleFavouriteUseCase,
    required FavouriteRepository favouriteRepository,
    required UserRepository userRepository,
  })  : _getFavouritesUseCase = getFavouritesUseCase,
        _toggleFavouriteUseCase = toggleFavouriteUseCase,
        _favouriteRepository = favouriteRepository,
        _userRepository = userRepository,
        super(const FavouriteInitial()) {
    // Subscribe ONCE — handles cross-screen sync automatically
    _streamSub = _favouriteRepository.favouriteIdsStream.listen(
      _onFavouriteIdsUpdated,
    );
  }

  // ── Stream handler ───────────────────────────────────────────

  /// Called every time any screen toggles a favourite.
  /// When a clinic is unfav'd from home → it disappears here automatically.
  void _onFavouriteIdsUpdated(Set<int> ids) {
    final current = state;

    // Don't interfere with these states
    if (current is FavouriteLoading ||
        current is FavouriteUnauthenticated ||
        current is FavouriteInitial) return;

    // ── Case 1: list was empty and user added from another screen ──
    if (current is FavouriteEmpty && ids.isNotEmpty) {
      loadFavourites();
      return;
    }

    if (current is! FavouriteLoaded) return;

    final currentIds = current.clinics.map((c) => c.id).toSet();
    final hasNewItems = ids.any((id) => !currentIds.contains(id));

    // ── Case 2: a new clinic was added that we have no object for ──
    if (hasNewItems) {
      loadFavourites();
      return;
    }

    // ── Case 3: removal only — filter locally (no API call needed) ──
    final updated = current.clinics
        .where((c) => ids.contains(c.id))
        .map((c) => c.copyWith(isFavorite: true))
        .toList();

    emit(updated.isEmpty ? const FavouriteEmpty() : FavouriteLoaded(clinics: updated));
  }
  // ── Public API ───────────────────────────────────────────────

  Future<void> loadFavourites() async {
    // Auth guard — never call API when not logged in
    if (!_userRepository.isLoggedIn) {
      emit(const FavouriteUnauthenticated());
      return;
    }

    emit(const FavouriteLoading());

    final result = await _getFavouritesUseCase();
    result.fold(
          (failure) => emit(FavouriteError(failure)),
          (clinics) => clinics.isEmpty
          ? emit(const FavouriteEmpty())
          : emit(FavouriteLoaded(clinics: clinics)),
    );
  }

  Future<void> toggleFavourite(int clinicId) async {
    if (!_userRepository.isLoggedIn) {
      emit(const FavouriteUnauthenticated());
      return;
    }
    // The repository handles the guard, optimistic update, and rollback.
    // The stream subscription above handles our UI update — no manual emit needed.
    await _toggleFavouriteUseCase(clinicId);
  }

  // ── Lifecycle ────────────────────────────────────────────────

  @override
  Future<void> close() {
    _streamSub?.cancel();
    return super.close();
  }
}