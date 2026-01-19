// lib/core/widgets/clinic_refresh_indicator.dart

import 'package:clinic_app/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'dart:math' as math;

class ClinicRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const ClinicRefreshIndicator({
    Key? key,
    required this.child,
    required this.onRefresh,
  }) : super(key: key);

  @override
  State<ClinicRefreshIndicator> createState() => _ClinicRefreshIndicatorState();
}

class _ClinicRefreshIndicatorState extends State<ClinicRefreshIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _successController;
  bool _showSuccess = false;

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _successController.dispose();
    super.dispose();
  }

  void _showSuccessAnimation() async {
    setState(() => _showSuccess = true);
    await _successController.forward(from: 0.0);
    await Future.delayed(const Duration(milliseconds: 200));
    _successController.reverse();
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() => _showSuccess = false);
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      onRefresh: widget.onRefresh,
      offsetToArmed: 100.h,
      onStateChanged: (state) {
        if (state == IndicatorState.complete) {
          _showSuccessAnimation();
        }
      },
      builder: (context, child, controller) {
        return Stack(
          children: [
            AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                final offset = controller.value.clamp(0.0, 1.5);
                return Transform.translate(
                  offset: Offset(0, offset * 100),
                  child: child,
                );
              },
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: Listenable.merge([controller, _successController]),
                builder: (context, _) {
                  return _buildRefreshHeader(controller);
                },
              ),
            ),
          ],
        );
      },
      child: widget.child,
    );
  }

  Widget _buildRefreshHeader(IndicatorController controller) {
    final value = controller.value.clamp(0.0, 1.5);

    // إخفاء أثناء التحميل
    if (controller.state == IndicatorState.loading && !_showSuccess) {
      return const SizedBox.shrink();
    }

    // إخفاء لما يكون idle
    if (controller.state == IndicatorState.idle && !_showSuccess) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 200.h * (value / 1.5),
      alignment: Alignment.center,
      child: _showSuccess
          ? _buildSuccessState()
          : _buildPullingState(controller, value),
    );
  }

  Widget _buildSuccessState() {

    return const SizedBox.shrink();
    // return AnimatedBuilder(
    //   animation: _successController,
    //   builder: (context, _) {
    //     final scale = Curves.easeOut.transform(_successController.value);
    //     final opacity = _successController.value;
    //
    //     return Container(
    //       width: double.infinity,
    //       height: 120.h,
    //       decoration: BoxDecoration(
    //         gradient: LinearGradient(
    //           begin: Alignment.topCenter,
    //           end: Alignment.bottomCenter,
    //           colors: [
    //             Colors.green.withOpacity(0.3 * opacity),
    //             Colors.green.withOpacity(0.2 * opacity),
    //             Colors.transparent,
    //           ],
    //         ),
    //       ),
    //       child: Center(
    //         child: Transform.scale(
    //           scale: scale,
    //           child: Container(
    //             width: 50.w,
    //             height: 50.w,
    //             decoration: BoxDecoration(
    //               shape: BoxShape.circle,
    //               color: Colors.green,
    //               boxShadow: [
    //                 BoxShadow(
    //                   color: Colors.green.withOpacity(0.5),
    //                   blurRadius: 20,
    //                   spreadRadius: 5,
    //                 ),
    //               ],
    //             ),
    //             child: Icon(
    //               Icons.check,
    //               color: Colors.white,
    //               size: 30.sp,
    //             ),
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // );
  }

  Widget _buildPullingState(IndicatorController controller, double value) {
    final progress = (value ).clamp(0.0, 1.0);
    final isArmed = progress >= 1.0;
    return SizedBox(
      width: double.infinity,
      height: 60.h,
      child: Center(
        child: Opacity(
          opacity: progress,
          child: CustomPaint(
            size: Size(
              MediaQuery.of(context).size.width,
              60.h,
            ),
            painter: _DrawingECGPainter(
              progress: progress,
              isArmed: isArmed,
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== Drawing ECG Painter ====================
class _DrawingECGPainter extends CustomPainter {
  final double progress;
  final bool isArmed;

  _DrawingECGPainter({required this.progress, required this.isArmed});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0) return;

    final baseline = size.height / 2;

    // draw from left to right
    final drawWidth = size.width * progress;

    // الخط الخارجي (glow)
    final glowPaint = Paint()
      ..color = ColorsManager.primaryColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    // mainPaint
    final mainPaint = Paint()
      ..color = isArmed ? Colors.white : ColorsManager.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(0, baseline);

    // رسم الخط بناءً على التقدم
    for (double x = 0; x <= drawWidth; x += 1) {
      final normalizedX = x / size.width;
      double y = baseline;

      // النبضة الأولى الصغيرة
      if (normalizedX >= 0.15 && normalizedX < 0.18) {
        final t = (normalizedX - 0.15) / 0.03;
        y = baseline - math.sin(t * math.pi) * size.height * 0.2;
      }
      // النبضة الرئيسية الكبيرة
      else if (normalizedX >= 0.25 && normalizedX < 0.35) {
        final t = (normalizedX - 0.25) / 0.1;
        if (t < 0.3) {
          // صعود سريع
          y = baseline - (t / 0.3) * size.height * 0.75;
        } else if (t < 0.5) {
          // هبوط سريع
          y = baseline - ((0.5 - t) / 0.2) * size.height * 0.75;
        } else {
          // انخفاض بسيط
          y = baseline + ((t - 0.5) / 0.5) * size.height * 0.15;
        }
      }
      // النبضة الثانية الصغيرة
      else if (normalizedX >= 0.4 && normalizedX < 0.43) {
        final t = (normalizedX - 0.4) / 0.03;
        y = baseline - math.sin(t * math.pi) * size.height * 0.15;
      }

      path.lineTo(x, y);
    }

    // رسم الـ glow أولاً
    canvas.drawPath(path, glowPaint);

    // رسم الخط الرئيسي
    canvas.drawPath(path, mainPaint);

    // نقطة مضيئة في آخر الخط
    if (progress > 0) {
      final lastPoint = Offset(drawWidth, _getYAtX(drawWidth, size, baseline));

      // هالة النقطة
      final pointGlow = Paint()
        ..color = (isArmed ? ColorsManager.backgroundSurface : ColorsManager.primaryColor)
            .withOpacity(0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
      canvas.drawCircle(lastPoint, 8, pointGlow);

      // النقطة الأساسية
      final pointPaint = Paint()
        ..color = isArmed ? ColorsManager.backgroundSurface : ColorsManager.primaryColor;
      canvas.drawCircle(lastPoint, 4, pointPaint);
    }
  }

  double _getYAtX(double x, Size size, double baseline) {
    final normalizedX = x / size.width;
    double y = baseline;

    if (normalizedX >= 0.15 && normalizedX < 0.18) {
      final t = (normalizedX - 0.15) / 0.03;
      y = baseline - math.sin(t * math.pi) * size.height * 0.2;
    } else if (normalizedX >= 0.25 && normalizedX < 0.35) {
      final t = (normalizedX - 0.25) / 0.1;
      if (t < 0.3) {
        y = baseline - (t / 0.3) * size.height * 0.75;
      } else if (t < 0.5) {
        y = baseline - ((0.5 - t) / 0.2) * size.height * 0.75;
      } else {
        y = baseline + ((t - 0.5) / 0.5) * size.height * 0.15;
      }
    } else if (normalizedX >= 0.4 && normalizedX < 0.43) {
      final t = (normalizedX - 0.4) / 0.03;
      y = baseline - math.sin(t * math.pi) * size.height * 0.15;
    }

    return y;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}