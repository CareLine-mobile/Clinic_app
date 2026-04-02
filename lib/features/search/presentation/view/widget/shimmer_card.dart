import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/colors.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 100.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isDark ? ColorsManager.secondaryDarkColor : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16.r),
      ),
    );
  }
}