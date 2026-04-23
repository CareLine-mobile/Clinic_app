import 'package:flutter/material.dart';

import 'app_text_style.dart';

class AppTextTheme {
  static const String fontFamily = 'Poppins';

  /// Light theme TextTheme — delegate to AppTextThemeFactory.
  static TextTheme get lightTextTheme => AppTextThemeFactory.light;

  /// Dark theme TextTheme — delegate to AppTextThemeFactory.
  static TextTheme get darkTextTheme => AppTextThemeFactory.dark;
}