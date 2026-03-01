import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/app_buton.dart';
import '../cubit/booking_flow_cubit.dart';

class BookingDateTimePage extends StatelessWidget {
  const BookingDateTimePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingFlowCubit, BookingFlowState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Date ──────────────────────────────────────────────
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, color: ColorsManager.primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    "Choose Date",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 60,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.availableDates.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final date = state.availableDates[index];
                    final isSelected = _isSameDay(date, state.selectedDate);
                    return GestureDetector(
                      onTap: () => context.read<BookingFlowCubit>().selectDate(date),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? ColorsManager.primaryColor.withOpacity(0.1) : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? ColorsManager.primaryColor : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            DateFormat('EEE, MMM d').format(date),
                            style: TextStyle(
                              color: isSelected ? ColorsManager.primaryColor : Colors.black87,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // ── Time Slots ─────────────────────────────────────────
              Row(
                children: [
                  const Icon(Icons.access_time, color: ColorsManager.primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    "Choose Time",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              state.slotsForSelectedDay.isEmpty
                  ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Text(
                    "No available slots for this day",
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ),
              )
                  : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: state.slotsForSelectedDay.length,
                itemBuilder: (context, index) {
                  final slot = state.slotsForSelectedDay[index];
                  final isSelected = state.selectedTime == slot.timeSlot &&
                      state.selectedTimeFrom == slot.timeFrom;
                  final isAvailable = slot.isAvailable;

                  return GestureDetector(
                    onTap: isAvailable
                        ? () => context.read<BookingFlowCubit>().selectSlot(slot)
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? ColorsManager.primaryColor.withOpacity(0.1)
                            : isAvailable
                            ? Colors.white
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? ColorsManager.primaryColor
                              : isAvailable
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
                                : isAvailable
                                ? Colors.black87
                                : Colors.grey.shade400,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 32),

              // ── Continue Button ───────────────────────────────────
              AppButton(
                text: "Continue",
                onPressed: state.canProceedStep1
                    ? () => context.read<BookingFlowCubit>().nextStep()
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