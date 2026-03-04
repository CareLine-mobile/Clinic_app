// lib/features/settings/presentation/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/widgets/app_buton.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../user_data/user_repo.dart';
import '../cubit/settings_cubit.dart';
import '../widgets/logout_button.dart';
import '../widgets/settings_card.dart';
import '../widgets/settings_header.dart';
import '../widgets/settings_item.dart';
import '../widgets/settings_section.dart';

// ════════════════════════════════════════════════════════════════════════════
// Root screen — orchestrates state listening only, zero UI logic
// ════════════════════════════════════════════════════════════════════════════

class SettingsTabScreen extends StatelessWidget {
  const SettingsTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      // React only when user becomes unauthenticated (after logout)
      listenWhen: (_, curr) => curr is AuthUnauthenticated,
      listener: (_, __) => Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.auth,
            (_) => false,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // UserRepository is a singleton — read .currentUser directly,
        // no BlocBuilder needed here
        body: _SettingsScrollView(
          user: UserRepository().currentUser,
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Scroll view — header + body
// ════════════════════════════════════════════════════════════════════════════

class _SettingsScrollView extends StatelessWidget {
  final User? user;

  const _SettingsScrollView({required this.user});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildHeader(),
        _SettingsBody(user: user),
      ],
    );
  }

  Widget _buildHeader() {
    if (user != null) {
      return SettingsHeader(
        userName: user!.name,
        userEmail: user!.email,
        userPhotoUrl: user!.avatar,
      );
    }
    return const SliverToBoxAdapter(child: _GuestBanner());
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Guest banner
// ════════════════════════════════════════════════════════════════════════════

class _GuestBanner extends StatelessWidget {
  const _GuestBanner();

  @override
  Widget build(BuildContext context) {
    final vSize = AppSizeVertical.instance;
    final hSize = AppSizeHorizontal.instance;
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: hSize.s16,
        vertical: vSize.s24,
      ),
      padding: EdgeInsets.all(hSize.s20),
      decoration: BoxDecoration(
        color: ColorsManager.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorsManager.primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(hSize.s12),
            decoration: BoxDecoration(
              color: ColorsManager.primaryColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person_outline, size: 32),
          ),
          SizedBox(width: hSize.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أهلاً بك كزائر',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: vSize.s4),
                Text(
                  'سجّل دخولك للاستفادة من كافة الخدمات',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.hintColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Settings body — all sections
// ════════════════════════════════════════════════════════════════════════════

class _SettingsBody extends StatelessWidget {
  final User? user;

  const _SettingsBody({required this.user});

  @override
  Widget build(BuildContext context) {
    final vSize = AppSizeVertical.instance;
    final hSize = AppSizeHorizontal.instance;

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(hSize.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user != null) ...[
              const _AccountSection(),
              SizedBox(height: vSize.s24),
            ],
            const _PreferencesSection(),
            SizedBox(height: vSize.s24),
            const _SupportSection(),
            SizedBox(height: vSize.s24),
            const _LegalSection(),
            SizedBox(height: vSize.s24),
            user != null ? const _LogoutButton() : const _GuestAuthButtons(),
            SizedBox(height: vSize.s50),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Account Section — authenticated only
// ════════════════════════════════════════════════════════════════════════════

class _AccountSection extends StatelessWidget {
  const _AccountSection();

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
              onTap: () {},
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

// ════════════════════════════════════════════════════════════════════════════
// Preferences Section — driven by SettingsCubit
// ════════════════════════════════════════════════════════════════════════════

class _PreferencesSection extends StatelessWidget {
  const _PreferencesSection();

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
// Support Section
// ════════════════════════════════════════════════════════════════════════════

class _SupportSection extends StatelessWidget {
  const _SupportSection();

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

// ════════════════════════════════════════════════════════════════════════════
// Legal Section
// ════════════════════════════════════════════════════════════════════════════

class _LegalSection extends StatelessWidget {
  const _LegalSection();

  @override
  Widget build(BuildContext context) {
    final vSize = AppSizeVertical.instance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Logout button — authenticated only
// ════════════════════════════════════════════════════════════════════════════

// Replace _LogoutButton in settings_screen.dart

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (prev, curr) =>
      curr is AuthLoading || curr is AuthAuthenticated || curr is AuthUnauthenticated,
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return AppButton(
          text: 'تسجيل الخروج',
          isLoading: isLoading,
          horizontalPadding: 0,
          verticalPadding: 0,
          onPressed: isLoading ? null : () => _confirm(context),
        );
      },
    );
  }

  void _confirm(BuildContext context) {
    // Capture before async gap — context may become invalid inside onConfirm
    final cubit = context.read<AuthCubit>();

    AppDialog.warning(
      context: context,
      title: 'تسجيل الخروج',
      message: 'هل أنت متأكد من تسجيل الخروج؟',
      confirmText: 'تسجيل الخروج',
      onConfirm: cubit.logout,
      // Navigation handled by BlocListener at root — no Navigator call here
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Guest auth buttons — not logged in
// ════════════════════════════════════════════════════════════════════════════

class _GuestAuthButtons extends StatelessWidget {
  const _GuestAuthButtons();

  @override
  Widget build(BuildContext context) {
    final vSize = AppSizeVertical.instance;
    return AppButton(
      text: 'تسجيل دخول',
      horizontalPadding: 0,
      verticalPadding: 0,
      onPressed: () => Navigator.pushNamed(context, Routes.auth),
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