import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/colors.dart';
import '../cubit/booking_flow_cubit.dart';

class BookingStepperWidget extends StatelessWidget {
  const BookingStepperWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingFlowCubit, BookingFlowState>(
      buildWhen: (prev, curr) => prev.currentStep != curr.currentStep,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStep("1", "Date & Time", index: 0, currentStep: state.currentStep),
              _buildDivider(),
              _buildStep("2", "Your Info", index: 1, currentStep: state.currentStep),
              _buildDivider(),
              _buildStep("3", "Confirmation", index: 2, currentStep: state.currentStep),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStep(String number, String label, {required int index, required int currentStep}) {
    final isActive = index == currentStep;
    final isCompleted = index < currentStep;

    final circleColor = isActive
        ? ColorsManager.primaryColor
        : isCompleted
        ? ColorsManager.successFill
        : Colors.grey[200]!;

    final labelColor = isActive
        ? ColorsManager.primaryColor
        : isCompleted
        ? ColorsManager.successFill
        : Colors.grey[500]!;

    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(shape: BoxShape.circle, color: circleColor),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text(
              number,
              style: TextStyle(
                color: isActive || isCompleted ? Colors.white : Colors.grey[500],
                fontWeight: FontWeight.bold,
              ),
            ),
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

  Widget _buildDivider() => const Expanded(
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Divider(color: Colors.grey, thickness: 1),
    ),
  );
}