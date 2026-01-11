import 'package:clinic_app/core/utils/app_size.dart';
import 'package:clinic_app/core/utils/assets.dart';
import 'package:clinic_app/core/widgets/app_text_feild.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/colors.dart';
import '../../domain/entities/clinic_summary.dart';

class HomeHeaderWidget extends StatelessWidget {
  final String? userName;
  final String? userPhotoUrl;
  final ClinicSummary? lastBooking;
  final int? queuePosition;
  final int? peopleAhead;
  final VoidCallback onNotificationTap;
  final VoidCallback? onBookingCardTap;
  final VoidCallback? onSearchTap;
  final bool isLoading;

  const HomeHeaderWidget({
    Key? key,
    this.userName,
    this.userPhotoUrl,
    this.lastBooking,
    this.queuePosition,
    this.peopleAhead,
    required this.onNotificationTap,
    this.onBookingCardTap,
    this.onSearchTap,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: ColorsManager.primaryColor,
      expandedHeight: SizeApp.expandedHeight,
      collapsedHeight: SizeApp.collapsedHeight,
      floating: false,
      pinned: true,
      stretch: true,
      automaticallyImplyLeading: false,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final isExpanded = constraints.maxHeight > 180.h;

          return Stack(
            children: [
              _buildBackground(context),
              _buildTopBar(context, isExpanded, constraints),
              if (isExpanded) ...[
                // Description with fade animation
                Positioned(
                  top: 70.h,
                  left: SizeApp.s16,
                  right: SizeApp.s16,
                  child: _buildDescription(context),
                ),
                _buildClinicCard(context),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.1,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.appBarBg),
                  repeat: ImageRepeat.repeat,
                  fit: BoxFit.none,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(
      BuildContext context,
      bool isExpanded,
      BoxConstraints constraints,
      ) {
    final textTheme = Theme.of(context).textTheme;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeApp.s16,
            vertical: SizeApp.s8,
          ),
          child: Row(
            children: [
              _buildUserAvatar(),
              SizedBox(width: isExpanded ? SizeApp.s12 : SizeApp.s8),
              Expanded(
                child: Text(
                  userName ?? "مستخدم",
                  style: textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontSize: isExpanded ? SizeApp.s16 + SizeApp.s2 : SizeApp.s16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              _buildNotificationBell(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar() {
    return CircleAvatar(
      radius: SizeApp.s24,
      backgroundImage: userPhotoUrl != null && userPhotoUrl!.isNotEmpty
          ? NetworkImage(userPhotoUrl!)
          : null,
      backgroundColor: Colors.white.withOpacity(0.3),
      child: userPhotoUrl == null || userPhotoUrl!.isEmpty
          ? Icon(
        Icons.person,
        color: Colors.white,
        size: SizeApp.iconSize,
      )
          : null,
    );
  }

  Widget _buildNotificationBell() {
    return GestureDetector(
      onTap: onNotificationTap,
      child: Container(
        padding: EdgeInsets.all(SizeApp.s10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(SizeApp.s12),
        ),
        child: Icon(
          Icons.notifications_outlined,
          color: Colors.white,
          size: SizeApp.s24 + SizeApp.s2,
        ),
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(vertical: SizeApp.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick clinic bookings',
            style: textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontSize: SizeApp.s20,
              fontWeight: FontWeight.bold,
              height: 1.3,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(0, 1),
                  blurRadius: 3,
                ),
              ],
            ),
          ),
          SizedBox(height: SizeApp.s4),
          Text(
            'Follow your turn without waiting',
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontSize: SizeApp.s16,
              fontWeight: FontWeight.w500,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClinicCard(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Transform.translate(
        offset: Offset(0, SizeApp.s40),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeApp.s16),
          child: isLoading
              ? _buildClinicCardShimmer(context)
              : lastBooking != null
              ? _buildLastBookingCard(context)
              : _buildEmptyStateCard(context),
        ),
      ),
    );
  }

  Widget _buildLastBookingCard(BuildContext context) {
    final clinic = lastBooking!;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onBookingCardTap,
      child: Container(
        padding: EdgeInsets.all(SizeApp.s12 + SizeApp.s2),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(SizeApp.s16 + SizeApp.s2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: SizeApp.s50 + SizeApp.s10,
              height: SizeApp.s50 + SizeApp.s10,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(SizeApp.s12 + SizeApp.s2),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(SizeApp.s12),
                child: Image.network(
                  clinic.firstImageUrl, // ✅ Changed from imageUrl
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.local_hospital,
                    color: Theme.of(context).primaryColor,
                    size: SizeApp.s30,
                  ),
                ),
              ),
            ),
            SizedBox(width: SizeApp.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeApp.s8,
                          vertical: SizeApp.s4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(SizeApp.s6),
                        ),
                        child: Text(
                          'آخر حجز',
                          style: textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      SizedBox(width: SizeApp.s6),
                      Icon(
                        Icons.check_circle,
                        color: ColorsManager.successFill,
                        size: SizeApp.s12 + SizeApp.s2,
                      ),
                    ],
                  ),
                  SizedBox(height: SizeApp.s6),
                  Text(
                    clinic.name,
                    style: textTheme.titleMedium?.copyWith(
                      fontSize: SizeApp.s16,
                      fontWeight: FontWeight.bold,
                      color: ColorsManager.defaultText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: SizeApp.s4),
                  // ✅ Changed: Show location instead of nextAppointment
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: SizeApp.s12 + SizeApp.s2,
                        color: ColorsManager.defaultTextSecondary,
                      ),
                      SizedBox(width: SizeApp.s4),
                      Expanded(
                        child: Text(
                          clinic.location,
                          style: textTheme.bodySmall?.copyWith(
                            fontSize: SizeApp.s12,
                            color: ColorsManager.defaultTextSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (queuePosition != null && peopleAhead != null)
              Container(
                padding: EdgeInsets.all(SizeApp.s10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(SizeApp.s12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$queuePosition',
                      style: textTheme.headlineLarge?.copyWith(
                        fontSize: SizeApp.s20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      'دورك',
                      style: textTheme.labelSmall?.copyWith(
                        color: ColorsManager.defaultTextSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: SizeApp.s6),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeApp.s8,
                        vertical: SizeApp.s4 - SizeApp.s2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(SizeApp.s8),
                      ),
                      child: Text(
                        '$peopleAhead قدامك',
                        style: textTheme.labelSmall?.copyWith(
                          fontSize: SizeApp.s10 - SizeApp.s2,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Icon(
                Icons.arrow_forward_ios,
                color: ColorsManager.inputBorder,
                size: SizeApp.s16 + SizeApp.s2,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyStateCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(SizeApp.s16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeApp.s16 + SizeApp.s2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: SizeApp.s50 + SizeApp.s10,
            height: SizeApp.s50 + SizeApp.s10,
            decoration: BoxDecoration(
              color: ColorsManager.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(SizeApp.s12 + SizeApp.s2),
            ),
            child: Icon(
              Icons.calendar_month,
              color: ColorsManager.primaryColor,
              size: SizeApp.s30,
            ),
          ),
          SizedBox(width: SizeApp.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'لا توجد حجوزات بعد',
                  style: textTheme.titleMedium?.copyWith(
                    fontSize: SizeApp.s16,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.defaultText,
                  ),
                ),
                SizedBox(height: SizeApp.s4),
                Text(
                  'ابدأ بحجز موعدك الأول',
                  style: textTheme.bodySmall?.copyWith(
                    fontSize: SizeApp.s12,
                    color: ColorsManager.defaultTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(SizeApp.s10),
            decoration: BoxDecoration(
              color: ColorsManager.primaryColor,
              borderRadius: BorderRadius.circular(SizeApp.s12),
            ),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: SizeApp.iconSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClinicCardShimmer(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Container(
      padding: EdgeInsets.all(SizeApp.s12 + SizeApp.s2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeApp.s16 + SizeApp.s2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Row(
          children: [
            Container(
              width: SizeApp.s50 + SizeApp.s10,
              height: SizeApp.s50 + SizeApp.s10,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(SizeApp.s12 + SizeApp.s2),
              ),
            ),
            SizedBox(width: SizeApp.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: SizeApp.s50 + SizeApp.s10,
                    height: SizeApp.s12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(SizeApp.s4),
                    ),
                  ),
                  SizedBox(height: SizeApp.s8),
                  Container(
                    width: SizeApp.s110 + SizeApp.s10,
                    height: SizeApp.s12 + SizeApp.s2,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(SizeApp.s4),
                    ),
                  ),
                  SizedBox(height: SizeApp.s6),
                  Container(
                    width: SizeApp.s70 + SizeApp.s10,
                    height: SizeApp.s12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(SizeApp.s4),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: SizeApp.s50,
              height: SizeApp.s60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(SizeApp.s12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}