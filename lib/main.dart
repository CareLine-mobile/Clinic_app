// lib/main.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'core/db/shared_pref_helper.dart';
import 'core/di/injection_container.dart';
import 'core/routes/app_router.dart';
import 'core/service/app_initializer.dart';
import 'core/service/notification_permission_service.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/app_constans.dart';
import 'core/utils/responsive.dart';
import 'dev_widget.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/settings/presentation/cubit/settings_cubit.dart';
import 'features/user_data/user_cubit.dart';
import 'features/user_data/user_repo.dart';
import 'features/my_booking/presentation/cubit/booking_cubit.dart';

// ── First-launch flags ────────────────────────────────────────────────────
bool isConfigurationDone = false;
bool isOnBoarding = false;
Locale initialLocale = const Locale('ar'); // updated before runApp

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //debugPaintSizeEnabled = true;

  // Use path-based URL strategy on web (no # in URLs)
  usePathUrlStrategy();

  await AppInitializer.init();

  // Notifications are not supported on web — guard the call
  if (!kIsWeb) {
    NotificationPermissionService.requestPermission().ignore();
  }

  await UserRepository().loadUser();

  // Read both flags before showing any UI
  isConfigurationDone =
      await SharedPrefHelper.getBool(key: AppConstants.configurationKey) ??
      false;
  isOnBoarding =
      await SharedPrefHelper.getBool(key: AppConstants.onboardingKey) ?? false;

  final savedLang = await SharedPrefHelper.getString(
    key: AppConstants.languageCode,
  );
  if (savedLang != null) {
    initialLocale = Locale(savedLang);
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      saveLocale: true,
      startLocale: initialLocale, // ← dynamic, not hardcoded 'ar'
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
        BlocProvider<UserCubit>(create: (_) => UserCubit(UserRepository())),
        BlocProvider<BookingCubit>(
          lazy: false,
          create: (_) {
            final bookingCubit = sl<BookingCubit>();
            if (UserRepository().isLoggedIn) bookingCubit.loadBookings();
            return bookingCubit;
          },
        ),
        BlocProvider<SettingsCubit>(
          create: (_) =>
              SettingsCubit(settingsRepository: sl())..loadSettings(),
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (prev, curr) => prev.themeMode != curr.themeMode,
        builder: (context, settings) {
          // ── Responsive ScreenUtilInit ──────────────────────────────────
          // LayoutBuilder fires on every window-resize, allowing ScreenUtilInit
          // to pick the correct design canvas for each breakpoint so that
          // existing .w / .h / .sp calls keep scaling without any rewrite.
          return LayoutBuilder(
            builder: (layoutContext, constraints) {
              final w = constraints.maxWidth;
              final Size designSize;
              if (w > Responsive.desktopBreakpoint) {
                designSize = const Size(1440, 900); // desktop reference
              } else if (w > Responsive.tabletBreakpoint) {
                designSize = const Size(768, 1024); // tablet reference
              } else {
                designSize = const Size(375, 812); // original phone reference
              }

              return ScreenUtilInit(
                designSize: designSize,
                minTextAdapt: true,
                splitScreenMode: true,
                builder: (context, child) {
                  return BlocListener<SettingsCubit, SettingsState>(
                    // ── FIX: whenever SettingsCubit loads or changes the
                    //         locale (e.g. on startup via loadSettings()),
                    //         push that locale into EasyLocalization so the
                    //         two sources stay in sync. ──────────────────────
                    listenWhen: (prev, curr) => prev.locale != curr.locale,
                    listener: (context, state) {
                      if (context.locale != state.locale) {
                        context.setLocale(state.locale);
                      }
                    },
                    child: MaterialApp.router(
                      theme: AppTheme.light,
                      darkTheme: AppTheme.dark,
                      themeMode: settings.themeMode,
                      localizationsDelegates: context.localizationDelegates,
                      supportedLocales: context.supportedLocales,
                      locale: context.locale,
                      debugShowCheckedModeBanner: kDebugMode,
                      routerConfig: appRouter,
                      //   builder: (context, child) => DevToolsOverlay(child:child!),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
