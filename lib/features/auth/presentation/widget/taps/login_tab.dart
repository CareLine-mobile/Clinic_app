import 'dart:developer';

import 'package:clinic_app/core/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:clinic_app/core/theme/colors.dart';
import 'package:clinic_app/core/widgets/app_buton.dart';
import 'package:clinic_app/core/widgets/app_text_feild.dart';
import 'package:clinic_app/core/routes/routes.dart';
import 'package:clinic_app/core/utils/validators.dart';
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          AppTextFieldFactory.email(
            controller: _emailController,
            hintText: 'auth.email'.tr(),
            validator: Validators.validateEmail,
          ),
          const SizedBox(height: 16),
          AppTextFieldFactory.password(
            controller: _passwordController,
            hintText: 'auth.password'.tr(),
            validator: Validators.validatePassword,
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'auth.forgotPassword'.tr(),
                style: TextStyle(
                  color: ColorsManager.primaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildLoginButton(),
          const SizedBox(height: 20),
          _buildDivider(),
          const SizedBox(height: 20),
          _buildGuestButton(),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (_, current) => current is AuthFailure || current is LoginSuccess,
      listener: (context, state) {
        if (state is AuthFailure) {
          log(state.message);
          _showErrorSnackBar(state.message);
        } else if (state is LoginSuccess) {
          Navigator.pushNamedAndRemoveUntil(context, Routes.dashBoard, (_) => false);
        }
      },
      builder: (context, state) {
        return AppButton(
          text: 'auth.login'.tr(),
          onPressed: state is AuthLoading ? null : _handleLogin,
          isLoading: state is AuthLoading,
          horizontalPadding: 0,
          verticalPadding: 0,
        );
      },
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300)),
      ],
    );
  }

  Widget _buildGuestButton() {
    return AppOutlinedButton(
      text: 'auth.continueAsGuest'.tr(),
      leadingIcon: Icons.person_outline,
      onPressed: () => Navigator.pushNamedAndRemoveUntil(context, Routes.dashBoard, (_) => false),
      horizontalPadding: 0,
      verticalPadding: 0,
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  void _showErrorSnackBar(String message) {
    CustomSnackBar.show(context, message: message,type: SnackBarType.error);
  }
}