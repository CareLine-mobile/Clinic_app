import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';

class TimeSlotGrid extends StatelessWidget {
  const TimeSlotGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.access_time, color: ColorsManager.primaryColor),
            const SizedBox(width: 8),
            Text(
              "Choose Time",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        BlocBuilder<BookingCubit, BookingState>(
          builder: (context, state) {
            if (state is BookingLoaded) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: state.timeSlots.length,
                itemBuilder: (context, index) {
                  final slot = state.timeSlots[index];
                  final isSelected = state.selectedTime == slot.time;
                  final isAvailable = slot.isAvailable;

                  return GestureDetector(
                    onTap: isAvailable
                        ? () {
                            context.read<BookingCubit>().selectTime(slot.time);
                          }
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
                          slot.time,
                          style: TextStyle(
                            color: isSelected
                                ? ColorsManager.primaryColor
                                : isAvailable
                                    ? Colors.black87
                                    : Colors.grey.shade400,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
          },
        ),
      ],
    );
  }
}
