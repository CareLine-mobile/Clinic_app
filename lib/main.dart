import 'package:alarm/alarm.dart';
import 'package:clinic_app/core/routes/app_routes.dart';
import 'package:clinic_app/features/alarm/screen/medication_alarm_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/theme/app_theme.dart';
import 'features/alarm/service/medication_alarm_service.dart';
import 'features/booking/presentation/pages/booking_screen.dart';
import 'features/dashboard/dashboard.dart';


// Global navigator key for alarm navigation
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Alarm Service (lightweight)
  await Alarm.init();
  await initializeDateFormatting('ar', null);
  await initializeDateFormatting('en_US', null);

  runApp(const VirtualPharmacistApp());
}

class VirtualPharmacistApp extends StatefulWidget {
  const VirtualPharmacistApp({Key? key}) : super(key: key);

  @override
  State<VirtualPharmacistApp> createState() => _VirtualPharmacistAppState();
}

class _VirtualPharmacistAppState extends State<VirtualPharmacistApp> with WidgetsBindingObserver {
  final _alarmService = MedicationAlarmService();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // _listenToAlarms();
    //
    // // ⬅️ تأخير العمليات الثقيلة بعد بناء الـ UI
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _initializeHeavyOperations();
    // });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _initialized) {
      _rescheduleAlarmsOnStartup();
    }
  }

  /// تهيئة العمليات الثقيلة بعد بناء الواجهة
  Future<void> _initializeHeavyOperations() async {
    if (_initialized) return;

    try {
      // طلب الأذونات
      await MedicationAlarmService.requestPermissions();

      // إعادة جدولة التنبيهات
      await _rescheduleAlarmsOnStartup();

      _initialized = true;
      debugPrint('✅ Heavy operations initialized');
    } catch (e) {
      debugPrint('⚠️ Failed to initialize: $e');
    }
  }

  /// Listen for alarm triggers
  void _listenToAlarms() {
    Alarm.ringStream.stream.listen((alarmSettings) {
      debugPrint('🔔 Alarm ringing: ${alarmSettings.id}');

      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => MedicationAlarmScreen(
            alarmSettings: alarmSettings,
          ),
          fullscreenDialog: true,
        ),
      );
    });
  }

  /// إعادة جدولة التنبيهات
  Future<void> _rescheduleAlarmsOnStartup() async {
    try {
      await _alarmService.rescheduleRecurringAlarms();
      debugPrint('✅ Alarms rescheduled');
    } catch (e) {
      debugPrint('⚠️ Failed to reschedule: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Virtual Pharmacist',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          navigatorKey: navigatorKey,
          home: const BookingScreen(),
      //    routes: AppRoutes.routes,
       //   onGenerateRoute: AppRoutes.onGenerateRoute,
        );
      },
    );
  }
}