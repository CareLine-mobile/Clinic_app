// lib/features/auth/presentation/pages/otp_verification_page.dart
import 'dart:async';
import 'package:clinic_app/core/widgets/CustomIcon.dart';
import 'package:clinic_app/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  static const int _cooldownSeconds = 60;

  final List<TextEditingController> _controllers =
  List.generate(_otpLength, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
  List.generate(_otpLength, (_) => FocusNode());

  Timer? _timer;
  int _secondsLeft = 0;
  bool get _isCoolingDown => _secondsLeft > 0;

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  String get _otpCode => _controllers.map((c) => c.text).join();
  bool get _isOtpComplete => _otpCode.length == _otpLength;

  void _startCooldown() {
    _timer?.cancel();
    setState(() => _secondsLeft = _cooldownSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

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
    if (_isCoolingDown) return;
    context.read<AuthCubit>().resendOtp(email: widget.email);
  }

  @override
  Widget build(BuildContext context) {
    // Detect tablet: width >= 600 logical pixels
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth >= 600;

    // Responsive horizontal padding: tighter on small phones, generous on tablets
    final double horizontalPadding = isTablet
        ? screenWidth * 0.15
        : screenWidth < 360
        ? 16
        : 24;

    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (_, current) =>
      current is OtpFailure ||
          current is OtpResendSuccess ||
          current is AuthAuthenticated ||
          current is LoginSuccess,
      listener: (context, state) {
        if (state is OtpFailure) {
          CustomSnackBar.show(
            context,
            message: state.message,
            type: SnackBarType.error,
          );
        } else if (state is OtpResendSuccess) {
          for (final c in _controllers) c.clear();
          _focusNodes.first.requestFocus();
          _startCooldown();
          CustomSnackBar.show(
            context,
            message: 'auth.otp.resend_success'.tr(),
            type: SnackBarType.success,
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
        final isVerifying = state is OtpLoading;
        final isResending = state is OtpResendLoading;

        return Scaffold(
          appBar: CustomAppBar(title: 'auth.otp.title'.tr()),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Use a centered constrained box on tablets
                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isTablet ? 520 : double.infinity,
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                        vertical: screenHeight * 0.04,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _OtpHeader(
                            email: widget.email,
                            isTablet: isTablet,
                            screenWidth: screenWidth,
                          ),
                          SizedBox(height: screenHeight * 0.05),
                          _OtpInputRow(
                            controllers: _controllers,
                            focusNodes: _focusNodes,
                            onChanged: _onDigitEntered,
                            onKeyEvent: _onKeyEvent,
                          ),
                          SizedBox(height: screenHeight * 0.045),
                          AppButton(
                            text: 'auth.otp.verify'.tr(),
                            onPressed:
                            (isVerifying || isResending || !_isOtpComplete)
                                ? null
                                : _handleVerify,
                            isLoading: isVerifying,
                            horizontalPadding: 0,
                            verticalPadding: 0,
                          ),
                          SizedBox(height: screenHeight * 0.025),
                          _ResendRow(
                            onResend:
                            (isVerifying || isResending || _isCoolingDown)
                                ? null
                                : _handleResend,
                            isResending: isResending,
                            secondsLeft: _secondsLeft,
                          ),
                          // Extra bottom spacing so keyboard doesn't cover content
                          SizedBox(
                            height: MediaQuery.of(context).viewInsets.bottom > 0
                                ? 24.h
                                : 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

// ─── Sub-Widgets ─────────────────────────────────────────────────────────────

class _OtpHeader extends StatelessWidget {
  final String email;
  final bool isTablet;
  final double screenWidth;

  const _OtpHeader({
    required this.email,
    required this.isTablet,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Icon size: 14% of screen width, clamped between 56–100 logical px
    final double iconSize = (screenWidth * 0.14).clamp(56.0, 100.0);

    return Column(
      children: [
        CustomIcon(
          assetPath: Assets.verifiedIcon,
          size: iconSize,
          color: theme.colorScheme.primary,
        ),
        SizedBox(height: 16.h),
        Text(
          'auth.otp.headline'.tr(),
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 24.sp : 20.sp,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8.h),
        Text(
          'auth.otp.subtitle'.tr(namedArgs: {'email': email}),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
            fontSize: isTablet ? 15.sp : 13.sp,
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
  final void Function(int, String) onChanged;
  final void Function(int, KeyEvent) onKeyEvent;

  const _OtpInputRow({
    required this.controllers,
    required this.focusNodes,
    required this.onChanged,
    required this.onKeyEvent,
  });

  @override
  Widget build(BuildContext context) {
    // Use LayoutBuilder so we know the EXACT available width at render time
    return Directionality(
      textDirection: TextDirection.ltr,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Total horizontal gap budget: 5 gaps between 6 cells + 2 outer padding
          const int cellCount = 6;
          const double gapUnit = 6.0; // gap between each cell
          final double totalGaps = gapUnit * (cellCount - 1);

          // Cell fills remaining space equally, clamped to safe extremes
          final double cellSize =
          ((constraints.maxWidth - totalGaps) / cellCount).clamp(36.0, 64.0);
          final double cellHeight = (cellSize * 1.2).clamp(44.0, 72.0);
          final double fontSize = (cellSize * 0.38).clamp(14.0, 24.0);

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(cellCount, (index) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _OtpDigitField(
                    controller: controllers[index],
                    focusNode: focusNodes[index],
                    onChanged: (v) => onChanged(index, v),
                    onKeyEvent: (e) => onKeyEvent(index, e),
                    cellWidth: cellSize,
                    cellHeight: cellHeight,
                    fontSize: fontSize,
                  ),
                  if (index < cellCount - 1) SizedBox(width: gapUnit),
                ],
              );
            }),
          );
        },
      ),
    );
  }
}

class _OtpDigitField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<KeyEvent> onKeyEvent;
  final double cellWidth;
  final double cellHeight;
  final double fontSize;

  const _OtpDigitField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onKeyEvent,
    required this.cellWidth,
    required this.cellHeight,
    required this.fontSize,
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
        width: widget.cellWidth,
        height: widget.cellHeight,
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
            fontSize: widget.fontSize,
          ),
          decoration: InputDecoration(
            counterText: '',
            contentPadding: EdgeInsets.zero,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide:
              BorderSide(color: theme.colorScheme.primary, width: 2),
            ),
            filled: true,
            fillColor: isFocused
                ? theme.colorScheme.primary.withValues(alpha: 0.05)
                : Colors.grey.shade50,
          ),
        ),
      ),
    );
  }
}

// ─── ResendRow ────────────────────────────────────────────────────────────────

class _ResendRow extends StatelessWidget {
  final VoidCallback? onResend;
  final bool isResending;
  final int secondsLeft;

  const _ResendRow({
    required this.onResend,
    required this.isResending,
    required this.secondsLeft,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCoolingDown = secondsLeft > 0;

    return Column(
      children: [
        Text(
          'auth.otp.noCode'.tr(),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade600,
            fontSize: 13.sp,
          ),
        ),
        SizedBox(height: 4.h),
        if (isCoolingDown)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontSize: 13.sp),
                children: [
                  TextSpan(
                    text: 'auth.otp.resend_in'.tr(),
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                  TextSpan(
                    text: ' $secondsLeft ',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'auth.otp.seconds'.tr(),
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          )
        else
          AppOutlinedButton(
            text: 'auth.otp.resend'.tr(),
            isLoading: isResending,
            active: onResend != null,
            onPressed: onResend ?? () {},
            verticalPadding: 4,
          ),
      ],
    );
  }
}