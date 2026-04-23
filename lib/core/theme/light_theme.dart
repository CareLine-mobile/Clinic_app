// ==================== Light Theme ====================
import 'package:flutter/material.dart';
import 'app_text_style.dart';
import 'colors.dart';
import 'text_theme.dart';

class LightTheme {
  static final ThemeData theme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Primary Colors
    primaryColor: ColorsManager.primaryColor,
    primaryColorLight: ColorsManager.secondaryColor,
    primaryColorDark: ColorsManager.primaryColor,

    // Card & Surface Colors
    cardColor: ColorsManager.backgroundCard,
    scaffoldBackgroundColor: ColorsManager.backgroundSurface,
    canvasColor: ColorsManager.defaultSurface,

    // Color Scheme
    colorScheme: ColorScheme.light(
      primary: ColorsManager.primaryColor,
      secondary: ColorsManager.secondaryColor,
      surface: ColorsManager.defaultSurface,
      surfaceContainerHighest: ColorsManager.backgroundCard,
      background: ColorsManager.backgroundSurface,
      error: ColorsManager.errorFill,
      onError: ColorsManager.errorOnFill,
      errorContainer: ColorsManager.errorSurface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: ColorsManager.defaultText,
      onBackground: ColorsManager.defaultText,
      onSurfaceVariant: ColorsManager.defaultTextSecondary,
      outline: ColorsManager.inputBorder,
      shadow: Colors.black.withOpacity(0.1),
    ),

    // App Bar Theme — uses titleLarge from textTheme
    appBarTheme: AppBarTheme(
      backgroundColor: ColorsManager.primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: AppTextStyles.titleLarge.copyWith(color: Colors.white),
    ),

    // Bottom Navigation Bar Theme — uses navBarSelected from AppTextStyles
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: ColorsManager.primaryColor,
      unselectedItemColor: ColorsManager.inputBorder,
      backgroundColor: Colors.white,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: AppTextStyles.navBarSelected,
      unselectedLabelStyle: AppTextStyles.navBarSelected.copyWith(
        color: ColorsManager.inputBorder,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    // Elevated Button Theme — label uses labelLarge
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

    // Input Decoration Theme — uses inputHint / inputError styles
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorsManager.inputSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: ColorsManager.inputBorder, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: ColorsManager.inputBorder, width: 1),
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
      hintStyle: AppTextStyles.inputHint,
      labelStyle: AppTextStyles.bodyMedium.copyWith(
        color: ColorsManager.defaultTextSecondary,
      ),
      errorStyle: AppTextStyles.inputError,
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: ColorsManager.defaultText,
      size: 24,
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: ColorsManager.inputBorder,
      thickness: 1,
      space: 1,
    ),

    // Chip Theme — uses labelMedium / specialtyBadge
    chipTheme: ChipThemeData(
      backgroundColor: ColorsManager.primaryColor.withOpacity(0.1),
      selectedColor: ColorsManager.primaryColor,
      disabledColor: ColorsManager.inputBorder.withOpacity(0.3),
      labelStyle: AppTextStyles.specialtyBadge,
      secondaryLabelStyle: AppTextStyles.specialtyBadge.copyWith(
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),

    // Text Theme — sourced from AppTextThemeFactory
    textTheme: AppTextTheme.lightTextTheme,
  );
}

