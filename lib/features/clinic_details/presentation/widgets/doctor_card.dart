// ══════════════════════════════════════════════════════════════════════════════
// doctor_card.dart  —  fixed
// ══════════════════════════════════════════════════════════════════════════════
//  ✅ All hardcoded Arabic strings replaced with easy_localization keys
//  ✅ _TimeSlotRow has its own BlocBuilder only for the time selection part
// ══════════════════════════════════════════════════════════════════════════════

import 'package:clinic_app/core/routes/routes.dart';
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
    final cardBackGroundColor = Theme.of(context).cardColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withOpacity(0.04) : Colors.transparent,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? accentColor.withOpacity(0.5) : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Doctor info row ──────────────────────────────
            Row(
              children: [
                // ── Tappable Avatar with gradient ring ───────
                GestureDetector(
                  onTap: () {
                    final id = int.tryParse(doctor.id);
                    if (id != null) {
                      Navigator.pushNamed(
                        context,
                        Routes.doctorProfile,
                        arguments: id,
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(2.5.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          accentColor,
                          accentColor.withOpacity(0.4),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(2.r),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: CircleAvatar(
                        radius: 26.r,
                        backgroundColor: Colors.grey.shade100,
                        backgroundImage: NetworkImage(doctor.imageUrl),
                        onBackgroundImageError: (_, __) {},
                        child: doctor.imageUrl.isEmpty
                            ? Icon(Icons.person, color: Colors.grey.shade400, size: 24.sp)
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // ── Name + Specialty ─────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        doctor.specialty,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      SizedBox(height: 4.h),
                      GestureDetector(
                        onTap: () {
                          final id = int.tryParse(doctor.id);
                          if (id != null) {
                            Navigator.pushNamed(
                              context,
                              Routes.doctorProfile,
                              arguments: id,
                            );
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'view_profile'.tr(),
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: accentColor,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 10.sp,
                              color: accentColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Price pill ────────────────────────────────
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '${doctor.consultationFee.toInt()} ${'clinic.currency'.tr()}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            // ── Stats row (rating + experience) ──────────────
            Padding(
              padding: EdgeInsetsDirectional.only(start: 68.w),
              child: Wrap(
                spacing: 14.w,
                runSpacing: 4.h,
                children: [
                  _StatChip(
                    icon: Icons.star_rounded,
                    iconColor: Colors.amber,
                    label: doctor.rating.toStringAsFixed(1),
                    context: context,
                  ),
                  _StatChip(
                    icon: Icons.work_outline_rounded,
                    iconColor: Colors.grey.shade400,
                    label: 'clinic.years_exp'.tr(namedArgs: {
                      'count': '${doctor.experienceYears}',
                    }),
                    context: context,
                  ),
                ],
              ),
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
                //  color: ColorsManager.defaultTextSecondary,
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
                            /// استخدام Row بدلاً من Column لتوفير الطول
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ///
                                Text(
                                  slot.timeSlot,
                                  style: theme.textTheme.bodySmall!.copyWith(
                                    fontWeight: isSlotSelected?FontWeight.w600:FontWeight.w500,
                                    color: isSlotSelected?Colors.white:ColorsManager.primaryColor,
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
                                    // style: theme.textTheme.labelSmall?.copyWith(
                                    //   fontSize: 10.sp, // خط صغير جداً
                                    //   // color: isSlotSelected
                                    //   //     ? Colors.white.withOpacity(0.9)
                                    //   //     : remaining <= 2
                                    //   //     ? ColorsManager.warningText
                                    //   //     : ColorsManager.miscellaneous,
                                    //
                                    //   height: 1.2,
                                    // ),
                                    style: theme.textTheme.bodySmall!.copyWith(
                                      fontSize: 10.sp,
                                      height: 1.2,
                                      fontWeight: isSlotSelected?FontWeight.w600:FontWeight.w500,
                                      color: isSlotSelected?Colors.white:ColorsManager.primaryColor,
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

// ─── Stat Chip (rating / experience) ──────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final BuildContext context;

  const _StatChip({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.context,
  });

  @override
  Widget build(BuildContext _) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14.sp, color: iconColor),
        SizedBox(width: 4.w),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}