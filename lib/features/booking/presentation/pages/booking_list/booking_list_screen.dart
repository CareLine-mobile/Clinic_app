// lib/features/booking/presentation/pages/booking_list/booking_list_screen.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/app_size.dart';
import '../../../../../core/widgets/Loading_widget.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../../../core/widgets/empty_state_widget.dart';
import '../../../domain/entities/booking_entity.dart';
import '../../cubit/booking_cubit.dart';
import '../../../../../features/user_data/user_repo.dart';
import 'booking_detail_screen.dart';

// ════════════════════════════════════════════════════════════════════════════
// Screen — reads BookingCubit from PatientHomeScreen (already provided above)
// ════════════════════════════════════════════════════════════════════════════

class BookingListScreen extends StatelessWidget {
  const BookingListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Guest guard — no BlocProvider needed, just show prompt
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

// ════════════════════════════════════════════════════════════════════════════
// Body — StatefulWidget for scroll pagination only
// ════════════════════════════════════════════════════════════════════════════

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
        buildWhen: (prev, curr) =>
        curr is BookingLoading ||
            curr is BookingLoaded ||
            curr is BookingError,
        builder: (context, state) => switch (state) {
          BookingLoading() => const Center(child: LoadingSpinner()),
          BookingError(:final message) => _ErrorView(message: message),
          BookingLoaded() => _BookingList(
            state: state,
            scrollController: _scrollController,
          ),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Booking list
// ════════════════════════════════════════════════════════════════════════════

class _BookingList extends StatelessWidget {
  final BookingLoaded state;
  final ScrollController scrollController;

  const _BookingList({
    required this.state,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    if (state.bookings.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.calendar_today_outlined,
        title: 'bookings.empty_title'.tr(),
        subtitle: 'bookings.empty_subtitle'.tr(),
        enableBackButton: false,
        actionLabel: 'bookings.find_clinic'.tr(),
        onActionPressed: () =>
            Navigator.pushNamed(context, Routes.dashBoard),
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

// ════════════════════════════════════════════════════════════════════════════
// Error view
// ════════════════════════════════════════════════════════════════════════════

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

// ════════════════════════════════════════════════════════════════════════════
// Booking card
// ════════════════════════════════════════════════════════════════════════════

class _BookingCard extends StatelessWidget {
  final BookingEntity booking;

  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<BookingCubit>(), // ← reuse the existing cubit
            child: BookingDetailScreen(booking: booking),
          ),
        ),
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
            Divider(height: 1, indent: SizeApp.s16, endIndent: SizeApp.s16),
            _CardDetails(booking: booking),
            _StatusFooter(status: booking.status),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Card header: clinic image + name + specialty
// ─────────────────────────────────────────────

class _CardHeader extends StatelessWidget {
  final BookingEntity booking;
  const _CardHeader({required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(SizeApp.s16),
      child: Row(
        children: [
          _ClinicAvatar(thumbnailUrl: booking.clinical.thumbnailUrl),
          SizedBox(width: SizeApp.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.clinical.name,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  booking.clinical.specialty,
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.hintColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Clinic avatar
// ─────────────────────────────────────────────

class _ClinicAvatar extends StatelessWidget {
  final String? thumbnailUrl;
  const _ClinicAvatar({this.thumbnailUrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: thumbnailUrl != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Image.network(
          thumbnailUrl!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const _ClinicPlaceholder(),
        ),
      )
          : const _ClinicPlaceholder(),
    );
  }
}

class _ClinicPlaceholder extends StatelessWidget {
  const _ClinicPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.local_hospital_outlined,
      color: Theme.of(context).primaryColor,
    );
  }
}

// ─────────────────────────────────────────────
// Card details: doctor, date, time, turn
// ─────────────────────────────────────────────

class _CardDetails extends StatelessWidget {
  final BookingEntity booking;
  const _CardDetails({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeApp.s16),
      child: Column(
        children: [
          _DetailRow(
            icon: Icons.person_outline_rounded,
            label: 'bookings.doctor'.tr(),
            value: booking.doctor.name,
          ),
          SizedBox(height: SizeApp.s8),
          _DetailRow(
            icon: Icons.calendar_today_outlined,
            label: 'bookings.date'.tr(),
            value: _formatDate(booking.date),
          ),
          SizedBox(height: SizeApp.s8),
          _DetailRow(
            icon: Icons.access_time_rounded,
            label: 'bookings.time'.tr(),
            value: booking.time,
          ),
          SizedBox(height: SizeApp.s8),
          _DetailRow(
            icon: Icons.format_list_numbered_rounded,
            label: 'bookings.turn_number'.tr(),
            value: '${booking.turnNumber}',
          ),
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
}

// ─────────────────────────────────────────────
// Detail row
// ─────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 16.sp, color: theme.primaryColor),
        SizedBox(width: SizeApp.s8),
        Text(
          '$label:',
          style: theme.textTheme.bodySmall
              ?.copyWith(color: theme.hintColor, fontWeight: FontWeight.w500),
        ),
        SizedBox(width: SizeApp.s4),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodySmall
                ?.copyWith(fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// Status footer
// ─────────────────────────────────────────────

class _StatusFooter extends StatelessWidget {
  final String status;
  const _StatusFooter({required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _StatusConfig.from(status);

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

// ─────────────────────────────────────────────
// Status config — data class with factory
// ─────────────────────────────────────────────

class _StatusConfig {
  final String label;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const _StatusConfig({
    required this.label,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  factory _StatusConfig.from(String status) => switch (status) {
    'confirmed' => const _StatusConfig(
      label: 'مؤكد',
      icon: Icons.check_circle_outline_rounded,
      color: Color(0xFF2E7D32),
      bgColor: Color(0xFFE8F5E9),
    ),
    'cancelled' => const _StatusConfig(
      label: 'ملغي',
      icon: Icons.cancel_outlined,
      color: Color(0xFFC62828),
      bgColor: Color(0xFFFFEBEE),
    ),
    'pending' => const _StatusConfig(
      label: 'قيد الانتظار',
      icon: Icons.hourglass_empty_rounded,
      color: Color(0xFFE65100),
      bgColor: Color(0xFFFFF3E0),
    ),
    _ => _StatusConfig(
      label: status,
      icon: Icons.info_outline_rounded,
      color: Colors.grey[600]!,
      bgColor: Colors.grey[100]!,
    ),
  };
}