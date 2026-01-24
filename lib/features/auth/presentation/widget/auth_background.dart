// lib/features/auth/presentation/widgets/auth_background.dart
// ============================================

import 'package:flutter/cupertino.dart';

class AuthBackground extends StatelessWidget {
  final bool isLogin;

  const AuthBackground({
    Key? key,
    required this.isLogin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isLogin
              ? [const Color(0xFF667eea), const Color(0xFF764ba2)]
              : [const Color(0xFFf093fb), const Color(0xFFf5576c)],
        ),
      ),
    );
  }
}
