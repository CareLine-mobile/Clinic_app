// lib/features/auth/presentation/widgets/login_tab.dart

import 'package:clinic_app/core/utils/assets.dart';
import 'package:clinic_app/core/widgets/CustomIcon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:clinic_app/core/theme/colors.dart';
import 'package:clinic_app/core/widgets/app_buton.dart';
import 'package:clinic_app/core/widgets/app_text_feild.dart';
import 'package:clinic_app/core/routes/routes.dart';
import 'package:clinic_app/core/utils/validators.dart';
import 'package:clinic_app/core/widgets/custom_snack_bar.dart';
import 'package:clinic_app/core/utils/app_size.dart';
import '../../cubit/auth_cubit.dart';
import '../../cubit/auth_state.dart';
import 'package:clinic_app/features/settings/presentation/cubit/settings_cubit.dart';

class LoginTab extends StatefulWidget {
  const LoginTab({Key? key}) : super(key: key);

  @override
  State<LoginTab> createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _v = AppSizeVertical.instance;
  final _h = AppSizeHorizontal.instance;
  final _t = TextSizeApp.instance;

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
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: _v.s8),
            AppTextFieldFactory.email(
              controller: _emailController,
              hintText: 'auth.email'.tr(),
              validator: Validators.validateEmail,
            ),
            SizedBox(height: _v.s16),
            AppTextFieldFactory.password(
              controller: _passwordController,
              hintText: 'auth.password'.tr(),
              validator: Validators.validatePassword,
            ),
            SizedBox(height: _v.s12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pushNamed(context, Routes.forgotPassword),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: _h.s8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'auth.forgotPassword.title'.tr(),
                  style: TextStyle(
                    color: ColorsManager.primaryColor,
                    fontSize: _t.s12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: _v.s16),
            _buildLoginButton(),
            SizedBox(height: _v.s20),
            _buildDivider(),
            SizedBox(height: _v.s20),
            _buildGoogleSignInButton(),
            SizedBox(height: _v.s12),
            _buildGuestButton(),
          ],
        ),
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
          context.read<SettingsCubit>().syncFcmToken();
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.dashBoard, (_) => false);
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

  Widget _buildGoogleSignInButton() {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (_, current) =>
      current is AuthFailure || current is LoginSuccess,
      listener: (context, state) {
        if (state is AuthFailure) {
          _showErrorSnackBar(state.message);
        } else if (state is LoginSuccess) {
          context.read<SettingsCubit>().syncFcmToken();
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
          horizontalPadding: 0,
          verticalPadding: 0,
          leadingWidget: CustomIcon(
            assetPath: Assets.googleIcon,
            noColor: true,
            size: _h.s20,
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

  Widget _buildGuestButton() {
    return AppOutlinedButton(
      text: 'auth.continueAsGuest'.tr(),
      onPressed: () => Navigator.pushNamedAndRemoveUntil(
          context, Routes.dashBoard, (_) => false),
      horizontalPadding: 0,
      verticalPadding: 0,
      leadingWidget: CustomIcon(
        assetPath: Assets.personIcon,
        size: _h.s20,
      ),
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