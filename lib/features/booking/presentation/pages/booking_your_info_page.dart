import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/colors.dart';

import '../../../../core/widgets/app_buton.dart';
import '../../../../core/widgets/app_text_feild.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';

class BookingYourInfoPage extends StatelessWidget {
   BookingYourInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Note: In a real app, use a Form and TextEditingControllers managed by the Cubit or internally.
    // For this UI implementation, we'll setup the UI structure.

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Patient Information",
            style: TextStyle(
              fontSize: 16,
              color: ColorsManager.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          AppTextField(
            hintText: "Enter your full name",
            title: "Full Name *",
          ),
          const SizedBox(height: 16),
          AppTextField(
            hintText: "Enter your phone number",
            title: "Phone Number *",
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),



          // AppTextField.textArea(
          //   hintText: "Briefly describe your symptoms or reason for visit",
          //   title: "Reason for Visit (Optional)",
          //   maxLines: 4,
          // ),
          const SizedBox(height: 32),
          // Booking Summary Section (simplified for this step as per image)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorsManager.backgroundSurface, // Light grey/blue background
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Booking Summary",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                _buildSummaryRow("Clinic:", "City Medical Center"),
                const SizedBox(height: 8),
                _buildSummaryRow("Doctor:", "Dr. Sarah Johnson"), // Hardcoded for now
                const SizedBox(height: 8),
                 BlocBuilder<BookingCubit, BookingState>(
                  builder: (context, state) {
                    if (state is BookingLoaded) {
                       return Column(children: [
                           _buildSummaryRow("Date:", DateFormat('EEE, MMM d').format(state.selectedDate)),
                           const SizedBox(height: 8),
                           _buildSummaryRow("Time:", state.selectedTime ?? "Not Selected"),
                       ]);
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Consultation Fee:", style: TextStyle(fontWeight: FontWeight.w500)),
                    Text("\$50", style: TextStyle(color: ColorsManager.primaryColor, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          AppButton(
            text: "Confirm Booking",
            onPressed: () {
               context.read<BookingCubit>().nextStep();
            },
            // disabledColor: Colors.grey, // If form invalid
            horizontalPadding: 0,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
