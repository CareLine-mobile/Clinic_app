// lib/features/home/domain/usecases/get_latest_clinics_usecase.dart
// Use this when backend adds separate featured endpoint
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
      // Get current location first
      final locationResult = await getCurrentLocationUseCase();

      return locationResult.fold(
            (failure) => Left(failure),
            (location) async {
          try {
            // Use location to get nearby clinics
            final clinics = await repository.nearbyClinics(
              latitude: location.latitude,
              longitude: location.longitude,
            );
            return Right(clinics);
          } catch (e, stackTrace) {
            return Left(ErrorHandler.handleException(e, stackTrace));
          }
        },
      );
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handleException(e, stackTrace));
    }
  }
}


