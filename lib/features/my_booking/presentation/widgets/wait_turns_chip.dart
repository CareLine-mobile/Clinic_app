import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WaitTurnsChip extends StatelessWidget {
  final int waitTurns; // قدامك كام واحد
  final int turnNumber; // رقم دورك الأصلي

  const WaitTurnsChip({
    super.key,
    required this.waitTurns,
    required this.turnNumber,
  });

  @override
  Widget build(BuildContext context) {
    final (bgColor, fgColor) = switch (waitTurns) {
      0     => (const Color(0xFFE8F5E9), const Color(0xFF2E7D32)), // دورك جه
      <= 3  => (const Color(0xFFFFF8E1), const Color(0xFFF57F17)), // قربت
      _     => (const Color(0xFFE3F2FD), const Color(0xFF1565C0)), // لسه بدري (أزرق هادي)
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${'bookings.turn_number'.tr()}: $turnNumber',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(height: 4.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: fgColor.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                waitTurns == 0 ? Icons.check_circle_outline : Icons.timer_outlined,
                size: 12.sp,
                color: fgColor,
              ),
              SizedBox(width: 4.w),
              Text(
                waitTurns == 0
                    ? 'bookings.wait_turns.your_turn'.tr()
                    : 'home.last_booking.people_ahead'.tr(namedArgs: {'count': waitTurns.toString()}),
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: fgColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}