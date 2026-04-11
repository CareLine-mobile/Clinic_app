import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/widgets/fluid_comonent/fluid_carousel.dart';
import '../../../../core/widgets/fluid_comonent/fluid_card.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FluidCarousel(
        children: <Widget>[
          FluidCard(
            color: 'Red',
            altColor: const Color(0xFF4259B2),
            title: "onboarding.slide1_title".tr(),
            subtitle: "onboarding.slide1_subtitle".tr(),
          ),
          FluidCard(
            color: 'Yellow',
            altColor: const Color(0xFF904E93),
            title: "onboarding.slide2_title".tr(),
            subtitle: "onboarding.slide2_subtitle".tr(),
          ),
          FluidCard(
            color: 'Blue',
            altColor: const Color(0xFFFFB138),
            title: "onboarding.slide3_title".tr(),
            subtitle: "onboarding.slide3_subtitle".tr(),
          ),
        ],
      ),
    );
  }
}