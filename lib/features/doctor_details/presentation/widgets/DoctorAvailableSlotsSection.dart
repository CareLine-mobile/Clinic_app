import 'package:clinic_app/core/theme/colors.dart';
import 'package:clinic_app/core/widgets/Loading_widget.dart';
import 'package:clinic_app/core/widgets/custom_snack_bar.dart';
import 'package:clinic_app/core/widgets/empty_state_widget.dart';
import 'package:clinic_app/features/clinic_details/domain/entites/time_slot_entity.dart';
import 'package:clinic_app/features/clinic_details/presentation/widgets/review_card.dart';
import 'package:clinic_app/features/doctor_details/domain/entities/doctor_profile_entity.dart';
import 'package:clinic_app/features/doctor_details/presentation/cubit/doctor_profile_cubit.dart';
import 'package:clinic_app/features/doctor_details/presentation/widgets/doctor_rating_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/app_text_widgets.dart';
import '../view/doctor_profile_screen.dart';
import '../widgets/Info_tile.dart';
class DoctorAvailableSlotsSection extends StatelessWidget {
  final DoctorProfileEntity doctor;

  const DoctorAvailableSlotsSection({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (doctor.availableSlots.isEmpty) return const SizedBox.shrink();

    // Group slots by day
    final Map<String, List<TimeSlotEntity>> slotsByDay = {};
    for (final slot in doctor.availableSlots) {
      final day = capitalizeWord(slot.day);
      slotsByDay.putIfAbsent(day, () => []).add(slot);
    }

    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
              'doctorProfile.availableSlots'.tr(),
              icon: Icons.access_time_rounded),
          SizedBox(height: 12.h),
          ...slotsByDay.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 8.h, top: 4.h),
                  child: Text(
                    entry.key,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: ColorsManager.primaryColor,
                    ),
                  ),
                ),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: entry.value.map((slot) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 14.w, vertical: 7.h),
                      decoration: BoxDecoration(
                        color: slot.isAvailable
                            ? ColorsManager.primaryColor.withOpacity(0.08)
                            : ColorsManager.backgroundSurface,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: slot.isAvailable
                              ? ColorsManager.primaryColor.withOpacity(0.3)
                              : theme.dividerColor,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            slot.isAvailable
                                ? Icons.check_circle_rounded
                                : Icons.cancel_rounded,
                            size: 12.sp,
                            color: slot.isAvailable
                                ? ColorsManager.primaryColor
                                : theme.hintColor,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            slot.timeSlot,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: slot.isAvailable
                                  ? ColorsManager.primaryColor
                                  : theme.hintColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 12.h),
              ],
            );
          }),
        ],
      ),
    );
  }
}
