// lib/features/clinics/presentation/widgets/details/

// ==================== clinic_header_widget.dart ====================
import 'package:clinic_app/features/clinic_details/data/clinic_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_size.dart';
import '../../domain/entites/clinic_entities.dart';

class ClinicHeaderWidget extends StatefulWidget {
  final List<String> imageUrls;
  final double rating;
  final int reviewsCount;
  final bool isOpen;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const ClinicHeaderWidget({
    Key? key,
    required this.imageUrls,
    required this.rating,
    required this.reviewsCount,
    required this.isOpen,
    required this.isFavorite,
    required this.onFavoriteToggle,
  }) : super(key: key);

  @override
  State<ClinicHeaderWidget> createState() => _ClinicHeaderWidgetState();
}

class _ClinicHeaderWidgetState extends State<ClinicHeaderWidget> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vSize = AppSizeVertical.instance;
    final hSize = AppSizeHorizontal.instance;

    return Stack(
      children: [
        // Image Gallery
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          itemCount: widget.imageUrls.length,
          itemBuilder: (context, index) {
            return Image.network(
              widget.imageUrls[index],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.local_hospital, size: 60),
                );
              },
            );
          },
        ),

        // Gradient Overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                ],
              ),
            ),
          ),
        ),

        // Status Badge
        Positioned(
          top: vSize.s50,
          left: hSize.s16,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: hSize.s12, vertical: vSize.s6),
            decoration: BoxDecoration(
              color: widget.isOpen ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(hSize.s20),
            ),
            child: Text(
              widget.isOpen ? 'مفتوح' : 'مغلق',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Favorite Button
        Positioned(
          top: vSize.s50,
          right: hSize.s16,
          child: GestureDetector(
            onTap: widget.onFavoriteToggle,
            child: Container(
              padding: EdgeInsets.all(hSize.s10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: widget.isFavorite ? Colors.red : Colors.grey[700],
                size: 24.r,
              ),
            ),
          ),
        ),

        // Page Indicators
        if (widget.imageUrls.length > 1)
          Positioned(
            bottom: vSize.s16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.imageUrls.length,
                    (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: hSize.s4),
                  width: _currentIndex == index ? 24.w : 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class ClinicStatisticsWidget extends StatelessWidget {
  final ClinicStatistics statistics;
  final Color accentColor;

  const ClinicStatisticsWidget({
    Key? key,
    required this.statistics,
    required this.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // نفترض وجود كلاسات الأحجام الخاصة بك، يمكنك استبدالها بـ SizedBox عادي
    final vSize = AppSizeVertical.instance;
    final hSize = AppSizeHorizontal.instance;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hSize.s20, vertical: vSize.s16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إحصائيات العيادة',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: vSize.s16),

          // تحديد ارتفاع ثابت للشبكة بالكامل لضمان تناسق الـ Expanded
          // يمكنك تعديل الارتفاع (300) حسب حاجتك وتصميم الشاشة
          SizedBox(
            height: 320.h,
            child: Row(
              children: [
                // --- العمود الأول (يمين) ---
                Expanded(
                  child: Column(
                    children: [
                      // الكارت الكبير (الزيارات)
                      Expanded(
                        flex: 3, // نسبة الارتفاع 60%
                        child: _StatCard(
                          icon: Icons.people_outline,
                          label: 'الزيارات',
                          value: statistics.totalVisits.toString(),
                          color: accentColor,
                          isBig: true, // مؤشر لتعديل الحجم الداخلي إن لزم
                        ),
                      ),
                      SizedBox(height: 12.h),
                      // الكارت الصغير (الأطباء)
                      Expanded(
                        flex: 2, // نسبة الارتفاع 40%
                        child: _StatCard(
                          icon: Icons.medical_services_outlined,
                          label: 'الأطباء',
                          value: statistics.totalDoctors.toString(),
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 12.w), // مسافة بين العمودين

                // --- العمود الثاني (يسار) ---
                Expanded(
                  child: Column(
                    children: [
                      // الكارت الصغير (الحجوزات) - عكس العمود الأول
                      Expanded(
                        flex: 2, // نسبة الارتفاع 40%
                        child: _StatCard(
                          icon: Icons.event_available,
                          label: 'الحجوزات',
                          value: statistics.totalBookings.toString(),
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      // الكارت الكبير (الرضا)
                      Expanded(
                        flex: 3, // نسبة الارتفاع 60%
                        child: _StatCard(
                          icon: Icons.thumb_up_outlined,
                          label: 'الرضا',
                          value: '${statistics.satisfactionRate}%',
                          color: Colors.orange,
                          isBig: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isBig; // اختياري: إذا أردت تغيير حجم الأيقونة بناء على حجم الكارت

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.isBig = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _StyledContainer(
      // جعلنا الكارت يملأ المساحة المتاحة له بالكامل
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // توسيط المحتوى عمودياً
        children: [
          FittedBox(
            child: Container(
              padding: EdgeInsets.all(isBig ? 14.r : 10.r), // تكبير الـ padding للكارت الكبير
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: isBig ? 30.r : 24.r, // تكبير الأيقونة للكارت الكبير
                color: color,
              ),
            ),
          ),
          SizedBox(height: isBig ? 12.h : 8.h),
          Text(
            value,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: isBig ? 24.sp : 20.sp, // تحكم في حجم الخط
              color: color,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith( // استخدمت bodyMedium ليكون أوضح
              fontSize: 12.sp,
              color: theme.hintColor,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _StyledContainer extends StatelessWidget {
  const _StyledContainer({
    required this.child,
    this.width,
    this.height
  });

  final Widget child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: ShapeDecoration(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // زيادة التدوير قليلاً ليناسب الشكل الحديث
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
          // يمكنك تخفيف الظلال إذا كانت الشبكة مزدحمة
        ],
      ),
      child: child,
    );
  }
}