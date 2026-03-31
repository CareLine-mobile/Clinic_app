import 'dart:async';
import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../home/domain/entities/clinic_summary.dart';
import '../../domain/repositories/favourite_repository.dart';
import '../datasources/favourite_remote_data_source.dart';

class FavouriteRepositoryImpl implements FavouriteRepository {
  final FavouriteRemoteDataSource _remoteDataSource;

  // ── In-memory state (single source of truth) ────────────────
  Set<int> _favouriteIds = {};
  final Set<int> _pendingIds = {}; // guard against double-tap
  bool _isSeeded = false;

  // ── Broadcast stream (never closed — app lifetime) ──────────
  final _controller = StreamController<Set<int>>.broadcast();

  FavouriteRepositoryImpl(this._remoteDataSource);

  // ── FavouriteRepository contract ────────────────────────────

  @override
  Stream<Set<int>> get favouriteIdsStream => _controller.stream;

  @override
  Set<int> get currentFavouriteIds => Set.unmodifiable(_favouriteIds);

  @override
  bool isTogglePending(int clinicId) => _pendingIds.contains(clinicId);

  /// Seed from the clinics-list response (isFavorite flags already present).
  /// Called by HomeCubit after it loads clinics — avoids an extra network call.
  @override
  void seedFavouriteIds(Set<int> ids) {
    if (_isSeeded) return;
    _favouriteIds = Set.from(ids);
    _isSeeded = true;
    _emit();
  }

  @override
  void clearOnLogout() {
    _favouriteIds.clear();
    _pendingIds.clear();
    _isSeeded = false;
    _emit();
  }

  // ── Toggle with guard + optimistic update + rollback ────────

  @override
  Future<Either<Failure, bool>> toggleFavourite(int clinicId) async {
    // ── Guard: ignore rapid double-tap ──────────────────────
    if (_pendingIds.contains(clinicId)) {
      log('[FavRepo] toggle ignored — already pending for $clinicId');
      return const Right(false);
    }

    _pendingIds.add(clinicId);

    // ── Optimistic update ───────────────────────────────────
    final bool wasAlreadyFav = _favouriteIds.contains(clinicId);
    if (wasAlreadyFav) {
      _favouriteIds.remove(clinicId);
    } else {
      _favouriteIds.add(clinicId);
    }
    _emit(); // subscribers see the change IMMEDIATELY

    try {
      // ── API call ────────────────────────────────────────
      final isFavOnServer = await _remoteDataSource.toggleFavourite(clinicId);
      _pendingIds.remove(clinicId);

      // ── Sync with server truth (handles edge cases) ─────
      if (isFavOnServer) {
        _favouriteIds.add(clinicId);
      } else {
        _favouriteIds.remove(clinicId);
      }
      _emit();

      return Right(isFavOnServer);
    } catch (e, st) {
      log('[FavRepo] toggle failed', error: e, stackTrace: st);
      _pendingIds.remove(clinicId);

      // ── Rollback optimistic update ──────────────────────
      if (wasAlreadyFav) {
        _favouriteIds.add(clinicId); // restore: put it back
      } else {
        _favouriteIds.remove(clinicId); // restore: remove it
      }
      _emit();

      return Left(_mapError(e));
    }
  }

  // ── Fetch list ───────────────────────────────────────────────

  @override
  Future<Either<Failure, List<ClinicSummary>>> getFavourites() async {
    try {
      final clinics = await _remoteDataSource.getFavourites();

      // Authoritative server response — always overwrite local IDs
      _favouriteIds = clinics.map((c) => c.id).toSet();
      _isSeeded = true;
      _emit();

      return Right(clinics);
    } catch (e, st) {
      log('[FavRepo] getFavourites failed', error: e, stackTrace: st);
      return Left(_mapError(e));
    }
  }

  // ── Private helpers ──────────────────────────────────────────

  void _emit() {
    print('📡 Repo emitting: $_favouriteIds');
    print(StackTrace.current); // ← This will show EXACTLY what called _emit()
    if (!_controller.isClosed) {
      _controller.add(Set.unmodifiable(_favouriteIds));
    }
  }

  Failure _mapError(dynamic e) {
    // Adjust to your actual Failure subclass hierarchy
    return ServerFailure(e.toString());
  }
}