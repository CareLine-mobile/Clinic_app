// lib/features/dashboard/patient_home_screen.dart

// lib/features/dashboard/patient_home_screen.dart

import 'dart:io';
import 'dart:ui';

import 'package:clinic_app/core/di/injection_container.dart';
import 'package:clinic_app/core/utils/assets.dart';
import 'package:clinic_app/core/widgets/CustomIcon.dart';
import 'package:clinic_app/features/dashboard/widgets/dashboard_body.dart';
import 'package:clinic_app/features/dashboard/widgets/floating_nav_bar.dart';
import 'package:clinic_app/features/dashboard/widgets/location_banner.dart';
import 'package:clinic_app/features/favourite/presentation/view/favourites_screen.dart';
import 'package:clinic_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:clinic_app/features/home/presentation/view/home_screen.dart';
import 'package:clinic_app/features/my_booking/presentation/view/booking_list_screen.dart';
import 'package:clinic_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:clinic_app/features/search/presentation/view/search_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_size.dart';
import '../../core/utils/location/location_utils.dart';
import '../auth/presentation/cubit/auth_cubit.dart';
import '../auth/presentation/cubit/auth_state.dart';
import '../home/data/datasources/localdatasource/location_data_source_impl.dart';
import '../my_booking/presentation/cubit/booking_cubit.dart';
import '../settings/presentation/view/settings_screen.dart';
import '../user_data/user_repo.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen>
    with WidgetsBindingObserver {            // ← observe app lifecycle
  int _currentIndex = 0;
  bool _isNavBarVisible = true;
  double _lastScrollPosition = 0;

  // ── Location banner state ────────────────────────────────
  bool _showLocationBanner = false;
  bool _bannerDismissed = false;             // user tapped ✕ → never re-show this session

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
      BlocProvider<SearchCubit>(
        create: (_) => sl<SearchCubit>(),
        child: const SearchScreen(),
      ),
      const FavouritesScreen(),
      const BookingListScreen(),
      const SettingsTabScreen(),

    ];

    // Check after first frame so context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkLocationService());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Re-check when user returns from the Settings app
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
  //  await LocationDataSourceUtilits.openLocationSettings();
    showLocationPermissionSheet(context);
    // didChangeAppLifecycleState will re-check when the user comes back
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
          // ── Banner props ──────────────────────────────
          showLocationBanner: _showLocationBanner,
          onOpenLocationSettings: _openLocationSettings,
          onDismissBanner: _dismissBanner,
        ),
      ),
    );
  }

  void showLocationPermissionSheet(BuildContext context) {
    final isAndroid = Platform.isAndroid;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // drag handle
            Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),

            // header
            Row(children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.location_off, color: Colors.orange[700]),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'location.access_needed'.tr(),
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'location.enable_manually'.tr(),
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ]),
            SizedBox(height: 20),

            // steps
            ..._buildSteps(isAndroid),
            SizedBox(height: 16),

            // info note
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(children: [
                Icon(Icons.info_outline, size: 16, color: Colors.blue[700]),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'location.why_we_use'.tr(),
                    style: TextStyle(fontSize: 13, color: Colors.blue[700]),
                  ),
                ),
              ]),
            ),
            SizedBox(height: 20),

            // primary CTA
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.settings),
                label: Text('location.open_settings'.tr()),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  await LocationUtils.openLocationSettings();
                },
              ),
            ),
            SizedBox(height: 8),



          ],
        ),
      ),
    );
  }

  List<Widget> _buildSteps(bool isAndroid) {
    final prefix = isAndroid ? 'location.android' : 'location.ios';
    final count  = isAndroid ? 5 : 4;

    return List.generate(count, (i) => Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22, height: 22,
            decoration: BoxDecoration(
              color: Colors.purple[50],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${i + 1}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.purple[700],
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '$prefix.step${i + 1}'.tr(),
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
        ],
      ),
    ));
  }
}





