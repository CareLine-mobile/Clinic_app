import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/assets.dart';
import '../../core/utils/location/location_utils.dart';
import '../auth/presentation/cubit/auth_cubit.dart';
import '../auth/presentation/cubit/auth_state.dart';
import '../favourite/presentation/view/favourites_screen.dart';
import '../home/presentation/cubit/home_cubit.dart';
import '../home/presentation/view/home_screen.dart';
import '../my_booking/presentation/cubit/booking_cubit.dart';
import '../my_booking/presentation/view/booking_list_screen.dart';
import '../search/presentation/cubit/search_cubit.dart';
import '../search/presentation/view/search_screen.dart';
import '../settings/presentation/view/settings_screen.dart';
import '../user_data/user_repo.dart';
import 'widgets/dashboard_body.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen>
    with WidgetsBindingObserver {

  int _currentIndex = 0;
  bool _isNavBarVisible = true;
  double _lastScrollPosition = 0;

  // ── Location banner state ────────────────────────────────
  bool _showLocationBanner = false;
  bool _bannerDismissed = false; // user tapped ✕ → never re-show this session

  late final List<Widget> _screens;

  final List<String> _icons = [
    Assets.homeIcon,
    Assets.searchIcon,
    Assets.favouriteIcon,
    Assets.myBookingIcon,
    Assets.settingIcon,
  ];

  // ── Lifecycle ────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _screens = [
      HomeScreen(onNavigateToSearch: (i) => setState(() => _currentIndex = i)),
      BlocProvider<SearchCubit>.value(
        value: di.sl<SearchCubit>(),
        child: const SearchScreen(),
      ),
      const FavouritesScreen(),
      const BookingListScreen(),
      const SettingsTabScreen(),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) => _checkLocationService());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkLocationService();
    }
  }

  // ── Location check ───────────────────────────────────────

  Future<void> _checkLocationService() async {
    if (_bannerDismissed) return;
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!mounted) return;
    setState(() => _showLocationBanner = !enabled);

    if (enabled) {
      context.read<HomeCubit>().refresh();
    }
  }

  void _dismissBanner() {
    setState(() {
      _showLocationBanner = false;
      _bannerDismissed = true;
    });
  }

  Future<void> _openLocationSettings() async {
    showLocationPermissionSheet(context);
  }

  // ── Scroll hide/show nav bar ─────────────────────────────

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

  // ── Build ────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingCubit>(
      create: (_) {
        final cubit = di.sl<BookingCubit>();
        if (UserRepository().isLoggedIn) cubit.loadBookings();
        return cubit;
      },
      child: BlocListener<AuthCubit, AuthState>(
        listenWhen: (_, curr) => curr is AuthUnauthenticated,
        listener: (context, _) => context.read<BookingCubit>().close(),
        child: DashBoardBody(
          currentIndex: _currentIndex,
          screens: _screens,
          icons: _icons,
          isNavBarVisible: _isNavBarVisible,
          onScroll: _onScroll,
          onTabTap: (index) {
            FocusManager.instance.primaryFocus?.unfocus();
            setState(() => _currentIndex = index);
          },
          showLocationBanner: _showLocationBanner,
          onOpenLocationSettings: _openLocationSettings,
          onDismissBanner: _dismissBanner,
        ),
      ),
    );
  }

  // ── Modern Location Permission Bottom Sheet ──────────────

  void showLocationPermissionSheet(BuildContext context) {
    final isAndroid = Platform.isAndroid;
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Drag handle
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: ColorsManager.inputBorder.withOpacity(0.5),
                borderRadius: BorderRadius.circular(100.r),
              ),
            ),
            SizedBox(height: 24.h),

            // ── Header
            Row(
              children: [
                Container(
                  width: 48.r,
                  height: 48.r,
                  decoration: const BoxDecoration(
                    color: ColorsManager.warningSurface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_off_rounded,
                    color: ColorsManager.warningFill,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'location.access_needed'.tr(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: ColorsManager.defaultText,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'location.enable_manually'.tr(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: ColorsManager.defaultTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // ── Steps
            ..._buildSteps(context, isAndroid),
            SizedBox(height: 20.h),

            // ── Info note
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: ColorsManager.infoSurface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: ColorsManager.infoFill.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 20.sp,
                    color: ColorsManager.infoText,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'location.why_we_use'.tr(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: ColorsManager.infoText,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 28.h),

            // ── Primary CTA
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.settings_rounded, size: 20.sp, color: Colors.white),
                label: Text(
                  'location.open_settings'.tr(),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.primaryColor,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  await LocationUtils.openLocationSettings();
                },
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  // ── Steps Builder ──────────────

  List<Widget> _buildSteps(BuildContext context, bool isAndroid) {
    final theme = Theme.of(context);
    final prefix = isAndroid ? 'location.android' : 'location.ios';
    final count = isAndroid ? 5 : 4;

    return List.generate(count, (i) => Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24.r,
            height: 24.r,
            decoration: BoxDecoration(
              color: ColorsManager.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${i + 1}',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.primaryColor,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              '$prefix.step${i + 1}'.tr(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: ColorsManager.defaultText,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    ));
  }
}