// lib/features/home/domain/usecases/get_latest_clinics_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failures.dart';
import '../entities/clinic_summary.dart';
import '../repositories/home_repository.dart';
import 'location/get_current_location_usecase.dart';

class GetNearByClinicsUseCase {
  final HomeRepository repository;
  final GetCurrentLocationUseCase getCurrentLocationUseCase;

  GetNearByClinicsUseCase({
    required this.repository,
    required this.getCurrentLocationUseCase,
  });

  Future<Either<Failure, List<ClinicSummary>>> call() async {
    try {
      final locationResult = await getCurrentLocationUseCase();

      return locationResult.fold(
        // ─── Location denied or failed → empty list, NOT a failure ──
            (failure) => const Right([]),
            (location) async {
          try {
            final clinics = await repository.nearbyClinics(
              latitude: location.latitude,
              longitude: location.longitude,
            );
            clinics.forEach((element) {
              print('GetNearByClinicsUseCase : ${element.toString()}');
            });
            return Right(clinics);
          } catch (e, stackTrace) {
            // ─── Nearby API failed → empty list, NOT a failure ────────
            return const Right([]);
          }
        },
      );
    } catch (e, stackTrace) {
      // ─── Any unexpected error → empty list, NOT a failure ────────────
      return const Right([]);
    }
  }
}