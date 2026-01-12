// lib/features/settings/presentation/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_size.dart';
import '../widgets/settings_header.dart';
import '../widgets/settings_section.dart';
import '../widgets/settings_item.dart';
import '../widgets/settings_card.dart';
import '../widgets/logout_button.dart';

class SettingsTabScreen extends StatelessWidget {
  const SettingsTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final vSize = AppSizeVertical.instance;
    final hSize = AppSizeHorizontal.instance;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // Header with Profile Card
          SettingsHeader(
            userName: 'أحمد محمد',
            userEmail: 'ahmed@example.com',
            userPhotoUrl: null,
          ),

          // Settings Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(hSize.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Account Section
                  SettingsSection(title: 'الحساب'),
                  SizedBox(height: vSize.s12),
                  SettingsCard(
                    children: [
                      SettingsItem(
                        icon: Icons.person_outline,
                        title: 'الملف الشخصي',
                        subtitle: 'عرض وتعديل معلوماتك الشخصية',
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

                  SizedBox(height: vSize.s24),

                  // Preferences Section
                  SettingsSection(title: 'التفضيلات'),
                  SizedBox(height: vSize.s12),
                  SettingsCard(
                    children: [
                      SettingsItem(
                        icon: Icons.notifications_outlined,
                        title: 'الإشعارات',
                        subtitle: 'إدارة إشعارات التطبيق',
                        trailing: Switch(
                          value: true,
                          onChanged: (value) {},
                          activeColor: ColorsManager.primaryColor,
                        ),
                        showArrow: false,
                      ),
                      const Divider(height: 1, thickness: 1),
                      SettingsItem(
                        icon: Icons.language,
                        title: 'اللغة',
                        subtitle: 'العربية',
                        onTap: () => _showLanguageDialog(context),
                      ),
                      const Divider(height: 1, thickness: 1),
                      SettingsItem(
                        icon: Icons.dark_mode_outlined,
                        title: 'الوضع الداكن',
                        subtitle: 'تفعيل الوضع الداكن',
                        trailing: Switch(
                          value: isDark,
                          onChanged: (value) {},
                          activeColor: ColorsManager.primaryColor,
                        ),
                        showArrow: false,
                      ),
                    ],
                  ),

                  SizedBox(height: vSize.s24),

                  // Support Section
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

                  SizedBox(height: vSize.s24),

                  // Legal Section
                  SettingsSection(title: 'القانونية'),
                  SizedBox(height: vSize.s12),
                  SettingsCard(
                    children: [
                      SettingsItem(
                        icon: Icons.description_outlined,
                        title: 'الشروط والأحكام',
                        subtitle: 'شروط استخدام التطبيق',
                        onTap: () {},
                      ),
                      const Divider(height: 1, thickness: 1),
                      SettingsItem(
                        icon: Icons.privacy_tip_outlined,
                        title: 'سياسة الخصوصية',
                        subtitle: 'كيف نحمي بياناتك',
                        onTap: () {},
                      ),
                      const Divider(height: 1, thickness: 1),
                      SettingsItem(
                        icon: Icons.info_outline,
                        title: 'حول التطبيق',
                        subtitle: 'الإصدار 1.0.0',
                        onTap: () {},
                      ),
                    ],
                  ),

                  SizedBox(height: vSize.s24),

                  // Logout Button
                  LogoutButton(
                    onTap: () => _showLogoutDialog(context),
                  ),

                  SizedBox(height: vSize.s50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختر اللغة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _LanguageOption(
              title: 'العربية',
              value: 'ar',
              groupValue: 'ar',
              onTap: () => Navigator.pop(context),
            ),
            _LanguageOption(
              title: 'English',
              value: 'en',
              groupValue: 'ar',
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement logout logic
            },
            child: const Text(
              'تسجيل الخروج',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

// Language Option Widget
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
      leading: Radio(
        value: value,
        groupValue: groupValue,
        onChanged: (val) {},
        activeColor: ColorsManager.primaryColor,
      ),
      onTap: onTap,
    );
  }
}