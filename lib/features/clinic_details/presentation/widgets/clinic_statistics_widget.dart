import 'package:clinic_app/core/utils/app_size.dart';
import 'package:clinic_app/features/clinic_details/domain/entites/clinic_statistics_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClinicStatisticsWidget extends StatelessWidget {
  final ClinicStatisticsEntity statistics;
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
      padding: EdgeInsets.symmetric(horizontal: hSize.s20, vertical: vSize.s12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'clinic.statistics.title'.tr(),
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: vSize.s12),

          // Reduced height from 320 to 240
          SizedBox(
            height: 240.h,
            child: Row(
              children: [
                // --- العمود الأول (يمين) ---
                Expanded(
                  child: Column(
                    children: [
                      // الكارت الكبير (الزيارات)
                      Expanded(
                        flex: 3,
                        child: _StatCard(
                          icon: Icons.people_outline,
                          label: 'clinic.statistics.visits'.tr(),
                          value: statistics.totalVisits,
                          color: accentColor,
                          isBig: true,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      // الكارت الصغير (الأطباء)
                      Expanded(
                        flex: 2,
                        child: _StatCard(
                          icon: Icons.medical_services_outlined,
                          label: 'clinic.statistics.specialists'.tr(),
                          value: statistics.totalDoctors,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 10.w),

                // --- العمود الثاني (يسار) ---
                Expanded(
                  child: Column(
                    children: [
                      // الكارت الصغير (الحجوزات)
                      Expanded(
                        flex: 2,
                        child: _StatCard(
                          icon: Icons.event_available,
                          label: 'clinic.statistics.bookings'.tr(),
                          value: statistics.totalBookings,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      // الكارت الكبير (الرضا)
                      Expanded(
                        flex: 3,
                        child: _StatCard(
                          icon: Icons.thumb_up_outlined,
                          label: 'clinic.statistics.satisfaction'.tr(),
                          value: statistics.satisfactionRate,
                          color: Colors.orange,
                          isBig: true,
                          isPercentage: true,
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

class _StatCard extends StatefulWidget {
  final IconData icon;
  final String label;
  final int value;
  final Color color;
  final bool isBig;
  final bool isPercentage;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.isBig = false,
    this.isPercentage = false,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.value.toDouble(),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _StyledContainer(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // Add this to prevent overflow
        children: [
          Container(
            padding: EdgeInsets.all(widget.isBig ? 10.r : 8.r),
            decoration: BoxDecoration(
              color: widget.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              widget.icon,
              size: widget.isBig ? 24.r : 20.r,
              color: widget.color,
            ),
          ),
          SizedBox(height: widget.isBig ? 6.h : 4.h), // Reduced from 8.h : 6.h
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Text(
                widget.isPercentage
                    ? '${_animation.value.toInt()}%'
                    : _animation.value.toInt().toString(),
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: widget.isBig ? 20.sp : 18.sp,
                  color: widget.color,
                ),
              );
            },
          ),
          SizedBox(height: 1.h), // Reduced from 2.h
          Text(
            widget.label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 11.sp,
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
    this.height,
  });

  final Widget child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      // FIX: Reduced vertical padding from 8.h to 4.h
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 6.w),
      decoration: ShapeDecoration(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }
}