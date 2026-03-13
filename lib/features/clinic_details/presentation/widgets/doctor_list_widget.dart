import 'package:clinic_app/features/clinic_details/domain/entites/doctor_entity.dart';
import 'package:clinic_app/features/clinic_details/presentation/widgets/doctor_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_size.dart';


// ─── Doctor List Widget ───────────────────────────────────────────────────────

class DoctorListWidget extends StatelessWidget {
  final List<DoctorEntity> doctors;
  final DateTime selectedDate;
  final DoctorEntity? selectedDoctor;
  final Function(DoctorEntity) onDoctorSelected;
  final Color accentColor;

  const DoctorListWidget({
    Key? key,
    required this.doctors,
    required this.selectedDate,
    required this.selectedDoctor,
    required this.onDoctorSelected,
    required this.accentColor,
  }) : super(key: key);

  String _getDayName(DateTime date) {
    const days = [
      'monday', 'tuesday', 'wednesday', 'thursday',
      'friday', 'saturday', 'sunday',
    ];
    return days[date.weekday - 1];
  }

  List<DoctorEntity> _getAvailableDoctors() {
    final dayName = _getDayName(selectedDate);
    return doctors.where((doctor) {
      return doctor.availableSlots.any(
            (slot) =>
        slot.day.toLowerCase() == dayName.toLowerCase() &&
            slot.isAvailable,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vSize = AppSizeVertical.instance;
    final availableDoctors = _getAvailableDoctors();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الأطباء المتاحون (${availableDoctors.length})',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: vSize.s12),
        if (availableDoctors.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.all(vSize.s32),
              child: Column(
                children: [
                  Icon(Icons.event_busy, size: 64.r, color: theme.hintColor),
                  SizedBox(height: vSize.s16),
                  Text(
                    'لا يوجد أطباء متاحون في هذا التاريخ',
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: availableDoctors.length,
            itemBuilder: (context, index) {
              final doctor = availableDoctors[index];
              return DoctorCard(
                doctor: doctor,
                selectedDate: selectedDate,
                isSelected: selectedDoctor?.id == doctor.id,
                onTap: () => onDoctorSelected(doctor),
                accentColor: accentColor,
              );
            },
          ),
      ],
    );
  }
}
