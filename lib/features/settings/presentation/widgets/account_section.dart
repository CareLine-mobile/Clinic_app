import 'package:clinic_app/features/settings/presentation/widgets/settings_card.dart';
import 'package:clinic_app/features/settings/presentation/widgets/settings_item.dart';
import 'package:clinic_app/features/settings/presentation/widgets/settings_section.dart';
import 'package:flutter/material.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/utils/app_size.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vSize = AppSizeVertical.instance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSection(title: 'الحساب'),
        SizedBox(height: vSize.s12),
        SettingsCard(
          children: [
            SettingsItem(
              icon: Icons.person_outline,
              title: 'الملف الشخصي',
              subtitle: 'عرض وتعديل معلوماتك الشخصية',
              onTap: () {
                Navigator.pushNamed(context, Routes.profile);
              },
            ),
            const Divider(height: 1, thickness: 1),
            SettingsItem(
              icon: Icons.lock_outline,
              title: 'تغيير كلمة المرور',
              subtitle: 'تحديث كلمة المرور الخاصة بك',
              onTap: () {},
            ),
            const Divider(height: 1, thickness: 1),
            SettingsItem(
              icon: Icons.calendar_today_outlined,
              title: 'حجوزاتي',
              subtitle: 'إدارة مواعيدك وحجوزاتك',
              onTap: () {},
            ),
            const Divider(height: 1, thickness: 1),
            SettingsItem(
              icon: Icons.medical_information_outlined,
              title: 'السجل الطبي',
              subtitle: 'تاريخك الطبي والزيارات السابقة',
              onTap: () {},
            ),
            const Divider(height: 1, thickness: 1),
            SettingsItem(
              icon: Icons.credit_card,
              title: 'طرق الدفع',
              subtitle: 'إدارة بطاقات الدفع',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}