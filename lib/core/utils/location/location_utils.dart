import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

/// A utility class for handling all location-related operations with comprehensive
/// error handling and permission management.
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

/// A utility class for handling all location-related operations with comprehensive
/// error handling and permission management.
class LocationUtils {
  static const LocationSettings _locationSettings = LocationSettings(
    accuracy: LocationAccuracy.best,
    distanceFilter: 10, // meters
  );


  /// Opens app settings for permission management
  static Future<void> openLocationSettings() async {
    try {
      if (Platform.isAndroid) {
        // On Android, open app settings to allow user to grant permission
        await Geolocator.openLocationSettings();
      } else {
        // On iOS, can only open app settings (user must navigate to location manually)
        await openAppSettings();
      }
    } catch (e, stackTrace) {
      log("Failed to open location settings", error: e, stackTrace: stackTrace);
    }
  }


}

/// Detailed status of location permission
enum LocationPermissionStatus {
  granted,
  denied,
  permanentlyDenied,
  restricted,
  limited,
  error,
}

/// Types of location errors
enum LocationErrorType {
  permissionDenied,
  permanentlyDenied,
  serviceDisabled,
  timeout,
  unknown,
}

/// Custom exception for location errors
class LocationException implements Exception {
  final String message;
  final LocationErrorType type;

  LocationException(this.message, this.type);

  @override
  String toString() => message;
}