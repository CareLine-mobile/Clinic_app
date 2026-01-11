// lib/features/home/presentation/screens/home_screen.dart

import 'package:clinic_app/core/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/theme/colors.dart';
import '../../../clinic_details/presentation/view/clinic_details_screen.dart';
import '../../domain/entities/clinic_summary.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_ui_cubit.dart';
import '../widget/card/clinic_card.dart';
import '../widget/card/clinic_list.dart';
import '../widget/home_app_bar_widget.dart';

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
  @override
  void initState() {
    super.initState();
    // Load clinics when screen initializes
    context.read<HomeCubit>().loadClinics();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: ColorsManager.backgroundSurface,
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: _handleStateChanges,
        builder: (context, state) {
          if (state is HomeLoading) {
            return _buildLoadingState();
          }

          if (state is HomeError) {
            return _buildErrorState(state.message);
          }

          if (state is HomeLoaded) {
            return _buildLoadedState(state, textTheme);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _handleStateChanges(BuildContext context, HomeState state) {
    // Handle any state changes that need UI feedback
    if (state is HomeError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          SizedBox(height: SizeApp.s16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: SizeApp.s24),
          ElevatedButton(
            onPressed: () => context.read<HomeCubit>().loadClinics(),
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(HomeLoaded state, TextTheme textTheme) {
    return RefreshIndicator(
      onRefresh: () => context.read<HomeCubit>().refresh(),
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header with Search
          _buildHeader(state),

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

          SliverToBoxAdapter(child: SizedBox(height: SizeApp.s40)),
        ],
      ),
    );
  }

  Widget _buildHeader(HomeLoaded state) {
    return BlocBuilder<HomeUiCubit, HomeUiState>(
      builder: (context, uiState) {
        return HomeHeaderWidget(
          userName: 'أحمد محمد',
          userPhotoUrl: null,
          lastBooking: state.lastBooking,
          queuePosition: 5,
          peopleAhead: 4,
          onNotificationTap: _handleNotificationTap,
          onBookingCardTap: () {
            if (state.lastBooking != null) {
              _navigateToClinicDetails(state.lastBooking!);
            }
          },
          onSearchTap: () => widget.onNavigateToSearch?.call(1),
          isLoading: uiState.isBookingLoading,
        );
      },
    );
  }

  Widget _buildClinicsList(List<ClinicSummary> clinics) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: SizeApp.s20),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) {
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
          childCount: clinics.length,
        ),
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          clinic.isFavorite ? 'تم الإزالة من المفضلة' : 'تم الإضافة للمفضلة',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _bookAppointment(ClinicSummary clinic) {
    final uiCubit = context.read<HomeUiCubit>();
    final homeCubit = context.read<HomeCubit>();

    // Start booking loading
    uiCubit.startBooking(clinic.id);

    // Perform booking
    homeCubit.bookAppointment(clinic.id).then((_) {
      // Finish booking loading
      uiCubit.finishBooking();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              SizedBox(width: SizeApp.s12),
              Expanded(
                child: Text(
                  'جاري حجز موعد في ${clinic.name}...',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: ColorsManager.primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeApp.s12),
          ),
          margin: EdgeInsets.all(SizeApp.s16),
          duration: const Duration(seconds: 2),
        ),
      );
    }).catchError((error) {
      uiCubit.cancelBooking();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل الحجز: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  void _handleNotificationTap() {
    // TODO: Navigate to notifications screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('لا توجد إشعارات جديدة'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}

