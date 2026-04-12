import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ProfileGenderSelector extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const ProfileGenderSelector({
    Key? key,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final genders = <String, String>{
      'Male': 'profile.gender.male'.tr(),
      'Female': 'profile.gender.female'.tr(),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(theme, 'profile.fields.gender'.tr()),
        const SizedBox(height: 8),
        Row(
          children: genders.entries.toList().asMap().entries.map((entry) {
            final idx = entry.key;
            final backendValue = entry.value.key;
            final displayLabel = entry.value.value;
            final selected = value == backendValue;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: idx == 0 ? 8 : 0),
                child: InkWell(
                  onTap: () => onChanged(backendValue.toLowerCase()),
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      color: selected
                          ? theme.colorScheme.primary.withOpacity(0.1)
                          : theme.inputDecorationTheme.fillColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? theme.colorScheme.primary
                            : (theme.inputDecorationTheme.enabledBorder
                            ?.borderSide.color ??
                            Colors.grey.shade300),
                        width: selected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio<String>(
                          value: backendValue,
                          groupValue: value,
                          onChanged: onChanged,
                          activeColor: theme.colorScheme.primary,
                          materialTapTargetSize:
                          MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                        Text(
                          displayLabel,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: selected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          backendValue == 'Male'
                              ? Icons.male_rounded
                              : Icons.female_rounded,
                          size: 18,
                          color: selected
                              ? theme.colorScheme.primary
                              : Colors.grey.shade500,
                        ),
                      ],
                    ),
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