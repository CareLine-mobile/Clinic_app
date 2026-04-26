import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/widgets/app_buton.dart';
import '../../cubit/clinic_details_cubit.dart';

class BookingDateTimePage extends StatelessWidget {
  const BookingDateTimePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClinicDetailsCubit, ClinicDetailsState>(
      builder: (context, state) {
        // Guard: only render when loaded
        if (state is! ClinicDetailsLoaded) return const SizedBox.shrink();

        final cubit = context.read<ClinicDetailsCubit>();

        // Available dates: 14 days from today
        final availableDates = List.generate(
          14,
              (i) => DateTime.now().add(Duration(days: i)),
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Date picker ─────────────────────────────────
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined,
                      color: ColorsManager.primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    'booking.choose_date'.tr(),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              SizedBox(
                height: 60,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: availableDates.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final date = availableDates[index];
                    final isSelected = _isSameDay(date, state.selectedDate);

                    return GestureDetector(
                      onTap: () => cubit.selectDateInBookingFlow(date),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ColorsManager.primaryColor.withOpacity(0.1)
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? ColorsManager.primaryColor
                                : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            DateFormat('EEE, MMM d', Localizations.localeOf(context).languageCode)
                                .format(date),
                            style: TextStyle(
                              color: isSelected
                                  ? ColorsManager.primaryColor
                                  : Theme.of(context).hintColor,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // ── Time slots ──────────────────────────────────
              Row(
                children: [
                  const Icon(Icons.access_time,
                      color: ColorsManager.primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    'booking.choose_time'.tr(),
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // slotsForSelectedDay is a computed getter on the STATE
              state.slotsForSelectedDay.isEmpty
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    'booking.no_slots'.tr(),
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ),
              )
                  : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: state.slotsForSelectedDay.length,
                itemBuilder: (context, index) {
                  final slot = state.slotsForSelectedDay[index];

                  // Compare against state.selectedTime — not cubit getter
                  final isSelected =
                      state.selectedTime == slot.timeSlot &&
                          state.selectedTimeFrom == slot.timeFrom;

                  return GestureDetector(
                    onTap: slot.isAvailable
                        ? () => cubit.selectTimeSlot(slot)
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? ColorsManager.primaryColor.withOpacity(0.1)
                            : slot.isAvailable
                            ? Colors.white
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? ColorsManager.primaryColor
                              : slot.isAvailable
                              ? Colors.grey.shade300
                              : Colors.transparent,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          slot.timeSlot,
                          style: TextStyle(
                            color: isSelected
                                ? ColorsManager.primaryColor
                                : slot.isAvailable
                                ? Colors.black87
                                : Colors.grey.shade400,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // ── Continue button ─────────────────────────────
              AppButton(
                text: 'booking.continue'.tr(),
                textColor: Colors.white,
                // canProceedStep1 is a computed getter on the STATE
                onPressed: state.canProceedStep1
                    ? () => cubit.nextBookingStep()
                    : null,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}