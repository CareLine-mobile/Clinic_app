import 'package:clinic_app/core/theme/colors.dart';
import 'package:clinic_app/features/doctor_details/domain/entities/doctor_profile_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/app_text_widgets.dart';
// ── Bio / About ──────────────────────────────────────────────────────────
class DoctorBioSection extends StatelessWidget {
  final DoctorProfileEntity doctor;

  const DoctorBioSection({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (doctor.bio.isEmpty && doctor.qualifications.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'doctorProfile.about'.tr(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          if (doctor.bio.isNotEmpty)
            Text(
              doctor.bio,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.8,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                letterSpacing: 0.3,
              ),
            ),
          if (doctor.qualifications.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.school_outlined,
                    color: ColorsManager.primaryColor.withOpacity(0.7), size: 18.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    doctor.qualifications,
                    style: theme.textTheme.bodySmall?.copyWith(
                      height: 1.6,
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}