// lib/features/map_locations/presentation/view/map_locations_screen.dart

import 'dart:io';

import 'package:clinic_app/core/theme/colors.dart';
import 'package:clinic_app/core/utils/location/location_utils.dart';
import 'package:clinic_app/features/map_locations/presentation/cubit/map_locations_cubit.dart';
import 'package:clinic_app/features/map_locations/presentation/widgets/map_clinic_card.dart';
import 'package:clinic_app/features/map_locations/presentation/widgets/map_error_view.dart';
import 'package:clinic_app/features/map_locations/presentation/widgets/map_loading_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/routes/routes.dart';

import 'package:clinic_app/features/map_locations/presentation/widgets/map_clinic_summary_sheet.dart';

class MapLocationsScreen extends StatefulWidget {
  const MapLocationsScreen({super.key});

  @override
  State<MapLocationsScreen> createState() => _MapLocationsScreenState();
}

class _MapLocationsScreenState extends State<MapLocationsScreen>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  bool _isPageScrolling = false;

  // ── Lifecycle ─────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.88,
      initialPage: 0,
    );
    // Trigger load
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<MapLocationsCubit>().loadLocations(),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // ── Handle PageView scroll → animate map ─────────────────────────────

  void _onPageChanged(int index) {
    if (!_isPageScrolling) return;
    context.read<MapLocationsCubit>().onCardScrolled(index);
  }

  // ── Build ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: BlocConsumer<MapLocationsCubit, MapLocationsState>(
        listener: (context, state) {
          // Sync PageController when cubit selects a card from a marker tap
          if (state is MapLocationsLoaded) {
            if (!_isPageScrolling &&
                _pageController.hasClients &&
                _pageController.page?.round() != state.selectedIndex) {
              _pageController.animateToPage(
                state.selectedIndex,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
              );
            }
          }
        },
        builder: (context, state) {
          if (state is MapLocationsLoading || state is MapLocationsInitial) {
            return const MapLoadingView();
          }

          if (state is MapLocationsPermissionDenied) {
            return MapPermissionDeniedView(
              isPermanent: state.isPermanent,
              onRetry: () =>
                  context.read<MapLocationsCubit>().loadLocations(),
              onOpenSettings: () async {
                await LocationUtils.openLocationSettings();
              },
            );
          }

          if (state is MapLocationsServiceDisabled) {
            return MapServiceDisabledView(
              onOpenSettings: () async {
                if (Platform.isAndroid) {
                  await Geolocator.openLocationSettings();
                } else {
                  await LocationUtils.openLocationSettings();
                }
              },
              onRetry: () =>
                  context.read<MapLocationsCubit>().loadLocations(),
            );
          }

          if (state is MapLocationsError) {
            return MapGenericErrorView(
              message: state.message,
              onRetry: () =>
                  context.read<MapLocationsCubit>().loadLocations(),
            );
          }

          if (state is MapLocationsLoaded) {
            return _buildMapWithCards(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  // ── Transparent AppBar ────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      leading: _GlassIconButton(
        icon: Icons.arrow_back_ios_new_rounded,
        onTap: () => Navigator.of(context).pop(),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 12.w),
          child: _GlassIconButton(
            icon: Icons.my_location_rounded,
            onTap: () {
              final state = context.read<MapLocationsCubit>().state;
              if (state is MapLocationsLoaded) {
                context.read<MapLocationsCubit>().onCardScrolled(0);
              }
            },
          ),
        ),
      ],
    );
  }

  // ── Main map + floating cards layout ─────────────────────────────────

  Widget _buildMapWithCards(BuildContext context, MapLocationsLoaded state) {
    // Initial camera target: user location OR first clinic
    final initialTarget = state.clinics.isNotEmpty &&
            state.clinics.first.lat != null &&
            state.clinics.first.lng != null
        ? LatLng(state.clinics.first.lat!, state.clinics.first.lng!)
        : state.userLocation;

    return Stack(
      children: [
        // ── Google Map fills the screen ──────────────────────────────
        GoogleMap(
          onMapCreated:
              context.read<MapLocationsCubit>().onMapCreated,
          initialCameraPosition: CameraPosition(
            target: initialTarget,
            zoom: 14,
          ),
          markers: state.markers,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
          compassEnabled: false,
          mapType: MapType.normal,
          onTap: (_) {}, // dismiss marker info if needed
        ),

        // ── Floating bottom PageView cards ───────────────────────────
        Positioned(
          bottom: 24.h,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 135.h, // Increased from 110.h to fix overflow and look better
            child: state.clinics.isEmpty
                ? _buildNoLocationCard(context)
                : NotificationListener<ScrollNotification>(
                    onNotification: (n) {
                      if (n is ScrollStartNotification) {
                        _isPageScrolling = true;
                      } else if (n is ScrollEndNotification) {
                        _isPageScrolling = false;
                      }
                      return false;
                    },
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: state.clinics.length,
                      onPageChanged: _onPageChanged,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final clinic = state.clinics[index];
                        final isSelected = index == state.selectedIndex;
                        return AnimatedScale(
                          scale: isSelected ? 1.0 : 0.95,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          child: MapClinicCard(
                            clinic: clinic,
                            onTap: () => MapClinicSummarySheet.show(context, clinic),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ),

        // ── Page indicator dots ──────────────────────────────────────
        if (state.clinics.isNotEmpty)
          Positioned(
            bottom: 8.h,
            left: 0,
            right: 0,
            child: _PageIndicator(
              count: state.clinics.length,
              currentIndex: state.selectedIndex,
            ),
          ),
      ],
    );
  }

  Widget _buildNoLocationCard(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        margin: EdgeInsets.symmetric(horizontal: 32.w),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
            ),
          ],
        ),
        child: Text(
          'map.no_results'.tr(),
          style: theme.textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// ── Glass-effect AppBar icon button ─────────────────────────────────────────

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(8.w),
        width: 38.w,
        height: 38.w,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 18.sp, color: ColorsManager.defaultText),
      ),
    );
  }
}

// ── Glass-effect title pill ──────────────────────────────────────────────────

class _GlassTitle extends StatelessWidget {
  final String title;

  const _GlassTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: ColorsManager.defaultText,
        ),
      ),
    );
  }
}

// ── Page indicator dots ──────────────────────────────────────────────────────

class _PageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;

  const _PageIndicator({required this.count, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          width: isActive ? 18.w : 6.w,
          height: 6.h,
          decoration: BoxDecoration(
            color: isActive
                ? ColorsManager.primaryColor
                : Colors.white.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(100.r),
            boxShadow: [
              if (isActive)
                BoxShadow(
                  color: ColorsManager.primaryColor.withValues(alpha: 0.4),
                  blurRadius: 4,
                ),
            ],
          ),
        );
      }),
    );
  }
}

