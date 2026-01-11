// ==================== components/booking_bottom_bar.dart ====================
import 'package:clinic_app/features/clinic_details/presentation/widgets/components/price_section.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/app_size.dart';
import '../../../domain/entites/clinic_entities.dart';
import 'book_button.dart';

class BookingBottomBar extends StatelessWidget {
  final ClinicDetails clinic;
  final Doctor doctor;

  const BookingBottomBar({
    Key? key,
    required this.clinic,
    required this.doctor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hSize = AppSizeHorizontal.instance;

    return Container(
      padding: EdgeInsets.all(hSize.s20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: PriceSection(
                doctor: doctor,
                accentColor: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(width: hSize.s16),
            Expanded(
              flex: 2,
              child: BookButton(
                doctor: doctor,
                accentColor: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}