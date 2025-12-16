// lib/features/clinics/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../../../../core/utils/app_size.dart';
import '../../../clinic_details/presentation/view/clinic_details_screen.dart';
import '../../data/model/clinic_model.dart';
import '../widget/card/clinic_card.dart';
import '../widget/card/clinic_list.dart';
import '../widget/home_app_bar_widget.dart';
import '../../../../core/theme/colors.dart';

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

  bool _isLoadingBooking = false;

  final List<ClinicModel> _featuredClinics = [
    ClinicModel(
      id: '1',
      name: 'عيادة الدكتور أحمد محمود',
      specialty: 'طب الأسنان',
      location: 'المعادي، القاهرة',
      imageUrl: 'https://images.unsplash.com/photo-1629909613654-28e377c37b09?w=800',
      rating: 4.8,
      reviewsCount: 156,
      nextAppointment: 'غداً 10:00 ص',
      price: 300,
      accentColor: ColorsManager.primaryColor,
      isFavorite: true,
      isOpen: true,
      doctorsCount: 4,
      availableTimes: ['10:00 ص', '12:00 م', '02:00 م', '04:00 م'],
    ),
    ClinicModel(
      id: '2',
      name: 'مركز العناية بالبشرة',
      specialty: 'الأمراض الجلدية',
      location: 'مدينة نصر، القاهرة',
      imageUrl: 'https://images.unsplash.com/photo-1631815588090-d4bfec5b1ccb?w=800',
      rating: 4.9,
      reviewsCount: 243,
      nextAppointment: 'اليوم 03:00 م',
      price: 500,
      accentColor: ColorsManager.primaryColor,
      isFavorite: false,
      isOpen: true,
      doctorsCount: 4,
      availableTimes: ['09:00 ص', '11:00 ص', '03:00 م', '05:00 م'],
    ),
    ClinicModel(
      id: '3',
      name: 'عيادة القلب المتخصصة',
      specialty: 'أمراض القلب',
      location: 'الزمالك، القاهرة',
      imageUrl: 'https://images.unsplash.com/photo-1551076805-e1869033e561?w=800',
      rating: 4.7,
      reviewsCount: 189,
      nextAppointment: 'بعد غد 11:00 ص',
      price: 450,
      accentColor: ColorsManager.primaryColor,
      isFavorite: true,
      isOpen: true,
      doctorsCount: 4,
      availableTimes: ['08:00 ص', '10:00 ص', '12:00 م', '02:00 م'],
    ),
  ];

  List<ClinicModel> _nearbyClinics = [];
  List<ClinicModel> _allClinics = [];

  @override
  void initState() {
    super.initState();
    _initializeClinics();
  }

  @override
  void dispose() {

    super.dispose();
  }

  void _initializeClinics() {
    _nearbyClinics = [
      ClinicModel(
        id: '4',
        name: 'عيادة العيون المتخصصة',
        specialty: 'طب العيون',
        location: 'الدقي، الجيزة',
        imageUrl: 'https://images.unsplash.com/photo-1551076805-e1869033e561?w=800',
        rating: 4.6,
        reviewsCount: 132,
        nextAppointment: 'السبت 09:00 ص',
        price: 400,
        accentColor: ColorsManager.primaryColor,
        isFavorite: true,
        isOpen: true,
        doctorsCount: 4,
        availableTimes: ['09:00 ص', '11:00 ص', '01:00 م', '03:00 م'],
      ),
      ClinicModel(
        id: '5',
        name: 'مركز الطب النفسي',
        specialty: 'الطب النفسي',
        location: 'المهندسين، الجيزة',
        imageUrl: 'https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e?w=800',
        rating: 4.5,
        reviewsCount: 98,
        nextAppointment: 'اليوم 05:00 م',
        price: 350,
        accentColor:ColorsManager.primaryColor,
        isFavorite: false,
        isOpen: true,
        doctorsCount: 4,
        availableTimes: ['10:00 ص', '02:00 م', '05:00 م'],
      ),
      ClinicModel(
        id: '6',
        name: 'عيادة الأطفال الحديثة',
        specialty: 'طب الأطفال',
        location: 'مصر الجديدة، القاهرة',
        imageUrl: 'https://images.unsplash.com/photo-1551190822-a9333d879b1f?w=800',
        rating: 4.9,
        reviewsCount: 276,
        nextAppointment: 'غداً 08:00 ص',
        price: 280,
        accentColor: ColorsManager.primaryColor,
        isFavorite: false,
        isOpen: true,
        doctorsCount: 4,
        availableTimes: ['08:00 ص', '10:00 ص', '12:00 م', '03:00 م'],
      ),
    ];
    _simulateLoadingBooking();
    _allClinics = [..._featuredClinics, ..._nearbyClinics];
  }

  void _simulateLoadingBooking() async {
    setState(() => _isLoadingBooking = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoadingBooking = false);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: ColorsManager.backgroundSurface,
      body: CustomScrollView(

        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header Widget with Search inside
          HomeHeaderWidget(
            userName: 'أحمد محمد',
            userPhotoUrl: null,
            lastBooking: _featuredClinics.first,
            queuePosition: 5,
            peopleAhead: 4,
            onNotificationTap: () {},
            onBookingCardTap: () => _showClinicDetails(_featuredClinics.first),
            onSearchTap: () {
              // Navigate to search screen (index 1)
              widget.onNavigateToSearch?.call(1);
            },
            isLoading: _isLoadingBooking,
          ),

          SliverToBoxAdapter(child: SizedBox(height: SizeApp.s50)),

          // Featured Clinics
          SliverToBoxAdapter(
            child: FeaturedClinicsSection(
              clinics: _featuredClinics,
              onTap: _showClinicDetails,
              onFavorite: _toggleFavorite,
              onBook: _bookAppointment,

            ),
          ),

          // Nearby Clinics
          SliverToBoxAdapter(
            child: HorizontalClinicsCarousel(
              clinics: _nearbyClinics,
              title: "العيادات القريبة",
              onTap: _showClinicDetails,
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
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: SizeApp.s20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final clinic = _allClinics[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: SizeApp.s12),
                    child: ClinicCard(
                      clinic: clinic,
                      layout: ClinicCardLayout.list,
                      onTap: () => _showClinicDetails(clinic),
                      onFavoriteToggle: () => _toggleFavorite(clinic),
                      onBookNow: () => _bookAppointment(clinic),

                    ),
                  );
                },
                childCount: _allClinics.length,
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: SizeApp.s40)),
        ],
      ),
    );
  }

  void _showClinicDetails(ClinicModel clinic) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClinicDetailsScreen(
          clinicId: clinic.id,
        ),
      ),
    );
  }

  void _toggleFavorite(ClinicModel clinic) {
    setState(() {
      final featuredIndex =
      _featuredClinics.indexWhere((c) => c.id == clinic.id);
      if (featuredIndex != -1) {
        _featuredClinics[featuredIndex] = clinic.copyWith(
          isFavorite: !clinic.isFavorite,
        );
      }

      final nearbyIndex = _nearbyClinics.indexWhere((c) => c.id == clinic.id);
      if (nearbyIndex != -1) {
        _nearbyClinics[nearbyIndex] = clinic.copyWith(
          isFavorite: !clinic.isFavorite,
        );
      }

      final allIndex = _allClinics.indexWhere((c) => c.id == clinic.id);
      if (allIndex != -1) {
        _allClinics[allIndex] = clinic.copyWith(
          isFavorite: !clinic.isFavorite,
        );
      }
    });
  }

  void _bookAppointment(ClinicModel clinic) {
    final textTheme = Theme.of(context).textTheme;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.white,
              size: SizeApp.iconSize,
            ),
            SizedBox(width: SizeApp.s12),
            Expanded(
              child: Text(
                'جاري حجز موعد في ${clinic.name}...',
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: SizeApp.s16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: clinic.accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeApp.s12),
        ),
        margin: EdgeInsets.all(SizeApp.s16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}