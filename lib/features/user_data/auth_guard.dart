import 'package:clinic_app/features/user_data/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/routes.dart';

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
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'تسجيل الدخول مطلوب',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'هذه الخاصية تتطلب تسجيل الدخول.\nهل تريد تسجيل الدخول الآن؟',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('لاحقاً', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(context, Routes.auth);
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('تسجيل الدخول'),
          ),
        ],
      ),
    );
  }
}