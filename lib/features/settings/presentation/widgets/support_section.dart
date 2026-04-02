import 'package:clinic_app/features/settings/presentation/widgets/settings_card.dart';
import 'package:clinic_app/features/settings/presentation/widgets/settings_item.dart';
import 'package:clinic_app/features/settings/presentation/widgets/settings_section.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_size.dart';

class SupportSection extends StatelessWidget {
  const SupportSection();

  @override
  Widget build(BuildContext context) {
    final vSize = AppSizeVertical.instance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSection(title: 'الدعم والمساعدة'),
        SizedBox(height: vSize.s12),
        SettingsCard(
          children: [
            SettingsItem(
              icon: Icons.help_outline,
              title: 'مركز المساعدة',
              subtitle: 'الأسئلة الشائعة والدعم',
              onTap: () {},
            ),
            const Divider(height: 1, thickness: 1),
            SettingsItem(
              icon: Icons.phone_outlined,
              title: 'تواصل معنا',
              subtitle: 'اتصل بفريق الدعم',
              onTap: () {},
            ),
            const Divider(height: 1, thickness: 1),
            SettingsItem(
              icon: Icons.star_outline,
              title: 'قيم التطبيق',
              subtitle: 'شاركنا رأيك',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}
