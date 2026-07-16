import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors.dart';

class SpecialtyChip extends StatelessWidget {
  final String label;
  const SpecialtyChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: ColorsManager.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10.r), // Softer pill shape
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: ColorsManager.primaryColor.withOpacity(0.9),
        ),
      ),
    );
  }
}
