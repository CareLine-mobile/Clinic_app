// lib/features/onboarding/presentation/pages/onboarding_screen.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/db/shared_pref_helper.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/app_constans.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/widgets/app_buton.dart';
import '../../../user_data/user_repo.dart';
import '../models/onboarding_item.dart';
import 'dart:ui' as ui;
import '../widgets/onboarding_page_view.dart';
import '../widgets/page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  final PageController _pageCtrl = PageController();
  int _current = 0;

  List<OnboardingItem> get _items => [
    OnboardingItem(
      image:    Assets.onboarding1,

      icon:     Icons.fitness_center_rounded,
      title:    'onboarding.page1.title'.tr(),
      subtitle: 'onboarding.page1.subtitle'.tr(),
    ),
    OnboardingItem(
     image:    Assets.onboarding2,

      icon:     Icons.shopping_cart_rounded,
      title:    'onboarding.page2.title'.tr(),
      subtitle: 'onboarding.page2.subtitle'.tr(),
    ),
    OnboardingItem(
    image:    Assets.onboarding3,

      icon:     Icons.delivery_dining_rounded,
      title:    'onboarding.page3.title'.tr(),
      subtitle: 'onboarding.page3.subtitle'.tr(),
    ),

  ];

  bool get _isLastPage => _current == _items.length - 1;

  // ── Actions ───────────────────────────────────────────────────────────────

  void _next() {
    if (!_isLastPage) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 450),
        curve:    Curves.easeInOutCubic,
      );
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() async{
    await SharedPrefHelper.saveBool(key: AppConstants.onboardingKey, value: true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, Routes.auth);

  }

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  @override
  void dispose() { _pageCtrl.dispose(); super.dispose(); }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor:          Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: ColorsManager.defaultSurface,
      body: SafeArea(
        child: Directionality(
          textDirection: ui.TextDirection.rtl,
          child: Column(
            children: [
              _buildTopBar(),
              _buildPageView(),
              _buildButton(),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  // ── Top bar ───────────────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Row(
        children: [
          PageIndicator(count: _items.length, current: _current),
          const Spacer(),
          GestureDetector(
            onTap: _goToLogin,
            child: Text(
              'onboarding.skip'.tr(),
              style: TextStyle(
                fontSize:   14.sp,
                fontWeight: FontWeight.w600,
                color:      ColorsManager.defaultTextSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── PageView ──────────────────────────────────────────────────────────────

  Widget _buildPageView() {
    return Expanded(
      child: PageView.builder(
        controller:    _pageCtrl,
        onPageChanged: (i) => setState(() => _current = i),
        itemCount:     _items.length,
        itemBuilder:   (_, i) => OnboardingSinglePage(item: _items[i]),
      ),
    );
  }

  // ── Button ────────────────────────────────────────────────────────────────

  Widget _buildButton() {
    return AppButton(
      text:              _isLastPage ? 'onboarding.start'.tr() : 'onboarding.next'.tr(),
      onPressed:         _next,
      leadingIcon:       Icons.chevron_left_rounded,
      horizontalPadding: 24.w,
      verticalPadding:   0,
    );
  }
}