import 'dart:developer';

import 'package:clinic_app/core/utils/assets.dart';
import 'package:clinic_app/core/widgets/CustomIcon.dart';
import 'package:clinic_app/core/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:clinic_app/core/widgets/app_buton.dart';
import 'package:clinic_app/core/widgets/app_text_feild.dart';
import 'package:clinic_app/core/routes/routes.dart';
import 'package:clinic_app/core/utils/validators.dart';
import '../../../../../core/utils/app_size.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_state.dart';

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
  final _v = AppSizeVertical.instance;
  final _h = AppSizeHorizontal.instance;
  final _t = TextSizeApp.instance;

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
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (_, current) =>
      current is AuthFailure || current is SignupSuccess || current is AuthAuthenticated,
      listener: (context, state) {
        if (state is AuthFailure) {
          _showErrorSnackBar(state.message);
        } else if (state is SignupSuccess) {
          CustomSnackBar.show(context, message: 'errors.server.accountNotVerified'.tr() ,type: SnackBarType.success);
          Navigator.pushNamed(
            context,
            Routes.verification,
            arguments: {
              'email': state.email,
              'cubit': context.read<AuthCubit>(),
            },
          );
        } else if (state is AuthAuthenticated) {
          Navigator.pushNamedAndRemoveUntil(context, Routes.dashBoard, (_) => false);
        }
      },
      builder: (context, state) {
        return Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTextField(
                  controller: _nameController,
                  hintText: 'auth.fullName'.tr(),
                  prefixIcon: Icon(Icons.person_outline, color: Colors.grey.shade500, size: 20),
                  validator: Validators.validateName,
                ),
                const SizedBox(height: 12),
                AppTextFieldFactory.email(
                  controller: _emailController,
                  hintText: 'auth.email'.tr(),
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  controller: _phoneController,
                  hintText: 'auth.phone'.tr(),
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icon(Icons.phone_outlined, color: Colors.grey.shade500, size: 20),
                  validator: Validators.validatePhone,
                ),
                const SizedBox(height: 12),
                AppTextFieldFactory.password(
                  controller: _passwordController,
                  hintText: 'auth.password'.tr(),
                  validator: Validators.validatePassword,
                ),
                const SizedBox(height: 12),
                AppTextFieldFactory.password(
                  controller: _confirmPasswordController,
                  hintText: 'auth.confirmPassword'.tr(),
                  validator: Validators.validateConfirmPassword(
                        () => _passwordController.text,
                  ),
                ),
                const SizedBox(height: 20),
                AppButton(
                  text: 'auth.createAccount'.tr(),
                  onPressed: state is AuthLoading ? null : _handleSignup,
                  isLoading: state is AuthLoading,
                  active: state is! GoogleLoginLoading && state is! AppleLoginLoading,
                  horizontalPadding: 0,
                  verticalPadding: 0,
                ),
                const SizedBox(height: 16),
                _buildDivider(),
                const SizedBox(height: 16),
                AppOutlinedButton(
                  text: 'auth.continueAsGuest'.tr(),
                  leadingWidget: CustomIcon(
                    assetPath: Assets.personIcon,
                    size: _h.s20,
                  ),
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(context, Routes.dashBoard, (_) => false),
                  horizontalPadding: 0,
                  verticalPadding: 0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: _h.s16),
          child: Text(
            'auth.or'.tr(),
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: _t.s12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300)),
      ],
    );
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

  void _showErrorSnackBar(String message) {
    CustomSnackBar.show(context, message: message,type: SnackBarType.error);
  }
}