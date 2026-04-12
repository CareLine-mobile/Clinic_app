import 'package:easy_localization/easy_localization.dart';
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
import '../widgets/logout_section.dart';
import '../widgets/preferences_section.dart';
import '../widgets/settings_header.dart';
import '../widgets/support_section.dart';

class SettingsTabScreen extends StatelessWidget {
  const SettingsTabScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (_, curr) => curr is AuthUnauthenticated,
      listener: (_, __) => Navigator.pushNamedAndRemoveUntil(
        context, Routes.auth, (_) => false,
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: _SettingsScrollView(user: UserRepository().currentUser),
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
    return const SliverToBoxAdapter(
      child: SafeArea(child: GuestBanner()),
    );
  }
}

class _SettingsBody extends StatelessWidget {
  final User? user;
  const _SettingsBody({required this.user});

  @override
  Widget build(BuildContext context) {
    final v = AppSizeVertical.instance;
    final h = AppSizeHorizontal.instance;

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: h.s16,
          vertical: v.s16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user != null) ...[
              const AccountSection(),
              SizedBox(height: v.s20),
            ],
            const PreferencesSection(),
            SizedBox(height: v.s20),
          //  const SupportSection(),
            SizedBox(height: v.s20),
            const LegalSection(),
            SizedBox(height: v.s20),
            user != null
                ? const LogoutSection()
                : const _GuestAuthButtons(),
            SizedBox(height: v.s70),
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
    return AppButton(
      text: 'common.login'.tr(),
      horizontalPadding: 0,
      verticalPadding: 0,
      onPressed: () => Navigator.pushNamed(context, Routes.auth),
    );
  }
}