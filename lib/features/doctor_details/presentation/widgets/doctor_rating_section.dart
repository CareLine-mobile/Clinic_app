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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatColumn(
            context: context,
            icon: Icons.star_rounded,
            iconColor: ColorsManager.warningFill,
            value: doctor.rating > 0 ? doctor.rating.toStringAsFixed(1) : 'N/A',
            label: doctor.reviewsCount > 0
                ? 'doctorProfile.reviewsCount'
                    .tr(namedArgs: {'count': '${doctor.reviewsCount}'})
                : 'doctorProfile.noReviewsShort'.tr(),
          ),
          Container(
            height: 40.h,
            width: 1,
            color: theme.dividerColor.withOpacity(0.2),
          ),
          _buildStatColumn(
            context: context,
            icon: Icons.work_outline_rounded,
            iconColor: ColorsManager.primaryColor,
            value: '${doctor.experienceYears}',
            label: 'doctorProfile.yearsExp'.tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 20.sp),
            SizedBox(width: 6.w),
            Text(
              value,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.hintColor,
          ),
        ),
      ],
    );
  }
}