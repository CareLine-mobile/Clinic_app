// lib/features/dashboard/widgets/dashboard_body.dart
import 'package:clinic_app/core/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/colors.dart';
import '../../../core/utils/app_size.dart';
import '../../../core/utils/assets.dart';
import 'floating_nav_bar.dart';
import 'location_banner.dart';

class DashBoardBody extends StatelessWidget {
  final int currentIndex;
  final StatefulNavigationShell navigationShell;
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
    required this.navigationShell,
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
    return ResponsiveLayout(
      mobile: _MobileDashboard(
        currentIndex: currentIndex,
        navigationShell: navigationShell,
        icons: icons,
        isNavBarVisible: isNavBarVisible,
        onScroll: onScroll,
        onTabTap: onTabTap,
        showLocationBanner: showLocationBanner,
        onOpenLocationSettings: onOpenLocationSettings,
        onDismissBanner: onDismissBanner,
      ),
      tablet: _WideDashboard(
        currentIndex: currentIndex,
        navigationShell: navigationShell,
        icons: icons,
        onScroll: onScroll,
        onTabTap: onTabTap,
        showLocationBanner: showLocationBanner,
        onOpenLocationSettings: onOpenLocationSettings,
        onDismissBanner: onDismissBanner,
        extended: false, // compact rail for tablet
      ),
      desktop: _WideDashboard(
        currentIndex: currentIndex,
        navigationShell: navigationShell,
        icons: icons,
        onScroll: onScroll,
        onTabTap: onTabTap,
        showLocationBanner: showLocationBanner,
        onOpenLocationSettings: onOpenLocationSettings,
        onDismissBanner: onDismissBanner,
        extended: true, // extended (labelled) rail for desktop
      ),
    );
  }
}

// ── Mobile layout — original floating bottom nav ────────────────────────────

class _MobileDashboard extends StatelessWidget {
  final int currentIndex;
  final StatefulNavigationShell navigationShell;
  final List<String> icons;
  final bool isNavBarVisible;
  final bool Function(ScrollNotification) onScroll;
  final ValueChanged<int> onTabTap;
  final bool showLocationBanner;
  final VoidCallback onOpenLocationSettings;
  final VoidCallback onDismissBanner;

  const _MobileDashboard({
    required this.currentIndex,
    required this.navigationShell,
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
    final Color glassColor = isDark ? Colors.black : Colors.white;
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
              // Banner slides in from top
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
                  child: navigationShell,
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

// ── Wide layout — NavigationRail + content ───────────────────────────────────

class _WideDashboard extends StatelessWidget {
  final int currentIndex;
  final StatefulNavigationShell navigationShell;
  final List<String> icons;
  final bool Function(ScrollNotification) onScroll;
  final ValueChanged<int> onTabTap;
  final bool showLocationBanner;
  final VoidCallback onOpenLocationSettings;
  final VoidCallback onDismissBanner;
  final bool extended;

  const _WideDashboard({
    required this.currentIndex,
    required this.navigationShell,
    required this.icons,
    required this.onScroll,
    required this.onTabTap,
    required this.showLocationBanner,
    required this.onOpenLocationSettings,
    required this.onDismissBanner,
    required this.extended,
  });

  // Map icon assets → NavigationRail labels / icons
  static const List<_NavItem> _navItems = [
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    _NavItem(
      icon: Icons.search_outlined,
      activeIcon: Icons.search_rounded,
      label: 'Search',
    ),
    _NavItem(
      icon: Icons.favorite_outline,
      activeIcon: Icons.favorite_rounded,
      label: 'Favourites',
    ),
    _NavItem(
      icon: Icons.calendar_today_outlined,
      activeIcon: Icons.calendar_today_rounded,
      label: 'Bookings',
    ),
    _NavItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings_rounded,
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Row(
        children: [
          // ── Navigation Rail ────────────────────────────
          SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: isDark
                    ? theme.colorScheme.surface
                    : theme.colorScheme.surfaceContainerLowest,
                border: Border(
                  right: BorderSide(
                    color: theme.dividerColor.withValues(alpha: 0.15),
                  ),
                ),
              ),
              child: NavigationRail(
                selectedIndex: currentIndex,
                onDestinationSelected: onTabTap,
                extended: extended,
                minWidth: 56,
                minExtendedWidth: 180,
                backgroundColor: Colors.transparent,
                selectedIconTheme: const IconThemeData(
                  color: ColorsManager.primaryColor,
                ),
                unselectedIconTheme: IconThemeData(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                selectedLabelTextStyle: const TextStyle(
                  color: ColorsManager.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                unselectedLabelTextStyle: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 13,
                ),
                indicatorColor: ColorsManager.primaryColor.withValues(
                  alpha: 0.12,
                ),
                destinations: _navItems
                    .map(
                      (item) => NavigationRailDestination(
                        icon: Icon(item.icon),
                        selectedIcon: Icon(item.activeIcon),
                        label: Text(item.label),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),

          // ── Content area ───────────────────────────────
          Expanded(
            child: Column(
              children: [
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
                    child: navigationShell,
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

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
