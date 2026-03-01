// ============================================
// AUTH BACKGROUND - Clean Gradient
// lib/features/auth/presentation/widgets/auth_background.dart
// ============================================

import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.grey.shade50,
            Colors.grey.shade100,
          ],
        ),
      ),
      child: child,
    );
  }
}