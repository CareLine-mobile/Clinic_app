// lib/core/utils/responsive.dart
//
// Single source of truth for responsive layout decisions.
//
// Usage:
//   final cat = Responsive.categoryOf(context);          // ScreenSizeCategory enum
//   final isDesktop = Responsive.isDesktop(context);     // quick bool helpers
//
//   // Branch in build() with a helper widget:
//   ResponsiveLayout(
//     mobile:  MobileWidget(),
//     tablet:  TabletWidget(),
//     desktop: DesktopWidget(),
//   )
//
//   // Or inline with builder:
//   Responsive.builder(context, (category) {
//     return category == ScreenSizeCategory.mobile ? MobileWidget() : WideWidget();
//   });

import 'package:flutter/material.dart';

// ── Breakpoints ──────────────────────────────────────────────────────────────

/// < 600  → mobile
/// 600–1024 → tablet
/// > 1024 → desktop
enum ScreenSizeCategory { mobile, tablet, desktop }

// ── Responsive helper class ──────────────────────────────────────────────────

class Responsive {
  /// Width threshold below which we consider the layout "mobile".
  static const double tabletBreakpoint = 600.0;

  /// Width threshold above which we consider the layout "desktop".
  static const double desktopBreakpoint = 1024.0;

  /// Max content width cap so content never stretches edge-to-edge on large
  /// monitors. Wrap Scaffold bodies with [centeredContent] to apply.
  static const double maxContentWidth = 1000.0;

  // ── Category ────────────────────────────────────────────────────────────

  /// Returns the [ScreenSizeCategory] for the current [context].
  /// Reads from [MediaQuery] — rebuilds automatically when size changes.
  static ScreenSizeCategory categoryOf(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return _fromWidth(width);
  }

  static ScreenSizeCategory _fromWidth(double width) {
    if (width > desktopBreakpoint) return ScreenSizeCategory.desktop;
    if (width > tabletBreakpoint) return ScreenSizeCategory.tablet;
    return ScreenSizeCategory.mobile;
  }

  // ── Quick bool helpers ───────────────────────────────────────────────────

  static bool isMobile(BuildContext context) =>
      categoryOf(context) == ScreenSizeCategory.mobile;

  static bool isTablet(BuildContext context) =>
      categoryOf(context) == ScreenSizeCategory.tablet;

  static bool isDesktop(BuildContext context) =>
      categoryOf(context) == ScreenSizeCategory.desktop;

  static bool isWide(BuildContext context) =>
      categoryOf(context) != ScreenSizeCategory.mobile;

  // ── Builder helper ───────────────────────────────────────────────────────

  /// Inline builder that receives the current [ScreenSizeCategory].
  static Widget builder(
    BuildContext context,
    Widget Function(ScreenSizeCategory category) builder,
  ) {
    return builder(categoryOf(context));
  }

  // ── Centered content helper ──────────────────────────────────────────────

  /// Wraps [child] in a horizontally-centered [ConstrainedBox] so content
  /// never stretches full width on large monitors.
  /// On mobile the constraint has no effect (screen is already narrow).
  static Widget centeredContent({
    required Widget child,
    double maxWidth = maxContentWidth,
  }) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

// ── ResponsiveLayout widget ──────────────────────────────────────────────────

/// Convenience widget that picks one of up to three child widgets based on
/// the current breakpoint. If [tablet] is omitted, [mobile] is used for
/// tablet widths. If [desktop] is omitted, [tablet] (or [mobile]) is used.
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final category = Responsive.categoryOf(context);
    switch (category) {
      case ScreenSizeCategory.desktop:
        return desktop ?? tablet ?? mobile;
      case ScreenSizeCategory.tablet:
        return tablet ?? mobile;
      case ScreenSizeCategory.mobile:
        return mobile;
    }
  }
}

// ── ConstrainedPageBody ──────────────────────────────────────────────────────

/// Drop-in body wrapper for Scaffold. On tablet/desktop, constrains max-width
/// to [maxWidth] and centres the content. On mobile it's a transparent pass-through.
class ConstrainedPageBody extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry? padding;

  const ConstrainedPageBody({
    super.key,
    required this.child,
    this.maxWidth = Responsive.maxContentWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (Responsive.isMobile(context)) {
      return padding != null ? Padding(padding: padding!, child: child) : child;
    }
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: padding != null
            ? Padding(padding: padding!, child: child)
            : child,
      ),
    );
  }
}
