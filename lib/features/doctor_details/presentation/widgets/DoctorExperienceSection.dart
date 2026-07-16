import 'package:clinic_app/core/theme/colors.dart';
import 'package:clinic_app/features/doctor_details/domain/entities/doctor_profile_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/app_text_widgets.dart';
import '../widgets/Info_tile.dart';
class DoctorExperienceSection extends StatelessWidget {
  final DoctorProfileEntity doctor;

  const DoctorExperienceSection({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'doctorProfile.professionalInfo'.tr(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 20.w,
            runSpacing: 12.h,
            children: [
              _buildSimpleInfo(
                icon: Icons.calendar_today_rounded,
                label: 'doctorProfile.experience'.tr(),
                value: 'doctorProfile.yearsValue'
                    .tr(namedArgs: {'count': '${doctor.experienceYears}'}),
                theme: theme,
              ),
              _buildSimpleInfo(
                icon: Icons.language_rounded,
                label: 'doctorProfile.languages'.tr(),
                value: doctor.languages.join(', '),
                theme: theme,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleInfo({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: ColorsManager.primaryColor.withOpacity(0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: ColorsManager.primaryColor, size: 16.sp),
        ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(color: theme.hintColor),
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}