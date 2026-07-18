// lib/features/map_locations/presentation/widgets/map_loading_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:clinic_app/core/theme/colors.dart';

/// A shimmer loading overlay shown while map/location data is fetching
class MapLoadingView extends StatelessWidget {
  final bool isTab;
  const MapLoadingView({super.key, this.isTab = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        // Greyed out map placeholder
        Container(
          color: isDark ? const Color(0xFF1A2332) : const Color(0xFFE5E3DF),
        ),

        // Floating shimmer card at the bottom
        Positioned(
          bottom: isTab ? 110.h : 20.h,
          left: 16.w,
          right: 16.w,
          child: Shimmer.fromColors(
            baseColor: isDark ? const Color(0xFF2D3748) : const Color(0xFFE2E8F0),
            highlightColor: isDark ? const Color(0xFF4A5568) : const Color(0xFFF7FAFC),
            child: Container(
              height: 135.h,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(20.r),
              ),
              padding: EdgeInsets.all(12.w),
              child: Row(
                children: [
                  // Image placeholder
                  Container(
                    width: 95.w,
                    height: 95.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Badge placeholder
                        Container(
                          width: 50.w,
                          height: 14.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        // Name placeholder
                        Container(
                          width: 140.w,
                          height: 14.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        // Location placeholder
                        Container(
                          width: 100.w,
                          height: 11.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        // Button row placeholder
                        Row(
                          children: [
                            Container(
                              width: 40.w,
                              height: 18.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 70.w,
                              height: 22.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Centered loading indicator
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60.w,
                height: 60.w,
                decoration: BoxDecoration(
                  color: ColorsManager.primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: ColorsManager.primaryColor.withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.location_searching_rounded,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Text(
                  'Fetching your location...',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: ColorsManager.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


