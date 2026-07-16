// lib/features/home/presentation/widget/home_app_bar_widget.dart

import 'package:clinic_app/core/utils/app_size.dart';
import 'package:clinic_app/core/utils/assets.dart';
import 'package:clinic_app/core/widgets/card/last_booking_card.dart';
import 'package:clinic_app/features/my_booking/presentation/cubit/booking_cubit.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/colors.dart';


class HomeHeaderWidget extends StatelessWidget {
  final String? userName;
  final String? userPhotoUrl;
  final VoidCallback onNotificationTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onBookingCardTap;
  final VoidCallback? onSearchTap;

  const HomeHeaderWidget({
    Key? key,
    this.userName,
    this.userPhotoUrl,
    required this.onNotificationTap,
    this.onSettingsTap,
    this.onBookingCardTap,
    this.onSearchTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: ColorsManager.primaryColor,
      expandedHeight: SizeApp.expandedHeight,
      collapsedHeight: SizeApp.collapsedHeight,
      floating: false,
      pinned: true,
      stretch: false,
      automaticallyImplyLeading: false,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final isExpanded = constraints.maxHeight > 180.h;

          return Stack(
            children: [
              _buildBackground(),
              _buildTopBar(context, isExpanded),
              if (isExpanded) ...[
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

  // ── Background ────────────────────────────────────────────

  Widget _buildBackground() {
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

  // ── Top bar: avatar + name + bell ─────────────────────────

  Widget _buildTopBar(BuildContext context, bool isExpanded) {
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
                  userName ?? 'auth.user'.tr(),
                  style: textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontSize: isExpanded
                        ? SizeApp.s16 + SizeApp.s2
                        : SizeApp.s16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              if (onSettingsTap != null) ...[
                _buildSettingsButton(),
                SizedBox(width: SizeApp.s8),
              ],
              _buildNotificationBell(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsButton() {
    return GestureDetector(
      onTap: onSettingsTap,
      child: Container(
        padding: EdgeInsets.all(SizeApp.s10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(SizeApp.s12),
        ),
        child: Icon(
          Icons.settings_outlined,
          color: Colors.white,
          size: SizeApp.s24 + SizeApp.s2,
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
          ? Icon(Icons.person, color: Colors.white, size: SizeApp.iconSize)
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

  // ── Description text ──────────────────────────────────────

  Widget _buildDescription(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(vertical: SizeApp.padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'home.header.title'.tr(),
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
            'home.header.subtitle'.tr(),
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

  // ── Booking card — driven by BookingCubit ─────────────────

  Widget _buildClinicCard(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Transform.translate(
        offset: Offset(0, SizeApp.s40),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeApp.s16),
          child: BlocBuilder<BookingCubit, BookingState>(
            buildWhen: (prev, curr) =>
            curr is BookingLoading ||
                curr is BookingLoaded ||
                curr is BookingError,
            builder: (context, state) {
              if (state is BookingLoading) {
                return _buildShimmer(context);
              }

              if (state is BookingLoaded) {
                // If there are no bookings, show empty state card
                if (state.bookings.isEmpty) {
                  return _buildEmptyStateCard(context);
                }

                final booking = state.bookings.first;
                return LastBookingCard(
                  booking: booking,
                  onTap: onBookingCardTap,
                );
              }
              // No booking or error → empty state card
              return _buildEmptyStateCard(context);
            },
          ),
        ),
      ),
    );
  }

  // ── Empty state card ──────────────────────────────────────

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
            blurRadius: 12.r,
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
              borderRadius:
              BorderRadius.circular(SizeApp.s12 + SizeApp.s2),
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
                  'home.last_booking.no_bookings_title'.tr(),
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp
                  ),
                ),
                SizedBox(height: SizeApp.s4),
                Text(
                  'home.last_booking.no_bookings_subtitle'.tr(),
                  style: textTheme.bodySmall?.copyWith(
                    color: ColorsManager.defaultTextSecondary,
                      fontSize: 14.sp
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

  // ── Shimmer skeleton ──────────────────────────────────────

  Widget _buildShimmer(BuildContext context) {
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
                borderRadius:
                BorderRadius.circular(SizeApp.s12 + SizeApp.s2),
              ),
            ),
            SizedBox(width: SizeApp.s12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _shimmerBox(width: SizeApp.s60, height: SizeApp.s12),
                  SizedBox(height: SizeApp.s8),
                  _shimmerBox(width: SizeApp.s110, height: SizeApp.s16),
                  SizedBox(height: SizeApp.s6),
                  _shimmerBox(width: SizeApp.s70, height: SizeApp.s12),
                ],
              ),
            ),
            _shimmerBox(width: SizeApp.s50, height: SizeApp.s60, radius: SizeApp.s12),
          ],
        ),
      ),
    );
  }

  Widget _shimmerBox({
    required double width,
    required double height,
    double? radius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius ?? SizeApp.s4),
      ),
    );
  }
}