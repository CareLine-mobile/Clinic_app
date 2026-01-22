import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result_handler.dart';
import '../../domain/entities/user_location.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/localdatasource/location_data_source.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationDataSource dataSource;

  LocationRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, UserLocation>> getCurrentLocation() async {
    return ResultHandler.handle(() async {
      return await dataSource.getCurrentLocation();
    });
  }

  @override
  Future<Either<Failure, bool>> checkLocationPermission() async {
    return ResultHandler.handle(() async {
      return await dataSource.checkLocationPermission();
    });
  }

  @override
  Future<Either<Failure, bool>> requestLocationPermission() async {
    return ResultHandler.handle(() async {
      return await dataSource.requestLocationPermission();
    });
  }
}