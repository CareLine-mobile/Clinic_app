// lib/features/clinics/presentation/widgets/details/

// ==================== clinic_header_widget.dart ====================
import 'package:clinic_app/features/clinic_details/data/clinic_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_size.dart';

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

// ==================== clinic_statistics_widget.dart ====================
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
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.people_outline,
                  label: 'إجمالي الزيارات',
                  value: statistics.totalVisits.toString(),
                  color: accentColor,
                ),
              ),
              SizedBox(width: hSize.s12),
              Expanded(
                child: _StatCard(
                  icon: Icons.event_available,
                  label: 'الحجوزات',
                  value: statistics.totalBookings.toString(),
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          SizedBox(height: vSize.s12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.medical_services_outlined,
                  label: 'الأطباء',
                  value: statistics.totalDoctors.toString(),
                  color: Colors.green,
                ),
              ),
              SizedBox(width: hSize.s12),
              Expanded(
                child: _StatCard(
                  icon: Icons.thumb_up_outlined,
                  label: 'رضا المرضى',
                  value: '${statistics.satisfactionRate}%',
                  color: Colors.orange,
                ),
              ),
            ],
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

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vSize = AppSizeVertical.instance;
    final hSize = AppSizeHorizontal.instance;

    return Container(
      padding: EdgeInsets.all(hSize.s16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(hSize.s12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32.r, color: color),
          SizedBox(height: vSize.s8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: vSize.s4),
          Text(
            label,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
