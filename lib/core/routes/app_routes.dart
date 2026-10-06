import 'package:clinic_app/core/api/model/endpoints.dart';
import 'package:clinic_app/core/di/injection_container.dart';
import 'package:clinic_app/core/routes/routes.dart';
import 'package:clinic_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_app/features/user_data/user_repo.dart';
import 'package:clinic_app/core/db/shared_pref_helper.dart';
import 'package:clinic_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:clinic_app/features/map_locations/presentation/cubit/map_locations_cubit.dart';
import 'package:clinic_app/features/map_locations/presentation/view/map_locations_screen.dart';
import 'package:clinic_app/features/my_booking/domain/entities/booking_entity.dart';
import 'package:clinic_app/features/my_booking/presentation/cubit/booking_cubit.dart';
import 'package:clinic_app/features/my_booking/presentation/view/booking_detail_screen.dart';
import 'package:clinic_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:clinic_app/features/search/presentation/view/search_screen.dart';
import 'package:clinic_app/features/settings/presentation/view/privacy_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/view/auth_screen.dart';
import '../../features/auth/presentation/view/forgot_password_screen.dart';
import '../../features/auth/presentation/view/otp_verification_page.dart';
import '../../features/auth/presentation/view/reset_password_screen.dart';
import '../../features/clinic_details/presentation/cubit/clinic_details_cubit.dart';
import '../../features/configuration/presentation/screens/configuration_screen.dart';
import '../../features/dashboard/dashboard.dart';
import '../../features/clinic_details/presentation/view/clinic_details_screen.dart';
import '../../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/profile/presentation/view/profile_screen.dart';
import '../../features/doctor_details/presentation/cubit/doctor_profile_cubit.dart';
import '../../features/doctor_details/presentation/view/doctor_profile_screen.dart';
import '../di/injection_container.dart' as di;

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final uri = Uri.tryParse(settings.name ?? '') ?? Uri(path: '/');
    switch (uri.path) {
      case Routes.configuration:
        return MaterialPageRoute(builder: (_) => const ConfigurationScreen());

      case Routes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      // ── Auth ────────────────────────────────────────────────────────────
      // Each route gets its OWN fresh AuthCubit (Factory).
      // BlocProvider owns the lifecycle → closes it when the route pops.
      case Routes.auth:
        if (UserRepository().isLoggedIn) {
          return MaterialPageRoute(
            settings: const RouteSettings(name: Routes.auth),
            builder: (_) => const _RouteRedirect(destination: Routes.dashBoard),
          );
        }
        return MaterialPageRoute(
          settings: const RouteSettings(name: Routes.auth),
          builder: (_) => BlocProvider<AuthCubit>(
            create: (_) => di.sl<AuthCubit>(),
            child: const AuthScreen(),
          ),
        );
      case Routes.bookingDetails:
        if (!UserRepository().isLoggedIn) return _authRoute();
        final args = settings.arguments as Map<String, dynamic>;
        final booking = args['booking'] as BookingEntity;
        final cubit = args['cubit'] as BookingCubit;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: cubit,
            child: BookingDetailScreen(booking: booking),
          ),
        );
      case Routes.privacyPolicy:
        return MaterialPageRoute(
          builder: (_) => PolicyScreen(
            url: Endpoints.policyLink,
            title: 'settings.legal.privacy'.tr(),
          ),
        );

      // so we pass it via arguments instead of creating a new one.
      case Routes.forgotPassword:
        final email =
            settings.arguments as String? ?? uri.queryParameters['email'];
        return MaterialPageRoute(
          settings: RouteSettings(name: uri.toString()),
          builder: (_) => BlocProvider<AuthCubit>(
            create: (_) => di.sl<AuthCubit>(),
            child: ForgotPasswordScreen(initialEmail: email),
          ),
        );
      case Routes.resetPassword:
        final args =
            settings.arguments as String? ?? uri.queryParameters['email'];
        if (args == null || args.trim().isEmpty) {
          return _authRoute(message: 'auth.routeDataMissing');
        }
        return MaterialPageRoute(
          settings: RouteSettings(name: uri.toString()),
          builder: (_) => BlocProvider<AuthCubit>(
            create: (_) => di.sl<AuthCubit>(),
            child: ResetPasswordScreen(email: args),
          ),
        );
      case Routes.profile:
        if (!UserRepository().isLoggedIn) return _authRoute();
        return MaterialPageRoute(
          settings: RouteSettings(name: uri.toString()),
          builder: (_) => BlocProvider<ProfileCubit>(
            create: (_) => di.sl<ProfileCubit>(),
            child: const ProfileScreen(),
          ),
        );
      case Routes.verification:
        final args = settings.arguments;
        String? email;
        if (args is Map<String, dynamic>) {
          email = args['email'] as String?;
        } else if (args is String) {
          email = args;
        }
        email ??= uri.queryParameters['email'];
        if (email == null || email.trim().isEmpty) {
          return _authRoute(message: 'auth.routeDataMissing');
        }
        final resolvedEmail = email;

        return MaterialPageRoute(
          settings: RouteSettings(name: uri.toString()),
          builder: (_) => BlocProvider<AuthCubit>(
            create: (_) => di.sl<AuthCubit>(),
            child: OtpVerificationPage(email: resolvedEmail),
          ),
        );

      // ── Dashboard ───────────────────────────────────────────────────────
      case Routes.dashBoard:
        return _dashboardRoute();

      case Routes.search:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<SearchCubit>(),
            child: const SearchScreen(),
          ),
        );

      // ── Clinic Details ──────────────────────────────────────────────────
      case Routes.clinicDetails:
        final clinicId = settings.arguments as int?;
        if (clinicId == null) return _errorRoute();
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di.sl<ClinicDetailsCubit>(),
            child: ClinicDetailsScreen(clinicId: clinicId),
          ),
        );

      case Routes.mapLocations:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<MapLocationsCubit>(
            create: (_) => di.sl<MapLocationsCubit>(),
            child: const MapLocationsScreen(),
          ),
        );

      // ── Doctor Profile ──────────────────────────────────────────────────
      case Routes.doctorProfile:
        final doctorId = settings.arguments as int?;
        if (doctorId == null) return _errorRoute();
        return MaterialPageRoute(
          builder: (_) => BlocProvider<DoctorProfileCubit>(
            create: (_) => di.sl<DoctorProfileCubit>(),
            child: DoctorProfileScreen(doctorId: doctorId),
          ),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _dashboardRoute() => MaterialPageRoute(
    settings: const RouteSettings(name: Routes.dashBoard),
    builder: (_) => MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => di.sl<AuthCubit>()),
        BlocProvider<HomeCubit>(create: (_) => di.sl<HomeCubit>()..initHome()),
      ],
      child: const DashBoardScreen(),
    ),
  );

  static Route<dynamic> _authRoute({String? message}) => MaterialPageRoute(
    settings: const RouteSettings(name: Routes.auth),
    builder: (_) => BlocProvider<AuthCubit>(
      create: (_) => di.sl<AuthCubit>(),
      child: AuthScreen(
        redirectToAuth: true,
        initialMessage:
            message ??
            (SharedPrefHelper.lastSecureStorageFailure != null
                ? 'auth.storageReadUnavailable'
                : null),
      ),
    ),
  );

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) =>
          const Scaffold(body: Center(child: Text('Route not found'))),
    );
  }
}

class _RouteRedirect extends StatefulWidget {
  final String destination;
  const _RouteRedirect({required this.destination});

  @override
  State<_RouteRedirect> createState() => _RouteRedirectState();
}

class _RouteRedirectState extends State<_RouteRedirect> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(widget.destination);
      }
    });
  }

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}
