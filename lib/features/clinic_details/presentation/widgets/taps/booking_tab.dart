// ==================== tabs/booking_tab.dart ====================
import 'package:clinic_app/features/clinic_details/presentation/cubit/clinic_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entites/clinic_entities.dart';
import '../../cubit/clinic_ui_cubit.dart';
import '../../widgets/clinic_calendar_widget.dart';
import '../../../../../core/utils/app_size.dart';

class BookingTab extends StatelessWidget {
  final ClinicEntity clinic;

  const BookingTab({
    Key? key,
    required this.clinic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClinicDetailsCubit, ClinicDetailsState>(
      builder: (context, state) {
        final clinicCubit = context.read<ClinicDetailsCubit>();

        return SingleChildScrollView(
          padding: EdgeInsets.all(AppSizeHorizontal.instance.s20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClinicCalendarWidget(
                selectedDate: clinicCubit.selectedDate,
                onDateSelected: (date) {
                  clinicCubit.selectDate(date);
                },
                accentColor: Theme.of(context).primaryColor,
              ),
              SizedBox(height: AppSizeVertical.instance.s24),
              DoctorListWidget(
                doctors: clinic.doctors,
                selectedDate: clinicCubit.selectedDate,
                selectedDoctor: clinicCubit.selectedDoctor,
                onDoctorSelected: (doctor) {
                  clinicCubit.selectDoctor(doctor);
                },
                accentColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
        );
      },
    );
  }
}