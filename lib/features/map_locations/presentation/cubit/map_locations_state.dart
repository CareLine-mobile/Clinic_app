// lib/features/map_locations/presentation/cubit/map_locations_state.dart

part of 'map_locations_cubit.dart';

abstract class MapLocationsState extends Equatable {
  const MapLocationsState();

  @override
  List<Object?> get props => [];
}

/// Initial state before anything happens
class MapLocationsInitial extends MapLocationsState {
  const MapLocationsInitial();
}

/// Loading data (location + clinics)
class MapLocationsLoading extends MapLocationsState {
  const MapLocationsLoading();
}

/// Successfully loaded with markers and clinics
class MapLocationsLoaded extends MapLocationsState {
  final List<ClinicSummary> clinics;
  final Set<Marker> markers;
  final int selectedIndex;
  final LatLng userLocation;

  const MapLocationsLoaded({
    required this.clinics,
    required this.markers,
    required this.selectedIndex,
    required this.userLocation,
  });

  MapLocationsLoaded copyWith({
    List<ClinicSummary>? clinics,
    Set<Marker>? markers,
    int? selectedIndex,
    LatLng? userLocation,
  }) {
    return MapLocationsLoaded(
      clinics: clinics ?? this.clinics,
      markers: markers ?? this.markers,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      userLocation: userLocation ?? this.userLocation,
    );
  }

  @override
  List<Object?> get props => [clinics, markers, selectedIndex, userLocation];
}

/// Location permission was denied
class MapLocationsPermissionDenied extends MapLocationsState {
  final bool isPermanent;
  const MapLocationsPermissionDenied({this.isPermanent = false});

  @override
  List<Object?> get props => [isPermanent];
}

/// GPS/Location service is disabled on the device
class MapLocationsServiceDisabled extends MapLocationsState {
  const MapLocationsServiceDisabled();
}

/// Generic error (network, api, etc.)
class MapLocationsError extends MapLocationsState {
  final String message;
  const MapLocationsError(this.message);

  @override
  List<Object?> get props => [message];
}
