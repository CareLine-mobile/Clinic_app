// lib/features/auth/presentation/widgets/auth_tab_selector.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:clinic_app/core/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// lib/features/auth/presentation/widgets/auth_tab_selector.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:clinic_app/core/theme/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthTabSelector extends StatelessWidget {
  final TabController controller;

  const AuthTabSelector({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark
        ? ColorsManager.secondaryDarkColor
        : ColorsManager.backgroundCard;

    final indicatorColor = isDark
        ? ColorsManager.darkColor
        : ColorsManager.inputSurface;

    final shadowColor = isDark
        ? Colors.black.withValues(alpha: 0.4)
        : Colors.black.withValues(alpha: 0.05);

    const selectedColor = ColorsManager.primaryColor;

    final unselectedColor = isDark
        ? ColorsManager.defaultTextSecondaryDark.withValues(alpha: 0.5)
        : ColorsManager.defaultTextSecondary;

    // Base style shared by both states — FittedBox does the size adaptation,
    // so we set a comfortable MAX size and let it shrink when needed.
    final baseStyle = TextStyle(
      fontFamily: 'Poppins',
      fontSize: 15.sp,   // maximum size — FittedBox shrinks below this if needed
    );

    return Container(
      height: 46.h,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: indicatorColor,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        // Colors are still driven by labelColor / unselectedLabelColor
        labelColor: selectedColor,
        unselectedLabelColor: unselectedColor,

        // Keep both styles the same size — weight is the only difference.
        // FittedBox handles actual sizing, not these values.
        labelStyle: baseStyle.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: baseStyle.copyWith(fontWeight: FontWeight.w400),

        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),

        // ── Custom tabs with FittedBox ─────────────────────────────────────
        // FittedBox(fit: BoxFit.scaleDown) keeps the text at its natural size
        // when there is enough room, and shrinks it proportionally when there
        // isn't — no overflow, no clipping, works in any language/screen size.
        tabs: [
          _FitTab(label: 'auth.login'.tr()),
          _FitTab(label: 'auth.signup'.tr()),
        ],
      ),
    );
  }
}

/// A [Tab] whose label shrinks to fit instead of overflowing or clipping.
class _FitTab extends StatelessWidget {
  final String label;
  const _FitTab({required this.label});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: FittedBox(
        fit: BoxFit.scaleDown,   // shrinks only when necessary, never upscales
        child: Text(
          label,
          maxLines: 1,
          softWrap: false,
        ),
      ),
    );
  }
}