import 'package:dartz/dartz.dart';
import '../../../../../core/errors/failures.dart';
import '../../entities/user_location.dart';
import '../../repositories/location_repository.dart';

class GetCurrentLocationUseCase {
  final LocationRepository repository;

  GetCurrentLocationUseCase(this.repository);

  Future<Either<Failure, UserLocation>> call() async {
    // First check permission
    final permissionResult = await repository.checkLocationPermission();

    return permissionResult.fold(
          (failure) => Left(failure),
          (hasPermission) async {
        if (!hasPermission) {
          // Request permission
          final requestResult = await repository.requestLocationPermission();
          return requestResult.fold(
                (failure) => Left(failure),
                (granted) async {
              if (!granted) {
                return const Left(ServerFailure('Location permission denied'));
              }
              return await repository.getCurrentLocation();
            },
          );
        }
        return await repository.getCurrentLocation();
      },
    );
  }
}
