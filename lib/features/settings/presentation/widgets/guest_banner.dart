import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_size.dart';

class GuestBanner extends StatelessWidget {
  const GuestBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final v = AppSizeVertical.instance;
    final h = AppSizeHorizontal.instance;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.fromLTRB(h.s16, v.s60, h.s16, v.s8),
      padding: EdgeInsets.all(h.s20),
      decoration: BoxDecoration(
        // ─── No heavy shadow, just a subtle border ──────────────
        color: isDark ? ColorsManager.secondaryDarkColor : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.07)
              : ColorsManager.primaryColor.withOpacity(0.12),
        ),
      ),
      child: Row(
        children: [
          // ─── Avatar placeholder ───────────────────────────────
          Container(
            width: h.s50,
            height: h.s50,
            decoration: BoxDecoration(
              color: ColorsManager.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_outline_rounded,
              color: ColorsManager.primaryColor,
              size: h.s24,
            ),
          ),
          SizedBox(width: h.s14),

          // ─── Text ─────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'settings.guest.title'.tr(),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: v.s4),
                Text(
                  'settings.guest.subtitle'.tr(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}