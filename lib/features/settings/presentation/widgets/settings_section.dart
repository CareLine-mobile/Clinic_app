import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_size.dart';

class SettingsSection extends StatelessWidget {
  final String title;

  const SettingsSection({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeApp.s4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: SizeApp.s16,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : ColorsManager.defaultText,
        ),
      ),
    );
  }
}
