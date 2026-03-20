// lib/features/search/presentation/pages/search_screen.dart

import 'package:clinic_app/core/widgets/card/clinic_card.dart';
import 'package:clinic_app/features/home/domain/entities/clinic_summary.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../../core/widgets/CustomIcon.dart';
import '../../../../../core/widgets/app_text_feild.dart';
import '../../../../../core/widgets/empty_state_widget.dart';
import '../cubit/search_cubit.dart';
import '../../../../../core/utils/enums.dart';
import '../../../../../core/routes/routes.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _SearchHeader(
              controller: _searchController,
              focusNode: _focusNode,
            ),
            const Expanded(child: _SearchBody()),
          ],
        ),
      ),
    );
  }
}

// ─── Search Header ────────────────────────────────────────────────────────────

class _SearchHeader extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const _SearchHeader({
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 40.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, _) {
          return AppTextFieldFactory.search(
            controller: controller,
            focusNode: focusNode,
            autofocus: true,
            hintText: 'search.hint'.tr(),
            prefixIcon: Padding(
              padding: EdgeInsets.all(10.r),
              child: CustomIcon(
                assetPath: Assets.searchBarIcon,
                size: 20.sp,
                color: value.text.isEmpty
                    ? Theme.of(context).hintColor
                    : ColorsManager.primaryColor,
              ),
            ),
            suffixIcon: value.text.isNotEmpty
                ? IconButton(
              onPressed: () {
                controller.clear();
                context
                    .read<SearchCubit>()
                    .onSearchQueryChanged('');
              },
              icon: Icon(
                Icons.close_rounded,
                size: 18.sp,
                color: Theme.of(context).hintColor,
              ),
            )
                : null,
            onChanged: (q) =>
                context.read<SearchCubit>().onSearchQueryChanged(q),
            fillColor: theme.cardColor,
            focusedFillColor: theme.cardColor,
            borderRadius: 14,
          );
        },
      ),
    );
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _SearchBody extends StatelessWidget {
  const _SearchBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) => switch (state) {
        SearchInitial() => const _SearchInitialView(),
        SearchLoading() => const _SearchLoadingView(),
        SearchLoaded(:final clinics) => _SearchResultsView(clinics: clinics),
        SearchEmpty() => const _SearchEmptyView(),
        SearchError(:final message) => _SearchErrorView(message: message),
        _ => const SizedBox.shrink(),
      },
    );
  }
}

// ─── Initial ──────────────────────────────────────────────────────────────────

class _SearchInitialView extends StatelessWidget {
  const _SearchInitialView();

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.search_rounded,
      title: 'search.initial_title'.tr(),
      subtitle: 'search.initial_hint'.tr(),
      enableBackButton: false,   // ← no back button
    );
  }
}

// ─── Loading ──────────────────────────────────────────────────────────────────

class _SearchLoadingView extends StatelessWidget {
  const _SearchLoadingView();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: 6,
      itemBuilder: (_, __) => const _ShimmerCard(),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 100.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isDark ? ColorsManager.secondaryDarkColor : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16.r),
      ),
    );
  }
}

// ─── Results ──────────────────────────────────────────────────────────────────

class _SearchResultsView extends StatelessWidget {
  final List<ClinicSummary> clinics;
  const _SearchResultsView({required this.clinics});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: clinics.length,
      itemBuilder: (context, index) {
        final clinic = clinics[index];
        return ClinicCard(
          key: ValueKey(clinic.id),
          clinic: clinic,
          layout: ClinicCardLayout.list,
          onTap: () => Navigator.pushNamed(
            context,
            Routes.clinicDetails,
            arguments: clinic.id,
          ),
        );
      },
    );
  }
}

// ─── Empty ────────────────────────────────────────────────────────────────────

class _SearchEmptyView extends StatelessWidget {
  const _SearchEmptyView();

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.search_off_rounded,
      title: 'search.empty_title'.tr(),
      subtitle: 'search.no_results'.tr(),
      enableBackButton: false,   // ← no back button
    );
  }
}

// ─── Error ────────────────────────────────────────────────────────────────────

class _SearchErrorView extends StatelessWidget {
  final String message;
  const _SearchErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.wifi_off_rounded,
      title: 'errors.network.title'.tr(),
      subtitle: message,
      enableBackButton: false,   // ← no back button
      actionLabel: 'common.retry'.tr(),
      onActionPressed: () => context.read<SearchCubit>().retry(),
    );
  }
}