// lib/features/map_locations/presentation/widgets/map_error_view.dart

import 'package:clinic_app/core/theme/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shown when location permission is denied
class MapPermissionDeniedView extends StatelessWidget {
  final bool isPermanent;
  final VoidCallback onRetry;
  final VoidCallback onOpenSettings;

  const MapPermissionDeniedView({
    super.key,
    required this.isPermanent,
    required this.onRetry,
    required this.onOpenSettings,
  });

  @override
  Widget build(BuildContext context) {
    return _MapErrorScaffold(
      icon: Icons.location_off_rounded,
      iconColor: ColorsManager.warningFill,
      iconBgColor: ColorsManager.warningSurface,
      title: 'map.permission_denied.title'.tr(),
      subtitle: isPermanent
          ? 'map.permission_denied.permanent_subtitle'.tr()
          : 'map.permission_denied.subtitle'.tr(),
      primaryLabel: isPermanent
          ? 'map.permission_denied.open_settings'.tr()
          : 'map.permission_denied.allow'.tr(),
      onPrimary: isPermanent ? onOpenSettings : onRetry,
      secondaryLabel: isPermanent ? 'map.permission_denied.allow'.tr() : null,
      onSecondary: isPermanent ? onRetry : null,
    );
  }
}

/// Shown when GPS/location service is off
class MapServiceDisabledView extends StatelessWidget {
  final VoidCallback onOpenSettings;
  final VoidCallback onRetry;

  const MapServiceDisabledView({
    super.key,
    required this.onOpenSettings,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return _MapErrorScaffold(
      icon: Icons.gps_off_rounded,
      iconColor: ColorsManager.errorFill,
      iconBgColor: ColorsManager.errorSurface,
      title: 'map.service_disabled.title'.tr(),
      subtitle: 'map.service_disabled.subtitle'.tr(),
      primaryLabel: 'map.service_disabled.enable'.tr(),
      onPrimary: onOpenSettings,
      secondaryLabel: 'map.retry'.tr(),
      onSecondary: onRetry,
    );
  }
}

/// Generic error view
class MapGenericErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const MapGenericErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return _MapErrorScaffold(
      icon: Icons.wifi_off_rounded,
      iconColor: ColorsManager.primaryColor,
      iconBgColor: ColorsManager.primaryColor.withValues(alpha: 0.1),
      title: 'map.error.title'.tr(),
      subtitle: message,
      primaryLabel: 'map.retry'.tr(),
      onPrimary: onRetry,
    );
  }
}

// ── Shared error scaffold ────────────────────────────────────────────────────

class _MapErrorScaffold extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  const _MapErrorScaffold({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon container
            Container(
              width: 88.w,
              height: 88.w,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 40.sp),
            ),
            SizedBox(height: 24.h),

            // Title
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),

            // Subtitle
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),

            // Primary button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPrimary,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.primaryColor,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  primaryLabel,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Optional secondary button
            if (secondaryLabel != null && onSecondary != null) ...[
              SizedBox(height: 12.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onSecondary,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    side: const BorderSide(color: ColorsManager.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    secondaryLabel!,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: ColorsManager.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}



