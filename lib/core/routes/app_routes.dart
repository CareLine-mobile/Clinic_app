import 'package:clinic_app/core/routes/routes.dart';
import 'package:clinic_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/view/auth_screen.dart';
import '../../features/dashboard/dashboard.dart';
import '../../features/clinic_details/presentation/view/clinic_details_screen.dart';
import '../di/injection_container.dart' as di;

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {

      case Routes.auth:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<AuthCubit>(
            create: (context) => di.sl<AuthCubit>(),
            child: const AuthScreen(),
          ),
        );

      case Routes.dashBoard:
        return MaterialPageRoute(
          builder: (_) => const PatientHomeScreen(),
        );

      case Routes.clinicDetails:
        final clinicId = settings.arguments as int?;
        if (clinicId == null) {
          return _errorRoute();
        }
        return MaterialPageRoute(
          builder: (_) => ClinicDetailsScreen(clinicId: clinicId),
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
