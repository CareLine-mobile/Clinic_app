// lib/features/booking/presentation/pages/booking_detail/booking_detail_screen.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/app_size.dart';
import '../../../../../core/widgets/custom_app_bar.dart';
import '../../../domain/entities/booking_entity.dart';
import '../../cubit/booking_cubit.dart';

class BookingDetailScreen extends StatelessWidget {
  final BookingEntity booking;

  const BookingDetailScreen({Key? key, required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is CancelBookingSuccess) {
          _showResultSnackBar(
            context,
            message: 'bookings.detail.cancel_success'.tr(),
            isError: false,
          );
          // Refresh list then go back
          context.read<BookingCubit>().loadBookings();
          Navigator.of(context).pop();
        } else if (state is CancelBookingError) {
          _showResultSnackBar(context, message: state.message, isError: true);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(title: 'bookings.detail.title'.tr()),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(SizeApp.s16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ClinicCard(clinical: booking.clinical),
              SizedBox(height: SizeApp.s16),
              _StatusBanner(status: booking.status),
              SizedBox(height: SizeApp.s16),
              _InfoSection(booking: booking),
              if (booking.patientName != null || booking.patientPhone != null) ...[
                SizedBox(height: SizeApp.s16),
                _PatientSection(booking: booking),
              ],
              if (booking.notes != null && booking.notes!.isNotEmpty) ...[
                SizedBox(height: SizeApp.s16),
                _NotesSection(notes: booking.notes!),
              ],
              // ─── Cancel button — pending only ──────────────
              if (booking.status == 'pending') ...[
                SizedBox(height: SizeApp.s24),
                _CancelButton(bookingId: booking.id),
              ],
              SizedBox(height: SizeApp.s40),
            ],
          ),
        ),
      ),
    );
  }

  void _showResultSnackBar(
      BuildContext context, {
        required String message,
        required bool isError,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? const Color(0xFFC62828)
            : const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Cancel button with loading state
// ─────────────────────────────────────────────

class _CancelButton extends StatelessWidget {
  final int bookingId;

  const _CancelButton({required this.bookingId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        final isLoading = state is CancelBookingLoading;

        return SizedBox(
          width: double.infinity,
          height: 52.h,
          child: OutlinedButton(
            onPressed: isLoading
                ? null
                : () => _confirmCancel(context),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFC62828), width: 1.5),
              foregroundColor: const Color(0xFFC62828),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            child: isLoading
                ? SizedBox(
              width: 22.w,
              height: 22.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Color(0xFFC62828),
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cancel_outlined, size: 20.sp),
                SizedBox(width: SizeApp.s8),
                Text(
                  'bookings.detail.cancel_booking'.tr(),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmCancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text('bookings.detail.cancel_confirm_title'.tr()),
        content: Text('bookings.detail.cancel_confirm_body'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogCtx).pop(),
            child: Text('common.no'.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              context.read<BookingCubit>().cancelBooking(bookingId);
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFC62828),
            ),
            child: Text(
              'bookings.detail.cancel_confirm_yes'.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════
// All widgets below are unchanged from original
// ══════════════════════════════════════════════════════════════════════════

class _ClinicCard extends StatelessWidget {
  final ClinicalEntity clinical;
  const _ClinicCard({required this.clinical});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(SizeApp.s16),
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
      child: Row(
        children: [
          _ClinicAvatar(thumbnailUrl: clinical.thumbnailUrl),
          SizedBox(width: SizeApp.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(clinical.name,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                SizedBox(height: 4.h),
                Text(clinical.specialty,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.hintColor)),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 14.sp, color: theme.hintColor),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        clinical.location,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: theme.hintColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _RatingChip(rating: clinical.rating),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ClinicAvatar extends StatelessWidget {
  final String? thumbnailUrl;
  const _ClinicAvatar({this.thumbnailUrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 64.w,
      height: 64.w,
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: thumbnailUrl != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(14.r),
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
  Widget build(BuildContext context) =>
      Icon(Icons.local_hospital_outlined, color: Theme.of(context).primaryColor);
}

class _RatingChip extends StatelessWidget {
  final double rating;
  const _RatingChip({required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 12.sp, color: Colors.amber[700]),
          SizedBox(width: 2.w),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: Colors.amber[700],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final String status;
  const _StatusBanner({required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _StatusConfig.from(status);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: SizeApp.s16, vertical: SizeApp.s12),
      decoration: BoxDecoration(
        color: config.bgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: config.color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(config.icon, color: config.color, size: 20.sp),
          SizedBox(width: SizeApp.s8),
          Text(
            config.label,
            style: TextStyle(
              color: config.color,
              fontWeight: FontWeight.bold,
              fontSize: 15.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final BookingEntity booking;
  const _InfoSection({required this.booking});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'bookings.detail.appointment_info'.tr(),
      children: [
        _DetailRow(
          icon: Icons.person_outline_rounded,
          label: 'bookings.doctor'.tr(),
          value: booking.doctor.name,
        ),
        _DetailRow(
          icon: Icons.medical_services_outlined,
          label: 'bookings.detail.specialty'.tr(),
          value: booking.doctor.specialty,
        ),
        _DetailRow(
          icon: Icons.calendar_today_outlined,
          label: 'bookings.date'.tr(),
          value: _formatDate(booking.date),
        ),
        _DetailRow(
          icon: Icons.access_time_rounded,
          label: 'bookings.time'.tr(),
          value: booking.time,
        ),
        if (booking.turnNumber != null)
          _DetailRow(
            icon: Icons.format_list_numbered_rounded,
            label: 'bookings.turn_number'.tr(),
            value: '${booking.turnNumber}',
            isHighlighted: true,
          ),
      ],
    );
  }

  String _formatDate(String date) {
    try {
      return DateFormat('EEEE، d MMMM yyyy', 'ar').format(DateTime.parse(date));
    } catch (_) {
      return date;
    }
  }
}

class _PatientSection extends StatelessWidget {
  final BookingEntity booking;
  const _PatientSection({required this.booking});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'bookings.detail.patient_info'.tr(),
      children: [
        if (booking.patientName != null)
          _DetailRow(
            icon: Icons.person_rounded,
            label: 'bookings.detail.patient_name'.tr(),
            value: booking.patientName!,
          ),
        if (booking.patientPhone != null)
          _DetailRow(
            icon: Icons.phone_outlined,
            label: 'bookings.detail.patient_phone'.tr(),
            value: booking.patientPhone!,
          ),
      ],
    );
  }
}

class _NotesSection extends StatelessWidget {
  final String notes;
  const _NotesSection({required this.notes});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return _SectionCard(
      title: 'bookings.detail.notes'.tr(),
      children: [
        Text(
          notes,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.hintColor,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(SizeApp.s16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
          Divider(height: SizeApp.s20),
          ...children.map((child) => Padding(
            padding: EdgeInsets.only(bottom: SizeApp.s10),
            child: child,
          )),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isHighlighted;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isHighlighted = false,
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
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.hintColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: SizeApp.s4),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isHighlighted ? theme.primaryColor : null,
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