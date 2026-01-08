// lib/features/clinics/presentation/screens/clinic_details_screen.dart
import 'package:clinic_app/features/clinic_details/domain/entites/clinic_entities.dart';
import 'package:clinic_app/features/clinic_details/presentation/cubit/clinic_details_cubit.dart';
import 'package:clinic_app/features/home/presentation/cubit/clinics_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_size.dart';
import '../widgets/clinic_calendar_widget.dart';
import '../widgets/clinic_header_widget.dart';
import '../widgets/clinic_image_gallery_widget.dart';
import '../widgets/clinic_info_widget.dart';
import '../widgets/clinic_services_widget.dart';
import '../widgets/reviews_section_widget.dart';


class ClinicDetailsScreen extends StatefulWidget {
  final String clinicId;

  const ClinicDetailsScreen({
    Key? key,
    required this.clinicId,
  }) : super(key: key);

  @override
  State<ClinicDetailsScreen> createState() => _ClinicDetailsScreenState();
}

class _ClinicDetailsScreenState extends State<ClinicDetailsScreen>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late TabController _tabController;

  final _vSize = AppSizeVertical.instance;
  final _hSize = AppSizeHorizontal.instance;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _tabController = TabController(length: 4, vsync: this);

    // Load clinic details
    context.read<ClinicDetailsCubit>().loadClinicDetails(widget.clinicId);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final shouldBeTransparent = offset < 180.h;
    context.read<ClinicUiCubit>().updateAppBarTransparency(shouldBeTransparent);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ClinicDetailsCubit, ClinicDetailsState>(
          listener: _handleClinicStateChanges,
        ),
      ],
      child: BlocBuilder<ClinicDetailsCubit, ClinicDetailsState>(
        bloc: context.read<ClinicDetailsCubit>(),
        builder: (context, state) {
          if (state is ClinicDetailsLoading) {
            return _buildLoadingState();
          }

          if (state is ClinicDetailsError) {
            return _buildErrorState(state.message);
          }

          if (state is ClinicDetailsLoaded) {
            return _buildLoadedState(state.clinic);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _handleClinicStateChanges(BuildContext context, ClinicDetailsState state) {
    if (state is BookingSuccess) {
      _showSuccessSnackBar(context, state.message);
    }

    if (state is BookingError) {
      _showErrorSnackBar(context, state.message);
    }

    if (state is ClinicDetailsError) {
      _showErrorSnackBar(context, state.message);
    }
  }

  Widget _buildLoadingState() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('خطأ'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: Colors.red,
            ),
            SizedBox(height: _vSize.s16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: _vSize.s24),
            ElevatedButton(
              onPressed: () {
                context.read<ClinicDetailsCubit>().loadClinicDetails(widget.clinicId);
              },
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(ClinicDetails clinic) {
    return BlocBuilder<ClinicUiCubit, ClinicUiState>(
      builder: (context, uiState) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: _buildAppBar(clinic, uiState.isAppBarTransparent),
          body: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              _buildImageGallery(clinic),
              _buildClinicInfo(clinic),
              _buildStatistics(clinic),
              _buildPinnedTabBar(clinic),
            ],
            body: _buildTabBarView(clinic, uiState),
          ),
          bottomNavigationBar: uiState.selectedDoctor != null
              ? _buildBottomBar(clinic, uiState.selectedDoctor!)
              : null,
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(ClinicDetails clinic, bool isTransparent) {
    return AppBar(
      backgroundColor: isTransparent
          ? Colors.transparent
          : Theme.of(context).scaffoldBackgroundColor,
      elevation: isTransparent ? 0 : 1,
      leading: _buildAppBarButton(
        icon: Icons.arrow_back,
        isTransparent: isTransparent,
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: isTransparent
          ? null
          : Text(
        clinic.name,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      actions: [
        _buildAppBarButton(
          icon: Icons.share,
          isTransparent: isTransparent,
          onPressed: _onSharePressed,
        ),
        SizedBox(width: _hSize.s8),
      ],
    );
  }

  Widget _buildAppBarButton({
    required IconData icon,
    required bool isTransparent,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Container(
        padding: EdgeInsets.all(_hSize.s8),
        decoration: BoxDecoration(
          color: isTransparent
              ? Colors.white.withOpacity(0.9)
              : Theme.of(context).cardColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isTransparent ? Colors.black : Theme.of(context).iconTheme.color,
        ),
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildImageGallery(ClinicDetails clinic) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 300.h,
        child: ClinicImageGalleryWidget(
          imageUrls: clinic.imageUrls,
          isOpen: clinic.isOpen,
          isFavorite: clinic.isFavorite,
          onFavoriteToggle: _onFavoriteToggle,
        ),
      ),
    );
  }

  Widget _buildClinicInfo(ClinicDetails clinic) {
    return SliverToBoxAdapter(
      child: ClinicInfoWidget(
        name: clinic.name,
        specialty: clinic.specialty,
        location: clinic.location,
        fullAddress: clinic.fullAddress,
        openingHours: clinic.openingHours,
        accentColor: _getAccentColor(clinic),
        contactInfo: clinic.contactInfo,
      ),
    );
  }

  Widget _buildStatistics(ClinicDetails clinic) {
    return SliverToBoxAdapter(
      child: ClinicStatisticsWidget(
        statistics: clinic.statistics,
        accentColor: _getAccentColor(clinic),
      ),
    );
  }

  Widget _buildPinnedTabBar(ClinicDetails clinic) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverTabBarDelegate(
        tabBar: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: _getAccentColor(clinic),
          unselectedLabelColor: Theme.of(context).hintColor,
          indicatorColor: _getAccentColor(clinic),
          labelStyle: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
          onTap: (index) {
            context.read<ClinicUiCubit>().changeTab(index);
          },
          tabs: const [
            Tab(text: 'الحجز'),
            Tab(text: 'الخدمات'),
            Tab(text: 'التقييمات'),
            Tab(text: 'عن العيادة'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBarView(ClinicDetails clinic, ClinicUiState uiState) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildBookingTab(clinic, uiState),
        _buildServicesTab(clinic),
        _buildReviewsTab(clinic),
        _buildAboutTab(clinic),
      ],
    );
  }

  Widget _buildBookingTab(ClinicDetails clinic, ClinicUiState uiState) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(_hSize.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClinicCalendarWidget(
            selectedDate: uiState.selectedDate,
            onDateSelected: (date) {
              context.read<ClinicUiCubit>().selectDate(date);
            },
            accentColor: _getAccentColor(clinic),
          ),
          SizedBox(height: _vSize.s24),
          DoctorListWidget(
            doctors: clinic.doctors,
            selectedDate: uiState.selectedDate,
            selectedDoctor: uiState.selectedDoctor,
            onDoctorSelected: (doctor) {
              context.read<ClinicUiCubit>().selectDoctor(doctor);
            },
            accentColor: _getAccentColor(clinic),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesTab(ClinicDetails clinic) {
    return ClinicServicesWidget(
      services: clinic.services,
      facilities: clinic.facilities,
      insuranceAccepted: clinic.insuranceAccepted,
    );
  }

  Widget _buildReviewsTab(ClinicDetails clinic) {
    return ReviewsSectionWidget(
      reviews: clinic.reviews,
      averageRating: clinic.rating,
      totalReviews: clinic.reviewsCount,
    );
  }

  Widget _buildAboutTab(ClinicDetails clinic) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(_hSize.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'عن العيادة',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: _vSize.s16),
          Text(
            clinic.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: _vSize.s32),
        ],
      ),
    );
  }

  Widget _buildBottomBar(ClinicDetails clinic, Doctor doctor) {
    return Container(
      padding: EdgeInsets.all(_hSize.s20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'سعر الكشف',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '${doctor.consultationFee.toInt()} ج.م',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: _getAccentColor(clinic),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: _hSize.s16),
            Expanded(
              flex: 2,
              child: BlocBuilder<ClinicDetailsCubit, ClinicDetailsState>(
                bloc: context.read<ClinicDetailsCubit>(),
                builder: (context, state) {
                  final isBooking = state is BookingInProgress;

                  return ElevatedButton(
                    onPressed: isBooking ? null : () => _onBookAppointment(doctor),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getAccentColor(clinic),
                      padding: EdgeInsets.symmetric(vertical: _vSize.s16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(_hSize.s12),
                      ),
                    ),
                    child: isBooking
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : Text(
                      'احجز الآن',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Event Handlers
  void _onFavoriteToggle() {
    context.read<ClinicDetailsCubit>().toggleFavorite();
  }

  void _onSharePressed() {
    // TODO: Implement share functionality
    _showInfoSnackBar(context, 'سيتم إضافة المشاركة قريباً');
  }

  void _onBookAppointment(Doctor doctor) {
    final uiState = context.read<ClinicUiCubit>().state;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تأكيد الحجز'),
        content: Text(
          'هل تريد حجز موعد مع ${doctor.name} بتاريخ ${uiState.selectedDate.day}/${uiState.selectedDate.month}/${uiState.selectedDate.year}؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<ClinicDetailsCubit>().bookAppointment(
                doctorId: doctor.id,
                date: uiState.selectedDate,
                timeSlot: '10:00 ص', // TODO: Get from selected slot
              );
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  // Helper Methods
  Color _getAccentColor(ClinicDetails clinic) {
    // Since ClinicDetails doesn't have accentColor (it's in the model),
    // you might want to add it to the entity or use a default color
    return Theme.of(context).primaryColor;
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showInfoSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

// SliverTabBar Delegate
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate({required this.tabBar});

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _SliverTabBarDelegate oldDelegate) => false;
}