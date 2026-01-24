// ============================================
// LOGIN TAB
// lib/features/auth/presentation/widgets/login_tab.dart
// ============================================

import 'package:clinic_app/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../core/widgets/app_buton.dart';
import '../../../../../core/widgets/app_text_feild.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_state.dart';


class LoginTab extends StatefulWidget {
  const LoginTab({Key? key}) : super(key: key);

  @override
  State<LoginTab> createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthListener(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextFieldFactory.email(
                controller: _emailController,
                hintText: 'auth.email'.tr(),
                fillColor: Colors.white.withOpacity(0.15),
                focusedFillColor: Colors.white.withOpacity(0.15),
                validator: _validateEmail,
              ),
              const SizedBox(height: 16),
              AppTextFieldFactory.password(
                controller: _passwordController,
                hintText: 'auth.password'.tr(),
                focusedFillColor: Colors.white.withOpacity(0.15),
                validator: _validatePassword,
              ),
              const SizedBox(height: 24),
              _buildLoginButton(),
              const SizedBox(height: 16),
              _buildForgotPasswordButton(),
              const SizedBox(height: 24),
              const AuthDivider(),
              const SizedBox(height: 24),
              _buildGuestButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return AppButton(
          text: 'auth.login'.tr(),
          onPressed: _handleLogin,
          isLoading: state is AuthLoading,
          horizontalPadding: 0,
          verticalPadding: 0,
        );
      },
    );
  }

  Widget _buildForgotPasswordButton() {
    return TextButton(
      onPressed: () {
        // TODO: Navigate to forgot password
      },
      child: Text(
        'auth.forgotPassword'.tr(),
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildGuestButton() {
    return AppOutlinedButton(
      text: 'auth.continueAsGuest'.tr(),
      leadingIcon: Icons.person_outline,
      onPressed: _handleGuestLogin,
      horizontalPadding: 0,
      verticalPadding: 0,
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.emailRequired'.tr();
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'validation.emailInvalid'.tr();
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.passwordRequired'.tr();
    }
    if (value.length < 6) {
      return 'validation.passwordMinLength'.tr();
    }
    return null;
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  void _handleGuestLogin() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.dashBoard,
          (route) => false,
    );
  }
}

// ============================================
// AUTH DIVIDER WIDGET
// lib/features/auth/presentation/widgets/auth_divider.dart
// ============================================

class AuthDivider extends StatelessWidget {
  const AuthDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.white.withOpacity(0.3),
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.white.withOpacity(0.3),
            thickness: 1,
          ),
        ),
      ],
    );
  }
}

// ============================================
// AUTH LISTENER WIDGET
// lib/features/auth/presentation/widgets/auth_listener.dart
// ============================================

class AuthListener extends StatelessWidget {
  final Widget child;

  const AuthListener({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          _showLoadingDialog(context);
        } else if (state is LoginSuccess || state is AuthAuthenticated) {
          _dismissDialog(context);
          _navigateToDashboard(context);
        } else if (state is AuthFailure) {
          _dismissDialog(context);
          _showErrorSnackBar(context, state.message);
        }
      },
      child: child,
    );
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const CircularProgressIndicator(
            color: Color(0xFF667eea),
          ),
        ),
      ),
    );
  }

  void _dismissDialog(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  void _navigateToDashboard(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/dashboard',
          (route) => false,
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}