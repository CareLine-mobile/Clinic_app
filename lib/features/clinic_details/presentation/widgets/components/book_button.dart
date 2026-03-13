import 'package:clinic_app/features/clinic_details/presentation/view/booking/booking_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_size.dart';
import '../../../../../core/widgets/confirmation_dialog.dart';
import '../../../../user_data/auth_guard.dart';
import '../../../domain/entites/clinic_entities.dart';
import '../../../domain/entites/doctor_entity.dart';
import '../../cubit/clinic_details_cubit.dart';

class BookButton extends StatelessWidget {
  final ClinicEntity clinic;
  final DoctorEntity doctor;
  final Color accentColor;

  const BookButton({
    Key? key,
    required this.clinic,
    required this.doctor,
    required this.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClinicDetailsCubit, ClinicDetailsState>(
      builder: (context, state) {
        final isBooking = state is BookingLoading;

        return ElevatedButton(
          onPressed: isBooking ? null : () => _showBookingDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
            padding: EdgeInsets.symmetric(vertical: AppSizeVertical.instance.s16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizeHorizontal.instance.s12),
            ),
          ),
          child: isBooking
              ? SizedBox(
            height: 20.h,
            width: 20.w,
            child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
          )
              : Text(
            'احجز الآن',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  void _showBookingDialog(BuildContext context) {
    if (!AuthGuard.check(context)) return;
    AppDialog.warning(
      context: context,
      message: 'هل تريد حجز موعد مع ${doctor.name}؟',
      onConfirm: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookingScreen(
              clinicalId: int.parse(clinic.id),
              doctorId: doctor.id,
              clinicName: clinic.name,
              doctorName: doctor.name,
              availableSlots: doctor.availableSlots,
            ),
          ),
        );
      },
    );
  }
}