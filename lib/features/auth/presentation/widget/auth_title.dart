// ============================================
// AUTH TITLE - Simplified Animation
// lib/features/auth/presentation/widgets/auth_title.dart
// ============================================

import 'package:clinic_app/core/utils/app_size.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/app_text_widgets.dart';

class AuthTitle extends StatelessWidget {
  final bool isLogin;

  const AuthTitle({
    super.key,
    required this.isLogin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Column(
        key: ValueKey<bool>(isLogin),
        children: [
          // Text(
          //   isLogin ? 'auth.welcomeBack'.tr() : 'auth.createAccountTitle'.tr(),
          //   textAlign: TextAlign.center,
          //   style: theme.textTheme.headlineSmall?.copyWith(
          //     fontWeight: FontWeight.bold,
          //     color: theme.colorScheme.onSurface, // متوافق مع الوضع الداكن/الفاتح
          //   ),
          // ),
          HeadlineText(
            isLogin ? 'auth.welcomeBack'.tr() : 'auth.createAccountTitle'.tr(),
            textAlign: TextAlign.center,

          ),
           SizedBox(height: AppSizeVertical.instance.s8),
          // Text(
          //   isLogin ? 'auth.loginSubtitle'.tr() : 'auth.signupSubtitle'.tr(),
          //   textAlign: TextAlign.center,
          //   style: theme.textTheme.bodyMedium?.copyWith(
          //     color: theme.colorScheme.onSurfaceVariant, // لون رمادي يتكيف مع النظام
          //     height: 1.5,
          //   ),
          // ),
          HeadlineText(
            isLogin ? 'auth.loginSubtitle'.tr() : 'auth.signupSubtitle'.tr(),
            textAlign: TextAlign.center,

          )
        ],
      ),
    );
  }
}