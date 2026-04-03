// lib/features/dashboard/patient_home_screen.dart

// lib/features/dashboard/patient_home_screen.dart

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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_size.dart';
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
    await LocationDataSourceUtilits.openLocationSettings();
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
}





