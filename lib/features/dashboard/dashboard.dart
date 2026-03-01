import 'dart:ui';
import 'package:clinic_app/core/utils/assets.dart';
import 'package:clinic_app/core/widgets/CustomIcon.dart';
import 'package:clinic_app/features/home/presentation/view/home_screen.dart';
import 'package:clinic_app/features/home/presentation/view/medication_tap_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_size.dart';
import '../booking/presentation/pages/booking_list/booking_list_screen.dart';
import '../settings/presentation/view/settings_screen.dart';

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
    Assets.pillsIcon,
    Assets.chatsIcon, // حجوزاتي
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
      const BookingListScreen(), // ← هنا بدل RemindersTabScreen
      const SettingsTabScreen(),
    ];
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification.metrics.axis == Axis.vertical) {
      if (notification is ScrollUpdateNotification) {
        final currentPosition = notification.metrics.pixels;

        if ((currentPosition - _lastScrollPosition).abs() > 5) {
          if (currentPosition > _lastScrollPosition && currentPosition > 100) {
            if (_isNavBarVisible) setState(() => _isNavBarVisible = false);
          } else if (currentPosition < _lastScrollPosition) {
            if (!_isNavBarVisible &&
                currentPosition < notification.metrics.maxScrollExtent - 100) {
              setState(() => _isNavBarVisible = true);
            }
          }
          _lastScrollPosition = currentPosition;
        }
      }
    }
    return true;
  }

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

    final displayIcons = isRTL ? _icons.reversed.toList() : _icons;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      extendBody: true,
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: _onScroll,
            child: IndexedStack(
              index: _currentIndex,
              children: _screens,
            ),
          ),

          // ── Floating Bottom Nav Bar ──────────────────────
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _isNavBarVisible ? SizeApp.s16 : -100.h,
            left: SizeApp.s12,
            right: SizeApp.s12,
            child: ClipRRect(
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
                      final actualIndex = isRTL
                          ? (_icons.length - 1 - displayIndex)
                          : displayIndex;
                      final isSelected = _currentIndex == actualIndex;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _currentIndex = actualIndex),
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
                                  padding: EdgeInsets.all(isSelected ? SizeApp.s8 : 0),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? activeColor.withOpacity(0.15)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(SizeApp.s12),
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
            ),
          ),
        ],
      ),
    );
  }
}