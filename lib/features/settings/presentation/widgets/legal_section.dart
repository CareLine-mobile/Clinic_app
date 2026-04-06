import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/custom_snack_bar.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import 'settings_card.dart';
import 'settings_item.dart';
import 'settings_section.dart';

class LegalSection extends StatelessWidget {
  const LegalSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is DeleteAccountSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context, Routes.auth, (_) => false,
          );
        }
        if (state is DeleteAccountFailure) {
          CustomSnackBar.show(
            context,
            message: state.message,
            type: SnackBarType.error,
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsSection(title: 'settings.sections.legal'.tr()),
          SettingsCard(
            children: [
              SettingsItem(
                icon: Icons.description_outlined,
                title: 'settings.legal.terms'.tr(),
                subtitle: 'settings.legal.terms_sub'.tr(),
                onTap: () {},
              ),
              _divider(),
              SettingsItem(
                icon: Icons.privacy_tip_outlined,
                title: 'settings.legal.privacy'.tr(),
                subtitle: 'settings.legal.privacy_sub'.tr(),
                onTap: () {},
              ),
              _divider(),
              SettingsItem(
                icon: Icons.info_outline_rounded,
                title: 'settings.legal.about'.tr(),
                subtitle: 'settings.legal.version'.tr(),
                onTap: () {},
              ),
              _divider(),
              // ─── Delete account — red icon ──────────────────────
              SettingsItem(
                icon: Icons.delete_outline_rounded,
                iconColor: const Color(0xFFC62828),
                iconBgColor: const Color(0xFFFFEBEE),
                title: 'settings.legal.delete_account'.tr(),
                subtitle: 'settings.legal.delete_account_sub'.tr(),
                onTap: () => _confirmDelete(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(height: 1, thickness: 1, indent: 68);

  void _confirmDelete(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    AppDialog.warning(
      context: context,
      title: 'settings.legal.delete_account'.tr(),
      message: 'settings.legal.delete_confirm'.tr(),
      confirmText: 'settings.legal.delete_yes'.tr(),
      onConfirm: cubit.deleteAccount,
    );
  }
}