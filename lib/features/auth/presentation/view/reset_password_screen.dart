// lib/features/auth/presentation/pages/reset_password_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:clinic_app/core/widgets/app_buton.dart';
import 'package:clinic_app/core/widgets/app_text_feild.dart';
import 'package:clinic_app/core/widgets/custom_app_bar.dart';
import 'package:clinic_app/core/widgets/custom_snack_bar.dart';
import 'package:clinic_app/core/routes/routes.dart';
import 'package:clinic_app/core/utils/validators.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  const ResetPasswordScreen({Key? key, required this.email}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {

    _otpController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }


  void _handleReset() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().resetPassword(
      email: widget.email,
      otp: _otpController.text.trim(),
      newPassword: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (_, current) =>
      current is ResetPasswordSuccess ||
          current is ResetPasswordFailure ||
          current is ForgotPasswordSuccess ||
          current is ForgotPasswordFailure,
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          CustomSnackBar.show(
            context,
            message: 'auth.resetPassword.success'.tr(),
            type: SnackBarType.success,
          );
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.auth, (_) => false);
        } else if (state is ResetPasswordFailure) {
          CustomSnackBar.show(
            context,
            message: state.message,
            type: SnackBarType.error,
          );
        } else if (state is ForgotPasswordSuccess) {
          _otpController.clear();
          CustomSnackBar.show(
            context,
            message: 'auth.otp.resend_success'.tr(),
            type: SnackBarType.success,
          );
        } else if (state is ForgotPasswordFailure) {
          CustomSnackBar.show(
            context,
            message: state.message,
            type: SnackBarType.error,
          );
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(title: 'auth.resetPassword.title'.tr()),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _ResetHeader(email: widget.email),
                      const SizedBox(height: 32),

                      // ─── OTP text field ──────────────────────────────
                      AppTextField(
                        controller: _otpController,
                        hintText: 'auth.resetPassword.subtitle'.tr(),
                        keyboardType: TextInputType.number,
                        prefixIcon: Icon(
                          Icons.pin_outlined,
                          color: Colors.grey.shade500,
                          size: 20,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'auth.resetPassword.otpRequired'.tr();
                          }
                          if (value.length != 6) {
                            return 'auth.resetPassword.otpInvalid'.tr();
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),
                      // ─── New password ────────────────────────────────
                      AppTextFieldFactory.password(
                        controller: _passwordController,
                        hintText: 'auth.resetPassword.newPassword'.tr(),
                        validator: Validators.validatePassword,
                      ),
                      const SizedBox(height: 16),

                      // ─── Confirm password ────────────────────────────
                      AppTextFieldFactory.password(
                        controller: _confirmController,
                        hintText: 'auth.confirmPassword'.tr(),
                        validator: Validators.validateConfirmPassword(
                              () => _passwordController.text,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // ─── Submit ──────────────────────────────────────
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          final isLoading = state is ResetPasswordLoading;
                          return AppButton(
                            text: 'auth.resetPassword.submit'.tr(),
                            onPressed: isLoading ? null : _handleReset,
                            isLoading: isLoading,
                            horizontalPadding: 0,
                            verticalPadding: 0,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────

class _ResetHeader extends StatelessWidget {
  final String email;
  const _ResetHeader({required this.email});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.lock_reset_rounded,
            size: 36,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'auth.resetPassword.headline'.tr(),
          style: theme.textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'auth.resetPassword.subtitle'.tr(),
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
