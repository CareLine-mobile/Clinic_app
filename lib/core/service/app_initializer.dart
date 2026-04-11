import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../firebase_options.dart';
import '../di/injection_container.dart' as di;

class AppInitializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    /// Initialize services
    // await Alarm.init(); /// todo:: phase 2
    await _initLanguages();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    /// Initialize dependencies
    await di.init();

  }

  static Future<void> _initLanguages() async {
    initializeDateFormatting('ar', null);
    initializeDateFormatting('en_US', null);
  }
}