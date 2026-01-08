import 'package:clinic_app/core/routes/routes.dart';
import 'package:flutter/material.dart';
import '../../features/dashboard/dashboard.dart';
import '../../features/clinic_details/presentation/view/clinic_details_screen.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.dashBoard:
        return MaterialPageRoute(
          builder: (_) => const PatientHomeScreen(),
        );

      case Routes.clinicDetails:
        final clinicId = settings.arguments as String?;
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