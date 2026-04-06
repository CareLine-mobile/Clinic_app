import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_size.dart';
import '../cubit/settings_cubit.dart';
import 'settings_card.dart';
import 'settings_item.dart';
import 'settings_section.dart';

class PreferencesSection extends StatelessWidget {
  const PreferencesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final v = AppSizeVertical.instance;

    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settings) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsSection(title: 'settings.sections.preferences'.tr()),
            SettingsCard(
              children: [
                // ─── Notifications ──────────────────────────────
                SettingsItem(
                  icon: Icons.notifications_outlined,
                  title: 'settings.preferences.notifications'.tr(),
                  subtitle: 'settings.preferences.notifications_sub'.tr(),
                  showArrow: false,
                  trailing: Switch(
                    value: settings.notificationsEnabled,
                    onChanged: (_) =>
                        context.read<SettingsCubit>().toggleNotifications(),
                    activeColor: ColorsManager.primaryColor,
                  ),
                ),
                _divider(),

                // ─── Language ───────────────────────────────────
                SettingsItem(
                  icon: Icons.language_rounded,
                  title: 'settings.preferences.language'.tr(),
                  subtitle: settings.isArabic
                      ? 'settings.preferences.arabic'.tr()
                      : 'settings.preferences.english'.tr(),
                  onTap: () => _showLanguageDialog(context, settings),
                ),
                _divider(),

                // ─── Dark mode ──────────────────────────────────
                SettingsItem(
                  icon: settings.isDark
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  title: 'settings.preferences.dark_mode'.tr(),
                  subtitle: settings.isDark
                      ? 'settings.preferences.dark_on'.tr()
                      : 'settings.preferences.dark_off'.tr(),
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

  Widget _divider() => const Divider(height: 1, thickness: 1, indent: 68);

  void _showLanguageDialog(BuildContext context, SettingsState settings) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('settings.preferences.choose_language'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LangOption(
              title: 'settings.preferences.arabic'.tr(),
              value: 'ar',
              groupValue: settings.locale.languageCode,
              onTap: () {
                Navigator.pop(context);
                context.read<SettingsCubit>().changeLanguage(context, 'ar');
              },
            ),
            _LangOption(
              title: 'settings.preferences.english'.tr(),
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

class _LangOption extends StatelessWidget {
  final String title;
  final String value;
  final String groupValue;
  final VoidCallback onTap;

  const _LangOption({
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
      contentPadding: EdgeInsets.zero,
    );
  }
}