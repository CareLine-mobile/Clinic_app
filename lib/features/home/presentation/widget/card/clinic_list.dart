// lib/features/clinics/presentation/widgets/clinics_carousel.dart

import 'package:clinic_app/core/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/model/clinic_model.dart';
import '../../../domain/entities/clinic_summary.dart';
import 'clinic_card.dart';

// ==================== Featured Section (Parallax Carousel) ====================
class FeaturedClinicsSection extends StatefulWidget {
  final List<ClinicSummary> clinics;
  final Function(ClinicSummary) onTap;
  final Function(ClinicSummary)? onFavorite;
  final Function(ClinicSummary)? onBook;

  const FeaturedClinicsSection({
    Key? key,
    required this.clinics,
    required this.onTap,
    this.onFavorite,
    this.onBook,
  }) : super(key: key);

  @override
  State<FeaturedClinicsSection> createState() => _FeaturedClinicsSectionState();
}

class _FeaturedClinicsSectionState extends State<FeaturedClinicsSection> {
  late PageController _controller;
  double currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.88);
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted) return;
    setState(() {
      currentPage = _controller.page ?? 0;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // تحديد اتجاه اللغة
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            "العيادات المميزة",
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 420.h,
          child: Directionality(
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            child: PageView.builder(
              controller: _controller,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.clinics.length,
              itemBuilder: (context, index) {
                final clinic = widget.clinics[index];
                final double diff = (currentPage - index).abs();
                // عكس اتجاه الـ parallax في RTL
                final double parallax = (currentPage - index) * 80.w * (isRTL ? -1 : 1);
                final double scale = 1.0 - (diff * 0.035).clamp(0.0, 0.15);
                final double opacity = (1.0 - (diff * 0.15)).clamp(0.5, 1.0);

                return Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: opacity,
                    child: ClinicCard(
                      clinic: clinic,
                      layout: ClinicCardLayout.featured,
                      horizontalParallaxOffset: parallax,
                      onTap: () => widget.onTap(clinic),
                      onFavoriteToggle: () => widget.onFavorite?.call(clinic),
                      onBookNow: () => widget.onBook?.call(clinic),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}

// ==================== Horizontal Carousel Section (Optimized) ====================
class HorizontalClinicsCarousel extends StatefulWidget {
  final List<ClinicSummary> clinics;
  final Function(ClinicSummary) onTap;
  final Function(ClinicSummary)? onFavorite;
  final Function(ClinicSummary)? onBook;
  final String? title;

  const HorizontalClinicsCarousel({
    Key? key,
    required this.clinics,
    required this.onTap,
    this.onFavorite,
    this.onBook,
    this.title,
  }) : super(key: key);

  @override
  State<HorizontalClinicsCarousel> createState() => _HorizontalClinicsCarouselState();
}

class _HorizontalClinicsCarouselState extends State<HorizontalClinicsCarousel> {
  late PageController _controller;
  double currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.88);
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (!mounted) return;
    setState(() {
      currentPage = _controller.page ?? 0;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // تحديد اتجاه اللغة
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              widget.title!,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        if (widget.title != null) SizedBox(height: 16.h),
        SizedBox(
          height: 280.h,
          child: Directionality(
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            child: PageView.builder(
              controller: _controller,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.clinics.length,
              itemBuilder: (context, index) {
                final clinic = widget.clinics[index];
                final double diff = (currentPage - index).abs();
                // عكس اتجاه الـ parallax في RTL
                final double parallax = (currentPage - index) * 60.w * (isRTL ? -1 : 1);
                final double scale = 1.0 - (diff * 0.03).clamp(0.0, 0.12);
                final double opacity = (1.0 - (diff * 0.12)).clamp(0.6, 1.0);

                return Transform.scale(
                  scale: scale,
                  child: Opacity(
                    opacity: opacity,
                    child: ClinicCard(
                      clinic: clinic,
                      layout: ClinicCardLayout.carousel,
                      horizontalParallaxOffset: parallax,
                      onTap: () => widget.onTap(clinic),
                      onFavoriteToggle: () => widget.onFavorite?.call(clinic),
                      onBookNow: () => widget.onBook?.call(clinic),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}

// ==================== Vertical List Section ====================
class ClinicsList extends StatelessWidget {
  final List<ClinicSummary> clinics;
  final Function(ClinicSummary) onTap;
  final Function(ClinicSummary)? onFavorite;
  final Function(ClinicSummary)? onBook;

  const ClinicsList({
    Key? key,
    required this.clinics,
    required this.onTap,
    this.onFavorite,
    this.onBook,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (clinics.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(40.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.local_hospital_outlined,
                size: 64.r,
                color: Colors.grey[300],
              ),
              SizedBox(height: 16.h),
              Text(
                "لا توجد عيادات",
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: clinics.length,
      itemBuilder: (context, index) {
        final clinic = clinics[index];
        return ClinicCard(
          key: ValueKey(clinic.id),
          clinic: clinic,
          layout: ClinicCardLayout.list,
          onTap: () => onTap(clinic),
          onFavoriteToggle: () => onFavorite?.call(clinic),
          onBookNow: () => onBook?.call(clinic),
        );
      },
    );
  }
}