// ============================================
// lib/features/auth/presentation/widgets/auth_title.dart
// ============================================

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthTitle extends StatelessWidget {
  final bool isLogin;

  const AuthTitle({
    Key? key,
    required this.isLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Column(
        key: ValueKey(isLogin),
        children: [
          Text(
            isLogin ? 'Welcome Back' : 'Create Account',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isLogin
                ? 'Login to continue your health journey'
                : 'Join us for better healthcare',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
