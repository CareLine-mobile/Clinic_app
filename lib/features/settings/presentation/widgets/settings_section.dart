import 'package:flutter/material.dart';
import '../../../../core/utils/app_size.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  const SettingsSection({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        right: AppSizeHorizontal.instance.s4,
        left: AppSizeHorizontal.instance.s4,
        bottom: AppSizeVertical.instance.s8,
      ),
      child: Text(
        title,
        style: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.hintColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}