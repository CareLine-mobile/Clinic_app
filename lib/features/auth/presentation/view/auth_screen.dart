// ============================================
// AUTH SCREEN - MAIN (Clean & Modern)
// lib/features/auth/presentation/screens/auth_screen.dart
// ============================================
import 'package:flutter/material.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/widgets/CustomIcon.dart';
import '../widget/auth_tab_selector.dart';
import '../widget/auth_title.dart';
import '../widget/taps/login_tab.dart';
import '../widget/taps/signup_tab.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ValueNotifier<bool> _isLoginNotifier = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      _isLoginNotifier.value = _tabController.index == 0;
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _isLoginNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    CustomIcon(assetPath: Assets.logoApp,isImage: true,size: AppSizeVertical.instance.logoSize,),
                    const SizedBox(height: 24),
                    ValueListenableBuilder<bool>(
                      valueListenable: _isLoginNotifier,
                      builder: (context, isLogin, child) {
                        return AuthTitle(isLogin: isLogin);
                      },
                    ),
                    const SizedBox(height: 32),
                    AuthTabSelector(controller: _tabController),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 480, // Fixed height for better performance
                      child: TabBarView(
                        controller: _tabController,
                        physics: const NeverScrollableScrollPhysics(), // Disable swipe for better UX
                        children: const [
                          LoginTab(),
                          SignupTab(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}







