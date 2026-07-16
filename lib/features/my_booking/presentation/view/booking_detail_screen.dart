import 'package:clinic_app/features/my_booking/domain/entities/booking_entity.dart';
import 'package:clinic_app/features/my_booking/presentation/widgets/SectionCard.dart';
import 'package:clinic_app/features/my_booking/presentation/widgets/booking_detail_row.dart';
import 'package:clinic_app/features/my_booking/presentation/widgets/booking_status_config.dart';
import 'package:clinic_app/features/my_booking/presentation/widgets/clinic_avatar.dart';
import 'package:clinic_app/features/my_booking/presentation/widgets/rating_chip.dart';
import 'package:clinic_app/features/my_booking/presentation/widgets/wait_turns_chip.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/routes/routes.dart';
import '../../../../../../core/utils/app_size.dart';
import '../../../../../../core/widgets/custom_app_bar.dart';
import '../cubit/booking_cubit.dart';
import '../widgets/review_form_widget.dart';

class BookingDetailScreen extends StatefulWidget {
  final BookingEntity booking;

  const BookingDetailScreen({super.key, required this.booking});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.booking.hasFollowUp) {
      context.read<BookingCubit>().getFollowUps(widget.booking.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is CancelBookingSuccess) {
          _showSnackBar(
            context,
            message: 'bookings.detail.cancel_success'.tr(),
            isError: false,
          );
          context.read<BookingCubit>().loadBookings();
          Navigator.of(context).pop();
        } else if (state is CancelBookingError) {
          _showSnackBar(context, message: state.message, isError: true);
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
              _ClinicCard(booking: widget.booking),
              SizedBox(height: SizeApp.s16),

              _StatusBanner(status: widget.booking.status),
              SizedBox(height: SizeApp.s16),

              _AppointmentInfoSection(booking: widget.booking),

              if (widget.booking.patientName != null || widget.booking.patientPhone != null) ...[
                SizedBox(height: SizeApp.s16),
                _PatientSection(booking: widget.booking),
              ],

              if (widget.booking.notes?.isNotEmpty == true) ...[
                SizedBox(height: SizeApp.s16),
                _NotesSection(notes: widget.booking.notes!),
              ],

              // Cancel — only for pending bookings
              if (widget.booking.canCancel) ...[
                SizedBox(height: SizeApp.s24),
                _CancelButton(bookingId: widget.booking.id),
              ],

              // Review form — only for completed bookings
              if (widget.booking.canReview) ...[
                SizedBox(height: SizeApp.s24),
                ReviewFormWidget(booking: widget.booking),
              ],
              
              if (widget.booking.hasFollowUp) ...[
                SizedBox(height: SizeApp.s24),
                _FollowUpTreeSection(parentBooking: widget.booking),
              ],

              SizedBox(height: SizeApp.s40),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(
      BuildContext context, {
        required String message,
        required bool isError,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
        isError ? const Color(0xFFC62828) : const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }
}

// ─── Clinic Card ─────────────────────────────────────────────────────────────

class _ClinicCard extends StatelessWidget {
  final BookingEntity booking;
  const _ClinicCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final clinical = booking.clinical;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.clinicDetails,
          arguments: clinical.id,
        );
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
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
          ClinicAvatar(thumbnailUrl: clinical.thumbnailUrl, size: 64, radius: 14),
          SizedBox(width: SizeApp.s12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(clinical.name,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                if (clinical.specialty != null) ...[
                  SizedBox(height: 4.h),
                  Text(clinical.specialty!,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.hintColor)),
                ],
                SizedBox(height: 6.h),
                if (clinical.location != null)
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 14.sp, color: theme.hintColor),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          clinical.location!,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: theme.hintColor),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      RatingChip(rating: clinical.rating),
                    ],
                  )
                else
                  RatingChip(rating: clinical.rating),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}

// ─── Status Banner ────────────────────────────────────────────────────────────

class _StatusBanner extends StatelessWidget {
  final String status;
  const _StatusBanner({required this.status});

  @override
  Widget build(BuildContext context) {
    final config = BookingStatusConfig.from(status);
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

// ─── Appointment Info ─────────────────────────────────────────────────────────

class _AppointmentInfoSection extends StatelessWidget {
  final BookingEntity booking;
  const _AppointmentInfoSection({required this.booking});

  @override
  Widget build(BuildContext context) {
    final bool showQueueInfo = booking.status == 'confirmed' || booking.status == 'checked_in';
    return SectionCard(
      title: 'bookings.detail.appointment_info'.tr(),
      children: [
        BookingDetailRow(
          icon: Icons.person_outline_rounded,
          label: 'bookings.doctor'.tr(),
          value: booking.doctor.name,
        ),
        BookingDetailRow(
          icon: Icons.calendar_today_outlined,
          label: 'bookings.date'.tr(),
          value: _formatDate(context, booking.date),
        ),

        if (showQueueInfo && booking.waitTurns != null && booking.turnNumber != null) ...[
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'bookings.time'.tr(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
                  ),
                  Text(
                    _formatTime(context, booking.time),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                  ),
                ],
              ),
              WaitTurnsChip(
                waitTurns: booking.waitTurns!,
                turnNumber: booking.turnNumber!,
              ),
            ],
          ),
        ] else ...[
          BookingDetailRow(
            icon: Icons.access_time_rounded,
            label: 'bookings.time'.tr(),
            value: _formatTime(context, booking.time),
          ),
        ],
      ],
    );
  }
}

String _formatDate(BuildContext context, String date) {
  try {
    final locale = context.locale.languageCode;
    final pattern = locale == 'ar' ? 'EEEE، d MMMM yyyy' : 'EEEE, d MMMM yyyy';
    return DateFormat(pattern, locale).format(DateTime.parse(date));
  } catch (_) {
    return date;
  }
}

String _formatTime(BuildContext context, String time) {
  try {
    final locale = context.locale.languageCode;
    final timeParts = time.split(':');
    final dt = DateTime(2020, 1, 1, int.parse(timeParts[0]), int.parse(timeParts[1]));
    return DateFormat('hh:mm a', locale).format(dt);
  } catch (_) {
    return time;
  }
}

// ─── Patient Section ──────────────────────────────────────────────────────────

class _PatientSection extends StatelessWidget {
  final BookingEntity booking;
  const _PatientSection({required this.booking});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'bookings.detail.patient_info'.tr(),
      children: [
        if (booking.patientName != null)
          BookingDetailRow(
            icon: Icons.person_rounded,
            label: 'bookings.detail.patient_name'.tr(),
            value: booking.patientName!,
          ),
        if (booking.patientPhone != null)
          BookingDetailRow(
            icon: Icons.phone_outlined,
            label: 'bookings.detail.patient_phone'.tr(),
            value: booking.patientPhone!,
          ),
      ],
    );
  }
}

// ─── Notes Section ────────────────────────────────────────────────────────────

class _NotesSection extends StatelessWidget {
  final String notes;
  const _NotesSection({required this.notes});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'bookings.detail.notes'.tr(),
      children: [
        Text(
          notes,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).hintColor,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

// ─── Cancel Button ────────────────────────────────────────────────────────────

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
            onPressed: isLoading ? null : () => _confirmCancel(context),
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

class _FollowUpTreeSection extends StatelessWidget {
  final BookingEntity parentBooking;

  const _FollowUpTreeSection({Key? key, required this.parentBooking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      buildWhen: (prev, curr) => curr is FollowUpLoading || curr is FollowUpLoaded || curr is FollowUpError,
      builder: (context, state) {
        if (state is FollowUpLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FollowUpError) {
          return Center(
            child: Text(
              state.message,
              style: TextStyle(color: Colors.red, fontSize: 14.sp),
            ),
          );
        } else if (state is FollowUpLoaded) {
          final followUps = state.followUps;
          if (followUps.isEmpty) return const SizedBox.shrink();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'bookings.follow_up_appointments'.tr(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SizedBox(height: SizeApp.s16),
              ...followUps.map((followUp) => _buildFollowUpNode(context, followUp)).toList(),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFollowUpNode(BuildContext context, BookingEntity followUp) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tree Line and Node
          SizedBox(
            width: 32.w,
            child: Column(
              children: [
                Container(
                  width: 2.w,
                  height: 20.h,
                  color: theme.primaryColor.withOpacity(0.5),
                ),
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.primaryColor,
                    border: Border.all(
                      color: isDark ? Colors.black : Colors.white,
                      width: 2,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2.w,
                    color: theme.primaryColor.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          
          // FollowUp Card
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: GestureDetector(
                onTap: () {
                  // Navigate to the follow up details if needed
                  Navigator.pushNamed(
                    context, 
                    Routes.bookingDetails,
                    arguments: {
                      'booking': followUp,
                      'cubit': context.read<BookingCubit>(),
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0A0E19) : Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.black12,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDate(context, followUp.date),
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _buildStatusBadge(followUp.status),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 14.sp, color: Colors.grey),
                          SizedBox(width: 4.w),
                          Text(
                            _formatTime(context, followUp.time),
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final config = BookingStatusConfig.from(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: config.bgColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: config.color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, color: config.color, size: 12.sp),
          SizedBox(width: 4.w),
          Text(
            config.label,
            style: TextStyle(
              color: config.color,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
