// lib/features/home/presentation/screens/home_screen.dart

import 'package:clinic_app/core/routes/routes.dart';
import 'package:clinic_app/core/utils/enums.dart';
import 'package:clinic_app/core/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../booking/presentation/cubit/booking_cubit.dart';
import '../../../clinic_details/presentation/view/clinic_details_screen.dart';
import '../../../user_data/user_repo.dart';
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

  const HomeScreen({Key? key, this.onNavigateToSearch}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<HomeCubit>().initHome();

    // Load bookings only if user is logged in
    if (UserRepository().isLoggedIn) {
      context.read<BookingCubit>().loadBookings();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<HomeCubit>().loadMoreClinics();
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final max = _scrollController.position.maxScrollExtent;
    return _scrollController.offset >= (max * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  _buildHeader(),
                  ..._buildLoadedBody(state, textTheme),
                ],
              ),
            );
          }

          if (state is HomeLoading) {
            return CustomScrollView(
              physics: const NeverScrollableScrollPhysics(),
              slivers: [
                _buildHeader(),
                const SliverFillRemaining(child: HomeBodyShimmer()),
              ],
            );
          }

          if (state is HomeError) {
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildHeader(),
                SliverFillRemaining(
                  child: ErrorStateWidget(
                    failure: state.failure,
                    onRetry: () => context.read<HomeCubit>().initHome(),
                  ),
                ),
              ],
            );
          }

          return CustomScrollView(
            slivers: [
              _buildHeader(),
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Header — reads user from singleton, booking from BookingCubit ─────────

  Widget _buildHeader() {
    return HomeHeaderWidget(
      userName: UserRepository().currentUser?.name,
      userPhotoUrl: UserRepository().currentUser?.avatar,
      onNotificationTap: _handleNotificationTap,
      onBookingCardTap: () {
        // BookingCubit state is accessible here if needed for navigation
      },
      onSearchTap: () => widget.onNavigateToSearch?.call(1),
    );
  }

  // ── State listener ────────────────────────────────────────────────────────

  void _handleStateChanges(BuildContext context, HomeState state) {
    if (state is HomeError) {
      CustomSnackBar.show(
        context,
        message: state.failure.message,
        type: SnackBarType.error,
      );
    }
  }

  // ── Loaded body ───────────────────────────────────────────────────────────

  List<Widget> _buildLoadedBody(HomeLoaded state, TextTheme textTheme) {
    return [
      SliverToBoxAdapter(child: SizedBox(height: SizeApp.s50)),

      if (state.featuredClinics.isNotEmpty)
        SliverToBoxAdapter(
          child: FeaturedClinicsSection(
            clinics: state.featuredClinics,
            onTap: _navigateToClinicDetails,
            onFavorite: _toggleFavorite,
            onBook: _bookAppointment,
          ),
        ),

      if (state.nearbyClinics.isNotEmpty)
        SliverToBoxAdapter(
          child: HorizontalClinicsCarousel(
            clinics: state.nearbyClinics,
            title: 'العيادات القريبة',
            onTap: _navigateToClinicDetails,
            onFavorite: _toggleFavorite,
            onBook: _bookAppointment,
          ),
        ),

      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeApp.s20,
            vertical: SizeApp.s8,
          ),
          child: Text(
            'جميع العيادات',
            style: textTheme.headlineLarge?.copyWith(
              fontSize: SizeApp.s24,
              fontWeight: FontWeight.bold,
              color: ColorsManager.defaultText,
            ),
          ),
        ),
      ),

      _buildClinicsList(state.allClinics),

      if (state.isLoadingMore)
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(SizeApp.s16),
            child: const Center(child: CircularProgressIndicator()),
          ),
        ),

      if (!state.hasMorePages && state.allClinics.isNotEmpty)
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(SizeApp.s16),
            child: Center(
              child: Text(
                'لا توجد المزيد من العيادات',
                style: textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ),
          ),
        ),

      if (state.allClinics.isEmpty &&
          state.featuredClinics.isEmpty &&
          state.nearbyClinics.isEmpty)
        SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.local_hospital_outlined,
                    size: 80, color: Colors.grey[400]),
                SizedBox(height: SizeApp.s16),
                Text(
                  'لا توجد عيادات متاحة',
                  style: textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),

      SliverToBoxAdapter(child: SizedBox(height: SizeApp.s40)),
    ];
  }

  // ── Clinics list ──────────────────────────────────────────────────────────

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

  // ── Event handlers ────────────────────────────────────────────────────────

  void _navigateToClinicDetails(ClinicSummary clinic) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (_) => ClinicDetailsScreen(clinicId: clinic.id),
    //   ),
    // );
    Navigator.pushNamed(context, Routes.clinicDetails, arguments: clinic.id);
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