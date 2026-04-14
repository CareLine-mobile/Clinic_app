// lib/features/auth/presentation/widgets/login_tab.dart

import 'package:clinic_app/core/utils/assets.dart';
import 'package:clinic_app/core/widgets/CustomIcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:clinic_app/core/theme/colors.dart';
import 'package:clinic_app/core/widgets/app_buton.dart';
import 'package:clinic_app/core/widgets/app_text_feild.dart';
import 'package:clinic_app/core/routes/routes.dart';
import 'package:clinic_app/core/utils/validators.dart';
import 'package:clinic_app/core/widgets/custom_snack_bar.dart';
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
              onPressed: () => Navigator.pushNamed(context, Routes.forgotPassword),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'auth.forgotPassword.title'.tr(),
                style: TextStyle(
                  color: ColorsManager.primaryColor,
                  fontSize: 13.sp,
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
          _buildGoogleSignInButton(),
          const SizedBox(height: 12),
          _buildGuestButton(),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (_, current) =>
      current is AuthFailure ||
          current is LoginSuccess ||
          current is AccountNotVerified,
      listener: (context, state) {
        if (state is AuthFailure) {
          _showErrorSnackBar(state.message);
        } else if (state is LoginSuccess) {
          Navigator.pushNamedAndRemoveUntil(context, Routes.dashBoard, (_) => false);
        } else if (state is AccountNotVerified) {
          Navigator.pushNamed(
            context,
            Routes.verification,
            arguments: {
              'email': state.email,
              'cubit': context.read<AuthCubit>(),
            },
          );
        }
      },
      builder: (context, state) {
        return AppButton(
          text: 'auth.login'.tr(),
          onPressed: state is AuthLoading ? null : _handleLogin,
          isLoading: state is AuthLoading,
          active: state is! GoogleLoginLoading,
          horizontalPadding: 0,
          verticalPadding: 0,
        );
      },
    );
  }

  // Google Sign-In Button Widget
  Widget _buildGoogleSignInButton() {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (_, current) =>
      current is AuthFailure || current is LoginSuccess,
      listener: (context, state) {
        if (state is AuthFailure) {
          _showErrorSnackBar(state.message);
        } else if (state is LoginSuccess) {
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.dashBoard, (_) => false);
        }
      },
      builder: (context, state) {
        final isGoogleLoading = state is GoogleLoginLoading;
        final isAnyLoading = state is AuthLoading || isGoogleLoading;

        return AppOutlinedButton(
          text: 'auth.signInWithGoogle'.tr(),
          onPressed: isAnyLoading ? null : _handleGoogleSignIn,
          isLoading: isGoogleLoading,
          active: !isAnyLoading,
          leadingWidget: const CustomIcon(assetPath: Assets.googleIcon, noColor: true,size: 20,),
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
            'auth.or'.tr(),
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
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

  void _handleGoogleSignIn() {
    context.read<AuthCubit>().googleLogin();
  }

  void _showErrorSnackBar(String message) {
    CustomSnackBar.show(context, message: message, type: SnackBarType.error);
  }
}