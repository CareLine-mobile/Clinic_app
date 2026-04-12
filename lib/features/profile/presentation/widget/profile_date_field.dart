import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ProfileDateField extends StatelessWidget {
  final DateTime? value;
  final VoidCallback onTap;
  final String Function(DateTime) formatDate;

  const ProfileDateField({
    Key? key,
    required this.value,
    required this.onTap,
    required this.formatDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDate = value != null;
    final label = hasDate
        ? formatDate(value!)
        : 'profile.fields.dateOfBirth'.tr();
    final borderColor = hasDate
        ? theme.colorScheme.primary
        : (theme.inputDecorationTheme.enabledBorder?.borderSide.color ??
        Colors.grey.shade300);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: theme.inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: hasDate ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 20,
              color: hasDate
                  ? theme.colorScheme.primary
                  : Colors.grey.shade500,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: hasDate
                      ? theme.colorScheme.onSurface
                      : Colors.grey.shade500,
                ),
              ),
            ),
            Icon(Icons.arrow_drop_down_rounded, color: Colors.grey.shade500),
          ],
        ),
      ),
    );
  }
}