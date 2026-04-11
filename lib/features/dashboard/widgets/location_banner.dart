import 'package:clinic_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
// TODO: تأكد من مسار ColorsManager الصحيح
// import '../../core/theme/colors.dart';

class LocationBanner extends StatelessWidget {
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const LocationBanner({
    super.key,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topPadding = MediaQuery.of(context).padding.top;

    return Padding(
      padding: EdgeInsets.only(
        top: topPadding + 12.h,
        left: 16.w,
        right: 16.w,
        bottom: 8.h,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: ColorsManager.warningSurface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: ColorsManager.warningFill.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorsManager.warningFill.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16.r),
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: ColorsManager.warningFill.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.location_off_rounded,
                      color: ColorsManager.warningFill,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          // ✅ تم إزالة الـ fallback
                          'location.disabled_title'.tr(),
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: ColorsManager.warningText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          // ✅ تم إزالة الـ fallback
                          'location.enable_prompt'.tr(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: ColorsManager.warningText.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    height: 28.h,
                    width: 1,
                    color: ColorsManager.warningFill.withOpacity(0.2),
                    margin: EdgeInsets.symmetric(horizontal: 12.w),
                  ),

                  InkWell(
                    onTap: onDismiss,
                    borderRadius: BorderRadius.circular(20.r),
                    child: Padding(
                      padding: EdgeInsets.all(4.r),
                      child: Icon(
                        Icons.close_rounded,
                        color: ColorsManager.warningText.withOpacity(0.6),
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}