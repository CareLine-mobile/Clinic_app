// lib/core/widgets/clinic_refresh_indicator.dart

import 'package:clinic_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'dart:math' as math;

class ClinicRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const ClinicRefreshIndicator({
    Key? key,
    required this.child,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      onRefresh: onRefresh,
      offsetToArmed: 80.h,
      builder: (context, child, controller) {
        return Stack(
          children: [
            // المحتوى ثابت - مش بيتحرك
            child,

            // الـ Indicator - بيطلع من فوق بس
            if (controller.state != IndicatorState.idle)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Transform.translate(
                  offset: Offset(0, -80.h + (controller.value * 80.h).clamp(0.0, 80.h)),
                  child: _buildIndicator(controller),
                ),
              ),
          ],
        );
      },
      child: child,
    );
  }

  Widget _buildIndicator(IndicatorController controller) {
    final value = controller.value.clamp(0.0, 1.0);
    final state = controller.state;

    // Loading
    if (state == IndicatorState.loading) {
      return const _LoadingIndicator();
    }

    // Pulling / Armed
    return _PullingIndicator(
      value: value,
      isArmed: value >= 1.0,
    );
  }
}

// ==================== Loading - قلب نابض بسيط ====================
class _LoadingIndicator extends StatefulWidget {
  const _LoadingIndicator();

  @override
  State<_LoadingIndicator> createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<_LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.h,
      alignment: Alignment.center,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // نبضة سلسة
          final pulse = 1.0 + (math.sin(_controller.value * 2 * math.pi) * 0.2);
          final opacity = 0.8 + (math.sin(_controller.value * 2 * math.pi) * 0.2);

          return Transform.scale(
            scale: pulse,
            child: Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    ColorsManager.primaryColor.withOpacity(opacity),
                    ColorsManager.primaryColor.withOpacity(opacity * 0.6),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorsManager.primaryColor.withOpacity(0.3),
                    blurRadius: 20 * pulse,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Icon(
                Icons.favorite,
                color: Colors.white,
                size: 32.sp,
              ),
            ),
          );
        },
      ),
    );
  }
}


// ==================== Pulling - دوائر متموجة ====================
class _PullingIndicator extends StatelessWidget {
  final double value;
  final bool isArmed;

  const _PullingIndicator({
    required this.value,
    required this.isArmed,
  });

  @override
  Widget build(BuildContext context) {
    final height = (120.h * value).clamp(0.0, 120.h);
    final scale = value.clamp(0.3, 1.0);

    return Container(
      height: height,
      alignment: Alignment.center,
      child: Opacity(
        opacity: value,
        child: Transform.scale(
          scale: scale,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // دائرة خارجية (wave effect)
              if (value > 0.3)
                Container(
                  width: 70.w * value,
                  height: 70.w * value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ColorsManager.primaryColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                ),

              // دائرة وسطى
              if (value > 0.5)
                Container(
                  width: 55.w * value,
                  height: 55.w * value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: ColorsManager.primaryColor.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                ),

              // القلب في المنتصف
              Container(
                width: 45.w,
                height: 45.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isArmed
                      ? ColorsManager.primaryColor
                      : Colors.white,
                  border: !isArmed ? Border.all(
                    color: ColorsManager.primaryColor,
                    width: 2,
                  ) : null,
                  boxShadow: [
                    BoxShadow(
                      color: ColorsManager.primaryColor.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.favorite,
                  color: isArmed
                      ? Colors.white
                      : ColorsManager.primaryColor,
                  size: 24.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}