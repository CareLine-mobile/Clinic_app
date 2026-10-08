import 'package:clinic_app/core/utils/app_size.dart';
import 'package:clinic_app/features/clinic_details/domain/entites/clinic_statistics_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClinicStatisticsWidget extends StatelessWidget {
  final ClinicStatisticsEntity statistics;
  final Color accentColor;

  const ClinicStatisticsWidget({
    super.key,
    required this.statistics,
    required this.accentColor,
  });

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
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth >= 900 ? 4 : 2;
              return GridView.count(
                crossAxisCount: crossAxisCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: crossAxisCount == 4 ? 1.25 : 1.0,
                children: [
                  _StatCard(
                    icon: Icons.people_outline,
                    label: 'clinic.statistics.visits'.tr(),
                    value: statistics.totalVisits,
                    color: accentColor,
                  ),
                  _StatCard(
                    icon: Icons.medical_services_outlined,
                    label: 'clinic.statistics.specialists'.tr(),
                    value: statistics.totalDoctors,
                    color: Colors.green,
                  ),
                  _StatCard(
                    icon: Icons.event_available,
                    label: 'clinic.statistics.bookings'.tr(),
                    value: statistics.totalBookings,
                    color: Colors.blue,
                  ),
                  _StatCard(
                    icon: Icons.thumb_up_outlined,
                    label: 'clinic.statistics.satisfaction'.tr(),
                    value: statistics.satisfactionRate,
                    color: Colors.orange,
                    isPercentage: true,
                  ),
                ],
              );
            },
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
  final bool isPercentage;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.isPercentage = false,
  });

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

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
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
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
      child: Padding(
        padding: EdgeInsets.all(8.r),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(widget.icon, size: 22.r, color: widget.color),
              ),
              SizedBox(height: 5.h),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) => Text(
                  widget.isPercentage
                      ? '${_animation.value.toInt()}%'
                      : _animation.value.toInt().toString(),
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                    color: widget.color,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                widget.label,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 11.sp,
                  color: theme.hintColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StyledContainer extends StatelessWidget {
  const _StyledContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
