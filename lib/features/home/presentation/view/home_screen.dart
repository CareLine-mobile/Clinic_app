// lib/features/home/presentation/screens/home_screen.dart

import 'package:clinic_app/core/utils/enums.dart';
import 'package:clinic_app/core/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../clinic_details/presentation/view/clinic_details_screen.dart';
import '../../domain/entities/clinic_summary.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_ui_cubit.dart';
import '../widget/card/clinic_card.dart';
import '../widget/card/clinic_list.dart';
import '../widget/clinical_refresh_indicator.dart';
import '../widget/home_app_bar_widget.dart';
import '../widget/home_shimmer_loading.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onNavigateToSearch;

  const HomeScreen({
    Key? key,
    this.onNavigateToSearch,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<HomeCubit>().loadClinics();
    context.read<HomeCubit>().loadLatestClinics();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<HomeCubit>().loadMoreClinics();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: ColorsManager.backgroundSurface,
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: _handleStateChanges,
        builder: (context, state) {
          if (state is HomeLoaded) {
            return ClinicRefreshIndicator(
              onRefresh: () => context.read<HomeCubit>().refresh(),
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildHeader(state),
                  ..._buildLoadedBody(state, textTheme),
                ],
              ),
            );
          }

          // For loading and error states, no refresh indicator
          return CustomScrollView(
            physics: state is HomeLoading
                ? const NeverScrollableScrollPhysics()
                : const BouncingScrollPhysics(),
            slivers: [
              _buildHeader(state),

              if (state is HomeLoading)
                ..._buildShimmerBody()
              else if (state is HomeError)
                SliverFillRemaining(
                  child: ErrorStateWidget(
                    failure: state.failure,
                    onRetry: () => context.read<HomeCubit>().loadClinics(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _handleStateChanges(BuildContext context, HomeState state) {
    if (state is HomeError) {
      CustomSnackBar.show(
        context,
        message: state.failure.message,
        type: SnackBarType.error,
      );
    }
  }

  /// Header
  Widget _buildHeader(HomeState state) {
    return BlocBuilder<HomeUiCubit, HomeUiState>(
      builder: (context, uiState) {
        ClinicSummary? lastBooking;
        if (state is HomeLoaded) {
          lastBooking = state.allClinics.first;
        }

        return HomeHeaderWidget(
          userName: 'أحمد محمد',
          userPhotoUrl: null,
          lastBooking: lastBooking,
          queuePosition: 5,
          peopleAhead: 4,
          onNotificationTap: _handleNotificationTap,
          onBookingCardTap: () {
            if (lastBooking != null) {
              _navigateToClinicDetails(lastBooking);
            }
          },
          onSearchTap: () => widget.onNavigateToSearch?.call(1),
          isLoading: uiState.isBookingLoading,
        );
      },
    );
  }

  /// Shimmer Body
  List<Widget> _buildShimmerBody() {
    return [
      const SliverFillRemaining(
        child: HomeBodyShimmer(),
      ),
    ];
  }

  /// Loaded Body
  List<Widget> _buildLoadedBody(HomeLoaded state, TextTheme textTheme) {
    return [
      SliverToBoxAdapter(child: SizedBox(height: SizeApp.s50)),

      // Featured Clinics
      if (state.featuredClinics.isNotEmpty)
        SliverToBoxAdapter(
          child: FeaturedClinicsSection(
            clinics: state.featuredClinics,
            onTap: _navigateToClinicDetails,
            onFavorite: _toggleFavorite,
            onBook: _bookAppointment,
          ),
        ),

      // Nearby Clinics
      if (state.nearbyClinics.isNotEmpty)
        SliverToBoxAdapter(
          child: HorizontalClinicsCarousel(
            clinics: state.nearbyClinics,
            title: "العيادات القريبة",
            onTap: _navigateToClinicDetails,
            onFavorite: _toggleFavorite,
            onBook: _bookAppointment,
          ),
        ),

      // All Clinics Header
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeApp.s20,
            vertical: SizeApp.s8,
          ),
          child: Text(
            "جميع العيادات",
            style: textTheme.headlineLarge?.copyWith(
              fontSize: SizeApp.s24,
              fontWeight: FontWeight.bold,
              color: ColorsManager.defaultText,
            ),
          ),
        ),
      ),

      // All Clinics List
      _buildClinicsList(state.allClinics),

      // Loading More Indicator
      if (state.isLoadingMore)
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(SizeApp.s16),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),

      // No More Data Message
      if (!state.hasMorePages && state.allClinics.isNotEmpty)
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(SizeApp.s16),
            child: Center(
              child: Text(
                'لا توجد المزيد من العيادات',
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),

      SliverToBoxAdapter(child: SizedBox(height: SizeApp.s40)),
    ];
  }

  Widget _buildClinicsList(List<ClinicSummary> clinics) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: SizeApp.s20),
      sliver: SliverList.builder(
        itemCount: clinics.length,
        itemBuilder: (context, index) {
          final clinic = clinics[index];
          return Padding(
            padding: EdgeInsets.only(bottom: SizeApp.s12),
            child: ClinicCard(
              clinic: clinic,
              layout: ClinicCardLayout.list,
              onTap: () => _navigateToClinicDetails(clinic),
              onFavoriteToggle: () => _toggleFavorite(clinic),
              onBookNow: () => _bookAppointment(clinic),
            ),
          );
        },
      ),
    );
  }

  // Event Handlers
  void _navigateToClinicDetails(ClinicSummary clinic) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClinicDetailsScreen(
          clinicId: clinic.id,
        ),
      ),
    );
  }

  void _toggleFavorite(ClinicSummary clinic) {
    context.read<HomeCubit>().toggleFavorite(clinic.id);
  }

  void _bookAppointment(ClinicSummary clinic) {
    _navigateToClinicDetails(clinic);
  }

  void _handleNotificationTap() {
    CustomSnackBar.show(
      context,
      message: 'لا توجد إشعارات جديدة',
      type: SnackBarType.info,
    );
  }
}