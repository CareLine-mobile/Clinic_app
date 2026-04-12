import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:clinic_app/core/widgets/app_buton.dart';
import 'package:clinic_app/core/widgets/app_text_feild.dart';
import 'package:clinic_app/core/widgets/custom_app_bar.dart';
import 'package:clinic_app/core/widgets/custom_snack_bar.dart';
import 'package:clinic_app/core/routes/routes.dart';
import 'package:clinic_app/core/utils/validators.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String? initialEmail;

  const ForgotPasswordScreen({super.key, this.initialEmail});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;

  bool get _isLoggedIn => widget.initialEmail != null;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSend() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().sendForgotPassword(
      email: _emailController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (_, current) =>
      current is ForgotPasswordSuccess || current is ForgotPasswordFailure,
      listener: (context, state) {
        if (state is ForgotPasswordSuccess) {
          Navigator.pushNamed(
            context,
            Routes.resetPassword,
            arguments: state.email,
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
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(title: 'auth.forgotPassword.title'.tr()),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _ForgotHeader(),
                    const SizedBox(height: 32),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppTextFieldFactory.email(
                            controller: _emailController,
                            hintText: 'auth.email'.tr(),
                            validator: Validators.validateEmail,
                            readOnly: _isLoggedIn,
                          ),
                          const SizedBox(height: 24),

                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              final isLoading = state is ForgotPasswordLoading;
                              return AppButton(
                                text: 'auth.forgotPassword.send'.tr(),
                                onPressed: isLoading ? null : _handleSend,
                                isLoading: isLoading,
                                horizontalPadding: 0,
                                verticalPadding: 0,
                              );
                            },
                          ),
                          if (!_isLoggedIn) ...[
                            const SizedBox(height: 16),
                            AppOutlinedButton(
                              text: 'auth.forgotPassword.backToLogin'.tr(),
                              leadingIcon: Icons.arrow_back_rounded,
                              onPressed: () => Navigator.pop(context),
                              horizontalPadding: 0,
                              verticalPadding: 0,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ForgotHeader extends StatelessWidget {
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
            Icons.lock_outline_rounded,
            size: 36,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'auth.forgotPassword.headline'.tr(),
          style: theme.textTheme.headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'auth.forgotPassword.subtitle'.tr(),
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}