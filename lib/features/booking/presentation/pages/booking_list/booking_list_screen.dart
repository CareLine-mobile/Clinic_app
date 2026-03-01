import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../../core/di/injection_container.dart' as di;
import '../../../../../core/routes/routes.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/app_size.dart';
import '../../../../../core/widgets/Loading_widget.dart';
import '../../../../../core/widgets/empty_state_widget.dart';
import '../../../../../features/user_data/user_cubit.dart';
import '../../../domain/entities/booking_entity.dart';
import '../../cubit/booking_cubit.dart';


class BookingListScreen extends StatelessWidget {
  const BookingListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ── Guard: guest users see a prompt, not the list ──────
    final isLoggedIn = context.read<UserCubit>().isLoggedIn;

    if (!isLoggedIn) {
      return EmptyStateWidget(
        icon: Icons.lock_outline_rounded,
        title: 'تسجيل الدخول مطلوب',
        subtitle: 'سجّل دخولك لعرض حجوزاتك والتحكم فيها',
        enableBackButton: false,
        actionLabel: 'تسجيل الدخول',
        onActionPressed: () => Navigator.pushNamed(context, Routes.auth),
      );
    }

    return BlocProvider(
      create: (_) => di.sl<BookingCubit>()..loadBookings(),
      child: const _BookingListBody(),
    );
  }
}

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
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      context.read<BookingCubit>().loadMoreBookings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.backgroundSurface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'حجوزاتي',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: BlocBuilder<BookingCubit, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return const Center(child: LoadingSpinner());
          }

          if (state is BookingError) {
            return EmptyStateWidget(
              icon: Icons.error_outline_rounded,
              title: 'حدث خطأ',
              subtitle: state.message,
              enableBackButton: false,
              actionLabel: 'إعادة المحاولة',
              onActionPressed: () => context.read<BookingCubit>().loadBookings(),
            );
          }

          if (state is BookingLoaded) {
            if (state.bookings.isEmpty) {
              return EmptyStateWidget(
                icon: Icons.calendar_today_outlined,
                title: 'لا توجد حجوزات',
                subtitle: 'لم تقم بحجز أي موعد حتى الآن',
                enableBackButton: false,
                actionLabel: 'ابحث عن عيادة',
                onActionPressed: () => Navigator.pushNamed(context, Routes.dashBoard),
              );
            }

            return RefreshIndicator(
              color: ColorsManager.primaryColor,
              onRefresh: () => context.read<BookingCubit>().loadBookings(),
              child: ListView.builder(
                controller: _scrollController,
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

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingEntity booking;

  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SizeApp.s12),
      decoration: BoxDecoration(
        color: Colors.white,
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
          // ── Clinic Header ──────────────────────────────
          _CardHeader(booking: booking),

          const Divider(height: 1, indent: 16, endIndent: 16),

          // ── Details Row ────────────────────────────────
          Padding(
            padding: EdgeInsets.all(SizeApp.s16),
            child: Column(
              children: [
                _DetailRow(
                  icon: Icons.person_outline_rounded,
                  label: 'الطبيب',
                  value: booking.doctor.name,
                ),
                SizedBox(height: SizeApp.s8),
                _DetailRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'التاريخ',
                  value: _formatDate(booking.date),
                ),
                SizedBox(height: SizeApp.s8),
                _DetailRow(
                  icon: Icons.access_time_rounded,
                  label: 'الوقت',
                  value: booking.time,
                ),
                SizedBox(height: SizeApp.s8),
                _DetailRow(
                  icon: Icons.format_list_numbered_rounded,
                  label: 'رقم الدور',
                  value: '${booking.turnNumber}',
                ),
              ],
            ),
          ),

          // ── Status Footer ──────────────────────────────
          _StatusFooter(status: booking.status),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('EEE، d MMM yyyy', 'ar').format(parsed);
    } catch (_) {
      return date;
    }
  }
}

class _CardHeader extends StatelessWidget {
  final BookingEntity booking;
  const _CardHeader({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeApp.s16),
      child: Row(
        children: [
          // Clinic image or placeholder
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: ColorsManager.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: booking.clinical.thumbnailUrl != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                booking.clinical.thumbnailUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const _ClinicPlaceholder(),
              ),
            )
                : const _ClinicPlaceholder(),
          ),

          SizedBox(width: SizeApp.s12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.clinical.name,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  booking.clinical.specialty,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey[500],
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

class _ClinicPlaceholder extends StatelessWidget {
  const _ClinicPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.local_hospital_outlined,
      color: ColorsManager.primaryColor,
    );
  }
}

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
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: ColorsManager.primaryColor),
        SizedBox(width: SizeApp.s8),
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 13.sp,
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: SizeApp.s4),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class _StatusFooter extends StatelessWidget {
  final String status;
  const _StatusFooter({required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _statusConfig(status);

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

  _StatusConfig _statusConfig(String status) {
    switch (status) {
      case 'confirmed':
        return _StatusConfig(
          label: 'مؤكد',
          icon: Icons.check_circle_outline_rounded,
          color: const Color(0xFF2E7D32),
          bgColor: const Color(0xFFE8F5E9),
        );
      case 'cancelled':
        return _StatusConfig(
          label: 'ملغي',
          icon: Icons.cancel_outlined,
          color: const Color(0xFFC62828),
          bgColor: const Color(0xFFFFEBEE),
        );
      case 'pending':
        return _StatusConfig(
          label: 'قيد الانتظار',
          icon: Icons.hourglass_empty_rounded,
          color: const Color(0xFFE65100),
          bgColor: const Color(0xFFFFF3E0),
        );
      default:
        return _StatusConfig(
          label: status,
          icon: Icons.info_outline_rounded,
          color: Colors.grey[600]!,
          bgColor: Colors.grey[100]!,
        );
    }
  }
}

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
}