import 'package:clinic_app/features/my_booking/domain/entities/booking_entity.dart';
import 'package:clinic_app/features/my_booking/presentation/widgets/booking_detail_row.dart';
import 'package:clinic_app/features/my_booking/presentation/widgets/booking_status_config.dart';
import 'package:clinic_app/features/my_booking/presentation/widgets/clinic_avatar.dart';
import 'package:clinic_app/features/my_booking/presentation/widgets/wait_turns_chip.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/routes/routes.dart';
import '../../../../../../core/theme/colors.dart';
import '../../../../../../core/utils/app_size.dart';
import '../../../../../../core/widgets/loading_widget.dart';
import '../../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../../core/widgets/empty_state_widget.dart';
import '../../../../../../features/user_data/user_repo.dart';
import '../cubit/booking_cubit.dart';
import 'booking_detail_screen.dart';

// ─── Screen ───────────────────────────────────────────────────────────────────

class BookingListScreen extends StatelessWidget {
  const BookingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (!UserRepository().isLoggedIn) {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'bookings.title'.tr(),
          showBackIcon: false,
        ),
        body: EmptyStateWidget(
          icon: Icons.lock_outline_rounded,
          title: 'bookings.auth_required_title'.tr(),
          subtitle: 'bookings.auth_required_subtitle'.tr(),
          enableBackButton: false,
          actionLabel: 'auth.login'.tr(),
          onActionPressed: () => Navigator.pushNamed(context, Routes.auth),
        ),
      );
    }

    return const _BookingListBody();
  }
}

// ─── Body ─────────────────────────────────────────────────────────────────────

class _BookingListBody extends StatefulWidget {
  const _BookingListBody();

  @override
  State<_BookingListBody> createState() => _BookingListBodyState();
}

class _BookingListBodyState extends State<_BookingListBody> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      context.read<BookingCubit>().loadMoreBookings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'bookings.title'.tr(),
        showBackIcon: false,
      ),
      body: BlocBuilder<BookingCubit, BookingState>(
        buildWhen: (_, curr) =>
        curr is BookingLoading ||
            curr is BookingLoaded ||
            curr is BookingError,
        builder: (context, state) => switch (state) {
          BookingLoading() => const Center(child: LoadingSpinner()),
          BookingError(:final message) => _ErrorView(message: message),
          BookingLoaded() =>
              _BookingList(state: state, scrollController: _scrollController),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}

// ─── Booking List ──────────────────────────────────────────────────────────────

class _BookingList extends StatelessWidget {
  final BookingLoaded state;
  final ScrollController scrollController;

  const _BookingList({required this.state, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    if (state.bookings.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.calendar_today_outlined,
        title: 'bookings.empty_title'.tr(),
        subtitle: 'bookings.empty_subtitle'.tr(),
        enableBackButton: false,
        actionLabel: 'bookings.find_clinic'.tr(),
        onActionPressed: () => Navigator.pushNamed(context, Routes.dashBoard),
      );
    }

    return RefreshIndicator(
      color: ColorsManager.primaryColor,
      onRefresh: () => context.read<BookingCubit>().loadBookings(),
      child: ListView.builder(
        controller: scrollController,
        padding: EdgeInsets.symmetric(
          horizontal: SizeApp.s16,
          vertical: SizeApp.s12,
        ),
        itemCount: state.bookings.length + (state.isPaginating ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.bookings.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: LoadingSpinner()),
            );
          }
          return _BookingCard(booking: state.bookings[index]);
        },
      ),
    );
  }
}

// ─── Error View ───────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.error_outline_rounded,
      title: 'errors.server.title'.tr(),
      subtitle: message,
      enableBackButton: false,
      actionLabel: 'bookings.retry'.tr(),
      onActionPressed: () => context.read<BookingCubit>().loadBookings(),
    );
  }
}

// ─── Booking Card ──────────────────────────────────────────────────────────────

class _BookingCard extends StatelessWidget {
  final BookingEntity booking;
  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: () => Navigator.pushNamed(
        context,
        Routes.bookingDetails,
        arguments: {
          'booking': booking,
          'cubit': context.read<BookingCubit>(),
        },
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: SizeApp.s12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            _CardHeader(booking: booking),
            Divider(
                height: 1,
                indent: SizeApp.s16,
                endIndent: SizeApp.s16),
            _CardDetails(booking: booking),
            _StatusFooter(status: booking.status),
          ],
        ),
      ),
    );
  }
}

// ─── Card Header ──────────────────────────────────────────────────────────────

class _CardHeader extends StatefulWidget {
  final BookingEntity booking;
  const _CardHeader({required this.booking});

  @override
  State<_CardHeader> createState() => _CardHeaderState();
}

class _CardHeaderState extends State<_CardHeader> {
  bool _isReviewed = false;

  @override
  void initState() {
    super.initState();
    _checkReviewStatus();
  }

  Future<void> _checkReviewStatus() async {
    final reviewed = await context
        .read<BookingCubit>()
        .isClinicReviewed(widget.booking.clinical.id);
    if (mounted) setState(() => _isReviewed = reviewed);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(SizeApp.s16),
      child: Row(
        children: [
          ClinicAvatar(thumbnailUrl: widget.booking.clinical.thumbnailUrl),
          SizedBox(width: SizeApp.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.booking.clinical.name,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  widget.booking.clinical.specialty,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.hintColor),
                ),
              ],
            ),
          ),

          // ─── Review badge ──────────────────────────────
          if (widget.booking.isCompleted)
            _isReviewed
                ? _ReviewBadge(
              label: 'bookings.reviewed'.tr(),
              icon: Icons.check_circle_outline_rounded,
              color: const Color(0xFF2E7D32),
              bgColor: const Color(0xFFE8F5E9),
            )
                : _ReviewBadge(
              label: 'reviews.form.title'.tr(),
              icon: Icons.rate_review_outlined,
              color: const Color(0xFF1565C0),
              bgColor: const Color(0xFF1565C0).withOpacity(0.1),
            ),
        ],
      ),
    );
  }
}

// ─── Badge widget ─────────────────────────────────────────────────────────────

class _ReviewBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const _ReviewBadge({
    required this.label,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: color),
          SizedBox(width: 3.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
// ─── Card Details ─────────────────────────────────────────────────────────────

class _CardDetails extends StatelessWidget {
  final BookingEntity booking;
  const _CardDetails({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeApp.s16),
      child: Column(
        children: [
          BookingDetailRow(
            icon: Icons.person_outline_rounded,
            label: 'bookings.doctor'.tr(),
            value: booking.doctor.name,
          ),
          SizedBox(height: SizeApp.s8),
          BookingDetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'bookings.date'.tr(),
            value: _formatDate(booking.date),
          ),
          SizedBox(height: SizeApp.s8),
          BookingDetailRow(
            icon: Icons.access_time_rounded,
            label: 'bookings.time'.tr(),
            value: _formatTime(booking.time),
          ),
          // Turn number — show only when available
          if (booking.isPending && booking.waitTurns != null) ...[
            SizedBox(height: SizeApp.s8),
            Row(
              children: [
                Icon(Icons.hourglass_top_rounded,
                    size: 16.sp, color: Theme.of(context).primaryColor),
                SizedBox(width: SizeApp.s8),
                Text(
                  '${'bookings.wait_turns.label'.tr()}:',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                WaitTurnsChip(waitTurns: booking.waitTurns!, turnNumber: booking.turnNumber!,),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(String date) {
    try {
      return DateFormat('EEE، d MMM yyyy', 'ar').format(DateTime.parse(date));
    } catch (_) {
      return date;
    }
  }

  String _formatTime(String time) {
    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = parts[1];
      final suffix = hour >= 12 ? 'م' : 'ص';
      final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$hour12:$minute $suffix';
    } catch (_) {
      return time;
    }
  }
}

// ─── Status Footer ────────────────────────────────────────────────────────────

class _StatusFooter extends StatelessWidget {
  final String status;
  const _StatusFooter({required this.status});

  @override
  Widget build(BuildContext context) {
    final config = BookingStatusConfig.from(status);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: SizeApp.s10),
      decoration: BoxDecoration(
        color: config.bgColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16.r),
          bottomRight: Radius.circular(16.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(config.icon, size: 14.sp, color: config.color),
          SizedBox(width: SizeApp.s6),
          Text(
            config.label,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: config.color,
            ),
          ),
        ],
      ),
    );
  }
}