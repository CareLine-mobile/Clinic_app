// lib/features/clinics/presentation/widgets/clinic_card.dart

import 'package:clinic_app/core/utils/app_size.dart';
import 'package:clinic_app/core/utils/assets.dart';
import 'package:clinic_app/core/widgets/CustomIcon.dart';
import 'package:clinic_app/core/widgets/custom_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/model/clinic_model.dart' show ClinicModel;

enum ClinicCardLayout {
  list,
  carousel,
  featured,
}

class ClinicCard extends StatefulWidget {
  final ClinicModel clinic;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onBookNow;
  final ClinicCardLayout layout;
  final double horizontalParallaxOffset;

  const ClinicCard({
    Key? key,
    required this.clinic,
    required this.onTap,
    this.onFavoriteToggle,
    this.onBookNow,
    this.layout = ClinicCardLayout.list,
    this.horizontalParallaxOffset = 0.0,
  }) : super(key: key);

  @override
  State<ClinicCard> createState() => _ClinicCardState();
}

class _ClinicCardState extends State<ClinicCard> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  // Size helpers
  final _vSize = AppSizeVertical.instance;
  final _hSize = AppSizeHorizontal.instance;
  final _tSize = TextSizeApp.instance;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _slideAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.layout) {
      case ClinicCardLayout.list:
        return _buildListLayout();
      case ClinicCardLayout.carousel:
        return _buildCarouselLayout();
      case ClinicCardLayout.featured:
        return _buildFeaturedLayout();
    }
  }

  // ==================== LAYOUT 1: List ====================
  Widget _buildListLayout() {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: _hSize.s16,
          vertical: _vSize.s8,
        ),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(_hSize.s16),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              _buildImage(
                width: 120.w,
                height: null,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(_hSize.s16),
                ),
                showOverlay: true,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(_hSize.s14),
                  child: _buildBasicInfo(showBookButton: true),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== LAYOUT 2: Carousel ====================
  Widget _buildCarouselLayout() {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 340.w,
        margin: EdgeInsets.symmetric(
          horizontal: _hSize.s6,
        ),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(_hSize.s16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildImage(
              width: double.infinity,
              height: _vSize.s100 + _vSize.s20,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(_hSize.s16),
              ),
              showOverlay: true,
            ),

            Padding(
              padding: EdgeInsets.all(_hSize.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name & Specialty Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.clinic.name,
                              style: textTheme.titleLarge?.copyWith(
                                fontSize: _tSize.s16,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: _vSize.s4),
                            Text(
                              widget.clinic.specialty,
                              style: textTheme.labelMedium?.copyWith(
                                fontSize: _tSize.s12 + 1.sp,
                                color: widget.clinic.accentColor,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: _hSize.s8),
                      // Rating Badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: _hSize.s8,
                          vertical: _vSize.s4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(_hSize.s8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: _tSize.s14,
                            ),
                            SizedBox(width: _hSize.s4),
                            Text(
                              widget.clinic.rating.toStringAsFixed(1),
                              style: textTheme.labelMedium?.copyWith(
                                fontSize: _tSize.s12 + 1.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: _vSize.s10),

                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: _tSize.s14,
                        color: theme.hintColor,
                      ),
                      SizedBox(width: _hSize.s4),
                      Expanded(
                        child: Text(
                          widget.clinic.location,
                          style: textTheme.bodySmall?.copyWith(
                            fontSize: _tSize.s12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: _vSize.s10),

                  // Price + Doctors + Book Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'الكشف',
                              style: textTheme.labelSmall?.copyWith(
                                fontSize: _tSize.s10 + 1.sp,
                              ),
                            ),
                            Text(
                              '${widget.clinic.price.toInt()} ج.م',
                              style: textTheme.titleMedium?.copyWith(
                                fontSize: _tSize.s18,
                                fontWeight: FontWeight.bold,
                                color: widget.clinic.accentColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: _hSize.s6),

                      // Doctors Count
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIcon(
                            assetPath:  Assets.doctorIcon,
                              size: _tSize.s16,
                              color: theme.hintColor,
                            ),
                            SizedBox(width: _hSize.s4),
                            Flexible(
                              child: Text(
                                '${widget.clinic.doctorsCount ?? 2} أطباء',
                                style: textTheme.labelMedium?.copyWith(
                                  fontSize: _tSize.s12,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== LAYOUT 3: Featured ====================
  Widget _buildFeaturedLayout() {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return GestureDetector(
      onTap: _toggleExpanded,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: _hSize.s8,
          vertical: _vSize.s10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_hSize.s24),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_hSize.s24),
          child: Stack(
            children: [
              _buildImage(
                width: double.infinity,
                height: double.infinity,
                borderRadius: BorderRadius.circular(_hSize.s24),
                showOverlay: false,
              ),

              // Gradient Overlay
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: _vSize.s100 + _vSize.s80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),

              _buildBadges(),

              // Basic Info Overlay
              Positioned(
                bottom: _vSize.s20,
                left: _hSize.s20,
                right: _hSize.s100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.clinic.specialty,
                      style: TextStyle(
                        fontSize: _tSize.s12 + 1.sp,
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: _vSize.s6),
                    Text(
                      widget.clinic.name,
                      style: TextStyle(
                        fontSize: _tSize.s20 + 1.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: _vSize.s8),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: _tSize.s18,
                        ),
                        SizedBox(width: _hSize.s6),
                        Text(
                          '${widget.clinic.rating} (${widget.clinic.reviewsCount})',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: _tSize.s14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Side Panel
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  final double slideOffset = isRTL
                      ? -(1.0 - _animationController.value) * 250.w
                      : (1.0 - _animationController.value) * 300.w;

                  return Transform.translate(
                    offset: Offset(slideOffset, 0),
                    child: Align(
                      alignment: isRTL ? Alignment.centerLeft : Alignment.centerRight,
                      child: Container(
                        width: 200.w,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: _vSize.s32,
                          horizontal: _hSize.s16,
                        ),
                        child: child,
                      ),
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: _hSize.s12,
                            vertical: _vSize.s8,
                          ),
                          decoration: BoxDecoration(
                            color: widget.clinic.accentColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(_hSize.s12),
                          ),
                          child: Text(
                            widget.clinic.specialty,
                            style: textTheme.labelMedium?.copyWith(
                              fontSize: _tSize.s12,
                              fontWeight: FontWeight.bold,
                              color: widget.clinic.accentColor,
                            ),
                          ),
                        ),
                        SizedBox(height: _vSize.s12),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: _tSize.s16,
                              color: theme.hintColor,
                            ),
                            SizedBox(width: _hSize.s6),
                            Expanded(
                              child: Text(
                                widget.clinic.location,
                                style: textTheme.bodySmall?.copyWith(
                                  fontSize: _tSize.s12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Available Times
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مواعيد اليوم',
                          style: textTheme.titleSmall?.copyWith(
                            fontSize: _tSize.s12 + 1.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: _vSize.s8),
                        ...widget.clinic.availableTimes.take(3).map(
                              (time) => Padding(
                            padding: EdgeInsets.only(bottom: _vSize.s6),
                            child: Text(
                              '• $time',
                              style: textTheme.bodySmall?.copyWith(
                                fontSize: _tSize.s12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Bottom Section (Price + Book)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.clinic.price.toInt()} ج.م',
                          style: textTheme.headlineLarge?.copyWith(
                            fontSize: _tSize.s24,
                            fontWeight: FontWeight.bold,
                            color: widget.clinic.accentColor,
                          ),
                        ),
                        SizedBox(height: _vSize.s12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: widget.onBookNow,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.clinic.accentColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: _vSize.s12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(_hSize.s14),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'احجز',
                              style: TextStyle(
                                fontSize: _tSize.s14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== SHARED COMPONENTS ====================

  Widget _buildImage({
    required double? width,
    required double? height,
    required BorderRadius borderRadius,
    required bool showOverlay,
  }) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            Positioned.fill(
              child: OverflowBox(
                alignment: Alignment.center,
                child: Transform.translate(
                  offset: Offset(widget.horizontalParallaxOffset, 0),
                  child: CustomNetworkImage(
                    imageUrl: widget.clinic.imageUrl,
                    width: (width ?? 400) * 1.3,
                    height: height,
                    fit: BoxFit.cover,
                    backgroundColor: widget.clinic.accentColor.withOpacity(0.1),
                    showLoadingIndicator: false,
                    customErrorWidget: Container(
                      color: widget.clinic.accentColor.withOpacity(0.1),
                      child: Icon(
                        Icons.local_hospital,
                        size: _tSize.s40,
                        color: widget.clinic.accentColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            if (showOverlay && widget.layout != ClinicCardLayout.featured)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.4),
                    ],
                  ),
                ),
              ),

            if (showOverlay) _buildBadges(),
          ],
        ),
      ),
    );
  }

  Widget _buildBadges() {
    final theme = Theme.of(context);

    return Stack(
      children: [
        // Status Badge
        Positioned(
          top: _vSize.s10,
          left: _hSize.s10,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: _hSize.s10,
              vertical: _vSize.s5,
            ),
            decoration: BoxDecoration(
              color: widget.clinic.isOpen
                  ? widget.clinic.accentColor.withOpacity(0.9)
                  : Colors.grey[600]?.withOpacity(0.9),
              borderRadius: BorderRadius.circular(_hSize.s20),
            ),
            child: Text(
              widget.clinic.isOpen ? 'متاح' : 'مغلق',
              style: TextStyle(
                color: Colors.white,
                fontSize: _tSize.s10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Favorite Badge
        Positioned(
          top: _vSize.s10,
          right: _hSize.s10,
          child: GestureDetector(
            onTap: widget.onFavoriteToggle,
            child: Container(
              padding: EdgeInsets.all(_hSize.s8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.clinic.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: widget.clinic.isFavorite
                    ? Colors.red
                    : Colors.grey[600],
                size: _tSize.s18,
              ),
            ),
          ),
        ),

        // Rating Badge (for list layout only)
        if (widget.layout == ClinicCardLayout.list)
          Positioned(
            bottom: _vSize.s10,
            left: _hSize.s10,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: _hSize.s8,
                vertical: _vSize.s4,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(_hSize.s8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: _tSize.s14,
                  ),
                  SizedBox(width: _hSize.s4),
                  Text(
                    widget.clinic.rating.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: _tSize.s10 + 1.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBasicInfo({required bool showBookButton}) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: _hSize.s10,
                vertical: _vSize.s5,
              ),
              decoration: BoxDecoration(
                color: widget.clinic.accentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(_hSize.s8),
              ),
              child: Text(
                widget.clinic.specialty,
                style: textTheme.labelMedium?.copyWith(
                  fontSize: _tSize.s10 + 1.sp,
                  fontWeight: FontWeight.w600,
                  color: widget.clinic.accentColor,
                ),
              ),
            ),
            SizedBox(height: _vSize.s8),
            Text(
              widget.clinic.name,
              style: textTheme.titleLarge?.copyWith(
                fontSize: _tSize.s16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: _vSize.s6),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: _tSize.s14,
                  color: theme.hintColor,
                ),
                SizedBox(width: _hSize.s4),
                Expanded(
                  child: Text(
                    widget.clinic.location,
                    style: textTheme.bodySmall?.copyWith(
                      fontSize: _tSize.s12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
        if (showBookButton)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.clinic.price.toInt()} ج',
                style: textTheme.titleMedium?.copyWith(
                  fontSize: _tSize.s18,
                  fontWeight: FontWeight.bold,
                  color: widget.clinic.accentColor,
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIcon(
                      assetPath:  Assets.doctorIcon,
                      size: _tSize.s16,
                      color: theme.hintColor,
                    ),
                    SizedBox(width: _hSize.s4),
                    Flexible(
                      child: Text(
                        '${widget.clinic.doctorsCount ?? 0} ',
                        style: textTheme.labelMedium?.copyWith(
                          fontSize: _tSize.s12,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}
