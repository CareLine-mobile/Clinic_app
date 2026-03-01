import 'package:clinic_app/core/widgets/app_buton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../cubit/booking_flow_cubit.dart';

class BookingConfirmationPage extends StatelessWidget {
  const BookingConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingFlowCubit, BookingFlowState>(
      listenWhen: (prev, curr) => prev.isSuccess != curr.isSuccess,
      listener: (context, state) {
        if (state.isSuccess) {
          _showSuccessDialog(context);
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // ── Icon ──────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.priority_high_rounded, color: Colors.orange, size: 32),
              ),
              const SizedBox(height: 24),

              const Text(
                "Confirm Your Booking",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Please review your booking details before confirming.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // ── Summary Card ──────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    _buildRow("Clinic", state.clinicName),
                    const Divider(height: 24),
                    _buildRow("Doctor", state.doctorName),
                    const Divider(height: 24),
                    _buildRow("Patient", state.patientName ?? "—"),
                    const Divider(height: 24),
                    _buildRow("Phone", state.patientPhone ?? "—"),
                    const Divider(height: 24),
                    _buildRow(
                      "Date",
                      DateFormat('EEE, MMM d yyyy').format(state.selectedDate),
                    ),
                    const Divider(height: 24),
                    _buildRow("Time", state.selectedTime ?? "—"),
                    if (state.notes != null && state.notes!.isNotEmpty) ...[
                      const Divider(height: 24),
                      _buildRow("Notes", state.notes!),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "The clinic will contact you for payment instructions once approved.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 32),

              // ── Confirm Button ────────────────────────────────────
              state.isSubmitting
                  ? const LoadingSpinner()
                  : AppButton(
                text: "Confirm Booking",
                onPressed: () => context.read<BookingFlowCubit>().confirmBooking(),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_outline, color: Colors.green, size: 40),
            ),
            const SizedBox(height: 16),
            const Text(
              "Booking Confirmed!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Your appointment has been booked successfully.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context)
                ..pop() // close dialog
                ..pop(); // go back to clinic screen
            },
            child: const Text("Done"),
          ),
        ],
      ),
    );
  }
}