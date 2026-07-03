// lib/features/map_locations/presentation/widgets/map_clinic_card.dart

import 'package:clinic_app/core/theme/colors.dart';
import 'package:clinic_app/core/widgets/custom_network_image.dart';
import 'package:clinic_app/features/home/domain/entities/clinic_summary.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

/// A compact horizontal card used in the floating PageView on the map screen.
class MapClinicCard extends StatelessWidget {
  final ClinicSummary clinic;
  final VoidCallback onTap;

  const MapClinicCard({
    super.key,
    required this.clinic,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Thumbnail ────────────────────────────────────────
              Hero(
                tag: 'clinic_map_image_${clinic.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14.r),
                  child: CustomNetworkImage(
                    imageUrl: clinic.firstImageUrl,
                    width: 95.w,
                    height: 95.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              // ── Info ─────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Open/Closed badge
                    _StatusBadge(isOpen: clinic.isOpen),
                    SizedBox(height: 4.h),

                    // Clinic name
                    Text(
                      clinic.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 2.h),

                    // Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 13.sp,
                          color: theme.hintColor,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            clinic.location,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.hintColor,
                              fontSize: 11.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 6.h),

                    // Rating + Navigate button
                    Row(
                      children: [
                        // Rating
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: ColorsManager.warningFill.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 12.sp,
                                color: ColorsManager.warningFill,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                clinic.rating,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: ColorsManager.warningText,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.sp,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        // Navigate button
                        if (clinic.lat != null && clinic.lng != null)
                          _NavigateButton(
                            lat: clinic.lat!,
                            lng: clinic.lng!,
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Arrow chevron ────────────────────────────────────
              Padding(
                padding: EdgeInsets.only(left: 4.w),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: theme.hintColor,
                  size: 20.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Open / Closed badge ──────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final bool isOpen;

  const _StatusBadge({required this.isOpen});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: isOpen
            ? ColorsManager.successSurface
            : ColorsManager.errorSurface,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        isOpen ? 'clinic.status.open'.tr() : 'clinic.status.closed'.tr(),
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: isOpen
              ? ColorsManager.successText
              : ColorsManager.errorText,
        ),
      ),
    );
  }
}

// ── Navigate button ──────────────────────────────────────────────────────────

class _NavigateButton extends StatelessWidget {
  final double lat;
  final double lng;

  const _NavigateButton({required this.lat, required this.lng});

  Future<void> _openMaps() async {
    final uri = Uri.parse('https://maps.google.com/?q=$lat,$lng');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openMaps,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: ColorsManager.primaryColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'map.navigate'.tr(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 3.w),
            Icon(Icons.near_me_rounded, color: Colors.white, size: 12.sp),
          ],
        ),
      ),
    );
  }
}

