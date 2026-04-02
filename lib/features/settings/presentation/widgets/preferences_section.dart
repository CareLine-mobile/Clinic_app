import 'package:clinic_app/features/settings/presentation/widgets/settings_card.dart';
import 'package:clinic_app/features/settings/presentation/widgets/settings_item.dart';
import 'package:clinic_app/features/settings/presentation/widgets/settings_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_size.dart';
import '../cubit/settings_cubit.dart';

class PreferencesSection extends StatelessWidget {
  const PreferencesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vSize = AppSizeVertical.instance;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settings) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsSection(title: 'التفضيلات'),
            SizedBox(height: vSize.s12),
            SettingsCard(
              children: [
                SettingsItem(
                  icon: Icons.notifications_outlined,
                  title: 'الإشعارات',
                  subtitle: 'إدارة إشعارات التطبيق',
                  showArrow: false,
                  trailing: Switch(
                    value: settings.notificationsEnabled,
                    onChanged: (_) =>
                        context.read<SettingsCubit>().toggleNotifications(),
                    activeColor: ColorsManager.primaryColor,
                  ),
                ),
                const Divider(height: 1, thickness: 1),
                SettingsItem(
                  icon: Icons.language,
                  title: 'اللغة',
                  subtitle: settings.isArabic ? 'العربية' : 'English',
                  onTap: () => _showLanguageDialog(context, settings),
                ),
                const Divider(height: 1, thickness: 1),
                SettingsItem(
                  icon: Icons.dark_mode_outlined,
                  title: 'الوضع الداكن',
                  subtitle: settings.isDark ? 'مفعّل' : 'غير مفعّل',
                  showArrow: false,
                  trailing: Switch(
                    value: settings.isDark,
                    onChanged: (_) =>
                        context.read<SettingsCubit>().toggleTheme(),
                    activeColor: ColorsManager.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context, SettingsState settings) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('اختر اللغة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LanguageOption(
              title: 'العربية',
              value: 'ar',
              groupValue: settings.locale.languageCode,
              onTap: () {
                Navigator.pop(context);
                context.read<SettingsCubit>().changeLanguage(context, 'ar');
              },
            ),
            _LanguageOption(
              title: 'English',
              value: 'en',
              groupValue: settings.locale.languageCode,
              onTap: () {
                Navigator.pop(context);
                context.read<SettingsCubit>().changeLanguage(context, 'en');
              },
            ),
          ],
        ),
      ),
    );
  }
}
// ════════════════════════════════════════════════════════════════════════════
// Language option — used inside dialog only
// ════════════════════════════════════════════════════════════════════════════

class _LanguageOption extends StatelessWidget {
  final String title;
  final String value;
  final String groupValue;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Radio<String>(
        value: value,
        groupValue: groupValue,
        onChanged: (_) => onTap(),
        activeColor: ColorsManager.primaryColor,
      ),
      onTap: onTap,
    );
  }
}