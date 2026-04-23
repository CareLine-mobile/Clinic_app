
import 'package:flutter/material.dart';

import 'app_text_style.dart';
import 'colors.dart';
import 'text_theme.dart';

class DarkTheme {
  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Primary Colors
    primaryColor: ColorsManager.primaryColor,
    primaryColorLight: ColorsManager.secondaryColor,
    primaryColorDark: ColorsManager.primaryColor,

    // Card & Surface Colors
    cardColor: ColorsManager.secondaryDarkColor,
    scaffoldBackgroundColor: ColorsManager.darkColor,
    canvasColor: ColorsManager.secondaryDarkColor,

    // Color Scheme
    colorScheme: ColorScheme.dark(
      primary: ColorsManager.primaryColor,
      secondary: ColorsManager.secondaryColor,
      surface: ColorsManager.secondaryDarkColor,
      surfaceContainerHighest: ColorsManager.darkColor,
      background: ColorsManager.darkColor,
      error: ColorsManager.errorFill,
      onError: ColorsManager.errorOnFill,
      errorContainer: ColorsManager.errorSurface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onSurfaceVariant: ColorsManager.defaultTextSecondaryDark,
      outline: Colors.grey[700]!,
      shadow: Colors.black.withOpacity(0.3),
    ),

    // App Bar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: ColorsManager.secondaryDarkColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: AppTextStyles.titleLarge.copyWith(color: Colors.white),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: ColorsManager.primaryColor,
      unselectedItemColor: Colors.grey[500],
      backgroundColor: ColorsManager.secondaryDarkColor,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: AppTextStyles.navBarSelected,
      unselectedLabelStyle: AppTextStyles.navBarSelected.copyWith(
        color: Colors.grey[500],
        fontWeight: FontWeight.w400,
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: ColorsManager.secondaryDarkColor,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsManager.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: AppTextStyles.labelLarge.copyWith(color: Colors.white),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ColorsManager.primaryColor,
        textStyle: AppTextStyles.labelLarge,
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorsManager.secondaryDarkColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[700]!, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[700]!, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ColorsManager.primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ColorsManager.errorFill, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: ColorsManager.errorFill, width: 2),
      ),
      hintStyle: AppTextStyles.inputHint.copyWith(color: Colors.grey[500]),
      labelStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[400]),
      errorStyle: AppTextStyles.inputError,
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: Colors.white,
      size: 24,
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: Colors.grey[800],
      thickness: 1,
      space: 1,
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: ColorsManager.primaryColor.withOpacity(0.2),
      selectedColor: ColorsManager.primaryColor,
      disabledColor: Colors.grey[800],
      labelStyle: AppTextStyles.specialtyBadge,
      secondaryLabelStyle: AppTextStyles.specialtyBadge.copyWith(
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),

    // Text Theme — sourced from AppTextThemeFactory (dark variant)
    textTheme: AppTextTheme.darkTextTheme,
  );
}