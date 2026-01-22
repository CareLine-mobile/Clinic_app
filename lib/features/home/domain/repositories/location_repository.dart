import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_location.dart';

abstract class LocationRepository {
  Future<Either<Failure, UserLocation>> getCurrentLocation();
  Future<Either<Failure, bool>> checkLocationPermission();
  Future<Either<Failure, bool>> requestLocationPermission();
}