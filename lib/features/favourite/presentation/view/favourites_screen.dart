import 'package:clinic_app/core/routes/routes.dart';
import 'package:clinic_app/core/theme/colors.dart';
import 'package:clinic_app/core/utils/enums.dart';
import 'package:clinic_app/core/widgets/custom_snack_bar.dart';
import 'package:clinic_app/core/widgets/error_state_widget.dart';
import 'package:clinic_app/features/clinic_details/presentation/view/clinic_details_screen.dart';
import 'package:clinic_app/features/home/domain/entities/clinic_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/widgets/card/clinic_card.dart';
import '../cubit/favourite_cubit.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavouriteCubit>(
      // Create + load in one shot
      create: (_) => di.sl<FavouriteCubit>()..loadFavourites(),
      child: const _FavouritesBody(),
    );
  }
}

// ─────────────────────────────────────────────────────────────

class _FavouritesBody extends StatelessWidget {
  const _FavouritesBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocConsumer<FavouriteCubit, FavouriteState>(
        // Show a snackbar when a toggle rolls back due to a network error
        listenWhen: (_, s) => s is FavouriteError,
        listener: (context, state) {
          if (state is FavouriteError) {
            CustomSnackBar.show(
              context,
              message: state.failure.message,
              type: SnackBarType.error,
            );
          }
        },
          builder: (context, state) => RefreshIndicator(
            onRefresh: () => context.read<FavouriteCubit>().loadFavourites(),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _AppBar(),
                _bodySliver(context, state),  // No RefreshIndicator here anymore
              ],
            ),
          )
      ),
    );
  }

  Widget _bodySliver(BuildContext context, FavouriteState state) {
    return switch (state) {
      FavouriteLoading() => const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      ),
      FavouriteUnauthenticated() => SliverFillRemaining(
        child: _UnauthenticatedView(),
      ),
      FavouriteEmpty() => SliverFillRemaining(
        child: _EmptyView(),
      ),
      FavouriteError(:final failure) => SliverFillRemaining(
        child: ErrorStateWidget(
          failure: failure,
          onRetry: () => context.read<FavouriteCubit>().loadFavourites(),
        ),
      ),
      FavouriteLoaded(:final clinics) => _ClinicListSliver(clinics: clinics),
      _ => const SliverToBoxAdapter(child: SizedBox.shrink()),
    };
  }
}

// ─────────────────────────────────────────────────────────────

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'المفضلة',
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
      actions: [
        BlocBuilder<FavouriteCubit, FavouriteState>(
          builder: (context, state) {
            if (state is! FavouriteLoaded) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(left: 16.w),
              child: Center(
                child: Text(
                  '${state.clinics.length} عيادة',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────

class _ClinicListSliver extends StatelessWidget {
  final List<ClinicSummary> clinics;
  const _ClinicListSliver({required this.clinics});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      sliver: SliverList.builder(
        itemCount: clinics.length,
        itemBuilder: (context, index) {
          final clinic = clinics[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: ClinicCard(
              clinic: clinic,
              layout: ClinicCardLayout.list,
              onTap: () => _openDetails(context, clinic),
              onBookNow: () => _openDetails(context, clinic),
              onFavoriteToggle: () =>
                  context.read<FavouriteCubit>().toggleFavourite(clinic.id),
            ),
          );
        },
      ),
    );
  }

  void _openDetails(BuildContext context, ClinicSummary clinic) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ClinicDetailsScreen(clinicId: clinic.id),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border_rounded,
                size: 80.r, color: Colors.grey[300]),
            SizedBox(height: 16.h),
            Text(
              'لا توجد عيادات مفضلة',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'اضغط على قلب أي عيادة لإضافتها للمفضلة',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────

class _UnauthenticatedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline_rounded,
              size: 80.r,
              color: ColorsManager.primaryColor.withOpacity(0.4),
            ),
            SizedBox(height: 16.h),
            Text(
              'يرجى تسجيل الدخول',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              'سجل دخولك لعرض عياداتك المفضلة وإدارتها',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 28.h),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, Routes.auth),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    horizontal: 48.w, vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('تسجيل الدخول'),
            ),
          ],
        ),
      ),
    );
  }
}