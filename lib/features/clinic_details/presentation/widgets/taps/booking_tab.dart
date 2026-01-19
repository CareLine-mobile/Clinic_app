// ==================== tabs/booking_tab.dart ====================
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
    return BlocBuilder<ClinicUiCubit, ClinicUiState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(AppSizeHorizontal.instance.s20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClinicCalendarWidget(
                selectedDate: state.selectedDate,
                onDateSelected: (date) {
                  context.read<ClinicUiCubit>().selectDate(date);
                },
                accentColor: Theme.of(context).primaryColor,
              ),
              SizedBox(height: AppSizeVertical.instance.s24),
              DoctorListWidget(
                doctors: clinic.doctors,
                selectedDate: state.selectedDate,
                selectedDoctor: state.selectedDoctor,
                onDoctorSelected: (doctor) {
                  context.read<ClinicUiCubit>().selectDoctor(doctor);
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