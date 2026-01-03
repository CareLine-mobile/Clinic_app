import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';

class BookingStepper extends StatelessWidget {
  const BookingStepper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        int currentStep = 0;
        if (state is BookingLoaded) {
          currentStep = state.currentStep;
        }

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStep(context, "1", "Date & Time", index: 0, currentStep: currentStep),
              _buildDivider(),
              _buildStep(context, "2", "Your Info", index: 1, currentStep: currentStep),
              _buildDivider(),
              _buildStep(context, "3", "Confirmation", index: 2, currentStep: currentStep),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStep(BuildContext context, String number, String label, {required int index, required int currentStep}) {
    bool isActive = index == currentStep;
    bool isCompleted = index < currentStep;

    Color circleColor = isActive ? ColorsManager.primaryColor : (isCompleted ? ColorsManager.successFill : Colors.grey[200]!);
    Color contentColor = isActive || isCompleted ? Colors.white : Colors.grey[500]!;
    Color labelColor = isActive ? ColorsManager.primaryColor : (isCompleted ? ColorsManager.successFill : Colors.grey[500]!);

    // If completed, show checkmark
    Widget iconOrNumber = isCompleted
        ? const Icon(Icons.check, color: Colors.white, size: 16)
        : Text(
            number,
            style: TextStyle(
              color: contentColor,
              fontWeight: FontWeight.bold,
            ),
          );

    if (isActive) {
       circleColor = ColorsManager.primaryColor;
       contentColor = Colors.white;
    } else if (isCompleted) {
        circleColor = ColorsManager.successFill; // Or generic success color
        contentColor = Colors.white;
    }


    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: circleColor,
          ),
          child: Center(
            child: iconOrNumber,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return const Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Divider(color: Colors.grey, thickness: 1),
      ),
    );
  }
}
