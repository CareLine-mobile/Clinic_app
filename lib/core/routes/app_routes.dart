import 'package:clinic_app/core/di/injection_container.dart';
import 'package:clinic_app/core/routes/routes.dart';
import 'package:clinic_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:clinic_app/features/my_booking/domain/entities/booking_entity.dart';
import 'package:clinic_app/features/my_booking/presentation/cubit/booking_cubit.dart';
import 'package:clinic_app/features/my_booking/presentation/view/booking_detail_screen.dart';
import 'package:clinic_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:clinic_app/features/search/presentation/view/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/view/auth_screen.dart';
import '../../features/auth/presentation/view/forgot_password_screen.dart';
import '../../features/auth/presentation/view/otp_verification_page.dart';
import '../../features/auth/presentation/view/reset_password_screen.dart';
import '../../features/clinic_details/presentation/cubit/clinic_details_cubit.dart';
import '../../features/dashboard/dashboard.dart';
import '../../features/clinic_details/presentation/view/clinic_details_screen.dart';
import '../di/injection_container.dart' as di;

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {

    // ── Auth ────────────────────────────────────────────────────────────
    // Each route gets its OWN fresh AuthCubit (Factory).
    // BlocProvider owns the lifecycle → closes it when the route pops.
      case Routes.auth:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<AuthCubit>(
            create: (_) => di.sl<AuthCubit>(),
            child: const AuthScreen(),
          ),
        );
      case Routes.bookingDetails:
        final args = settings.arguments as Map<String, dynamic>;
        final booking = args['booking'] as BookingEntity;
        final cubit   = args['cubit']   as BookingCubit;
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: cubit,
            child: BookingDetailScreen(booking: booking),
          ),
        );
    // ForgotPassword needs to share the cubit created in Routes.auth
    // so we pass it via arguments instead of creating a new one.
      case Routes.forgotPassword:
        final cubit = settings.arguments as AuthCubit?;
        return MaterialPageRoute(
          builder: (_) => cubit != null
              ? BlocProvider.value(
            value: cubit,
            child: const ForgotPasswordScreen(),
          )
          // fallback: create a fresh one if navigated to directly
              : BlocProvider<AuthCubit>(
            create: (_) => di.sl<AuthCubit>(),
            child: const ForgotPasswordScreen(),
          ),
        );

      case Routes.resetPassword:
        final args = settings.arguments as Map<String, dynamic>;
        final email = args['email'] as String;
        final cubit = args['cubit'] as AuthCubit?;
        return MaterialPageRoute(
          builder: (_) => cubit != null
              ? BlocProvider.value(
            value: cubit,
            child: ResetPasswordScreen(email: email),
          )
              : BlocProvider<AuthCubit>(
            create: (_) => di.sl<AuthCubit>(),
            child: ResetPasswordScreen(email: email),
          ),
        );

    // OTP — always shares the same cubit that started the signup/login flow.
    // Pass the cubit via arguments from AuthScreen.
      case Routes.verification:
      // ─── Handle both String and Map arguments ────────────────────
        final args = settings.arguments;
        String email;
        AuthCubit? cubit;

        if (args is Map<String, dynamic>) {
          email = args['email'] as String;
          cubit = args['cubit'] as AuthCubit?;
        } else if (args is String) {
          // Fallback for backward compatibility: if a plain email string is passed, use it and create a new cubit.
          email = args;
          cubit = null;
        } else {
          return _errorRoute();
        }

        return MaterialPageRoute(
          builder: (_) => cubit != null
              ? BlocProvider.value(
            value: cubit,
            child: OtpVerificationPage(email: email),
          )
              : BlocProvider<AuthCubit>(
            create: (_) => di.sl<AuthCubit>(),
            child: OtpVerificationPage(email: email),
          ),
        );

    // ── Dashboard ───────────────────────────────────────────────────────
      case Routes.dashBoard:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<AuthCubit>(
                create: (_) => di.sl<AuthCubit>(),
              ),
              BlocProvider<HomeCubit>(
                create: (_) => di.sl<HomeCubit>()..initHome(),
              ),
            ],
            child: const PatientHomeScreen(),
          ),
        );

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

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text('Route not found')),
      ),
    );
  }
}