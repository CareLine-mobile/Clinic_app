import 'package:clinic_app/features/user_data/user_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/widgets/confirmation_dialog.dart';

class AuthGuard {
  /// Returns true if user is logged in.
  /// If not — shows a dialog and returns false.
  /// Usage: if (!AuthGuard.check(context)) return;
  static bool check(BuildContext context) {
    final isLoggedIn = context.read<UserCubit>().isLoggedIn;
    if (!isLoggedIn) {
      _showLoginDialog(context);
      return false;
    }
    return true;
  }

  static void _showLoginDialog(BuildContext context) {
    showConfirmationDialog(
      context: context,
      icon: Icons.lock_outline_rounded,
      title: 'auth_guard.title'.tr(),
      message: 'auth_guard.message'.tr(),
      confirmText: 'common.login'.tr(),
      cancelText: 'auth_guard.later'.tr(),
      onConfirm: () => Navigator.pushNamed(context, Routes.auth),
    );
  }
}