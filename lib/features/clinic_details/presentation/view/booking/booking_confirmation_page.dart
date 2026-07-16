import 'package:clinic_app/core/theme/colors.dart';
import 'package:clinic_app/core/widgets/app_buton.dart';
import 'package:clinic_app/core/widgets/app_text_feild.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/widgets/app_error_box.dart';
import '../../cubit/clinic_details_cubit.dart';

class BookingConfirmationPage extends StatefulWidget {
  const BookingConfirmationPage({super.key});

  @override
  State<BookingConfirmationPage> createState() => _BookingConfirmationPageState();
}

class _BookingConfirmationPageState extends State<BookingConfirmationPage> {
  ClinicDetailsLoaded? _cachedData;
  final TextEditingController _couponController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

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
        final couponData = _cachedData!.appliedCoupon;
        final bookingError = _cachedData!.bookingErrorMessage;
        final isCouponLoading = _cachedData!.isCouponLoading;

        return AbsorbPointer(
          absorbing: isSubmitting,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
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

                SizedBox(height: 32.h),

                // ── Promo Code ──────────────────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppTextField(
                        height: 46.h,
                        controller: _couponController,
                        hintText: 'booking.enter_promo_code'.tr(),
                        prefixIcon: const Icon(Icons.local_offer_outlined, color: ColorsManager.primaryColor),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    SizedBox(
                      height: 46.h,
                      child: ElevatedButton(
                        onPressed: isCouponLoading
                            ? null
                            : () {
                                context.read<ClinicDetailsCubit>().applyCoupon(_couponController.text);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsManager.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        child: isCouponLoading
                            ? SizedBox(
                                width: 24.w,
                                height: 24.w,
                                child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text('booking.apply'.tr(), style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
                if (_cachedData!.couponError != null)
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        _cachedData!.couponError!,
                        style: theme.textTheme.bodySmall?.copyWith(color: ColorsManager.errorFill),
                      ),
                    ),
                  ),

                if (couponData != null) ...[
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: ColorsManager.successSurface.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: ColorsManager.successFill.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        // Top Part: Success Message & Badge
                        Row(
                          children: [
                            Icon(Icons.verified_rounded, color: ColorsManager.successFill, size: 24.sp),
                            SizedBox(width: 8.w),
                            Text(
                              'booking.coupon_applied'.tr(),
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: ColorsManager.successFill,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: ColorsManager.successFill.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                '-${(couponData.discountValue / couponData.originalPrice * 100).toStringAsFixed(0)}%',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: ColorsManager.successFill,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        // Dotted Divider
                        Row(
                          children: List.generate(
                            30,
                            (index) => Expanded(
                              child: Container(
                                color: index % 2 == 0 ? ColorsManager.successFill.withOpacity(0.3) : Colors.transparent,
                                height: 1.5.h,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        // Bottom Part: Prices & Saved Amount
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'booking.final_price'.tr(),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: ColorsManager.miscellaneous,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${couponData.finalPrice} ${'doctorProfile.egp'.tr()}',
                                      style: theme.textTheme.titleLarge?.copyWith(
                                        color: ColorsManager.successFill,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      '${couponData.originalPrice}',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: ColorsManager.successFill,
                                borderRadius: BorderRadius.circular(20.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorsManager.successFill.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.local_offer_rounded, color: Colors.white, size: 14.sp),
                                  SizedBox(width: 4.w),
                                  Text(
                                    '${'booking.you_saved'.tr()} ${couponData.discountValue}',
                                    style: theme.textTheme.labelMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
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

                SizedBox(height: 24.h),

                // ── Inline Error Widget ──────────────────
                if (bookingError != null)
                  AppErrorBox(errorMessage: bookingError),

                Text(
                  'booking.payment_note'.tr(),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: ColorsManager.miscellaneous,
                  ),
                ),
                SizedBox(height: 24.h),

                AppButton(
                  text: 'booking.confirm_button'.tr(),
                  isLoading: isSubmitting,
                  onPressed: isSubmitting
                      ? null
                      : () => context.read<ClinicDetailsCubit>().confirmBooking(),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
         ),
        );
      },
    );
  }

  Widget _buildRow(ThemeData theme, String label, String value, {Color? valueColor, bool isBold = false}) {
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
              fontWeight: isBold ? FontWeight.w900 : FontWeight.bold,
              color: valueColor ?? ColorsManager.defaultText,
            ),
          ),
        ),
      ],
    );
  }
}