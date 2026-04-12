import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ProfileProgressSection extends StatelessWidget {
  final ValueNotifier<double> progressNotifier;
  final Color Function(double value, ThemeData theme) progressColor;
  final String Function(int completed) progressHint;

  const ProfileProgressSection({
    Key? key,
    required this.progressNotifier,
    required this.progressColor,
    required this.progressHint,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.15),
        ),
      ),
      child: Column(
        children: [
          Text(
            'profile.completion.title'.tr(),
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 20),
          ValueListenableBuilder<double>(
            valueListenable: progressNotifier,
            builder: (_, progress, __) {
              final completed = (progress * 5).round();
              return Column(
                children: [
                  SizedBox(
                    width: 136,
                    height: 136,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Track ring
                        SizedBox.expand(
                          child: CircularProgressIndicator(
                            value: 1.0,
                            strokeWidth: 10,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.dividerColor.withOpacity(0.25),
                            ),
                          ),
                        ),
                        // Animated fill ring
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: progress),
                          duration: const Duration(milliseconds: 650),
                          curve: Curves.easeOutCubic,
                          builder: (_, v, __) => SizedBox.expand(
                            child: CircularProgressIndicator(
                              value: v,
                              strokeWidth: 10,
                              strokeCap: StrokeCap.round,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                progressColor(v, theme),
                              ),
                            ),
                          ),
                        ),
                        // Animated percentage counter
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: progress),
                          duration: const Duration(milliseconds: 650),
                          curve: Curves.easeOutCubic,
                          builder: (_, v, __) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${(v * 100).toInt()}%',
                                style:
                                theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: progressColor(v, theme),
                                ),
                              ),
                              Text(
                                'profile.completion.done'.tr(),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'profile.completion.of5'
                        .tr(namedArgs: {'filled': '$completed'}),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (progress < 1.0 && completed < 5) ...[
                    const SizedBox(height: 6),
                    Text(
                      progressHint(completed),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: progressColor(progress, theme),
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}