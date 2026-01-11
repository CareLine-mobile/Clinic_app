// ==================== components/price_section.dart ====================
import 'package:flutter/material.dart';

import '../../../domain/entites/clinic_entities.dart';


class PriceSection extends StatelessWidget {
  final Doctor doctor;
  final Color accentColor;

  const PriceSection({
    Key? key,
    required this.doctor,
    required this.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'سعر الكشف',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          '${doctor.consultationFee.toInt()} ج.م',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: accentColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}