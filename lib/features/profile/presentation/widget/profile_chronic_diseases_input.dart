import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ProfileChronicDiseasesInput extends StatelessWidget {
  final List<String> diseases;
  final TextEditingController addController;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  const ProfileChronicDiseasesInput({
    Key? key,
    required this.diseases,
    required this.addController,
    required this.onAdd,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final inputBorderColor =
        theme.inputDecorationTheme.enabledBorder?.borderSide.color ??
            Colors.grey.shade300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(theme, 'profile.fields.chronicDiseases'.tr()),
        const SizedBox(height: 10),
        if (diseases.isNotEmpty) ...[
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: diseases.map((d) {
              return Chip(
                label: Text(
                  d,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: 13,
                  ),
                ),
                deleteIcon: const Icon(Icons.close_rounded, size: 15),
                onDeleted: () => onRemove(d),
                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                deleteIconColor: theme.colorScheme.primary,
                side: BorderSide(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
        ],
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: addController,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => onAdd(),
                style: theme.textTheme.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'profile.fields.chronicHint'.tr(),
                  hintStyle:
                  TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  filled: true,
                  fillColor: theme.inputDecorationTheme.fillColor,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: inputBorderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: inputBorderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: onAdd,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 46,
                  height: 46,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
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