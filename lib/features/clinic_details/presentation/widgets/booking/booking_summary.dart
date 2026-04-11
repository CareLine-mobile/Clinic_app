import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/widgets/app_buton.dart';

class BookingSummary extends StatelessWidget {
  final VoidCallback onContinue;

  const BookingSummary({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: ColorsManager.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'booking.bottom_bar.fee_label'.tr(),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const Text(
                "\$50",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: ColorsManager.primaryColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppButton(
          text: 'booking.continue'.tr(),
          onPressed: onContinue,
          horizontalPadding: 0,
        ),
      ],
    );
  }
}
