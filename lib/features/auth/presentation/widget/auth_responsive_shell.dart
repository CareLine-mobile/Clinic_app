import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/utils/responsive.dart';

/// Shared responsive frame for every auth flow screen.
class AuthResponsiveShell extends StatelessWidget {
  final Widget child;

  const AuthResponsiveShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth > Responsive.desktopBreakpoint;
        final tablet = constraints.maxWidth > Responsive.tabletBreakpoint;
        final minHeight = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : 0.0;
        final content = desktop
            ? Row(
                textDirection: TextDirection.ltr,
                children: [
                  Expanded(child: _BrandPanel(textDirection: textDirection)),
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: Directionality(
                          textDirection: textDirection,
                          child: _Card(child: child),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: tablet ? 520 : 440),
                  child: tablet
                      ? _Card(child: child)
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: child,
                        ),
                ),
              );

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: desktop
                ? 32
                : tablet
                ? 32
                : 0,
            vertical: 24,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minHeight),
            child: SizedBox(width: double.infinity, child: content),
          ),
        );
      },
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) => Card(
    elevation: 2,
    clipBehavior: Clip.antiAlias,
    color: Theme.of(context).cardColor,
    margin: const EdgeInsets.all(24),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    child: Padding(padding: const EdgeInsets.all(32), child: child),
  );
}

class _BrandPanel extends StatelessWidget {
  final TextDirection textDirection;
  const _BrandPanel({required this.textDirection});

  @override
  Widget build(BuildContext context) {
    final foreground = Theme.of(context).colorScheme.onPrimary;
    return Directionality(
      textDirection: textDirection,
      child: Container(
        margin: const EdgeInsetsDirectional.only(end: 32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ColorsManager.primaryColor, ColorsManager.secondaryColor],
          ),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(Assets.logoApp, width: 72, height: 72),
            const SizedBox(height: 24),
            Text(
              'auth.brandName'.tr(),
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: foreground,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'auth.brandTagline'.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: foreground.withValues(alpha: .9),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
