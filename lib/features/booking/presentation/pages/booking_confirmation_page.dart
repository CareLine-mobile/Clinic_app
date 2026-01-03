import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/app_buton.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';

class BookingConfirmationPage extends StatelessWidget {
  const BookingConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.priority_high_rounded,
              color: Colors.orange,
              size: 32,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Booking Pending Approval",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorsManager.primaryColor, // Or Teal as per image
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Your booking request is under review. You will be notified shortly.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          
          BlocBuilder<BookingCubit, BookingState>(
            builder: (context, state) {
              if (state is BookingLoaded) {
                 final dateStr = DateFormat('EEE, MMM d').format(state.selectedDate);
                 final timeStr = state.selectedTime ?? "";
                 final fullDateTime = "$dateStr at $timeStr";

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  decoration: BoxDecoration(
                    color: ColorsManager.backgroundSurface, // Light grey
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                       _buildRow("Patient:", state.patientName ?? "N/A"),
                       const SizedBox(height: 12),
                       _buildRow("Phone:", state.patientPhone ?? "N/A"),
                       const SizedBox(height: 12),
                       _buildRow("Date & Time:", fullDateTime),
                    ],
                  ),
                );
              }
               return const SizedBox.shrink();
            },
          ),
          
          const SizedBox(height: 20),
          const Text(
            "The clinic will contact you for payment instructions once approved.",
             textAlign: TextAlign.center,
             style: TextStyle(color: Colors.grey, fontSize: 12),
          ),

          const SizedBox(height: 32),
          
           AppButton(
            text: "Back to Home",
            onPressed: () {
              Navigator.of(context).pop(); 
            },
            // style: ElevatedButton.styleFrom(
            //   backgroundColor: Colors.grey[300], // Grey color as per image?
            //   foregroundColor: Colors.black,
            //   elevation: 0,
            // ),
             // Using default AppButton for now, but maybe should be grey
           ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    );
  }
}
