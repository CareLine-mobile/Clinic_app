// ─── Detail Row ──────────────────────────────────────────────────────────────

import 'package:clinic_app/core/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isHighlighted;
  final VoidCallback? onTap;

  const BookingDetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.isHighlighted = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget rowContent = Row(
      children: [
        Icon(icon, size: 16.sp, color: theme.primaryColor),
        SizedBox(width: SizeApp.s8),
        Text(
          '$label:',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.hintColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: SizeApp.s4),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isHighlighted ? theme.primaryColor : null,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
        if (onTap != null) ...[
          SizedBox(width: 4.w),
          Icon(Icons.arrow_forward_ios, size: 10.sp, color: theme.primaryColor),
        ],
      ],
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: rowContent,
      );
    }
    return rowContent;
  }
}
