import 'dart:io';
import 'dart:ui' as ui;

import 'package:bloc/bloc.dart';
import 'package:clinic_app/features/home/data/datasources/localdatasource/location_data_source_impl.dart';
import 'package:clinic_app/features/home/domain/entities/clinic_summary.dart';
import 'package:clinic_app/features/home/domain/usecases/get_nearby_clinics_usecase.dart';
import 'package:clinic_app/core/utils/location/location_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_locations_state.dart';

class MapLocationsCubit extends Cubit<MapLocationsState> {
  final GetNearByClinicsUseCase _getNearByClinicsUseCase;
  GoogleMapController? _mapController;

  // Cache downloaded clinic images so we don't re-fetch every time
  final Map<int, Uint8List> _imageCache = {};

  MapLocationsCubit({
    required GetNearByClinicsUseCase getNearByClinicsUseCase,
  })  : _getNearByClinicsUseCase = getNearByClinicsUseCase,
        super(const MapLocationsInitial());

  // ── Called when map is ready ──────────────────────────────────────────
  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  // ── Initial load ──────────────────────────────────────────────────────
  Future<void> loadLocations() async {
    emit(const MapLocationsLoading());

    try {
      // 1. Get device location
      final userLocation =
          await LocationDataSourceUtilits.getCurrentLocation();
      final userLatLng =
          LatLng(userLocation.latitude, userLocation.longitude);

      // 2. Fetch nearby clinics
      final result = await _getNearByClinicsUseCase.call();

      result.fold(
        (failure) => emit(MapLocationsError(failure.message)),
        (clinics) async {
          // Pre-download all clinic images in parallel
          await _preloadImages(clinics);

          final markers =
              await _buildMarkers(clinics, selectedIndex: 0);
          emit(MapLocationsLoaded(
            clinics: clinics,
            markers: markers,
            selectedIndex: 0,
            userLocation: userLatLng,
          ));
        },
      );
    } on LocationException catch (e) {
      switch (e.type) {
        case LocationErrorType.permissionDenied:
          emit(const MapLocationsPermissionDenied(isPermanent: false));
          break;
        case LocationErrorType.permanentlyDenied:
          emit(const MapLocationsPermissionDenied(isPermanent: true));
          break;
        case LocationErrorType.serviceDisabled:
          emit(const MapLocationsServiceDisabled());
          break;
        default:
          emit(MapLocationsError(e.message));
      }
    } catch (e) {
      emit(MapLocationsError(e.toString()));
    }
  }

  // ── Pre-download images for all clinics ──────────────────────────────
  Future<void> _preloadImages(List<ClinicSummary> clinics) async {
    final futures = clinics.map((c) => _downloadImage(c));
    await Future.wait(futures);
  }

  Future<void> _downloadImage(ClinicSummary clinic) async {
    if (_imageCache.containsKey(clinic.id)) return;
    try {
      final httpClient = HttpClient();
      final request = await httpClient.getUrl(Uri.parse(clinic.firstImageUrl));
      final response = await request.close();
      if (response.statusCode == 200) {
        final bytes = await consolidateHttpClientResponseBytes(response);
        _imageCache[clinic.id] = bytes;
      }
      httpClient.close();
    } catch (_) {
      // Silently fail — we'll use the fallback icon marker
    }
  }

  // ── Called when user taps a marker on the map ─────────────────────────
  void onMarkerTapped(int clinicId) {
    final current = state;
    if (current is! MapLocationsLoaded) return;

    final index = current.clinics.indexWhere((c) => c.id == clinicId);
    if (index == -1) return;

    _animateToClinic(current.clinics[index]);
    _rebuildMarkersWithSelected(current.clinics, index);
  }

  // ── Called when user scrolls the bottom PageView card ────────────────
  void onCardScrolled(int index) {
    final current = state;
    if (current is! MapLocationsLoaded) return;
    if (index == current.selectedIndex) return;

    final clinic = current.clinics[index];
    emit(current.copyWith(selectedIndex: index));
    _animateToClinic(clinic);
    _rebuildMarkersWithSelected(current.clinics, index);
  }

  // ── Rebuild markers, highlighting the selected one ────────────────────
  Future<void> _rebuildMarkersWithSelected(
      List<ClinicSummary> clinics, int selectedIndex) async {
    final markers =
        await _buildMarkers(clinics, selectedIndex: selectedIndex);
    final current = state;
    if (current is MapLocationsLoaded) {
      emit(current.copyWith(
        markers: markers,
        selectedIndex: selectedIndex,
      ));
    }
  }

  // ── Animate camera to clinic position ────────────────────────────────
  void _animateToClinic(ClinicSummary clinic) {
    if (clinic.lat == null || clinic.lng == null) return;
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(clinic.lat!, clinic.lng!),
        15,
      ),
    );
  }

  // ── Build marker set from clinic list ────────────────────────────────
  Future<Set<Marker>> _buildMarkers(
    List<ClinicSummary> clinics, {
    int selectedIndex = 0,
  }) async {
    final Set<Marker> markers = {};

    for (int i = 0; i < clinics.length; i++) {
      final clinic = clinics[i];
      if (clinic.lat == null || clinic.lng == null) continue;

      final isSelected = i == selectedIndex;
      final imageBytes = _imageCache[clinic.id];

      final icon = await _createMarkerBitmap(
        isSelected: isSelected,
        imageBytes: imageBytes,
      );

      markers.add(
        Marker(
          markerId: MarkerId(clinic.id.toString()),
          position: LatLng(clinic.lat!, clinic.lng!),
          icon: icon,
          zIndex: isSelected ? 10 : 1,
          anchor: const Offset(0.5, 1.0),
          onTap: () => onMarkerTapped(clinic.id),
        ),
      );
    }
    return markers;
  }

  // ─────────────────────────────────────────────────────────────────────
  // Custom marker bitmap with clinic image inside the pin
  // ─────────────────────────────────────────────────────────────────────
  Future<BitmapDescriptor> _createMarkerBitmap({
    required bool isSelected,
    Uint8List? imageBytes,
  }) async {
    // Selected: larger pin with image; unselected: smaller simple pin
    final double markerSize = isSelected ? 120 : 60;
    final double borderWidth = isSelected ? 4.0 : 2.5;
    final Color pinColor = isSelected
        ? const Color(0xFF0891B2) // primary
        : const Color(0xFF6B7280); // grey
    final double imageRadius = isSelected ? 42 : 0; // no image when small
    final double circleRadius = isSelected ? 48 : 22;
    final double triangleHeight = isSelected ? 16 : 8;

    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final center = Offset(markerSize / 2, circleRadius + 4);

    // ── Drop shadow ────────────────────────────────────────────────────
    canvas.drawCircle(
      center + const Offset(0, 3),
      circleRadius * 0.9,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );

    // ── Main filled circle ──────────────────────────────────────────────
    canvas.drawCircle(
      center,
      circleRadius,
      Paint()..color = pinColor,
    );

    // ── White border ─────────────────────────────────────────────────────
    canvas.drawCircle(
      center,
      circleRadius,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth,
    );

    // ── Triangle (pin pointer) ──────────────────────────────────────────
    final triTop = center.dy + circleRadius * 0.7;
    final path = Path()
      ..moveTo(center.dx - (isSelected ? 10 : 6), triTop)
      ..lineTo(center.dx + (isSelected ? 10 : 6), triTop)
      ..lineTo(center.dx, triTop + triangleHeight)
      ..close();
    canvas.drawPath(path, Paint()..color = pinColor);

    // ── Clinic image (only when selected & image is available) ──────────
    if (isSelected && imageBytes != null) {
      // Decode the downloaded image
      final codec = await ui.instantiateImageCodec(
        imageBytes,
        targetWidth: (imageRadius * 2).toInt() + 20,
        targetHeight: (imageRadius * 2).toInt() + 20,
      );
      final frameInfo = await codec.getNextFrame();
      final clinicImage = frameInfo.image;

      // Clip to a circle and draw the image inside the pin
      canvas.save();
      canvas.clipPath(
        Path()
          ..addOval(Rect.fromCircle(center: center, radius: imageRadius)),
      );
      canvas.drawImageRect(
        clinicImage,
        Rect.fromLTWH(
          0,
          0,
          clinicImage.width.toDouble(),
          clinicImage.height.toDouble(),
        ),
        Rect.fromCircle(center: center, radius: imageRadius),
        Paint()..filterQuality = FilterQuality.high,
      );
      canvas.restore();

      // Inner ring around the image for polish
      canvas.drawCircle(
        center,
        imageRadius,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5,
      );
    } else {
      // ── Unselected: draw a simple location icon dot ────────────────
      canvas.drawCircle(
        center,
        isSelected ? 12 : 6,
        Paint()..color = Colors.white,
      );
    }

    // ── Render to bitmap ──────────────────────────────────────────────
    final totalH = (center.dy + circleRadius * 0.7 + triangleHeight + 4).ceil();
    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(markerSize.toInt(), totalH);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.bytes(bytes!.buffer.asUint8List());
  }

  @override
  Future<void> close() {
    _mapController?.dispose();
    _imageCache.clear();
    return super.close();
  }
}
