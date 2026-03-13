import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_size.dart';
import '../../../domain/entites/clinic_entities.dart';
import '../../../domain/entites/doctor_entity.dart';
import '../../../domain/entites/time_slot_entity.dart';
import '../../cubit/clinic_details_cubit.dart';
import '../../widgets/clinic_calendar_widget.dart';

class BookingTab extends StatelessWidget {
  final ClinicEntity clinic;

  const BookingTab({Key? key, required this.clinic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // BlocBuilder triggers rebuild on EVERY state change
    return BlocBuilder<ClinicDetailsCubit, ClinicDetailsState>(
      builder: (context, state) {
        // Only render when loaded
        if (state is! ClinicDetailsLoaded) return const SizedBox.shrink();

        return SingleChildScrollView(
          padding: EdgeInsets.all(AppSizeHorizontal.instance.s20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClinicCalendarWidget(
                selectedDate: state.selectedDate,
                onDateSelected: context.read<ClinicDetailsCubit>().selectDate,
                accentColor: Theme.of(context).primaryColor,
              ),
              SizedBox(height: AppSizeVertical.instance.s24),

              _DoctorListWidget(
                doctors: clinic.doctors,
                state: state,
              ),

              if (state.selectedDoctor != null && state.selectedTime != null) ...[
                SizedBox(height: 16.h),
                _SelectionSummary(state: state),
              ],

              SizedBox(height: AppSizeVertical.instance.s40),
            ],
          ),
        );
      },
    );
  }
}

// ─── Doctor List ──────────────────────────────────────────────────────────────

class _DoctorListWidget extends StatelessWidget {
  final List<DoctorEntity> doctors;
  final ClinicDetailsLoaded state;

  const _DoctorListWidget({
    required this.doctors,
    required this.state,
  });

  String _dayName(int weekday) {
    const days = {
      1: 'monday', 2: 'tuesday', 3: 'wednesday', 4: 'thursday',
      5: 'friday',  6: 'saturday', 7: 'sunday',
    };
    return days[weekday] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dayName = _dayName(state.selectedDate.weekday);

    final availableDoctors = doctors.where((d) {
      return d.availableSlots.any(
            (s) => s.day.toLowerCase().trim() == dayName && s.isAvailable,
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الأطباء المتاحون (${availableDoctors.length})',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),

        if (availableDoctors.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32.h),
              child: Column(
                children: [
                  Icon(Icons.event_busy, size: 64.r, color: theme.hintColor),
                  SizedBox(height: 16.h),
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
              final isSelected = state.selectedDoctor?.id == doctor.id;

              return _DoctorCard(
                doctor: doctor,
                state: state,
                isSelected: isSelected,
                accentColor: Theme.of(context).primaryColor,
              );
            },
          ),
      ],
    );
  }
}

// ─── Doctor Card ──────────────────────────────────────────────────────────────

class _DoctorCard extends StatelessWidget {
  final DoctorEntity doctor;
  final ClinicDetailsLoaded state;
  final bool isSelected;
  final Color accentColor;

  const _DoctorCard({
    required this.doctor,
    required this.state,
    required this.isSelected,
    required this.accentColor,
  });

  String _dayName(int weekday) {
    const days = {
      1: 'monday', 2: 'tuesday', 3: 'wednesday', 4: 'thursday',
      5: 'friday',  6: 'saturday', 7: 'sunday',
    };
    return days[weekday] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ClinicDetailsCubit>();
    final dayName = _dayName(state.selectedDate.weekday);
    final slots = doctor.availableSlots
        .where((s) => s.day.toLowerCase().trim() == dayName && s.isAvailable)
        .toList();

    return GestureDetector(
      onTap: () => cubit.selectDoctor(doctor),
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
            // ── Info row ────────────────────────────────────
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
                        style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(Icons.star_rounded, size: 16.sp, color: Colors.amber),
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
                          Icon(Icons.work_outline, size: 14.sp, color: Colors.grey.shade400),
                          SizedBox(width: 4.w),
                          Text(
                            '${doctor.experienceYears} سنة',
                            style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Column(
                  children: [
                    Text(
                      '${doctor.consultationFee.toInt()}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: accentColor,
                      ),
                    ),
                    Text('ج.م',
                        style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade500)),
                  ],
                ),
              ],
            ),

            SizedBox(height: 16.h),
            Divider(height: 1, color: Colors.grey.shade100),
            SizedBox(height: 12.h),

            // ── Time slots ──────────────────────────────────
            if (slots.isNotEmpty)
              _TimeSlotRow(
                doctor: doctor,
                slots: slots,
                isCardSelected: isSelected,
                selectedTime: isSelected ? state.selectedTime : null,
                accentColor: accentColor,
              )
            else
              Row(
                children: [
                  Icon(Icons.info_outline, size: 16.sp, color: Colors.grey.shade400),
                  SizedBox(width: 6.w),
                  Text(
                    'لا توجد مواعيد متاحة اليوم',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade500),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Time Slot Row ────────────────────────────────────────────────────────────

class _TimeSlotRow extends StatelessWidget {
  final DoctorEntity doctor;
  final List<TimeSlotEntity> slots;
  final bool isCardSelected;
  final String? selectedTime;   // ← comes directly from state, no cubit getter
  final Color accentColor;

  const _TimeSlotRow({
    required this.doctor,
    required this.slots,
    required this.isCardSelected,
    required this.selectedTime,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
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
              final isSlotSelected = isCardSelected && selectedTime == slot.timeSlot;
              final remaining = slot.remainingSlots;

              return GestureDetector(
                onTap: () {
                  // If tapping slot on non-selected card → select doctor first
                  if (!isCardSelected) cubit.selectDoctor(doctor);
                  cubit.selectTimeSlot(slot);
                },
                child: Container(
                  margin: EdgeInsets.only(left: 8.w),
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
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
                          color: isSlotSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                      if (isCardSelected && remaining < slot.maxBookings) ...[
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
  }
}

// ─── Selection Summary ────────────────────────────────────────────────────────

class _SelectionSummary extends StatelessWidget {
  final ClinicDetailsLoaded state;
  const _SelectionSummary({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.primaryColor;
    final cubit = context.read<ClinicDetailsCubit>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: primary.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline_rounded, color: primary, size: 20.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.selectedDoctor!.name,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  state.selectedTime!,
                  style: TextStyle(fontSize: 12.sp, color: theme.hintColor),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: cubit.resetBookingFlow,
            child: Icon(Icons.close_rounded, size: 18.sp, color: theme.hintColor),
          ),
        ],
      ),
    );
  }
}