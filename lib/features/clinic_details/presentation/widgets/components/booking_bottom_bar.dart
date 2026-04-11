// ══════════════════════════════════════════════════════════════════════════════
// booking_bottom_bar.dart  —  fixed
// ══════════════════════════════════════════════════════════════════════════════
//  ✅ AuthGuard.check(context) before opening BookingScreen
//  ✅ All hardcoded Arabic strings replaced with easy_localization keys
// ══════════════════════════════════════════════════════════════════════════════

import 'package:clinic_app/features/clinic_details/domain/entites/clinic_entities.dart';
import 'package:clinic_app/features/clinic_details/presentation/cubit/clinic_details_cubit.dart';
import 'package:clinic_app/features/clinic_details/presentation/view/booking/booking_screen.dart';
import 'package:clinic_app/features/user_data/auth_guard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/theme/colors.dart';
import '../../../domain/entites/doctor_entity.dart';

class BookingBottomBar extends StatelessWidget {
  final ClinicEntity clinic;
  final DoctorEntity doctor;

  const BookingBottomBar({
    Key? key,
    required this.clinic,
    required this.doctor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // ── Fee info ────────────────────────────────────
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'booking.bottom_bar.fee_label'.tr(),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade500,
                  ),
                ),
                Text(
                  '${doctor.consultationFee.toInt()} ${'clinic.currency'.tr()}',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(width: 16.w),

            // ── Book Now button ─────────────────────────────
            Expanded(
              child: ElevatedButton(
                onPressed: () => _openBookingScreen(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                // ✅ was hardcoded 'احجز الآن'
                child: Text(
                  'booking.bottom_bar.book_now'.tr(),
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openBookingScreen(BuildContext context) {
    if (!AuthGuard.check(context)) return;

    final cubit = context.read<ClinicDetailsCubit>();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: BookingScreen(
            clinicalId: int.parse(clinic.id),
            doctorId: doctor.id,
            clinicName: clinic.name,
            doctorName: doctor.name,
            availableSlots: doctor.availableSlots,
          ),
        ),
      ),
    );
  }
}