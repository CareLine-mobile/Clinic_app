// ══════════════════════════════════════════════════════════════════════════════
// booking_bottom_bar.dart
// ══════════════════════════════════════════════════════════════════════════════
// The bottom bar that appears when a doctor + slot are selected.
// It owns the navigation to BookingScreen and passes the existing cubit.
// ══════════════════════════════════════════════════════════════════════════════

import 'package:clinic_app/features/clinic_details/domain/entites/clinic_entities.dart';
import 'package:clinic_app/features/clinic_details/presentation/cubit/clinic_details_cubit.dart';
import 'package:clinic_app/features/clinic_details/presentation/view/booking/booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/colors.dart';
import '../../../domain/entites/doctor_entity.dart' show DoctorEntity;


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
            // Fee info
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'رسوم الاستشارة',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade500,
                  ),
                ),
                Text(
                  '${doctor.consultationFee.toInt()} ج.م',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.primaryColor,
                  ),
                ),
              ],
            ),
            SizedBox(width: 16.w),

            // Book button
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
                child: Text(
                  'احجز الآن',
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
    // ✅ BlocProvider.value passes the EXISTING cubit to the new route
    // without creating a new one — so all selected state is preserved.
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