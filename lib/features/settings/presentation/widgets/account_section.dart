import 'package:clinic_app/features/user_data/user_repo.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/app_size.dart';
import 'settings_card.dart';
import 'settings_item.dart';
import 'settings_section.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final v = AppSizeVertical.instance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSection(title: 'settings.sections.account'.tr()),
        SettingsCard(
          children: [
            SettingsItem(
              icon: Icons.person_outline_rounded,
              title: 'settings.account.profile'.tr(),
              subtitle: 'settings.account.profile_sub'.tr(),
              onTap: () => Navigator.pushNamed(context, Routes.profile),
            ),
            _divider(),
            SettingsItem(
              icon: Icons.lock_outline_rounded,
              title: 'settings.account.change_password'.tr(),
              subtitle: 'settings.account.change_password_sub'.tr(),
              onTap: () {
                Navigator.pushNamed(context, Routes.forgotPassword,arguments: UserRepository().currentUser!.email);
              },
            ),

          ],
        ),
      ],
    );
  }

  Widget _divider() => const Divider(height: 1, thickness: 1, indent: 68);
}