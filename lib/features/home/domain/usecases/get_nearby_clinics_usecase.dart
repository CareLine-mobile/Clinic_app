import 'package:clinic_app/features/home/data/datasources/localdatasource/location_data_source_impl.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/location/location_utils.dart';
import '../entities/clinic_summary.dart';
import '../repositories/home_repository.dart';


class GetNearByClinicsUseCase {
  final HomeRepository repository;
 // LocationDataSource locationDataSource;

  GetNearByClinicsUseCase({
    required this.repository,
  //  required this.locationDataSource,
  });

  Future<Either<Failure, List<ClinicSummary>>> call() async {
    try {
      final locationResult = await LocationDataSourceUtilits.getCurrentLocation();

      final clinics = await repository.nearbyClinics(
        latitude: locationResult.latitude,
        longitude: locationResult.longitude,
      );
      return Right(clinics);


    } on LocationException catch (e) {
      return Left(LocationFailure(e.type, e.message));
    } catch (e, stackTrace) {
      // ─── Any unexpected error → empty list, NOT a failure ────────────
      return const Right([]);
    }
  }
}

/*
// lib/features/home/domain/usecases/get_latest_clinics_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failures.dart';
import '../../data/datasources/localdatasource/location_data_source.dart';
import '../entities/clinic_summary.dart';
import '../repositories/home_repository.dart';
import 'location/get_current_location_usecase.dart';

class GetNearByClinicsUseCase {
  final HomeRepository repository;
  LocationDataSource locationDataSource

  GetNearByClinicsUseCase({
    required this.repository,
    required this.getCurrentLocationUseCase,
  });

  Future<Either<Failure, List<ClinicSummary>>> call() async {
    try {
      final locationResult = await getCurrentLocationUseCase();

      return locationResult.fold(
        // ─── Location denied or failed → empty list, NOT a failure ──
            (failure) => Left(failure),
            (location) async {
          try {
            final clinics = await repository.nearbyClinics(
              latitude: location.latitude,
              longitude: location.longitude,
            );

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
 */