// ==================== app_text_widgets.dart ====================
// Reusable Text widgets for recurring style patterns across the app.
// These prevent copy-paste of copyWith chains and ensure consistency.
//
// Usage examples:
//   HeadlineText('Clinic Name')
//   SectionTitle('Available Doctors', count: 3)
//   BodyText('Doctor bio goes here', loose: true)
//   BadgeLabel('Cardiology', color: Colors.blue)
//   PriceLabel(250, currency: 'ج.م')

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_text_style.dart';
import '../theme/colors.dart';

// ---------------------------------------------------------------------------
// Page / Section Headings
// ---------------------------------------------------------------------------

/// Large page-level heading — clinic name on detail screen, onboarding titles.
class HeadlineText extends StatelessWidget {
  final String text;
  final Color? color;
  final int? maxLines;
  final TextAlign? textAlign;

  const HeadlineText(
      this.text, {
        Key? key,
        this.color,
        this.maxLines,
        this.textAlign,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).textTheme.headlineMedium!;
    return Text(
      text,
      style: color != null ? base.copyWith(color: color) : base,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
    );
  }
}

/// Section title with optional item count badge.
/// Renders as: "Available Doctors  [3]"
class SectionTitle extends StatelessWidget {
  final String title;
  final IconData? icon;
  final int? count;
  final Color? accentColor;

  const SectionTitle(
      this.title, {
        Key? key,
        this.icon,
        this.count,
        this.accentColor,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = accentColor ?? theme.primaryColor;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icon badge if provided, otherwise the colored left accent bar
        if (icon != null)
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 16.sp, color: accent),
          )
        else
          Container(
            width: 3.w,
            height: 18.h,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        SizedBox(width: icon != null ? 10.w : 8.w),

        // Title text
        Flexible(
          child: Text(
            title,
            style: AppTextStyles.sectionHeader,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        // Optional count badge
        if (count != null) ...[
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              '$count',
              style: AppTextStyles.labelSmall.copyWith(
                color: accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Body Text
// ---------------------------------------------------------------------------

/// Standard body text — auto-inherits bodyMedium from theme.
/// [loose] applies extra line-height for Arabic long-form content.
class BodyText extends StatelessWidget {
  final String text;
  final bool loose;
  final Color? color;
  final int? maxLines;
  final TextAlign? textAlign;
  final bool bold;

  const BodyText(
      this.text, {
        Key? key,
        this.loose = false,
        this.color,
        this.maxLines,
        this.textAlign,
        this.bold = false,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context).textTheme.bodyMedium!;
    if (loose) style = style.copyWith(height: 1.75);
    if (bold) style = style.copyWith(fontWeight: FontWeight.w600);
    if (color != null) style = style.copyWith(color: color);

    return Text(
      text,
      style: style,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
    );
  }
}

/// Dimmed secondary body text — used for hints, subtitles, timestamps.
class CaptionText extends StatelessWidget {
  final String text;
  final Color? color;
  final int? maxLines;
  final TextAlign? textAlign;

  const CaptionText(
      this.text, {
        Key? key,
        this.color,
        this.maxLines,
        this.textAlign,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).textTheme.bodySmall!;
    return Text(
      text,
      style: color != null ? base.copyWith(color: color) : base,
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
    );
  }
}

// ---------------------------------------------------------------------------
// Specialty / Category Badge Label
// ---------------------------------------------------------------------------

/// Colored text badge for specialty chips, booking status, category tags.
class BadgeLabel extends StatelessWidget {
  final String text;
  final Color? color;
  final Color? backgroundColor;
  final double? fontSize;

  const BadgeLabel(
      this.text, {
        Key? key,
        this.color,
        this.backgroundColor,
        this.fontSize,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? ColorsManager.primaryColor;
    final bgColor = backgroundColor ?? textColor.withOpacity(0.1);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        text,
        style: AppTextStyles.specialtyBadge.copyWith(
          color: textColor,
          fontSize: fontSize,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Price Label
// ---------------------------------------------------------------------------

/// Clinic / doctor consultation fee display.
/// Renders as: "250 ج.م" in bold primary color.
class PriceLabel extends StatelessWidget {
  final double amount;
  final String currency;
  final TextStyle? style;

  const PriceLabel(
      this.amount, {
        Key? key,
        this.currency = 'ج.م',
        this.style,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: amount.toInt().toString(),
            style: style ?? AppTextStyles.price,
          ),
          TextSpan(
            text: ' $currency',
            style: AppTextStyles.bodySmall.copyWith(
              color: ColorsManager.miscellaneous,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Rating Label
// ---------------------------------------------------------------------------

/// Star + rating value inline widget (e.g. "★ 4.8").
class RatingLabel extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final double iconSize;

  const RatingLabel(
      this.rating, {
        Key? key,
        this.reviewCount,
        this.iconSize = 14,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star_rounded,
          color: ColorsManager.warningFill,
          size: iconSize.sp,
        ),
        SizedBox(width: 3.w),
        Text(
          rating.toStringAsFixed(1),
          style: AppTextStyles.ratingValue,
        ),
        if (reviewCount != null) ...[
          SizedBox(width: 4.w),
          Text(
            '($reviewCount)',
            style: AppTextStyles.labelSmall,
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Empty / Error State Text Block
// ---------------------------------------------------------------------------

/// Centered title + subtitle pair used in empty/error states.
class EmptyStateText extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color? titleColor;

  const EmptyStateText({
    Key? key,
    required this.title,
    required this.subtitle,
    this.titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: titleColor ?? theme.hintColor,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// On-Primary Text (white text on colored backgrounds)
// ---------------------------------------------------------------------------

/// Lightweight text widget for use inside colored containers / app bars.
class OnPrimaryText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight fontWeight;
  final int? maxLines;

  const OnPrimaryText(
      this.text, {
        Key? key,
        this.fontSize,
        this.fontWeight = FontWeight.w500,
        this.maxLines,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.onPrimary.copyWith(
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
    );
  }
}