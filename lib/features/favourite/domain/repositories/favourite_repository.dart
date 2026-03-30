import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../../home/domain/entities/clinic_summary.dart';

abstract class FavouriteRepository {
  /// Reactive broadcast stream of currently-favourited clinic IDs.
  /// Every cubit that shows clinic cards subscribes to this single stream.
  Stream<Set<int>> get favouriteIdsStream;

  /// Synchronous snapshot — read current state without awaiting.
  Set<int> get currentFavouriteIds;

  /// Guard: true if a toggle API call is already in-flight for this clinic.
  bool isTogglePending(int clinicId);

  /// Toggle with:
  ///   1. Guard (double-tap protection)
  ///   2. Optimistic update → stream emits immediately
  ///   3. API call
  ///   4. Server-state sync OR rollback on failure
  Future<Either<Failure, bool>> toggleFavourite(int clinicId);

  /// Fetch full favourites list from server.
  /// Side-effect: syncs internal ID set and emits on stream.
  Future<Either<Failure, List<ClinicSummary>>> getFavourites();

  /// Seed with IDs already known (e.g. from the clinics-list API response).
  /// Skips the extra network call on cold-start.
  /// No-op if already seeded this session.
  void seedFavouriteIds(Set<int> ids);

  /// Clear everything on logout — emits empty set so all cards un-heart.
  void clearOnLogout();
}