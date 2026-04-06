import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/app_buton.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';

class LogoutSection extends StatelessWidget {
  const LogoutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (prev, curr) =>
      curr is AuthLoading ||
          curr is AuthAuthenticated ||
          curr is AuthUnauthenticated,
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return AppOutlinedButton(
          text: 'settings.logout'.tr(),
          isLoading: isLoading,
          active: !isLoading,
          horizontalPadding: 0,
          verticalPadding: 0,
          onPressed: isLoading ? null : () => _confirm(context),
        );
      },
    );
  }

  void _confirm(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    AppDialog.warning(
      context: context,
      title: 'settings.logout'.tr(),
      message: 'settings.logout_confirm'.tr(),
      confirmText: 'settings.logout'.tr(),
      onConfirm: cubit.logout,
    );
  }
}