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
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
              'doctorProfile.professionalInfo'.tr(),
              icon: Icons.work_outline_rounded),
          SizedBox(height: 16.h),
          Row(
            children: [
              InfoTile(
                icon: Icons.calendar_today_rounded,
                label: 'doctorProfile.experience'.tr(),
                value: 'doctorProfile.yearsValue'
                    .tr(namedArgs: {'count': '${doctor.experienceYears}'}),
                color: ColorsManager.primaryColor,
              ),
              SizedBox(width: 12.w),
              InfoTile(
                icon: Icons.language_rounded,
                label: 'doctorProfile.languages'.tr(),
                value: doctor.languages.join(', '),
                color: ColorsManager.infoFill,
              ),
            ],
          ),
          if (doctor.consultationFee > 0) ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.payments_outlined,
                      color: ColorsManager.successFill, size: 20.sp),
                  SizedBox(width: 10.w),
                  Flexible(
                    child: Text(
                      'doctorProfile.consultationFee'.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${doctor.consultationFee.toInt()} '
                        '${'doctorProfile.egp'.tr()}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorsManager.successFill,
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