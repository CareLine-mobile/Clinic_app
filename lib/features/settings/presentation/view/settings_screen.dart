
import 'package:clinic_app/features/settings/presentation/widgets/logout_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/routes.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/widgets/app_buton.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../user_data/user_repo.dart';
import '../widgets/account_section.dart';
import '../widgets/guest_banner.dart';
import '../widgets/legal_section.dart';
import '../widgets/preferences_section.dart';
import '../widgets/settings_header.dart';
import '../widgets/support_section.dart';



class SettingsTabScreen extends StatelessWidget {
  const SettingsTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      // React only when user becomes unauthenticated (after logout)
      listenWhen: (_, curr) => curr is AuthUnauthenticated,
      listener: (_, __) => Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.auth,
            (_) => false,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // UserRepository is a singleton — read .currentUser directly,
        // no BlocBuilder needed here
        body: _SettingsScrollView(
          user: UserRepository().currentUser,
        ),
      ),
    );
  }
}
class _SettingsScrollView extends StatelessWidget {
  final User? user;

  const _SettingsScrollView({required this.user});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _buildHeader(),
        _SettingsBody(user: user),
      ],
    );
  }

  Widget _buildHeader() {
    if (user != null) {
      return SettingsHeader(
        userName: user!.name,
        userEmail: user!.email,
        userPhotoUrl: user!.avatar,
      );
    }
    return const SliverToBoxAdapter(child: GuestBanner());
  }
}
class _SettingsBody extends StatelessWidget {
  final User? user;

  const _SettingsBody({required this.user});

  @override
  Widget build(BuildContext context) {
    final vSize = AppSizeVertical.instance;
    final hSize = AppSizeHorizontal.instance;

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(hSize.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user != null) ...[
              const AccountSection(),
              SizedBox(height: vSize.s24),
            ],
            const PreferencesSection(),
            SizedBox(height: vSize.s24),
            const SupportSection(),
            SizedBox(height: vSize.s24),
            const LegalSection(),
            SizedBox(height: vSize.s24),
            user != null ? const LogoutSection() : const _GuestAuthButtons(),
            SizedBox(height: vSize.s50),
          ],
        ),
      ),
    );
  }
}
class _GuestAuthButtons extends StatelessWidget {
  const _GuestAuthButtons();

  @override
  Widget build(BuildContext context) {
    final vSize = AppSizeVertical.instance;
    return AppButton(
      text: 'تسجيل دخول',
      horizontalPadding: 0,
      verticalPadding: 0,
      onPressed: () => Navigator.pushNamed(context, Routes.auth),
    );
  }
}

