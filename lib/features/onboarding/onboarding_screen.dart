import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            title: "نظم أدويتك بسهولة",
            subtitle:
            "تابع مواعيد أدويتك اليومية بطريقة بسيطة وفعالة مع تذكيرات ذكية",
          ),
          FluidCard(
            color: 'Yellow',
            altColor: const Color(0xFF904E93),
            title: "لا تنسى جرعتك أبداً",
            subtitle:
            "استلم تنبيهات في الوقت المناسب لتضمن عدم تفويت أي جرعة من أدويتك",
          ),
          FluidCard(
            color: 'Blue',
            altColor: const Color(0xFFFFB138),
            title: "تتبع تقدمك",
            subtitle:
            "راقب التزامك اليومي واحصل على إحصائيات مفصلة عن صحتك الدوائية",
          ),
        ],
      ),
    );
  }
}