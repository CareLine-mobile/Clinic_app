// ══════════════════════════════════════════════════════════════════════════════
// booking_tab.dart  —  fully rebuilt
// ══════════════════════════════════════════════════════════════════════════════
//  ✅ Single BlocBuilder at the top — no nested builders
//  ✅ DoctorCard widget reused (has its own inner BlocBuilder for time slots)
//  ✅ AuthGuard lives in BookingBottomBar._openBookingScreen (already done)
//  ✅ All strings via easy_localization keys from ar.json
// ══════════════════════════════════════════════════════════════════════════════

import 'package:clinic_app/features/clinic_details/presentation/widgets/components/booking_bottom_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/utils/app_size.dart';
import '../../../domain/entites/clinic_entities.dart';
import '../../../domain/entites/doctor_entity.dart';
import '../../cubit/clinic_details_cubit.dart';
import '../../widgets/clinic_calendar_widget.dart';
import '../../widgets/doctor_card.dart';

class BookingTab extends StatelessWidget {
  final ClinicEntity clinic;

  const BookingTab({Key? key, required this.clinic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClinicDetailsCubit, ClinicDetailsState>(
      builder: (context, state) {
        if (state is! ClinicDetailsLoaded) return const SizedBox.shrink();

        return Stack(
          children: [
            // ── Scrollable content ──────────────────────────
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                AppSizeHorizontal.instance.s20,
                AppSizeVertical.instance.s16,
                AppSizeHorizontal.instance.s20,
                // Extra bottom padding so content isn't hidden behind bottom bar
                state.selectedDoctor != null && state.selectedTime != null
                    ? 100.h
                    : AppSizeVertical.instance.s40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Calendar
                  ClinicCalendarWidget(
                    selectedDate: state.selectedDate,
                    onDateSelected:
                    context.read<ClinicDetailsCubit>().selectDate,
                    accentColor: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: AppSizeVertical.instance.s24),

                  // Doctor list
                  _DoctorSection(
                    doctors: clinic.doctors,
                    state: state,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─── Doctor Section ───────────────────────────────────────────────────────────

class _DoctorSection extends StatelessWidget {
  final List<DoctorEntity> doctors;
  final ClinicDetailsLoaded state;

  const _DoctorSection({
    required this.doctors,
    required this.state,
  });

  String _dayName(int weekday) {
    const days = {
      1: 'monday',
      2: 'tuesday',
      3: 'wednesday',
      4: 'thursday',
      5: 'friday',
      6: 'saturday',
      7: 'sunday',
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
        // ── Section title ───────────────────────────────────
        Text(
          'clinic.available_doctors'
              .tr(namedArgs: {'count': '${availableDoctors.length}'}),
          style: theme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),

        // ── Empty state ─────────────────────────────────────
        if (availableDoctors.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32.h),
              child: Column(
                children: [
                  Icon(Icons.event_busy,
                      size: 64.r, color: theme.hintColor),
                  SizedBox(height: 16.h),
                  Text(
                    'clinic.no_doctors'.tr(),
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: theme.hintColor),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
        // ── Doctor cards ────────────────────────────────────
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: availableDoctors.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final doctor = availableDoctors[index];
              final isSelected = state.selectedDoctor?.id == doctor.id;

              // ✅ Reuse the DoctorCard widget you already have
              return DoctorCard(
                doctor: doctor,
                selectedDate: state.selectedDate,
                isSelected: isSelected,
                onTap: () =>
                    context.read<ClinicDetailsCubit>().selectDoctor(doctor),
                accentColor: Theme.of(context).primaryColor,
              );
            },
          ),
      ],
    );
  }
}