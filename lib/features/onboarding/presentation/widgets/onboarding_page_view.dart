// lib/features/onboarding/presentation/widgets/onboarding_single_page.dart

import 'package:clinic_app/core/widgets/custom_lottie_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;
import '../../../../core/theme/colors.dart';
import '../models/onboarding_item.dart';

class OnboardingSinglePage extends StatefulWidget {
  final OnboardingItem item;

  const OnboardingSinglePage({Key? key, required this.item}) : super(key: key);


  @override
  State<OnboardingSinglePage> createState() => _OnboardingSinglePageState();
}

class _OnboardingSinglePageState extends State<OnboardingSinglePage>
    with SingleTickerProviderStateMixin {

  late final AnimationController _ctrl;

  // Image
  late final Animation<Offset> _imgSlide;
  late final Animation<double>  _imgFade;

  // Icon chip
  late final Animation<Offset> _iconSlide;
  late final Animation<double>  _iconFade;

  // Text block
  late final Animation<Offset> _textSlide;
  late final Animation<double>  _textFade;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _imgSlide = Tween(begin: const Offset(0, 0.10), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl,
        curve: const Interval(0.00, 0.65, curve: Curves.easeOutCubic)));
    _imgFade  = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl,
        curve: const Interval(0.00, 0.55, curve: Curves.easeOut)));

    _iconSlide = Tween(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl,
        curve: const Interval(0.30, 0.75, curve: Curves.easeOutBack)));
    _iconFade  = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl,
        curve: const Interval(0.30, 0.65, curve: Curves.easeOut)));

    _textSlide = Tween(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl,
        curve: const Interval(0.45, 1.00, curve: Curves.easeOutCubic)));
    _textFade  = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl,
        curve: const Interval(0.45, 0.85, curve: Curves.easeOut)));

    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Column(
        children: [

          // ── الصورة ────────────────────────────────────────────────────
          Expanded(
            child: SlideTransition(
              position: _imgSlide,
              child: FadeTransition(
                opacity: _imgFade,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
               child: CustomLottieIcon(assetPath: widget.item.image,width: 250.w,height: 250.h,),
               //   child: Image.asset(widget.item.image, fit: BoxFit.contain),
                ),
              ),
            ),
          ),

          // ── أيقونة الفئة ───────────────────────────────────────────────
          // SlideTransition(
          //   position: _iconSlide,
          //   child: FadeTransition(
          //     opacity: _iconFade,
          //     child: Container(
          //       width: 52.r, height: 52.r,
          //       decoration: BoxDecoration(
          //         color:        ColorsManager.successSurface,
          //         borderRadius: BorderRadius.circular(14.r),
          //       ),
          //       child: Icon(
          //         widget.item.icon,
          //         color: ColorsManager.primaryColor,
          //         size:  24.r,
          //       ),
          //     ),
          //   ),
          // ),
          //
          // SizedBox(height: 20.h),

          // ── Title + Subtitle ────────────────────────────────────────────
          SlideTransition(
            position: _textSlide,
            child: FadeTransition(
              opacity: _textFade,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Column(
                  children: [
                    Text(
                      widget.item.title.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize:   22.sp,
                        fontWeight: FontWeight.bold,
                        color:      ColorsManager.defaultText,
                        height:     1.4,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      widget.item.subtitle.tr(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color:    ColorsManager.defaultTextSecondary,

                     //   height:   1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 28.h),
        ],
      ),
    );
  }
}