// lib/features/clinics/presentation/screens/clinic_details_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_size.dart';
import '../../../../core/theme/colors.dart';
import '../../data/clinic_details_model.dart';
import '../widgets/clinic_calendar_widget.dart';
import '../widgets/clinic_header_widget.dart';
import '../widgets/clinic_image_gallery_widget.dart';
import '../widgets/clinic_info_widget.dart';
import '../widgets/clinic_services_widget.dart';
import '../widgets/reviews_section_widget.dart';


class ClinicDetailsScreen extends StatefulWidget {
  final String clinicId;

  const ClinicDetailsScreen({Key? key, required this.clinicId}) : super(key: key);

  @override
  State<ClinicDetailsScreen> createState() => _ClinicDetailsScreenState();
}

class _ClinicDetailsScreenState extends State<ClinicDetailsScreen>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  bool _appBarTransparent = true;
  DateTime _selectedDate = DateTime.now();
  DoctorModel? _selectedDoctor;
  late TabController _tabController;

  final _vSize = AppSizeVertical.instance;
  final _hSize = AppSizeHorizontal.instance;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _tabController = TabController(length: 4, vsync: this);
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final shouldBeTransparent = offset < 180.h;
    if (shouldBeTransparent != _appBarTransparent) {
      setState(() => _appBarTransparent = shouldBeTransparent);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clinicDetails = _getDummyClinicDetails(); // dummy data

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(clinicDetails),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          // Header (Image Gallery) - مع ارتفاع ثابت
          SliverToBoxAdapter(
            child: SizedBox(
              height: 300.h, // أو MediaQuery.of(context).size.height * 0.4
              child: ClinicImageGalleryWidget(  // استخدم النسخة المعدلة اللي تحت
                imageUrls: clinicDetails.imageUrls,
                isOpen: clinicDetails.isOpen,
                isFavorite: clinicDetails.isFavorite,
                onFavoriteToggle: () => _toggleFavorite(clinicDetails),
              ),
            ),
          ),

          // Clinic Info
          SliverToBoxAdapter(
            child: ClinicInfoWidget(
              name: clinicDetails.name,
              specialty: clinicDetails.specialty,
              location: clinicDetails.location,
              fullAddress: clinicDetails.fullAddress,
              openingHours: clinicDetails.openingHours,
              accentColor: clinicDetails.accentColor,
              contactInfo: clinicDetails.contactInfo,
            ),
          ),

          // Statistics
          SliverToBoxAdapter(
            child: ClinicStatisticsWidget(
              statistics: clinicDetails.statistics,
              accentColor: clinicDetails.accentColor,
            ),
          ),

          // Pinned TabBar
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverTabBarDelegate(
              tabBar: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: clinicDetails.accentColor,
                unselectedLabelColor: theme.hintColor,
                indicatorColor: clinicDetails.accentColor,
                labelStyle: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: 'الحجز'),
                  Tab(text: 'الخدمات'),
                  Tab(text: 'التقييمات'),
                  Tab(text: 'عن العيادة'),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildBookingTab(clinicDetails),
            ClinicServicesWidget(
              services: clinicDetails.services,
              facilities: clinicDetails.facilities,
              insuranceAccepted: clinicDetails.insuranceAccepted,
            ),
            ReviewsSectionWidget(
              reviews: clinicDetails.reviews,
              averageRating: clinicDetails.rating,
              totalReviews: clinicDetails.reviewsCount,
            ),
            _buildAboutTab(clinicDetails),
          ],
        ),
      ),
      bottomNavigationBar: _selectedDoctor != null ? _buildBottomBar(clinicDetails) : null,
    );
  }

  // باقي المتودز زي _buildAppBar, _toggleFavorite, _bookAppointment ... نفس اللي عندك

  Widget _buildBookingTab(ClinicDetailsModel clinic) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(_hSize.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClinicCalendarWidget(
            selectedDate: _selectedDate,
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
                _selectedDoctor = null;
              });
            },
            accentColor: clinic.accentColor,
          ),
          SizedBox(height: _vSize.s24),
          DoctorListWidget(
            doctors: clinic.doctors,
            selectedDate: _selectedDate,
            selectedDoctor: _selectedDoctor,
            onDoctorSelected: (doctor) => setState(() => _selectedDoctor = doctor),
            accentColor: clinic.accentColor,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutTab(ClinicDetailsModel clinic) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(_hSize.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('عن العيادة', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: _vSize.s16),
          Text(clinic.description, style: Theme.of(context).textTheme.bodyMedium),
          SizedBox(height: _vSize.s32),
          // يمكن تضيف خريطة هنا لو عايز
        ],
      ),
    );
  }

  Widget? _buildBottomBar(ClinicDetailsModel clinic) {
    return Container(
      padding: EdgeInsets.all(_hSize.s20),
      decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2))]),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Text('سعر الكشف', style: Theme.of(context).textTheme.bodySmall), Text('${_selectedDoctor!.consultationFee.toInt()} ج.م', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: clinic.accentColor, fontWeight: FontWeight.bold))])),
            SizedBox(width: _hSize.s16),
            Expanded(flex: 2, child: ElevatedButton(onPressed: () => _bookAppointment(_selectedDoctor!), style: ElevatedButton.styleFrom(backgroundColor: clinic.accentColor, padding: EdgeInsets.symmetric(vertical: _vSize.s16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_hSize.s12))), child: Text('احجز الآن', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.white)))),
          ],
        ),
      ),
    );
  }

  // Dummy data ... نفس اللي عندك
  PreferredSizeWidget _buildAppBar(ClinicDetailsModel clinic) {
    return AppBar(
      backgroundColor: _appBarTransparent
          ? Colors.transparent
          : Theme.of(context).scaffoldBackgroundColor,
      elevation: _appBarTransparent ? 0 : 1,
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(_hSize.s8),
          decoration: BoxDecoration(
            color: _appBarTransparent
                ? Colors.white.withOpacity(0.9)
                : Theme.of(context).cardColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_back,
            color: _appBarTransparent
                ? Colors.black
                : Theme.of(context).iconTheme.color,
          ),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: _appBarTransparent
          ? null
          : Text(
        clinic.name,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: EdgeInsets.all(_hSize.s8),
            decoration: BoxDecoration(
              color: _appBarTransparent
                  ? Colors.white.withOpacity(0.9)
                  : Theme.of(context).cardColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.share,
              color: _appBarTransparent
                  ? Colors.black
                  : Theme.of(context).iconTheme.color,
            ),
          ),
          onPressed: () {},
        ),
        SizedBox(width: _hSize.s8),
      ],
    );
  }



  void _toggleFavorite(ClinicDetailsModel clinic) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          clinic.isFavorite ? 'تم الإزالة من المفضلة' : 'تم الإضافة للمفضلة',
        ),
      ),
    );
  }

  void _bookAppointment(DoctorModel doctor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحجز'),
        content: Text(
          'هل تريد حجز موعد مع ${doctor.name} بتاريخ ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم الحجز بنجاح!'),
                ),
              );
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  // Dummy data
  ClinicDetailsModel _getDummyClinicDetails() {
    return ClinicDetailsModel(
      id: '1',
      name: 'عيادة الدكتور أحمد محمود',
      specialty: 'طب الأسنان',
      description:
      'عيادة متخصصة في طب الأسنان التجميلي والعلاجي مع أحدث التقنيات والمعدات الطبية المتطورة.',
      location: 'المعادي، القاهرة',
      fullAddress: 'شارع 9، المعادي، القاهرة، مصر',
      latitude: 29.960258,
      longitude: 31.250774,
      imageUrls: [
        'https://images.unsplash.com/photo-1629909613654-28e377c37b09?w=800',
        'https://images.unsplash.com/photo-1551076805-e1869033e561?w=800',
        'https://images.unsplash.com/photo-1588776814546-1ffcf47267a5?w=800',
      ],
      rating: 4.8,
      reviewsCount: 156,
      price: 300,
      accentColor: ColorsManager.primaryColor,
      isFavorite: false,
      isOpen: true,
      openingHours: 'السبت - الخميس: 9 ص - 9 م',
      services: ['تنظيف أسنان', 'حشو عصب', 'تركيبات', 'تقويم أسنان', 'تبييض', 'زراعة'],
      facilities: ['موقف سيارات', 'صيدلية', 'معمل تحاليل'],
      insuranceAccepted: ['التأمين الصحي', 'بوبا', 'مصر للتأمين'],
      doctors: _getDummyDoctors(),
      reviews: _getDummyReviews(),
      statistics: ClinicStatistics(
        totalVisits: 2450,
        totalBookings: 1823,
        totalDoctors: 4,
        satisfactionRate: 96,
        monthlyVisits: {},
      ),
      contactInfo: ContactInfo(
        phone: '+20 123 456 7890',
        email: 'info@clinic.com',
        website: 'www.clinic.com',
        socialMedia: {},
      ),
    );
  }

  List<DoctorModel> _getDummyDoctors() {
    return List.generate(
      4,
          (index) => DoctorModel(
        id: '$index',
        name: 'د. ${['أحمد محمود', 'سارة علي', 'محمد حسن', 'نورا خالد'][index]}',
        specialty: 'استشاري ${['أسنان', 'تقويم', 'جراحة', 'أطفال'][index]}',
        imageUrl: 'https://i.pravatar.cc/150?img=${index + 1}',
        rating: 4.5 + (index * 0.1),
        reviewsCount: 50 + (index * 10),
        experienceYears: 10 + index,
        qualifications: 'بكالوريوس طب وجراحة الفم والأسنان',
        bio: 'طبيب متخصص مع خبرة واسعة في المجال',
        languages: ['العربية', 'الإنجليزية'],
        availableSlots: _getDummySlots(),
        consultationFee: 300 + (index * 50),
      ),
    );
  }

  List<DoctorAvailabilitySlot> _getDummySlots() {
    final now = DateTime.now();
    return List.generate(
      5,
          (index) => DoctorAvailabilitySlot(
        dateTime: now.add(Duration(days: index)),
        timeSlot: '${10 + index}:00 ص',
        isAvailable: index % 2 == 0,
        bookedCount: index,
        maxBookings: 5,
      ),
    );
  }

  List<ReviewModel> _getDummyReviews() {
    return List.generate(
      5,
          (index) => ReviewModel(
        id: '$index',
        patientName: 'مريض ${index + 1}',
        patientImageUrl: 'https://i.pravatar.cc/100?img=${index + 10}',
        rating: 4.0 + (index * 0.2),
        comment: 'تجربة ممتازة والخدمة رائعة',
        date: DateTime.now().subtract(Duration(days: index * 7)),
        doctorName: 'د. أحمد محمود',
      ),
    );
  }
}

// SliverTabBar Delegate (مهم جدًا للـ pinned tab)
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _SliverTabBarDelegate({required this.tabBar});

  @override double get minExtent => tabBar.preferredSize.height;
  @override double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Theme.of(context).scaffoldBackgroundColor, child: tabBar);
  }

  @override bool shouldRebuild(covariant _SliverTabBarDelegate oldDelegate) => false;
}