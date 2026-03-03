// lib/features/auth/presentation/pages/otp_verification_page.dart
// ============================================
import 'package:clinic_app/core/widgets/CustomIcon.dart';
import 'package:clinic_app/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:clinic_app/core/widgets/app_buton.dart';
import 'package:clinic_app/core/widgets/custom_snack_bar.dart';
import 'package:clinic_app/core/routes/routes.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/assets.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email;

  const OtpVerificationPage({Key? key, required this.email}) : super(key: key);

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  static const int _otpLength = 6;

  final List<TextEditingController> _controllers =
  List.generate(_otpLength, (_) => TextEditingController());

  final List<FocusNode> _focusNodes =
  List.generate(_otpLength, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  String get _otpCode => _controllers.map((c) => c.text).join();

  bool get _isOtpComplete => _otpCode.length == _otpLength;

  void _onDigitEntered(int index, String value) {
    if (value.length == 1 && index < _otpLength - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _handleVerify() {
    if (!_isOtpComplete) return;
    context.read<AuthCubit>().verifyOtp(
      email: widget.email,
      otp: _otpCode,
    );
  }

  void _handleResend() {
    // TODO: wire up resend OTP use case
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (_, current) =>
      current is OtpFailure ||
          current is AuthAuthenticated,
      listener: (context, state) {
        if (state is OtpFailure) {
          CustomSnackBar.show(
            context,
            message: state.message,
            type: SnackBarType.error,
          );
        } else if (state is AuthAuthenticated || state is LoginSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            Routes.dashBoard,
                (_) => false,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is OtpLoading;

        return Scaffold(
          appBar: CustomAppBar(title: 'auth.otp.title'.tr()),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _OtpHeader(email: widget.email),
                  const SizedBox(height: 40),
                  _OtpInputRow(
                    controllers: _controllers,
                    focusNodes: _focusNodes,
                    onChanged: _onDigitEntered,
                    onKeyEvent: _onKeyEvent,
                  ),
                  const SizedBox(height: 36),
                  AppButton(
                    text: 'auth.otp.verify'.tr(),
                    onPressed:
                    (isLoading || !_isOtpComplete) ? null : _handleVerify,
                    isLoading: isLoading,
                    horizontalPadding: 0,
                    verticalPadding: 0,
                  ),
                  const SizedBox(height: 20),
                  _ResendRow(onResend: isLoading ? null : _handleResend),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Sub-Widgets ────────────────────────────────────────────────────────────

class _OtpHeader extends StatelessWidget {
  final String email;

  const _OtpHeader({required this.email});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        CustomIcon(
          assetPath: Assets.verifiedIcon,
          size: AppSizeVertical.instance.s70,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'auth.otp.headline'.tr(),
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'auth.otp.subtitle'.tr(namedArgs: {'email': email}),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _OtpInputRow extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final void Function(int index, String value) onChanged;
  final void Function(int index, KeyEvent event) onKeyEvent;

  const _OtpInputRow({
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
    required this.onKeyEvent,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Directionality لضمان إن الخانات دايماً من شمال لين
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(controllers.length, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: _OtpDigitField(
              controller: controllers[index],
              focusNode: focusNodes[index],
              onChanged: (value) => onChanged(index, value),
              onKeyEvent: (event) => onKeyEvent(index, event),
            ),
          );
        }),
      ),
    );
  }
}

class _OtpDigitField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<KeyEvent> onKeyEvent;

  const _OtpDigitField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onKeyEvent,
  });

  @override
  State<_OtpDigitField> createState() => _OtpDigitFieldState();
}

class _OtpDigitFieldState extends State<_OtpDigitField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() => setState(() {});

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFocused = widget.focusNode.hasFocus;

    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: widget.onKeyEvent,
      child: SizedBox(
        width: 48,
        height: 56,
        child: TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          maxLength: 1,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: widget.onChanged,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            counterText: '',
            contentPadding: EdgeInsets.zero,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: isFocused
                ? theme.colorScheme.primary.withOpacity(0.05)
                : Colors.grey.shade50,
          ),
        ),
      ),
    );
  }
}

class _ResendRow extends StatelessWidget {
  final VoidCallback? onResend;

  const _ResendRow({required this.onResend});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'auth.otp.noCode'.tr(),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
          ),
        ),
        TextButton(
          onPressed: onResend,
          child: Text(
            'auth.otp.resend'.tr(),
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}