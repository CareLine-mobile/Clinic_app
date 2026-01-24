// ============================================
// SIGNUP TAB
// lib/features/auth/presentation/widgets/signup_tab.dart
// ============================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/widgets/app_buton.dart';
import '../../../../../core/widgets/app_text_feild.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_state.dart';
import 'login_tab.dart';


class SignupTab extends StatefulWidget {
  const SignupTab({Key? key}) : super(key: key);

  @override
  State<SignupTab> createState() => _SignupTabState();
}

class _SignupTabState extends State<SignupTab> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SignupListener(
      emailController: _emailController,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              AppTextField(
                controller: _nameController,
                hintText: 'auth.fullName'.tr(),
                fillColor: Colors.white.withOpacity(0.15),
                focusedFillColor: Colors.white.withOpacity(0.15),
                prefixIcon: Icon(
                  Icons.person_outline,
                  color: Colors.white.withOpacity(0.7),
                ),
                validator: _validateName,
              ),
              const SizedBox(height: 16),
              AppTextFieldFactory.email(
                controller: _emailController,
                hintText: 'auth.email'.tr(),
                fillColor: Colors.white.withOpacity(0.15),
                focusedFillColor: Colors.white.withOpacity(0.15),
                validator: _validateEmail,
              ),
              const SizedBox(height: 16),
              AppTextField(
                controller: _phoneController,
                hintText: 'auth.phone'.tr(),
                fillColor: Colors.white.withOpacity(0.15),
                focusedFillColor: Colors.white.withOpacity(0.15),
                keyboardType: TextInputType.phone,
                prefixIcon: Icon(
                  Icons.phone_outlined,
                  color: Colors.white.withOpacity(0.7),
                ),
                validator: _validatePhone,
              ),
              const SizedBox(height: 16),
              AppTextFieldFactory.password(
                controller: _passwordController,
                hintText: 'auth.password'.tr(),

                focusedFillColor: Colors.white.withOpacity(0.15),
                validator: _validatePassword,
              ),
              const SizedBox(height: 16),
              AppTextFieldFactory.password(
                controller: _confirmPasswordController,
                hintText: 'auth.confirmPassword'.tr(),

                focusedFillColor: Colors.white.withOpacity(0.15),
                validator: _validateConfirmPassword,
              ),
              const SizedBox(height: 24),
              _buildSignupButton(),
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

  Widget _buildSignupButton() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return AppButton(
          text: 'auth.createAccount'.tr(),
          onPressed: _handleSignup,
          isLoading: state is AuthLoading,
          horizontalPadding: 0,
          verticalPadding: 0,
        );
      },
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

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.nameRequired'.tr();
    }
    return null;
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

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.phoneRequired'.tr();
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

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) {
      return 'validation.passwordMismatch'.tr();
    }
    return null;
  }

  void _handleSignup() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().signup(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  void _handleGuestLogin() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/dashboard',
          (route) => false,
    );
  }
}

// ============================================
// SIGNUP LISTENER WIDGET
// lib/features/auth/presentation/widgets/signup_listener.dart
// ============================================

class SignupListener extends StatelessWidget {
  final Widget child;
  final TextEditingController emailController;

  const SignupListener({
    Key? key,
    required this.child,
    required this.emailController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          _showLoadingDialog(context);
        } else if (state is SignupSuccess) {
          _dismissDialog(context);
          // Navigate to OTP verification with email
          Navigator.pushNamed(
            context,
            '/otp-verification',
            arguments: {
              'email': emailController.text.trim(),
            },
          );
        } else if (state is AuthAuthenticated) {
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
            color: Color(0xFFF5576C),
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