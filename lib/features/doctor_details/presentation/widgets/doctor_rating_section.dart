import 'package:clinic_app/core/theme/colors.dart';
import 'package:clinic_app/features/doctor_details/domain/entities/doctor_profile_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorRatingSection extends StatelessWidget {
  final DoctorProfileEntity doctor;

  const DoctorRatingSection({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
      child: Row(
        children: [
          // ── Big star rating ──────────────────────────────────
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ColorsManager.warningFill.withOpacity(0.15),
                  ColorsManager.warningFill.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(
                  color: ColorsManager.warningFill.withOpacity(0.25)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_rounded,
                    color: ColorsManager.warningFill, size: 22.sp),
                SizedBox(width: 6.w),
                Text(
                  doctor.rating > 0
                      ? doctor.rating.toStringAsFixed(1)
                      : 'N/A',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.warningText,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          // Reviews summary — Expanded so long/translated text never
          // pushes the experience badge off screen.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  doctor.reviewsCount > 0
                      ? 'doctorProfile.reviewsCount'
                      .tr(namedArgs: {'count': '${doctor.reviewsCount}'})
                      : 'doctorProfile.noReviewsShort'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                Text(
                  'doctorProfile.aggregatedRating'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.hintColor),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          // Experience badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: ColorsManager.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${doctor.experienceYears}',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.primaryColor,
                  ),
                ),
                Text(
                  'doctorProfile.yearsExp'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 10.sp, color: ColorsManager.primaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}