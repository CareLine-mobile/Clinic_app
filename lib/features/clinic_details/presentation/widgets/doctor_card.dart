import 'package:clinic_app/features/clinic_details/domain/entites/time_slot_entity.dart';
import 'package:clinic_app/features/clinic_details/presentation/cubit/clinic_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entites/doctor_entity.dart';

class DoctorCard extends StatelessWidget {
  final DoctorEntity doctor;
  final DateTime selectedDate;
  final bool isSelected;
  final VoidCallback onTap;
  final Color accentColor;

  const DoctorCard({
    Key? key,
    required this.doctor,
    required this.selectedDate,
    required this.isSelected,
    required this.onTap,
    required this.accentColor,
  }) : super(key: key);

  String _getDayName(DateTime date) {
    const days = [
      'monday', 'tuesday', 'wednesday', 'thursday',
      'friday', 'saturday', 'sunday',
    ];
    return days[date.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final dayName = _getDayName(selectedDate);
    final availableSlots = doctor.availableSlots
        .where((s) =>
    s.day.toLowerCase().trim() == dayName && s.isAvailable)
        .toList();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withOpacity(0.04) : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? accentColor : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Doctor info ──────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    doctor.imageUrl,
                    width: 65.w, height: 65.w,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 65.w, height: 65.w,
                      color: Colors.grey.shade100,
                      child: Icon(Icons.person, color: Colors.grey.shade400),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        doctor.specialty,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12.sp, color: Colors.grey.shade600),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(Icons.star_rounded,
                              size: 16.sp, color: Colors.amber),
                          SizedBox(width: 4.w),
                          Text(
                            doctor.rating.toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Icon(Icons.work_outline,
                              size: 14.sp, color: Colors.grey.shade400),
                          SizedBox(width: 4.w),
                          Text(
                            '${doctor.experienceYears} سنة',
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Divider(height: 1, color: Colors.grey.shade100),
            SizedBox(height: 12.h),

            if (availableSlots.isNotEmpty)
              _TimeSlotRow(
                doctor: doctor,
                slots: availableSlots,
                isCardSelected: isSelected,
                accentColor: accentColor,
              )
            else
              Row(
                children: [
                  Icon(Icons.info_outline,
                      size: 16.sp, color: Colors.grey.shade400),
                  SizedBox(width: 6.w),
                  Text(
                    'لا توجد مواعيد متاحة اليوم',
                    style: TextStyle(
                        fontSize: 12.sp, color: Colors.grey.shade500),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _TimeSlotRow extends StatelessWidget {
  final DoctorEntity doctor;
  final List<TimeSlotEntity> slots;
  final bool isCardSelected;
  final Color accentColor;

  const _TimeSlotRow({
    required this.doctor,
    required this.slots,
    required this.isCardSelected,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClinicDetailsCubit, ClinicDetailsState>(
      builder: (context, state) {
        // ✅ Read selectedTime from STATE — not cubit getter
        final selectedTime = state is ClinicDetailsLoaded
            ? state.selectedTime
            : null;

        final cubit = context.read<ClinicDetailsCubit>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isCardSelected) ...[
              Text(
                'اختر الوقت',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 8.h),
            ],
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: slots.map((slot) {
                  final isSlotSelected =
                      isCardSelected && selectedTime == slot.timeSlot;
                  final remaining = slot.remainingSlots;

                  return GestureDetector(
                    onTap: () {
                      if (!isCardSelected) cubit.selectDoctor(doctor);
                      cubit.selectTimeSlot(slot);
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 8.w),
                      padding: EdgeInsets.symmetric(
                          horizontal: 14.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: isSlotSelected
                            ? accentColor
                            : isCardSelected
                            ? accentColor.withOpacity(0.06)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: isSlotSelected
                              ? accentColor
                              : isCardSelected
                              ? accentColor.withOpacity(0.3)
                              : Colors.grey.shade200,
                          width: isSlotSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            slot.timeSlot,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: isSlotSelected
                                  ? Colors.white
                                  : Colors.black87,
                            ),
                          ),
                          if (isCardSelected &&
                              remaining < slot.maxBookings) ...[
                            SizedBox(height: 2.h),
                            Text(
                              'متبقي $remaining',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: isSlotSelected
                                    ? Colors.white70
                                    : remaining <= 2
                                    ? Colors.orange.shade700
                                    : Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}