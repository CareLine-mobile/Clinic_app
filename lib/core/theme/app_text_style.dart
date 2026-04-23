// ==================== app_text_styles.dart ====================
// Centralized text style constants for the CareLine app.
// All font sizes use flutter_screenutil (.sp) for responsive scaling.
// Colors reference ColorsManager constants — never hardcoded.
//
// Usage:
//   Text('Hello', style: AppTextStyles.headlineLarge)
//   Text('Hello', style: Theme.of(context).textTheme.headlineLarge)
//
// Hierarchy (largest → smallest):
//   displayLarge  → Hero / splash numbers
//   headlineLarge → Page-level headings (e.g. clinic name on detail screen)
//   headlineMedium→ Section headings inside a page
//   headlineSmall → Card titles, modal headings
//   titleLarge    → AppBar title, section list header
//   titleMedium   → Sub-section label, tab title
//   titleSmall    → Card subtitle, item label
//   bodyLarge     → Primary readable content
//   bodyMedium    → Default body / descriptions (most-used)
//   bodySmall     → Secondary info, hints, timestamps
//   labelLarge    → Button text, primary action label
//   labelMedium   → Chip, badge, tag text
//   labelSmall    → Caption, helper text, overline
//   displaySmall  → Micro detail (e.g. "reviews_count" tiny number)

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'colors.dart';

/// Font family used across the entire app.
const String _kFontFamily = 'Poppins';

/// Shared line-height multiplier for Arabic + Latin legibility.
const double _kLineHeightDefault = 1.5;
const double _kLineHeightTight   = 1.25;
const double _kLineHeightLoose   = 1.75;

// ---------------------------------------------------------------------------
// AppTextStyles — static, theme-independent constants.
// Use these when you need a fixed style outside of a BuildContext
// (e.g. in a SliverPersistentHeaderDelegate or TextStyle constant).
// ---------------------------------------------------------------------------
abstract class AppTextStyles {
  // ── Display ──────────────────────────────────────────────────────────────

  /// Hero numbers / big statistics (e.g. "4.8" rating, "1,200 visits").
  static TextStyle get displayLarge => TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 48.sp,
    fontWeight: FontWeight.w700,
    color: ColorsManager.defaultText,
    height: _kLineHeightTight,
  );

  /// Medium display — used for progress percentages, large counters.
  static TextStyle get displayMedium => TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 36.sp,
    fontWeight: FontWeight.w600,
    color: ColorsManager.defaultText,
    height: _kLineHeightTight,
  );

  /// Small display — animated stat card numbers.
  static TextStyle get displaySmall => TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    color: ColorsManager.defaultText,
    height: _kLineHeightTight,
  );

  // ── Headline ─────────────────────────────────────────────────────────────

  /// Page-level heading (e.g. clinic name on detail screen header).
  static TextStyle get headlineLarge => TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
    color: ColorsManager.defaultText,
    height: _kLineHeightTight,
    letterSpacing: -0.3,
  );

  /// Section heading within a page (e.g. "Available Doctors").
  static TextStyle get headlineMedium => TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    color: ColorsManager.defaultText,
    height: _kLineHeightTight,
  );

  /// Card / modal heading (e.g. confirmation dialog title).
  static TextStyle get headlineSmall => TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: ColorsManager.defaultText,
    height: _kLineHeightDefault,
  );

  // ── Title ─────────────────────────────────────────────────────────────────

  /// AppBar title, prominent list section header.
  static TextStyle get titleLarge => TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: ColorsManager.defaultText,
    height: _kLineHeightDefault,
  );

  /// Sub-section label, tab title, settings group title.
  static TextStyle get titleMedium => TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: ColorsManager.defaultText,
    height: _kLineHeightDefault,
  );

  /// Card subtitle, item label inside a list tile.
  static TextStyle get titleSmall => TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: ColorsManager.defaultText,
    height: _kLineHeightDefault,
  );

  // ── Body ──────────────────────────────────────────────────────────────────

  /// Primary readable content — doctor bio, clinic description.
  static TextStyle get bodyLarge => TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: ColorsManager.defaultTextSecondary,
    height: _kLineHeightLoose,
  );

  /// Default body text — used in most places (most common style).
  static TextStyle get bodyMedium => TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: ColorsManager.defaultTextSecondary,
    height: _kLineHeightDefault,
  );

  /// Secondary info, hints, timestamps, subtitle under a name.
  static TextStyle get bodySmall => TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: ColorsManager.defaultTextSecondary,
    height: _kLineHeightDefault,
  );

  // ── Label ─────────────────────────────────────────────────────────────────

  /// Button text, primary CTA label.
  static TextStyle get labelLarge => TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: ColorsManager.primaryColor,
    height: _kLineHeightDefault,
    letterSpacing: 0.1,
  );

  /// Chip text, badge label, specialty tag.
  static TextStyle get labelMedium => TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: ColorsManager.miscellaneous,
    height: _kLineHeightDefault,
  );

  /// Caption / helper / overline / review count.
  static TextStyle get labelSmall => TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    color: ColorsManager.defaultTextSecondary,
    height: _kLineHeightDefault,
    letterSpacing: 0.2,
  );

  // ── Semantic / context-specific helpers ───────────────────────────────────

  /// Used on dark/primary backgrounds (AppBar, header gradients).
  static TextStyle get onPrimary => TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    height: _kLineHeightDefault,
  );

  /// Section header with colored accent bar (SectionHeader widget).
  static TextStyle get sectionHeader => TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    color: ColorsManager.defaultText,
    height: _kLineHeightDefault,
  );

  /// Specialty/category badge text (tinted background chips).
  static TextStyle get specialtyBadge => TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
    color: ColorsManager.primaryColor,
    height: _kLineHeightDefault,
  );

  /// Status badge text (open/closed, booking status, etc.).
  static TextStyle get statusBadge => TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 11.sp,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    height: _kLineHeightDefault,
  );

  /// Rating number displayed inside a star pill/badge.
  static TextStyle get ratingValue => TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
    color: ColorsManager.warningText,
    height: _kLineHeightDefault,
  );

  /// Price / consultation fee label.
  static TextStyle get price => TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 18.sp,
    fontWeight: FontWeight.w800,
    color: ColorsManager.primaryColor,
    height: _kLineHeightTight,
  );

  /// Input field hint text.
  static TextStyle get inputHint => TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: ColorsManager.inputBorder,
    height: _kLineHeightDefault,
  );

  /// Error text shown under form fields.
  static TextStyle get inputError => TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: ColorsManager.errorFill,
    height: _kLineHeightDefault,
  );

  /// Tab bar label (selected).
  static TextStyle get tabSelected => TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w700,
    color: ColorsManager.primaryColor,
    height: _kLineHeightDefault,
  );

  /// Tab bar label (unselected).
  static TextStyle get tabUnselected => TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: ColorsManager.miscellaneous,
    height: _kLineHeightDefault,
  );

  /// Nav bar selected item label.
  static TextStyle get navBarSelected => TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
    color: ColorsManager.primaryColor,
    height: _kLineHeightDefault,
  );

  /// Booking step label (active).
  static TextStyle get stepActive => TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 13.sp,
    fontWeight: FontWeight.w600,
    color: ColorsManager.primaryColor,
    height: _kLineHeightDefault,
  );

  /// Booking step label (inactive).
  static TextStyle get stepInactive => TextStyle(
    fontFamily: _kFontFamily,
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    color: ColorsManager.miscellaneous,
    height: _kLineHeightDefault,
  );
}

// ---------------------------------------------------------------------------
// AppTextTheme — generates TextTheme objects for ThemeData.
// Call [lightTextTheme] / [darkTextTheme] from your theme files.
// ---------------------------------------------------------------------------
abstract class AppTextThemeFactory {
  /// Creates the light-mode TextTheme.
  static TextTheme get light => TextTheme(
    // Display
    displayLarge:  AppTextStyles.displayLarge,
    displayMedium: AppTextStyles.displayMedium,
    displaySmall:  AppTextStyles.displaySmall,

    // Headline
    headlineLarge:  AppTextStyles.headlineLarge,
    headlineMedium: AppTextStyles.headlineMedium,
    headlineSmall:  AppTextStyles.headlineSmall,

    // Title
    titleLarge:  AppTextStyles.titleLarge,
    titleMedium: AppTextStyles.titleMedium,
    titleSmall:  AppTextStyles.titleSmall,

    // Body
    bodyLarge:  AppTextStyles.bodyLarge,
    bodyMedium: AppTextStyles.bodyMedium,
    bodySmall:  AppTextStyles.bodySmall,

    // Label
    labelLarge:  AppTextStyles.labelLarge,
    labelMedium: AppTextStyles.labelMedium,
    labelSmall:  AppTextStyles.labelSmall,
  );

  /// Creates the dark-mode TextTheme (same sizes, adjusted colors).
  static TextTheme get dark => TextTheme(
    // Display
    displayLarge:  AppTextStyles.displayLarge.copyWith(color: Colors.white),
    displayMedium: AppTextStyles.displayMedium.copyWith(color: Colors.white),
    displaySmall:  AppTextStyles.displaySmall.copyWith(color: Colors.white),

    // Headline
    headlineLarge:  AppTextStyles.headlineLarge.copyWith(color: Colors.white),
    headlineMedium: AppTextStyles.headlineMedium.copyWith(color: Colors.white),
    headlineSmall:  AppTextStyles.headlineSmall.copyWith(color: Colors.white),

    // Title
    titleLarge:  AppTextStyles.titleLarge.copyWith(color: Colors.white),
    titleMedium: AppTextStyles.titleMedium.copyWith(color: Colors.white),
    titleSmall:  AppTextStyles.titleSmall.copyWith(color: Colors.white),

    // Body
    bodyLarge:  AppTextStyles.bodyLarge.copyWith(color: Colors.white70),
    bodyMedium: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
    bodySmall:  AppTextStyles.bodySmall.copyWith(color: const Color(0xFFB0B8C8)),

    // Label
    labelLarge:  AppTextStyles.labelLarge.copyWith(color: Colors.white),
    labelMedium: AppTextStyles.labelMedium.copyWith(color: Colors.white70),
    labelSmall:  AppTextStyles.labelSmall.copyWith(color: const Color(0xFF8899AA)),
  );
}

// ---------------------------------------------------------------------------
// TextStyle extension helpers — makes copyWith less verbose at call-sites.
// ---------------------------------------------------------------------------
extension TextStyleX on TextStyle {
  /// Quick bold override.
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);

  /// Quick semi-bold override.
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);

  /// Quick medium-weight override.
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);

  /// Quick regular-weight override.
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);

  /// Apply primary color.
  TextStyle get primary =>
      copyWith(color: ColorsManager.primaryColor);

  /// Apply white color (for use on colored backgrounds).
  TextStyle get white => copyWith(color: Colors.white);

  /// Apply hint/secondary color.
  TextStyle get hint => copyWith(color: ColorsManager.inputBorder);

  /// Apply error color.
  TextStyle get error => copyWith(color: ColorsManager.errorFill);

  /// Apply loose line-height for RTL / long-form Arabic text.
  TextStyle get loose => copyWith(height: _kLineHeightLoose);

  /// Apply tight line-height for numbers and short labels.
  TextStyle get tight => copyWith(height: _kLineHeightTight);
}