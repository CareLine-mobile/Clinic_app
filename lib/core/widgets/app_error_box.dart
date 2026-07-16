import 'package:clinic_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppErrorBox extends StatelessWidget {
  final String errorMessage;
  final EdgeInsetsGeometry? margin;

  const AppErrorBox({
    Key? key,
    required this.errorMessage,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: margin ?? EdgeInsets.only(bottom: 24.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ColorsManager.errorSurface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorsManager.errorFill.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline_rounded, color: ColorsManager.errorFill, size: 20.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              errorMessage,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: ColorsManager.errorFill,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
