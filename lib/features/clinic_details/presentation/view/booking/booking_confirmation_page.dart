import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/widgets/app_buton.dart';
import '../../cubit/clinic_details_cubit.dart';

// ✅ تم تحويلها لـ StatefulWidget عشان نقدر نحتفظ بالداتا
class BookingConfirmationPage extends StatefulWidget {
  const BookingConfirmationPage({super.key});

  @override
  State<BookingConfirmationPage> createState() => _BookingConfirmationPageState();
}

class _BookingConfirmationPageState extends State<BookingConfirmationPage> {
  ClinicDetailsLoaded? _cachedData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ClinicDetailsCubit, ClinicDetailsState>(
      builder: (context, state) {
        if (state is ClinicDetailsLoaded) {
          _cachedData = state;
        }

        if (_cachedData == null) return const SizedBox.shrink();

        final isSubmitting = state is BookingLoading;

        return AbsorbPointer(
          absorbing: isSubmitting,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 20.h),

                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: const BoxDecoration(
                    color: ColorsManager.warningSurface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.priority_high_rounded,
                      color: ColorsManager.warningFill, size: 32.sp),
                ),
                SizedBox(height: 24.h),

                Text(
                  'booking.confirm_title'.tr(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.primaryColor,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'booking.confirm_subtitle'.tr(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: ColorsManager.defaultTextSecondary,
                  ),
                ),
                SizedBox(height: 32.h),

                // ── Summary Container ──────────────────
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
                  decoration: BoxDecoration(
                    color: ColorsManager.backgroundCard,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                        color: ColorsManager.inputBorder.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      _buildRow(theme, 'booking.summary.clinic'.tr(), _cachedData!.clinic.name),
                      Divider(height: 24.h, color: ColorsManager.inputBorder.withOpacity(0.2)),

                      _buildRow(theme, 'booking.summary.doctor'.tr(), _cachedData!.selectedDoctor?.name ?? "—"),
                      Divider(height: 24.h, color: ColorsManager.inputBorder.withOpacity(0.2)),

                      _buildRow(theme, 'booking.summary.patient'.tr(), _cachedData!.patientName ?? "—"),
                      Divider(height: 24.h, color: ColorsManager.inputBorder.withOpacity(0.2)),

                      _buildRow(theme, 'booking.summary.phone'.tr(), _cachedData!.patientPhone ?? "—"),
                      Divider(height: 24.h, color: ColorsManager.inputBorder.withOpacity(0.2)),

                      _buildRow(
                        theme,
                        'booking.summary.date'.tr(),
                        DateFormat('EEE, MMM d yyyy', context.locale.languageCode)
                            .format(_cachedData!.selectedDate),
                      ),
                      Divider(height: 24.h, color: ColorsManager.inputBorder.withOpacity(0.2)),

                      _buildRow(theme, 'booking.summary.time'.tr(), _cachedData!.selectedTime ?? "—"),

                      if (_cachedData!.bookingNotes?.isNotEmpty == true) ...[
                        Divider(height: 24.h, color: ColorsManager.inputBorder.withOpacity(0.2)),
                        _buildRow(theme, 'booking.summary.notes'.tr(), _cachedData!.bookingNotes!),
                      ],
                    ],
                  ),
                ),

                SizedBox(height: 20.h),
                Text(
                  'booking.payment_note'.tr(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: ColorsManager.miscellaneous,
                  ),
                ),
                SizedBox(height: 32.h),

                AppButton(
                  text: 'booking.confirm_button'.tr(),
                  isLoading: isSubmitting,
                  onPressed: isSubmitting
                      ? null // تعطيل الزرار وقت التحميل
                      : () => context.read<ClinicDetailsCubit>().confirmBooking(),
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRow(ThemeData theme, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: ColorsManager.defaultTextSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 16.w),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: ColorsManager.defaultText,
            ),
          ),
        ),
      ],
    );
  }
}