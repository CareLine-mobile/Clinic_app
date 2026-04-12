import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:clinic_app/core/widgets/app_buton.dart';

class ProfileLoadErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ProfileLoadErrorView({
    Key? key,
    required this.message,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.cloud_off_rounded,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            AppButton(
              text: 'profile.actions.retry'.tr(),
              onPressed: onRetry,
              horizontalPadding: 0,
              verticalPadding: 0,
            ),
          ],
        ),
      ),
    );
  }
}