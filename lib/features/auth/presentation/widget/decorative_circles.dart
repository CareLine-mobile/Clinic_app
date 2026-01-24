// ============================================
// lib/features/auth/presentation/widgets/decorative_circles.dart
// ============================================

import 'package:flutter/material.dart';

class DecorativeCircles extends StatelessWidget {
  const DecorativeCircles({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildCircle(
          top: -100,
          right: -100,
          size: 250,
          opacity: 0.1,
        ),
        _buildCircle(
          bottom: -80,
          left: -80,
          size: 200,
          opacity: 0.1,
        ),
        _buildCircle(
          top: 200,
          left: -50,
          size: 150,
          opacity: 0.05,
        ),
      ],
    );
  }

  Widget _buildCircle({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required double size,
    required double opacity,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(opacity),
        ),
      ),
    );
  }
}
