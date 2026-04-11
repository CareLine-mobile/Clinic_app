// ══════════════════════════════════════════════════════════════════════════════
// doctor_card.dart  —  fixed
// ══════════════════════════════════════════════════════════════════════════════
//  ✅ All hardcoded Arabic strings replaced with easy_localization keys
//  ✅ _TimeSlotRow has its own BlocBuilder only for the time selection part
// ══════════════════════════════════════════════════════════════════════════════

import 'package:clinic_app/core/theme/colors.dart';
import 'package:clinic_app/features/clinic_details/domain/entites/time_slot_entity.dart';
import 'package:clinic_app/features/clinic_details/presentation/cubit/clinic_details_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
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
            // ── Doctor info row ──────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.network(
                    doctor.imageUrl,
                    width: 65.w,
                    height: 65.w,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 65.w,
                      height: 65.w,
                      color: Colors.grey.shade100,
                      child:
                      Icon(Icons.person, color: Colors.grey.shade400),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // Name / specialty / rating
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
                          // ✅ was hardcoded 'سنة'
                          Text(
                            'clinic.years_exp'.tr(namedArgs: {
                              'count': '${doctor.experienceYears}'
                            }),
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Consultation fee
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${doctor.consultationFee.toInt()}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: accentColor,
                      ),
                    ),
                    Text(
                      'clinic.currency'.tr(),
                      style: TextStyle(
                          fontSize: 11.sp, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 16.h),
            Divider(height: 1, color: Colors.grey.shade100),
            SizedBox(height: 12.h),

            // ── Time slots / empty message ───────────────────
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
                  // ✅ was hardcoded 'لا توجد مواعيد متاحة اليوم'
                  Text(
                    'clinic.no_slots_today'.tr(),
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

// ─── Time Slot Row ────────────────────────────────────────────────────────────

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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<ClinicDetailsCubit, ClinicDetailsState>(
      buildWhen: (prev, next) {
        if (prev is ClinicDetailsLoaded && next is ClinicDetailsLoaded) {
          return prev.selectedTime != next.selectedTime ||
              prev.selectedDoctor?.id != next.selectedDoctor?.id;
        }
        return true;
      },
      builder: (context, state) {
        final selectedTime =
        state is ClinicDetailsLoaded ? state.selectedTime : null;
        final cubit = context.read<ClinicDetailsCubit>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isCardSelected) ...[
              Text(
                'clinic.choose_time'.tr(),
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: ColorsManager.defaultTextSecondary,
                ),
              ),
              SizedBox(height: 8.h), // مساحة أقل
            ],
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: slots.map((slot) {
                  final isSlotSelected =
                      isCardSelected && selectedTime == slot.timeSlot;
                  final remaining = slot.remainingSlots;

                  return Padding(
                    padding: EdgeInsets.only(
                      left: 8.w,
                      right: slot == slots.last ? 8.w : 0,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      decoration: BoxDecoration(
                        color: isSlotSelected
                            ? accentColor
                            : isCardSelected
                            ? Colors.transparent
                            : ColorsManager.backgroundSurface,
                        // تصميم الكبسولة النحيف (Pill Shape)
                        borderRadius: BorderRadius.circular(100.r),
                        border: Border.all(
                          color: isSlotSelected
                              ? accentColor
                              : isCardSelected
                              ? ColorsManager.inputBorder.withOpacity(0.3)
                              : Colors.transparent,
                          width: 1, // حد رفيع جداً
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(100.r),
                          onTap: () {
                            if (!isCardSelected) cubit.selectDoctor(doctor);
                            cubit.selectTimeSlot(slot);
                          },
                          child: Padding(
                            // Padding نحيف جداً وأنيق
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 6.h,
                            ),
                            // استخدام Row بدلاً من Column لتوفير الطول
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  slot.timeSlot,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: isSlotSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: isSlotSelected
                                        ? Colors.white
                                        : ColorsManager.defaultText,
                                    height: 1.2,
                                  ),
                                ),
                                // إظهار المتبقي بجانب الوقت بشكل احترافي وصغير
                                if (isCardSelected &&
                                    remaining < slot.maxBookings) ...[
                                  SizedBox(width: 6.w),
                                  // نقطة فاصلة صغيرة (Dot indicator)
                                  Container(
                                    width: 4.r,
                                    height: 4.r,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSlotSelected
                                          ? Colors.white70
                                          : (remaining <= 2
                                          ? ColorsManager.warningText
                                          : ColorsManager.inputBorder),
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    'clinic.remaining'.tr(
                                      namedArgs: {'count': '$remaining'},
                                    ),
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      fontSize: 10.sp, // خط صغير جداً
                                      color: isSlotSelected
                                          ? Colors.white.withOpacity(0.9)
                                          : remaining <= 2
                                          ? ColorsManager.warningText
                                          : ColorsManager.miscellaneous,
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
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