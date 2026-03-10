// lib/features/auth/presentation/widgets/auth_tab_selector.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:clinic_app/core/theme/colors.dart';

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
        ? ColorsManager.secondaryDarkColor  // 0xFF0A0E19
        : ColorsManager.backgroundCard;     // 0xFFECEFF1

    final indicatorColor = isDark
        ? ColorsManager.darkColor           // 0xFF050811
        : ColorsManager.inputSurface;      // 0xFFFFFFFF

    final shadowColor = isDark
        ? Colors.black.withValues(alpha:  0.4)
        : Colors.black.withValues(alpha: 0.05);

    const selectedColor = ColorsManager.primaryColor;  // same for both modes

    final unselectedColor = isDark
        ? ColorsManager.defaultTextSecondaryDark.withValues(alpha: 0.5) // 0xFFF5F5F5
        : ColorsManager.defaultTextSecondary;                      // 0xFF4B5563

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: controller,
        indicator: BoxDecoration(
          color: indicatorColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: selectedColor,
        unselectedLabelColor: unselectedColor,
        labelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        tabs: [
          Tab(text: 'auth.login'.tr()),
          Tab(text: 'auth.signup'.tr()),
        ],
      ),
    );
  }
}