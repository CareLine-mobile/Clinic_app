import '../../../domain/entities/user_location.dart';

abstract class LocationDataSource {
  Future<UserLocation> getCurrentLocation();
  Future<bool> checkLocationPermission();
  Future<bool> requestLocationPermission();
}