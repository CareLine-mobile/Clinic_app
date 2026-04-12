import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileGenderSelector extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const ProfileGenderSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // البيانات (استخدام Dart Records)
    final genders = [
      (id: 'male', label: 'profile.gender.male'.tr(), icon: Icons.male_rounded),
      (id: 'female', label: 'profile.gender.female'.tr(), icon: Icons.female_rounded),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'profile.fields.gender'.tr(),
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 12.h),

        // استخدام Collection For لوضع SizedBox بين العناصر بأمان تام مع اللغتين
        Row(
          children: [
            for (int i = 0; i < genders.length; i++) ...[
              Expanded(
                child: _buildGenderCard(
                  context: context,
                  theme: theme,
                  gender: genders[i],
                  isSelected: value?.toLowerCase() == genders[i].id,
                ),
              ),
              // وضع مسافة بين العناصر فقط (ولا نضعها بعد العنصر الأخير)
              if (i != genders.length - 1) SizedBox(width: 12.w),
            ]
          ],
        ),
      ],
    );
  }

  Widget _buildGenderCard({
    required BuildContext context,
    required ThemeData theme,
    required dynamic gender,
    required bool isSelected,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onChanged(gender.id),
        borderRadius: BorderRadius.circular(12.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withOpacity(0.08)
                : theme.inputDecorationTheme.fillColor ?? Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.dividerColor.withOpacity(0.4),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                gender.icon,
                size: 20.sp,
                color: isSelected
                    ? theme.colorScheme.primary
                    : Colors.grey.shade500,
              ),
              SizedBox(width: 8.w),
              Text(
                gender.label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}