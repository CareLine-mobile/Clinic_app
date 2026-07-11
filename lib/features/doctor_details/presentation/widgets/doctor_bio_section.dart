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
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
          'doctorProfile.about'.tr(),
              icon: Icons.person_outline_rounded

          ),
          SizedBox(height: 12.h),
          if (doctor.bio.isNotEmpty)
            Text(
              doctor.bio,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(height: 1.65, color: theme.hintColor),
            ),
          if (doctor.qualifications.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: ColorsManager.primaryColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                    color: ColorsManager.primaryColor.withOpacity(0.12)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.school_outlined,
                      color: ColorsManager.primaryColor, size: 18.sp),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      doctor.qualifications,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(height: 1.6, color: theme.hintColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}