import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/custom_snack_bar.dart';
import '../../../clinic_details/domain/entites/time_slot_entity.dart';
import '../../domain/usecases/make_appointment_usecase.dart';
import '../cubit/booking_flow_cubit.dart';
import 'booking_date_time_page.dart';
import 'booking_your_info_page.dart';
import 'booking_confirmation_page.dart';
import '../widgets/booking_stepper.dart';

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
    return BlocProvider(
      create: (_) => BookingFlowCubit(
        makeAppointmentUseCase: sl<MakeAppointmentUseCase>(),
        clinicalId: clinicalId,
        doctorId: doctorId,
        clinicName: clinicName,
        doctorName: doctorName,
        availableSlots: availableSlots,
      ),
      child: const _BookingScreenBody(),
    );
  }
}

class _BookingScreenBody extends StatelessWidget {
  const _BookingScreenBody();

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingFlowCubit, BookingFlowState>(
      listenWhen: (prev, curr) => prev.errorMessage != curr.errorMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          CustomSnackBar.show(context, message: state.errorMessage!, type: SnackBarType.error);
        }
      },
      child: BlocBuilder<BookingFlowCubit, BookingFlowState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  if (state.currentStep > 0) {
                    context.read<BookingFlowCubit>().previousStep();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.clinicName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    state.doctorName,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                const BookingStepperWidget(),
                Expanded(
                  child: switch (state.currentStep) {
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