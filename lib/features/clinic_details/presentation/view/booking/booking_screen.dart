// ══════════════════════════════════════════════════════════
// booking_screen.dart
// ══════════════════════════════════════════════════════════
import 'package:clinic_app/core/widgets/custom_snack_bar.dart';
import 'package:clinic_app/features/clinic_details/domain/entites/time_slot_entity.dart';
import 'package:clinic_app/features/clinic_details/presentation/cubit/clinic_details_cubit.dart';
import 'package:clinic_app/features/clinic_details/presentation/widgets/booking/booking_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'booking_date_time_page.dart';
import 'booking_your_info_page.dart';
import 'booking_confirmation_page.dart';

class BookingScreen extends StatelessWidget {
  final int clinicalId;
  final String doctorId;
  final String clinicName;
  final String doctorName;
  final List<TimeSlotEntity> availableSlots;

  const BookingScreen({
    super.key,
    required this.clinicalId,
    required this.doctorId,
    required this.clinicName,
    required this.doctorName,
    required this.availableSlots,
  });

  @override
  Widget build(BuildContext context) {
    return _BookingScreenBody(
      clinicName: clinicName,
      doctorName: doctorName,
    );
  }
}

class _BookingScreenBody extends StatelessWidget {
  final String clinicName;
  final String doctorName;

  const _BookingScreenBody({
    required this.clinicName,
    required this.doctorName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<ClinicDetailsCubit, ClinicDetailsState>(
      listener: (context, state) {
        if (state is BookingError) {
          CustomSnackBar.show(context,
              message: state.message, type: SnackBarType.error);
        }
        if (state is BookingSuccess) {
          CustomSnackBar.show(context,
              message: state.message, type: SnackBarType.success);
        }
      },
      child: BlocBuilder<ClinicDetailsCubit, ClinicDetailsState>(
        builder: (context, state) {
          // Read bookingStep from STATE — not cubit getter
          final currentStep =
          state is ClinicDetailsLoaded ? state.bookingStep : 0;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  if (currentStep > 0) {
                    context.read<ClinicDetailsCubit>().previousBookingStep();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clinicName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    doctorName,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                BookingStepperWidget(currentStep: currentStep),
                Expanded(
                  child: switch (currentStep) {
                    0 => const BookingDateTimePage(),
                    1 => const BookingYourInfoPage(),
                    2 => const BookingConfirmationPage(),
                    _ => const BookingDateTimePage(),
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


