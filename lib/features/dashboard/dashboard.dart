// lib/features/dashboard/patient_home_screen.dart

import 'dart:ui';
import 'package:clinic_app/core/utils/assets.dart';
import 'package:clinic_app/core/widgets/CustomIcon.dart';
import 'package:clinic_app/features/home/presentation/view/home_screen.dart';
import 'package:clinic_app/features/home/presentation/view/medication_tap_screen.dart';
import 'package:clinic_app/features/my_booking/presentation/view/booking_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_size.dart';
import '../auth/presentation/cubit/auth_cubit.dart';
import '../auth/presentation/cubit/auth_state.dart';
import '../my_booking/presentation/cubit/booking_cubit.dart';
import '../settings/presentation/view/settings_screen.dart';
import '../user_data/user_repo.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({Key? key}) : super(key: key);

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  int _currentIndex = 0;
  bool _isNavBarVisible = true;
  double _lastScrollPosition = 0;

  late final List<Widget> _screens;

  final List<String> _icons = [
    Assets.homeIcon,
    Assets.searchIcon,
    Assets.myBookingIcon,
    Assets.settingIcon,
  ];

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(
        onNavigateToSearch: (index) {
          setState(() => _currentIndex = index);
        },
      ),
      const MedicationsTabScreen(),
      const BookingListScreen(),
      const SettingsTabScreen(),
    ];
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return true;

    if (notification is ScrollUpdateNotification) {
      final current = notification.metrics.pixels;

      if ((current - _lastScrollPosition).abs() > 5) {
        if (current > _lastScrollPosition && current > 100) {
          if (_isNavBarVisible) setState(() => _isNavBarVisible = false);
        } else if (current < _lastScrollPosition) {
          if (!_isNavBarVisible &&
              current < notification.metrics.maxScrollExtent - 100) {
            setState(() => _isNavBarVisible = true);
          }
        }
        _lastScrollPosition = current;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingCubit>(
      // يتخلق مرة واحدة فوق الـ IndexedStack
      // كل الـ tabs (HomeScreen, BookingListScreen...) تقدر توصله
      create: (_) {
        final cubit = di.sl<BookingCubit>();
        if (UserRepository().isLoggedIn) cubit.loadBookings();
        return cubit;
      },
      child: BlocListener<AuthCubit, AuthState>(
        // امسح data البوكينج فور ما logout يحصل
        listenWhen: (_, curr) => curr is AuthUnauthenticated,
        listener: (context, _) => context.read<BookingCubit>().close(),
        child: _PatientHomeBody(
          currentIndex: _currentIndex,
          screens: _screens,
          icons: _icons,
          isNavBarVisible: _isNavBarVisible,
          onScroll: _onScroll,
          onTabTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Body — مستقلة عن الـ provider logic
// ─────────────────────────────────────────────

class _PatientHomeBody extends StatelessWidget {
  final int currentIndex;
  final List<Widget> screens;
  final List<String> icons;
  final bool isNavBarVisible;
  final bool Function(ScrollNotification) onScroll;
  final ValueChanged<int> onTabTap;

  const _PatientHomeBody({
    required this.currentIndex,
    required this.screens,
    required this.icons,
    required this.isNavBarVisible,
    required this.onScroll,
    required this.onTabTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isRTL = Localizations.localeOf(context).languageCode == 'ar';

    const Color activeColor = ColorsManager.primaryColor;
    final Color inactiveColor = theme.colorScheme.onSurfaceVariant;
    final Color glassColor = isDark
        ? Colors.black.withOpacity(0.3)
        : Colors.white.withOpacity(0.3);
    final Color borderColor = isDark
        ? Colors.white.withOpacity(0.15)
        : Colors.black.withOpacity(0.1);

    final displayIcons = isRTL ? icons.reversed.toList() : icons;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBody: true,
      body: Stack(
        children: [
          // ── Screens ───────────────────────────────────────
          NotificationListener<ScrollNotification>(
            onNotification: onScroll,
            child: IndexedStack(
              index: currentIndex,
              children: screens,
            ),
          ),

          // ── Floating nav bar ──────────────────────────────
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: isNavBarVisible ? SizeApp.s16 : -100.h,
            left: SizeApp.s12,
            right: SizeApp.s12,
            child: _FloatingNavBar(
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

// ─────────────────────────────────────────────
// Floating nav bar
// ─────────────────────────────────────────────

class _FloatingNavBar extends StatelessWidget {
  final List<String> displayIcons;
  final int currentIndex;
  final bool isRTL;
  final int totalIcons;
  final Color activeColor;
  final Color inactiveColor;
  final Color glassColor;
  final Color borderColor;
  final ValueChanged<int> onTap;

  const _FloatingNavBar({
    required this.displayIcons,
    required this.currentIndex,
    required this.isRTL,
    required this.totalIcons,
    required this.activeColor,
    required this.inactiveColor,
    required this.glassColor,
    required this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(SizeApp.s30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: SizeApp.s70,
          padding: EdgeInsets.symmetric(horizontal: SizeApp.s4),
          decoration: BoxDecoration(
            color: glassColor,
            borderRadius: BorderRadius.circular(SizeApp.s30),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(displayIcons.length, (displayIndex) {
              final actualIndex =
              isRTL ? (totalIcons - 1 - displayIndex) : displayIndex;
              final isSelected = currentIndex == actualIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(actualIndex),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: SizeApp.s8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          padding:
                          EdgeInsets.all(isSelected ? SizeApp.s8 : 0),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? activeColor.withOpacity(0.15)
                                : Colors.transparent,
                            borderRadius:
                            BorderRadius.circular(SizeApp.s12),
                          ),
                          child: CustomIcon(
                            assetPath: displayIcons[displayIndex],
                            size: SizeApp.s24 + SizeApp.s2,
                            color: isSelected ? activeColor : inactiveColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}