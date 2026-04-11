// ══════════════════════════════════════════════════════════
// booking_confirmation_page.dart
// ══════════════════════════════════════════════════════════
import 'package:clinic_app/core/widgets/app_buton.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../cubit/clinic_details_cubit.dart';

class BookingConfirmationPage extends StatelessWidget {
  const BookingConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ClinicDetailsCubit, ClinicDetailsState>(
      listenWhen: (_, curr) => curr is BookingSuccess,
      listener: (context, state) {
        if (state is BookingSuccess) _showSuccessDialog(context);
      },
      builder: (context, state) {
        // Guard
        if (state is! ClinicDetailsLoaded && state is! BookingLoading) {
          return const SizedBox.shrink();
        }

        final isSubmitting = state is BookingLoading;

        // Grab the last loaded snapshot for display (BookingLoading doesn't carry data)
        final loaded = state is ClinicDetailsLoaded
            ? state
            : (context.read<ClinicDetailsCubit>().state is ClinicDetailsLoaded
            ? context.read<ClinicDetailsCubit>().state as ClinicDetailsLoaded
            : null);

        if (loaded == null) return const SizedBox.shrink();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.priority_high_rounded,
                    color: Colors.orange, size: 32),
              ),
              const SizedBox(height: 24),

               Text(
                'booking.confirm_title'.tr(),
                style:const  TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ColorsManager.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
               Text(
                 'booking.confirm_subtitle'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // ── Summary — reads from STATE ──────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    _buildRow('booking.summary.clinic'.tr(), loaded.clinic.name),
                    const Divider(height: 24),
                    _buildRow('booking.summary.doctor'.tr(), loaded.selectedDoctor?.name ?? "—"),
                    const Divider(height: 24),
                    _buildRow('booking.summary.patient'.tr(), loaded.patientName ?? "—"),
                    const Divider(height: 24),
                    _buildRow('booking.summary.phone'.tr(), loaded.patientPhone ?? "—"),
                    const Divider(height: 24),
                    _buildRow(
                      'booking.summary.date'.tr(),
                      DateFormat('EEE, MMM d yyyy').format(loaded.selectedDate),
                    ),
                    const Divider(height: 24),
                    _buildRow('booking.summary.time'.tr(), loaded.selectedTime ?? "—"),
                    if (loaded.bookingNotes?.isNotEmpty == true) ...[
                      const Divider(height: 24),
                      _buildRow('booking.summary.notes'.tr(), loaded.bookingNotes!),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 20),
               Text(
                'booking.payment_note'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 32),

              isSubmitting
                  ? const LoadingSpinner()
                  : AppButton(
                text: 'booking.confirm_button'.tr(),
                onPressed: () =>
                    context.read<ClinicDetailsCubit>().confirmBooking(),
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
        Text(label,
            style: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.w500)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black87),
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
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_outline,
                  color: Colors.green, size: 40),
            ),
            const SizedBox(height: 16),
             Text(
              'booking.confirmed_title'.tr(),
              style:
              TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
             Text(
              'booking.confirmed_body'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context)
              ..pop()
              ..pop(),
            child: Text('booking.confirmed_done'.tr()),
          ),
        ],
      ),
    );
  }
}