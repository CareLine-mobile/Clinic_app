import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/di/injection_container.dart' as di;
import 'core/routes/app_routes.dart';
import 'core/routes/routes.dart';
import 'core/service/app_initializer.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/clinic_details/presentation/cubit/clinic_details_cubit.dart';
import 'features/clinic_details/presentation/cubit/clinic_ui_cubit.dart';
import 'features/home/presentation/cubit/home_cubit.dart';
import 'features/home/presentation/cubit/home_ui_cubit.dart';
import 'features/user_data/user_cubit.dart';
import 'features/user_data/user_repo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppInitializer.init();

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
        // ── Global: user state accessible everywhere ──────────
        BlocProvider<UserCubit>(
          create: (_) => UserCubit(UserRepository()),
        ),

        // ── Auth ──────────────────────────────────────────────
        BlocProvider<AuthCubit>(
          create: (_) => di.sl<AuthCubit>(),
        ),

        // ── Home ──────────────────────────────────────────────
        BlocProvider<HomeCubit>(
          create: (_) => di.sl<HomeCubit>(),
        ),
        BlocProvider<HomeUiCubit>(
          create: (_) => di.sl<HomeUiCubit>(),
        ),

        // ── Clinic Details ────────────────────────────────────
        // ⚠️ These are better created per-route (registerFactory in DI)
        // but keeping them here if your routing requires it
        BlocProvider<ClinicDetailsCubit>(
          create: (_) => di.sl<ClinicDetailsCubit>(),
        ),
        BlocProvider<ClinicUiCubit>(
          create: (_) => di.sl<ClinicUiCubit>(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            navigatorKey: AppRouter.navigatorKey,
            theme: AppTheme.light,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            initialRoute: UserRepository().isLoggedIn ? Routes.dashBoard : Routes.auth,
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}