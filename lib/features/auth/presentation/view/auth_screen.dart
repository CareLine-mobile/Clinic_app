// ============================================
// AUTH SCREEN - MAIN
// lib/features/auth/presentation/screens/auth_screen.dart
// ============================================

import 'package:clinic_app/features/auth/presentation/widget/taps/signup_tab.dart';
import 'package:flutter/material.dart';

import '../widget/auth_background.dart';
import '../widget/auth_logo.dart';
import '../widget/auth_tab_selector.dart';
import '../widget/auth_title.dart';
import '../widget/decorative_circles.dart';
import '../widget/taps/login_tab.dart';


class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLogin = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _isLogin = _tabController.index == 0;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AuthBackground(isLogin: _isLogin),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                const AuthLogo(),
                const SizedBox(height: 30),
                AuthTitle(isLogin: _isLogin),
                const SizedBox(height: 40),
                AuthTabSelector(controller: _tabController),
                const SizedBox(height: 30),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      LoginTab(),
                      SignupTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const DecorativeCircles(),
        ],
      ),
    );
  }
}
