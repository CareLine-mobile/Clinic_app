// lib/features/home/presentation/screens/home_screen.dart

import 'package:clinic_app/core/errors/failures.dart';
import 'package:clinic_app/core/utils/location/location_error_handler.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:clinic_app/core/routes/routes.dart';
import 'package:clinic_app/core/utils/enums.dart';
import 'package:clinic_app/core/widgets/card/clinic_card.dart';
import 'package:clinic_app/core/widgets/card/clinic_list.dart';
import 'package:clinic_app/core/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/utils/location/location_utils.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../my_booking/presentation/cubit/booking_cubit.dart';
import '../../../user_data/user_repo.dart';
import '../../domain/entities/clinic_summary.dart';
import '../cubit/home_cubit.dart';
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
  //  context.read<HomeCubit>().initHome();

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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: _handleStateChanges,
        // ─── Don't rebuild for same state type ───────────────────
        buildWhen: (prev, curr) => curr.runtimeType != prev.runtimeType ||
            curr is HomeLoaded,
        builder: (context, state) {
          if (state is HomeLoaded) {
            return ClinicRefreshIndicator(
              onRefresh: () => context.read<HomeCubit>().refresh(),
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildHeader(),
                  ..._buildLoadedBody(state),
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

          // HomeInitial or fallback
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

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return HomeHeaderWidget(
      userName: UserRepository().currentUser?.name,
      userPhotoUrl: UserRepository().currentUser?.avatar,
      onNotificationTap: _handleNotificationTap,
      onBookingCardTap: () {},
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
    } else if(state is LocationError) {

      if (state.failure is LocationFailure){

        final f = state.failure as LocationFailure;
        if(f.locationErrorType == LocationErrorType.serviceDisabled){

        }
     //   LocationErrorHandler.handleError(f.locationErrorType, context);
      }

     }
  }

  // ── Loaded body ───────────────────────────────────────────────────────────

  List<Widget> _buildLoadedBody(HomeLoaded state) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final v = AppSizeVertical.instance;
    final h = AppSizeHorizontal.instance;

    return [
      SliverToBoxAdapter(child: SizedBox(height: v.s50)),

      // ─── Featured ──────────────────────────────────────────────
      if (state.featuredClinics.isNotEmpty)
        SliverToBoxAdapter(
          child: FeaturedClinicsSection(
            clinics: state.featuredClinics,
            onTap: _navigateToClinicDetails,
            onFavorite: _toggleFavorite,
            onBook: _bookAppointment,
          ),
        ),

      // ─── Nearby ────────────────────────────────────────────────
      if (state.nearbyClinics.isNotEmpty)
        SliverToBoxAdapter(
          child: HorizontalClinicsCarousel(
            clinics: state.nearbyClinics,
            title: 'home.sections.nearby'.tr(),
            onTap: _navigateToClinicDetails,
            onFavorite: _toggleFavorite,
            onBook: _bookAppointment,
            trailing: InkWell(
              onTap: () => Navigator.of(context).pushNamed(Routes.mapLocations),
              borderRadius: BorderRadius.circular(100.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'map.view_map'.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.map_outlined,
                        size: 14.sp,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

      // ─── All clinics title ─────────────────────────────────────
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.fromLTRB(h.s20, v.s16, h.s20, v.s8),
          child: Text(
            'home.sections.all_clinics'.tr(),
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

      // ─── Clinics list ──────────────────────────────────────────
      _buildClinicsList(state.allClinics),

      // ─── Load more indicator ───────────────────────────────────
      if (state.isLoadingMore)
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(v.s16),
            child: Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
                strokeWidth: 2.5,
              ),
            ),
          ),
        ),

      // ─── End of list ───────────────────────────────────────────
      if (!state.hasMorePages && state.allClinics.isNotEmpty)
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: v.s20),
            child: Row(
              children: [
                Expanded(
                  child: Divider(color: theme.dividerColor.withOpacity(0.3)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: h.s12),
                  child: Text(
                    'home.sections.no_more'.tr(),
                    style: textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(color: theme.dividerColor.withOpacity(0.3)),
                ),
              ],
            ),
          ),
        ),

      // ─── Completely empty state ────────────────────────────────
      if (state.allClinics.isEmpty &&
          state.featuredClinics.isEmpty &&
          state.nearbyClinics.isEmpty)
        SliverFillRemaining(
          child: _EmptyHomeView(),
        ),

      SliverToBoxAdapter(child: SizedBox(height: v.s40)),
    ];
  }

  // ── Clinics list ──────────────────────────────────────────────────────────

  Widget _buildClinicsList(List<ClinicSummary> clinics) {
    final h = AppSizeHorizontal.instance;
    final v = AppSizeVertical.instance;

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: h.s16),
      sliver: SliverList.builder(
        itemCount: clinics.length,
        itemBuilder: (context, index) {
          final clinic = clinics[index];
          return Padding(
            padding: EdgeInsets.only(bottom: v.s12),
            child: ClinicCard(
              key: ValueKey(clinic.id),
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

  void _navigateToClinicDetails(ClinicSummary clinic) =>
      Navigator.pushNamed(context, Routes.clinicDetails, arguments: clinic.id);

  void _toggleFavorite(ClinicSummary clinic) =>
      context.read<HomeCubit>().toggleFavorite(clinic.id);

  void _bookAppointment(ClinicSummary clinic) =>
      _navigateToClinicDetails(clinic);

  void _handleNotificationTap() {
    CustomSnackBar.show(
      context,
      message: 'home.no_notifications'.tr(),
      type: SnackBarType.info,
    );
  }
}

// ─── Empty home view ──────────────────────────────────────────────────────────

class _EmptyHomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final v = AppSizeVertical.instance;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_hospital_outlined,
            size: 72,
            color: theme.hintColor.withOpacity(0.3),
          ),
          SizedBox(height: v.s16),
          Text(
            'home.sections.empty_title'.tr(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: v.s8),
          Text(
            'home.sections.empty_subtitle'.tr(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.hintColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}