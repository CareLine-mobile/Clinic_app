import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../cubit/booking_cubit.dart';
import '../widgets/booking_summary.dart';
import '../widgets/date_timeline.dart';
import '../widgets/time_slot_grid.dart';

class BookingDateTimePage extends StatelessWidget {
  const BookingDateTimePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select Date & Time",
            style: TextStyle(
              fontSize: 16,
              color: ColorsManager.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          const DateTimeline(),
          const SizedBox(height: 24),
          const TimeSlotGrid(),
          const SizedBox(height: 32),
          BookingSummary(
            onContinue: () {
              context.read<BookingCubit>().nextStep();
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
