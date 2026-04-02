import 'package:clinic_app/core/routes/routes.dart';
import 'package:clinic_app/core/widgets/confirmation_dialog.dart';
import 'package:clinic_app/features/home/presentation/widget/clinical_refresh_indicator.dart';
import 'package:clinic_app/features/settings/presentation/widgets/settings_card.dart';
import 'package:clinic_app/features/settings/presentation/widgets/settings_item.dart';
import 'package:clinic_app/features/settings/presentation/widgets/settings_section.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_size.dart';
import '../../../../core/widgets/custom_snack_bar.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';

class LegalSection extends StatelessWidget {
  const LegalSection({super.key});
  void closeDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    final vSize = AppSizeVertical.instance;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
          if (state is DeleteAccountSuccess) {
            closeDialog(context);
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.auth,
                  (route) => false,
            );
          }
          if (state is DeleteAccountFailure) {
            closeDialog(context);
            CustomSnackBar.show(
              context,
              message: state.message,
              type: SnackBarType.error,
            );
          }
          if (state is DeleteAccountLoading) {
            AppDialog.warning(context: context, message: 'جاري المسح');
          }
      },
      child: Column(
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
              const Divider(height: 1, thickness: 1),
              SettingsItem(
                icon: Icons.delete,
                title: 'مسح الحساب ',
                subtitle: 'تتطبق الشروط والاحكام',
                onTap: () {
                  AppDialog.warning(context: context,
                      message: 'هل انت متأكد من انك تريد حذف حسابك',
                      onConfirm: () {
                       context.read<AuthCubit>().deleteAccount();
                      },
                      confirmText: 'تأكيد');
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}