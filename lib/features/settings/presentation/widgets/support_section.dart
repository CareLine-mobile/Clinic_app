import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/app_size.dart';
import 'settings_card.dart';
import 'settings_item.dart';
import 'settings_section.dart';

class SupportSection extends StatelessWidget {
  const SupportSection({super.key});
//01068296803
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSection(title: 'settings.sections.support'.tr()),
        SettingsCard(
          children: [
            SettingsItem(
              icon: Icons.help_outline_rounded,
              title: 'settings.support.help'.tr(),
              subtitle: 'settings.support.help_sub'.tr(),
              onTap: () {},
            ),
            _divider(),
            SettingsItem(
              icon: Icons.phone_outlined,
              title: 'settings.support.contact'.tr(),
              subtitle: 'settings.support.contact_sub'.tr(),
              onTap: () {},
            ),
            _divider(),
            SettingsItem(
              icon: Icons.star_outline_rounded,
              title: 'settings.support.rate'.tr(),
              subtitle: 'settings.support.rate_sub'.tr(),
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _divider() => const Divider(height: 1, thickness: 1, indent: 68);
}