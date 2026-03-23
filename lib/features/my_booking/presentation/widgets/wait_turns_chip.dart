import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/utils/app_size.dart';

class WaitTurnsChip extends StatelessWidget {
  final int waitTurns;

  const WaitTurnsChip({super.key, required this.waitTurns});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // colour shifts: green → amber → red as queue grows
    final (bgColor, fgColor) = switch (waitTurns) {
      0     => (const Color(0xFFE8F5E9), const Color(0xFF2E7D32)),
      <= 3  => (const Color(0xFFFFF8E1), const Color(0xFFF57F17)),
      _     => (const Color(0xFFFFEBEE), const Color(0xFFC62828)),
    };

    final label = waitTurns == 0
        ? 'bookings.wait_turns.your_turn'.tr()
        : 'bookings.wait_turns.count'.tr(args: ['$waitTurns']);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeApp.s10, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: fgColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            waitTurns == 0
                ? Icons.notifications_active_rounded
                : Icons.people_alt_outlined,
            size: 14.sp,
            color: fgColor,
          ),
          SizedBox(width: 5.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: fgColor,
            ),
          ),
        ],
      ),
    );
  }
}