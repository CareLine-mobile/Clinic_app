// lib/main.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'core/di/injection_container.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/routes.dart';
import 'core/service/app_initializer.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/auth/presentation/view/otp_verification_page.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/user_data/user_cubit.dart';
import 'features/user_data/user_repo.dart';
bool isServiceEnable =false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppInitializer.init();
 // await Geolocator.requestPermission();
// isServiceEnable = await Geolocator.isLocationServiceEnabled();

  // Load persisted user before UI starts
  await UserRepository().loadUser();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      startLocale: const Locale('ar'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // ── Global: current user accessible everywhere ────────
        BlocProvider<UserCubit>(
          create: (_) => UserCubit(UserRepository()),
        ),

        // ── Settings: theme, language, notifications ──────────
        BlocProvider<SettingsCubit>(
         create: (_) => SettingsCubit(settingsRepository: sl())..loadSettings(),
        ),


      ],
      // BlocBuilder here so themeMode changes rebuild MaterialApp immediately
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (prev, curr) => prev.themeMode != curr.themeMode,
        builder: (context, settings) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp(
                navigatorKey: AppRouter.navigatorKey,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,         // make sure this exists
                themeMode: settings.themeMode,    // driven by SettingsCubit
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,           // driven by easy_localization
                initialRoute: UserRepository().isLoggedIn ? Routes.dashBoard : Routes.auth,
              onGenerateRoute: AppRouter.onGenerateRoute,

              );
            },
          );
        },
      ),
    );
  }
}