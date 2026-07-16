// lib/features/configuration/presentation/view/configuration_screen.dart

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/db/shared_pref_helper.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_constans.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/widgets/app_buton.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';

class ConfigurationScreen extends StatefulWidget {
  const ConfigurationScreen({Key? key}) : super(key: key);

  @override
  State<ConfigurationScreen> createState() => _ConfigurationScreenState();
}

class _ConfigurationScreenState extends State<ConfigurationScreen>
    with SingleTickerProviderStateMixin {
  // Local selections — committed only when user taps "Get Started"
  String _selectedLang = 'ar';
  bool _selectedDark = false;
  bool _isSaving = false;

  late final AnimationController _animCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  bool get _isArabic => _selectedLang == 'ar';

  Color get _bgColor =>
      _selectedDark ? ColorsManager.darkColor : ColorsManager.defaultSurface;

  Color get _cardColor =>
      _selectedDark ? ColorsManager.secondaryDarkColor : Colors.white;

  Color get _textPrimary =>
      _selectedDark ? Colors.white : ColorsManager.defaultText;

  Color get _textSecondary =>
      _selectedDark ? Colors.white60 : ColorsManager.defaultTextSecondary;

  // ── Save & navigate ───────────────────────────────────────────────────────

  Future<void> _onGetStarted() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    final cubit = context.read<SettingsCubit>();

    // Persist language via SettingsCubit (also calls easy_localization setLocale)
    await cubit.changeLanguage(context, _selectedLang);

    // Sync theme if the selection differs from current state
    if (cubit.state.isDark != _selectedDark) {
      await cubit.toggleTheme();
    }

    // Mark configuration as done — will never show again
    await SharedPrefHelper.saveBool(
      key: AppConstants.configurationKey,
      value: true,
    );

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, Routes.onboarding);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final v = AppSizeVertical.instance;
    final h = AppSizeHorizontal.instance;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
      _selectedDark ? Brightness.light : Brightness.dark,
    ));

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      color: _bgColor,
      child: Directionality(
        // Immediately mirror layout to preview the selection
        textDirection:
        _isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: h.s24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: v.s60),

                      // ── App icon + name ──────────────────────────────
                      _buildAppIcon(v, h),

                      SizedBox(height: v.s40),

                      // ── Welcome headline ─────────────────────────────
                      _buildHeadline(v),

                      SizedBox(height: v.s40),

                      // ── Language card ────────────────────────────────
                      _buildSectionLabel(
                        icon: Icons.language_rounded,
                        label: _isArabic ? 'اللغة' : 'Language',
                        v: v,
                        h: h,
                      ),
                      SizedBox(height: v.s8),
                      _buildLanguageSelector(v, h),

                      SizedBox(height: v.s24),

                      // ── Theme card ───────────────────────────────────
                      _buildSectionLabel(
                        icon: Icons.palette_outlined,
                        label: _isArabic ? 'المظهر' : 'Appearance',
                        v: v,
                        h: h,
                      ),
                      SizedBox(height: v.s8),
                      _buildThemeSelector(v, h),

                      SizedBox(height: v.s60),

                      // ── Get Started button ───────────────────────────
                      AppButton(
                        text: _isArabic ? 'ابدأ الآن' : 'Get Started',
                        isLoading: _isSaving,
                        onPressed: _onGetStarted,
                        horizontalPadding: 0,
                        verticalPadding: 0,
                        borderRadius: 12,
                      ),

                      SizedBox(height: v.s40),
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

  // ── App icon ──────────────────────────────────────────────────────────────

  Widget _buildAppIcon(AppSizeVertical v, AppSizeHorizontal h) {
    return Column(
      children: [
        Container(
          width: 96.w,
          height: 96.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            color: _cardColor,
            border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.1)),
          ),
          padding: EdgeInsets.all(14.r),
          child: Image.asset(
            Assets.logoApp,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: v.s16),
        Text(
          'CareLine',
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w800,
            color: ColorsManager.primaryColor,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  // ── Headline ──────────────────────────────────────────────────────────────

  Widget _buildHeadline(AppSizeVertical v) {
    return Column(
      children: [
        Text(
          _isArabic ? 'مرحباً بك 👋' : 'Welcome 👋',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: _textPrimary,
          ),
        ),
        SizedBox(height: v.s8),
        Text(
          _isArabic
              ? 'اختر لغتك وشكل المفضل للبدء'
              : 'Choose your language & appearance to get started',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            color: _textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ── Section label ─────────────────────────────────────────────────────────

  Widget _buildSectionLabel({
    required IconData icon,
    required String label,
    required AppSizeVertical v,
    required AppSizeHorizontal h,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: ColorsManager.primaryColor),
        SizedBox(width: h.s6),
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: _textSecondary,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  // ── Language selector ─────────────────────────────────────────────────────

  Widget _buildLanguageSelector(AppSizeVertical v, AppSizeHorizontal h) {
    return _buildSegmentedControl(
      isLeftSelected: _selectedLang == 'ar',
      leftLabel: 'العربية',
      rightLabel: 'English',
      leftEmoji: '🇸🇦',
      rightEmoji: '🇺🇸',
      onLeftTap: () => setState(() => _selectedLang = 'ar'),
      onRightTap: () => setState(() => _selectedLang = 'en'),
    );
  }

  // ── Theme selector ────────────────────────────────────────────────────────

  Widget _buildThemeSelector(AppSizeVertical v, AppSizeHorizontal h) {
    return _buildSegmentedControl(
      isLeftSelected: !_selectedDark,
      leftLabel: _isArabic ? 'فاتح' : 'Light',
      rightLabel: _isArabic ? 'داكن' : 'Dark',
      leftIcon: Icons.light_mode_rounded,
      rightIcon: Icons.dark_mode_rounded,
      onLeftTap: () => setState(() => _selectedDark = false),
      onRightTap: () => setState(() => _selectedDark = true),
    );
  }

  // ── Reusable Segmented Control ────────────────────────────────────────────

  Widget _buildSegmentedControl({
    required bool isLeftSelected,
    required String leftLabel,
    required String rightLabel,
    IconData? leftIcon,
    IconData? rightIcon,
    String? leftEmoji,
    String? rightEmoji,
    required VoidCallback onLeftTap,
    required VoidCallback onRightTap,
  }) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        height: 52.h,
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(26.r),
          border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.08)),
        ),
        child: Stack(
          children: [
            // ── The Sliding Pill (Indicator) ──
            AnimatedAlign(
              alignment: isLeftSelected
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              duration: const Duration(milliseconds: 300),
            curve: Curves.fastEaseInToSlowEaseOut, // Smooth spring-like curve
            child: FractionallySizedBox(
              widthFactor: 0.5, // Takes exactly half the width
              heightFactor: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: ColorsManager.primaryColor,
                  borderRadius: BorderRadius.circular(22.r),
                  boxShadow: [
                    BoxShadow(
                      color: ColorsManager.primaryColor.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // ── The Buttons ──
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onLeftTap,
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontFamily: 'Cairo', // Assuming the app uses Cairo/Tajawal or similar
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: isLeftSelected ? Colors.white : _textSecondary,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (leftIcon != null)
                            Icon(leftIcon,
                                size: 18.sp,
                                color: isLeftSelected
                                    ? Colors.white
                                    : _textSecondary)
                          else if (leftEmoji != null)
                            Text(leftEmoji, style: TextStyle(fontSize: 16.sp)),
                          SizedBox(width: 8.w),
                          Text(leftLabel),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: onRightTap,
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: !isLeftSelected ? Colors.white : _textSecondary,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (rightIcon != null)
                            Icon(rightIcon,
                                size: 18.sp,
                                color: !isLeftSelected
                                    ? Colors.white
                                    : _textSecondary)
                          else if (rightEmoji != null)
                            Text(rightEmoji, style: TextStyle(fontSize: 16.sp)),
                          SizedBox(width: 8.w),
                          Text(rightLabel),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}