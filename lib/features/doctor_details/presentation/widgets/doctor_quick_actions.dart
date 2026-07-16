import 'package:clinic_app/core/theme/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'action_button.dart';
class DoctorQuickActions extends StatelessWidget {
  final VoidCallback onShare;
  final VoidCallback onSave;

  const DoctorQuickActions({
    super.key,
    required this.onShare,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          Expanded(
            child: ActionButton(
              icon: Icons.share_rounded,
              label: 'doctorProfile.share'.tr(),
              color: ColorsManager.primaryColor,
              onTap: onShare,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: ActionButton(
              icon: Icons.bookmark_border_rounded,
              label: 'doctorProfile.save'.tr(),
              color: ColorsManager.infoFill,
              onTap: onSave,
            ),
          ),
        ],
      ),
    );
  }
}