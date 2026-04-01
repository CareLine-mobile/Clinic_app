import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../core/utils/location/location_utils.dart';
import '../../../domain/entities/user_location.dart';
import 'location_data_source.dart';

class LocationDataSourceUtilits  {

  static Future<UserLocation> getCurrentLocation() async {
    try {

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw LocationException(
            "Location permission denied",
            LocationErrorType.permissionDenied,
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw LocationException(
          "Location permission denied",
          LocationErrorType.permanentlyDenied,
        );
      }

      bool isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
     //  await Geolocator.openLocationSettings();
      throw LocationException(
        "Location service disabled",
        LocationErrorType.serviceDisabled,
      );
      }
      // Get position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return UserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      throw LocationException(
        "Location error: $e",
        LocationErrorType.unknown,
      );
    }
  }


  static Future<bool> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }


  static Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }
  static Future<void> openLocationSettings() async {

      if (Platform.isAndroid) {
        // On Android, open app settings to allow user to grant permission
        await Geolocator.openLocationSettings();
      } else {
        // On iOS, can only open app settings (user must navigate to location manually)
        await openAppSettings();
      }

  }
}