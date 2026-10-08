import 'dart:async';

import 'package:clinic_app/core/api/model/endpoints.dart';
import 'package:clinic_app/core/db/shared_pref_helper.dart';
import 'package:clinic_app/core/utils/app_constans.dart';
import 'package:clinic_app/core/di/injection_container.dart' as di;
import 'package:clinic_app/core/routes/routes.dart';
import 'package:clinic_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_app/features/auth/presentation/view/auth_screen.dart';
import 'package:clinic_app/features/auth/presentation/view/forgot_password_screen.dart';
import 'package:clinic_app/features/auth/presentation/view/otp_verification_page.dart';
import 'package:clinic_app/features/auth/presentation/view/reset_password_screen.dart';
import 'package:clinic_app/features/clinic_details/presentation/cubit/clinic_details_cubit.dart';
import 'package:clinic_app/features/clinic_details/presentation/view/booking/booking_screen.dart';
import 'package:clinic_app/features/clinic_details/presentation/view/clinic_details_screen.dart';
import 'package:clinic_app/features/configuration/presentation/screens/configuration_screen.dart';
import 'package:clinic_app/features/dashboard/dashboard.dart';
import 'package:clinic_app/features/doctor_details/presentation/cubit/doctor_profile_cubit.dart';
import 'package:clinic_app/features/doctor_details/presentation/view/doctor_profile_screen.dart';
import 'package:clinic_app/features/favourite/presentation/view/favourites_screen.dart';
import 'package:clinic_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:clinic_app/features/home/presentation/view/home_screen.dart';
import 'package:clinic_app/features/map_locations/presentation/cubit/map_locations_cubit.dart';
import 'package:clinic_app/features/map_locations/presentation/view/map_locations_screen.dart';
import 'package:clinic_app/features/my_booking/domain/entities/booking_entity.dart';
import 'package:clinic_app/features/my_booking/presentation/view/booking_detail_screen.dart';
import 'package:clinic_app/features/my_booking/presentation/view/booking_list_screen.dart';
import 'package:clinic_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:clinic_app/features/profile/presentation/view/profile_screen.dart';
import 'package:clinic_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:clinic_app/features/search/presentation/view/search_screen.dart';
import 'package:clinic_app/features/settings/presentation/view/privacy_view.dart';
import 'package:clinic_app/features/settings/presentation/view/settings_screen.dart';
import 'package:clinic_app/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:clinic_app/features/user_data/user_repo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final clinicFlowNavigatorKey = GlobalKey<NavigatorState>();

class _UserRefreshListenable extends ChangeNotifier {
  _UserRefreshListenable() {
    _wasLoggedIn = UserRepository().isLoggedIn;
    _subscription = UserRepository().userStream.listen((user) {
      if (_wasLoggedIn && user == null) _logoutRedirectPending = true;
      _wasLoggedIn = user != null;
      notifyListeners();
    });
  }

  late final StreamSubscription<dynamic> _subscription;
  late bool _wasLoggedIn;
  bool _logoutRedirectPending = false;

  bool consumeLogoutRedirect() {
    final pending = _logoutRedirectPending;
    _logoutRedirectPending = false;
    return pending;
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final _userRefreshListenable = _UserRefreshListenable();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  refreshListenable: _userRefreshListenable,
  initialLocation: Uri.base.path == '/'
      ? Routes.home
      : '${Uri.base.path}${Uri.base.hasQuery ? '?${Uri.base.query}' : ''}',
  redirect: (context, state) async {
    final location = state.uri.path;
    final configDone =
        await SharedPrefHelper.getBool(key: AppConstants.configurationKey) ??
        false;
    if (!configDone && location != Routes.configuration) {
      return Routes.configuration;
    }
    final onboardingDone =
        await SharedPrefHelper.getBool(key: AppConstants.onboardingKey) ??
        false;
    if (!onboardingDone &&
        location != Routes.configuration &&
        location != Routes.onboarding) {
      return Routes.onboarding;
    }
    if (location == Routes.dashBoard) return Routes.home;
    if (_userRefreshListenable.consumeLogoutRedirect() &&
        location != Routes.auth) {
      return Routes.auth;
    }

    final loggedIn = UserRepository().isLoggedIn;
    final from = state.uri.queryParameters['from'];
    if (location == Routes.auth && loggedIn) return from ?? Routes.home;
    final needsAuth =
        location == Routes.profile ||
        RegExp(r'^/bookings/[^/]+$').hasMatch(location);
    if (needsAuth && !loggedIn) {
      return Uri(
        path: Routes.auth,
        queryParameters: {'from': state.uri.toString()},
      ).toString();
    }
    if (location == '/') return loggedIn ? Routes.home : Routes.auth;
    return null;
  },
  routes: [
    GoRoute(
      path: Routes.configuration,
      pageBuilder: (context, state) =>
          _page(state, 'route_titles.app'.tr(), const ConfigurationScreen()),
    ),
    GoRoute(
      path: Routes.onboarding,
      pageBuilder: (context, state) =>
          _page(state, 'route_titles.app'.tr(), const OnboardingScreen()),
    ),
    GoRoute(path: Routes.dashBoard, redirect: (_, __) => Routes.home),
    GoRoute(path: '/', redirect: (_, __) => Routes.home),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(create: (_) => di.sl<AuthCubit>()),
          BlocProvider<HomeCubit>(
            create: (_) => di.sl<HomeCubit>()..initHome(),
          ),
        ],
        child: DashBoardScreen(navigationShell: navigationShell),
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.home,
              pageBuilder: (context, state) => _page(
                state,
                'route_titles.home'.tr(),
                HomeScreen(
                  onNavigateToSearch: (_) => context.go(Routes.search),
                ),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.search,
              pageBuilder: (context, state) => _page(
                state,
                'route_titles.search'.tr(),
                BlocProvider<SearchCubit>.value(
                  value: di.sl<SearchCubit>(),
                  child: const SearchScreen(),
                ),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.favourites,
              pageBuilder: (context, state) => _page(
                state,
                'route_titles.favorites'.tr(),
                const FavouritesScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.bookings,
              pageBuilder: (context, state) => _page(
                state,
                'route_titles.bookings'.tr(),
                const BookingListScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.settings,
              pageBuilder: (context, state) => _page(
                state,
                'route_titles.settings'.tr(),
                const SettingsTabScreen(),
              ),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: Routes.auth,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) {
        final message =
            state.uri.queryParameters['message'] ??
            (SharedPrefHelper.lastSecureStorageFailure != null
                ? 'auth.storageReadUnavailable'
                : null);
        return _page(
          state,
          'route_titles.auth'.tr(),
          BlocProvider<AuthCubit>(
            create: (_) => di.sl<AuthCubit>(),
            child: AuthScreen(initialMessage: message),
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.verification,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) {
        final email = state.uri.queryParameters['email'];
        if (email == null || email.trim().isEmpty) {
          return _page(
            state,
            'route_titles.auth'.tr(),
            BlocProvider<AuthCubit>(
              create: (_) => di.sl<AuthCubit>(),
              child: const AuthScreen(initialMessage: 'auth.routeDataMissing'),
            ),
          );
        }
        return _page(
          state,
          'route_titles.verification'.tr(),
          BlocProvider<AuthCubit>(
            create: (_) => di.sl<AuthCubit>(),
            child: OtpVerificationPage(email: email),
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.forgotPassword,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => _page(
        state,
        'route_titles.forgot_password'.tr(),
        BlocProvider<AuthCubit>(
          create: (_) => di.sl<AuthCubit>(),
          child: ForgotPasswordScreen(
            initialEmail: state.uri.queryParameters['email'],
          ),
        ),
      ),
    ),
    GoRoute(
      path: Routes.resetPassword,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) {
        final email = state.uri.queryParameters['email'];
        if (email == null || email.trim().isEmpty) {
          return _page(
            state,
            'route_titles.auth'.tr(),
            BlocProvider<AuthCubit>(
              create: (_) => di.sl<AuthCubit>(),
              child: const AuthScreen(initialMessage: 'auth.routeDataMissing'),
            ),
          );
        }
        return _page(
          state,
          'route_titles.reset_password'.tr(),
          BlocProvider<AuthCubit>(
            create: (_) => di.sl<AuthCubit>(),
            child: ResetPasswordScreen(email: email),
          ),
        );
      },
    ),
    ShellRoute(
      navigatorKey: clinicFlowNavigatorKey,
      builder: (context, state, child) {
        final clinicId = int.tryParse(state.pathParameters['clinicId'] ?? '');
        if (clinicId == null) return const _RouteNotFound();
        return BlocProvider<ClinicDetailsCubit>(
          create: (_) => di.sl<ClinicDetailsCubit>(),
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/clinic/:clinicId',
          builder: (context, state) {
            final id = int.tryParse(state.pathParameters['clinicId'] ?? '');
            if (id == null) return const _RouteNotFound();
            return Title(
              title: 'route_titles.clinic'.tr(),
              color: Theme.of(context).primaryColor,
              child: ClinicDetailsScreen(clinicId: id),
            );
          },
          routes: [
            GoRoute(
              path: 'booking',
              builder: (context, state) => const _ClinicBookingRoute(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/doctor/:doctorId',
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) {
        final id = int.tryParse(state.pathParameters['doctorId'] ?? '');
        if (id == null)
          return _page(
            state,
            'route_titles.not_found'.tr(),
            const _RouteNotFound(),
          );
        return _page(
          state,
          'route_titles.doctor'.tr(),
          BlocProvider<DoctorProfileCubit>(
            create: (_) => di.sl<DoctorProfileCubit>(),
            child: DoctorProfileScreen(doctorId: id),
          ),
        );
      },
    ),
    GoRoute(
      path: '/bookings/:bookingId',
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) {
        final id = int.tryParse(state.pathParameters['bookingId'] ?? '');
        if (id == null)
          return _page(
            state,
            'route_titles.not_found'.tr(),
            const _RouteNotFound(),
          );
        final extra = state.extra;
        return _page(
          state,
          'bookings.detail.title'.tr(),
          BookingDetailScreen(
            bookingId: id,
            booking: extra is BookingEntity ? extra : null,
          ),
        );
      },
    ),
    GoRoute(
      path: Routes.profile,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => _page(
        state,
        'route_titles.profile'.tr(),
        BlocProvider<ProfileCubit>(
          create: (_) => di.sl<ProfileCubit>(),
          child: const ProfileScreen(),
        ),
      ),
    ),
    GoRoute(
      path: Routes.mapLocations,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => _page(
        state,
        'route_titles.map'.tr(),
        BlocProvider<MapLocationsCubit>(
          create: (_) => di.sl<MapLocationsCubit>(),
          child: const MapLocationsScreen(),
        ),
      ),
    ),
    GoRoute(
      path: Routes.privacyPolicy,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (context, state) => _page(
        state,
        'settings.legal.privacy'.tr(),
        PolicyScreen(
          url: Endpoints.policyLink,
          title: 'settings.legal.privacy'.tr(),
        ),
      ),
    ),
  ],
  errorBuilder: (_, __) => const _RouteNotFound(),
);

CustomTransitionPage<void> _page(
  GoRouterState state,
  String title,
  Widget child,
) => CustomTransitionPage<void>(
  key: state.pageKey,
  child: Title(title: title, color: const Color(0xFF008C9E), child: child),
  transitionsBuilder: (context, animation, secondaryAnimation, child) =>
      FadeTransition(opacity: animation, child: child),
);

class _ClinicBookingRoute extends StatelessWidget {
  const _ClinicBookingRoute();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClinicDetailsCubit, ClinicDetailsState>(
      builder: (context, state) {
        if (state is! ClinicDetailsLoaded || state.selectedDoctor == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final clinic = state.clinic;
        final doctor = state.selectedDoctor!;
        return Title(
          title: 'route_titles.booking'.tr(),
          color: Theme.of(context).primaryColor,
          child: BookingScreen(
            clinicalId: int.tryParse(clinic.id) ?? 0,
            doctorId: doctor.id,
            clinicName: clinic.name,
            doctorName: doctor.name,
            availableSlots: doctor.availableSlots,
          ),
        );
      },
    );
  }
}

class _RouteNotFound extends StatelessWidget {
  const _RouteNotFound();

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('route_titles.not_found'.tr())));
}
