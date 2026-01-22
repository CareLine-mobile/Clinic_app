// lib/features/home/domain/usecases/get_latest_clinics_usecase.dart
// Use this when backend adds separate featured endpoint
import 'package:dartz/dartz.dart';
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
    // Get current location first
    final locationResult = await getCurrentLocationUseCase();

    return locationResult.fold(
          (failure) => Left(failure),
          (location) async {
        // Use location to get nearby clinics
        return await repository.nearbyClinics(
          latitude: location.latitude,
          longitude: location.longitude,
        );
      },
    );
  }
}


