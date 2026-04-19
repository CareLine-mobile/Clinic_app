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
            boxShadow: [
              BoxShadow(
                color: ColorsManager.primaryColor.withOpacity(0.25),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
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
              ? 'اختر لغتك ومظهرك المفضل للبدء'
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
    return Row(
      children: [
        Expanded(
          child: _SelectionTile(
            isSelected: _selectedLang == 'ar',
            isDark: _selectedDark,
            cardColor: _cardColor,
            onTap: () => setState(() => _selectedLang = 'ar'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🇸🇦', style: TextStyle(fontSize: 30.sp)),
                SizedBox(height: v.s8),
                Text(
                  'العربية',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: _selectedLang == 'ar'
                        ? ColorsManager.primaryColor
                        : _textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: h.s12),
        Expanded(
          child: _SelectionTile(
            isSelected: _selectedLang == 'en',
            isDark: _selectedDark,
            cardColor: _cardColor,
            onTap: () => setState(() => _selectedLang = 'en'),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🇺🇸', style: TextStyle(fontSize: 30.sp)),
                SizedBox(height: v.s8),
                Text(
                  'English',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: _selectedLang == 'en'
                        ? ColorsManager.primaryColor
                        : _textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Theme selector ────────────────────────────────────────────────────────

  Widget _buildThemeSelector(AppSizeVertical v, AppSizeHorizontal h) {
    return Row(
      children: [
        Expanded(
          child: _SelectionTile(
            isSelected: !_selectedDark,
            isDark: _selectedDark,
            cardColor: _cardColor,
            onTap: () => setState(() => _selectedDark = false),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.light_mode_rounded,
                  size: 30.sp,
                  color: !_selectedDark
                      ? ColorsManager.primaryColor
                      : _textSecondary,
                ),
                SizedBox(height: v.s8),
                Text(
                  _isArabic ? 'فاتح' : 'Light',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: !_selectedDark
                        ? ColorsManager.primaryColor
                        : _textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: h.s12),
        Expanded(
          child: _SelectionTile(
            isSelected: _selectedDark,
            isDark: _selectedDark,
            cardColor: _cardColor,
            onTap: () => setState(() => _selectedDark = true),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.dark_mode_rounded,
                  size: 30.sp,
                  color: _selectedDark
                      ? ColorsManager.primaryColor
                      : _textSecondary,
                ),
                SizedBox(height: v.s8),
                Text(
                  _isArabic ? 'داكن' : 'Dark',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: _selectedDark
                        ? ColorsManager.primaryColor
                        : _textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reusable animated selection tile
// ─────────────────────────────────────────────────────────────────────────────

class _SelectionTile extends StatelessWidget {
  const _SelectionTile({
    required this.isSelected,
    required this.isDark,
    required this.cardColor,
    required this.onTap,
    required this.child,
  });

  final bool isSelected;
  final bool isDark;
  final Color cardColor;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(vertical: 20.h),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorsManager.primaryColor.withOpacity(isDark ? 0.15 : 0.08)
              : cardColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected
                ? ColorsManager.primaryColor
                : (isDark
                ? Colors.white.withOpacity(0.08)
                : const Color(0xFFE5EAF2)),
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: ColorsManager.primaryColor.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ]
              : [],
        ),
        child: Center(child: child),
      ),
    );
  }
}