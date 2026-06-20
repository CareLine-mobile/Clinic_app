// lib/features/my_booking/presentation/widgets/follow_up_widgets.dart

import 'package:clinic_app/core/routes/routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/utils/app_size.dart';
import '../../domain/entities/booking_entity.dart';
import 'booking_status_config.dart';

// ══════════════════════════════════════════════════════════════════════════════
// Banner — shown when this booking IS a follow-up
// ══════════════════════════════════════════════════════════════════════════════

class _FollowUpBanner extends StatelessWidget {
  const _FollowUpBanner();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: SizeApp.s16,
        vertical: SizeApp.s12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFF1565C0).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.repeat_rounded,
            color: const Color(0xFF1565C0),
            size: 20.sp,
          ),
          SizedBox(width: SizeApp.s8),
          Expanded(
            child: Text(
              'bookings.detail.is_followup_hint'.tr(),
              style: TextStyle(
                color: const Color(0xFF1565C0),
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Follow-up Section — timeline of all follow-ups
// ══════════════════════════════════════════════════════════════════════════════

class _FollowUpSection extends StatelessWidget {
  final List<BookingEntity> followUps;
  const _FollowUpSection({required this.followUps});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(SizeApp.s16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header ─────────────────────────────────────────────
          Row(
            children: [
              Icon(
                Icons.account_tree_outlined,
                color: theme.primaryColor,
                size: 18.sp,
              ),
              SizedBox(width: SizeApp.s8),
              Text(
                'bookings.detail.followups_title'.tr(),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 3.h,
                ),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  '${followUps.length}',
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          Divider(height: SizeApp.s20),

          // ─── Timeline ────────────────────────────────────────────
          ...List.generate(followUps.length, (index) {
            final isLast = index == followUps.length - 1;
            return _TimelineItem(
              followUp: followUps[index],
              isLast: isLast,
              index: index,
            );
          }),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Timeline Item — one follow-up row
// ══════════════════════════════════════════════════════════════════════════════

class _TimelineItem extends StatelessWidget {
  final BookingEntity followUp;
  final bool isLast;
  final int index;

  const _TimelineItem({
    required this.followUp,
    required this.isLast,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config = BookingStatusConfig.from(followUp.status);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Timeline connector column ─────────────────────────
          SizedBox(
            width: 32.w,
            child: Column(
              children: [
                // Dot
                Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    color: config.bgColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: config.color.withOpacity(0.4),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.repeat_rounded,
                    size: 14.sp,
                    color: config.color,
                  ),
                ),
                // Dashed line (if not last)
                if (!isLast)
                  Expanded(
                    child: _DashedLine(color: theme.dividerColor),
                  ),
              ],
            ),
          ),

          SizedBox(width: SizeApp.s12),

          // ─── Content ────────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : SizeApp.s16),
              child: Container(
                padding: EdgeInsets.all(SizeApp.s12),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: theme.dividerColor.withOpacity(0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date + status badge row
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 13.sp,
                          color: theme.hintColor,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          _formatDate(context, followUp.date),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        _StatusChip(config: config),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    // Time
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 13.sp,
                          color: theme.hintColor,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          followUp.time,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                        if (followUp.turnNumber != null) ...[
                          SizedBox(width: 12.w),
                          Icon(
                            Icons.format_list_numbered_rounded,
                            size: 13.sp,
                            color: theme.primaryColor,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${'bookings.turn_number'.tr()}: ${followUp.turnNumber}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(BuildContext context, String date) {
    try {
      return DateFormat('d MMM yyyy', context.locale.languageCode).format(DateTime.parse(date));
    } catch (_) {
      return date;
    }
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Status chip — small colored label
// ══════════════════════════════════════════════════════════════════════════════

class _StatusChip extends StatelessWidget {
  final BookingStatusConfig config;
  const _StatusChip({required this.config});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: config.bgColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: config.color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: 10.sp, color: config.color),
          SizedBox(width: 4.w),
          Text(
            config.label,
            style: TextStyle(
              color: config.color,
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Dashed vertical line connector
// ══════════════════════════════════════════════════════════════════════════════

class _DashedLine extends StatelessWidget {
  final Color color;
  const _DashedLine({required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashHeight = 4.0;
        const dashSpace = 4.0;
        final totalHeight = constraints.maxHeight;
        final dashCount = (totalHeight / (dashHeight + dashSpace)).floor();

        return Column(
          children: List.generate(dashCount, (_) => Column(
            children: [
              Container(
                width: 1.5,
                height: dashHeight,
                color: color.withOpacity(0.5),
              ),
              SizedBox(height: dashSpace),
            ],
          )),
        );
      },
    );
  }
}