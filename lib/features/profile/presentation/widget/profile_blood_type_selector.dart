import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ProfileBloodTypeSelector extends StatelessWidget {
  final String? selected;
  final ValueChanged<String> onToggle;

  static const _bloodTypes = [
    'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'
  ];

  const ProfileBloodTypeSelector({
    Key? key,
    required this.selected,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(theme, 'profile.fields.bloodType'.tr()),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _bloodTypes.map((type) {
            final sel = selected == type;
            return InkWell(
              onTap: () => onToggle(type),
              borderRadius: BorderRadius.circular(8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 54,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: sel
                      ? theme.colorScheme.primary
                      : theme.inputDecorationTheme.fillColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: sel
                        ? theme.colorScheme.primary
                        : (theme.inputDecorationTheme.enabledBorder
                        ?.borderSide.color ??
                        Colors.grey.shade300),
                    width: sel ? 0 : 1,
                  ),
                ),
                child: Text(
                  type,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: sel ? Colors.white : theme.colorScheme.onSurface,
                    fontWeight: sel ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _fieldLabel(ThemeData theme, String text) {
    return Text(
      text,
      style: theme.textTheme.bodySmall?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
    );
  }
}