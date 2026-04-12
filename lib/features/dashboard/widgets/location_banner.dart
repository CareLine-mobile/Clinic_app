import 'package:clinic_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

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

    return Material(
      color: ColorsManager.warningFill,
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.white.withOpacity(0.15),
        highlightColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(
            top: topPadding + 6.h,
            bottom: 6.h,
            left: 12.w,
            right: 12.w,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.location_off_rounded,
                  color: Colors.white,
                  size: 14.sp,
                ),
              ),
              SizedBox(width: 8.w),

              // ✨ Enhancement 2: Added text overflow protection
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'location.disabled_title'.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      'location.enable_prompt'.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 10.sp,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 18.h,
                width: 1,
                color: Colors.white.withOpacity(0.3),
                margin: EdgeInsets.symmetric(horizontal: 8.w),
              ),

              IconButton(
                onPressed: onDismiss,
                icon: Icon(
                  Icons.close_rounded,
                  color: Colors.white.withOpacity(0.8),
                  size: 16.sp,
                ),
                padding: EdgeInsets.all(8.r),
                constraints: const BoxConstraints(),
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}