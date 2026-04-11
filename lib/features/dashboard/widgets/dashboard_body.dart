import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/colors.dart';
import '../../../core/utils/app_size.dart';
import 'floating_nav_bar.dart';
import 'location_banner.dart';

class DashBoardBody extends StatelessWidget {
  final int currentIndex;
  final List<Widget> screens;
  final List<String> icons;
  final bool isNavBarVisible;
  final bool Function(ScrollNotification) onScroll;
  final ValueChanged<int> onTabTap;

  // ── Banner ──────────────────────────────────────────────
  final bool showLocationBanner;
  final VoidCallback onOpenLocationSettings;
  final VoidCallback onDismissBanner;

  const DashBoardBody({
    required this.currentIndex,
    required this.screens,
    required this.icons,
    required this.isNavBarVisible,
    required this.onScroll,
    required this.onTabTap,
    required this.showLocationBanner,
    required this.onOpenLocationSettings,
    required this.onDismissBanner,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';

    const Color activeColor = ColorsManager.primaryColor;
    final Color inactiveColor = theme.colorScheme.onSurfaceVariant;
    final Color glassColor = isDark
        ? Colors.black
        : Colors.white;
    final Color borderColor = isDark
        ? Colors.white.withValues(alpha: 0.15)
        : Colors.black.withValues(alpha: 0.1);

    final displayIcons = isRTL ? icons.reversed.toList() : icons;
    final double bottomSafeArea = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBody: true,
      body: Stack(
        children: [
          // ── Screens ────────────────────────────────────
          Column(
            children: [
              // Banner slides in from top — AnimatedSize handles the height
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: showLocationBanner
                    ? LocationBanner(
                  onTap: onOpenLocationSettings,
                  onDismiss: onDismissBanner,
                )
                    : const SizedBox.shrink(),
              ),
              Expanded(
                child: NotificationListener<ScrollNotification>(
                  onNotification: onScroll,
                  child: IndexedStack(
                    index: currentIndex,
                    children: screens,
                  ),
                ),
              ),
            ],
          ),

          // ── Floating nav bar ───────────────────────────
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: isNavBarVisible
                ? (SizeApp.s16 + bottomSafeArea)
                : -(100.h + bottomSafeArea),
            left: SizeApp.s12,
            right: SizeApp.s12,
            child: FloatingNavBar(
              displayIcons: displayIcons,
              currentIndex: currentIndex,
              isRTL: isRTL,
              totalIcons: icons.length,
              activeColor: activeColor,
              inactiveColor: inactiveColor,
              glassColor: glassColor,
              borderColor: borderColor,
              onTap: onTabTap,
            ),
          ),
        ],
      ),
    );
  }
}