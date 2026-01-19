// ==================== components/book_button.dart ====================
import 'package:clinic_app/core/widgets/confirmation_dialog.dart';
import 'package:clinic_app/features/clinic_details/domain/entites/doctor_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../domain/entites/clinic_entities.dart';
import '../../cubit/clinic_details_cubit.dart';
import '../../cubit/clinic_ui_cubit.dart';
import '../../../../../core/utils/app_size.dart';


class BookButton extends StatelessWidget {
  final DoctorEntity doctor;
  final Color accentColor;

  const BookButton({
    Key? key,
    required this.doctor,
    required this.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClinicDetailsCubit, ClinicDetailsState>(
      builder: (context, state) {
        final isBooking = state is BookingInProgress;

        return ElevatedButton(
          onPressed: isBooking ? null : () => _showBookingDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
            padding: EdgeInsets.symmetric(
              vertical: AppSizeVertical.instance.s16,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppSizeHorizontal.instance.s12,
              ),
            ),
          ),
          child: isBooking
              ? SizedBox(
            height: 20.h,
            width: 20.w,
            child: const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
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
    final uiState = context.read<ClinicUiCubit>().state;

    AppDialog.warning(
      context: context,
      onConfirm: () {

    }, message: '',
    );
  }
}