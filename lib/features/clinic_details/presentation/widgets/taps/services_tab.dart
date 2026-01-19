// ==================== tabs/services_tab.dart ====================
import 'package:flutter/material.dart';
import '../../../domain/entites/clinic_entities.dart';
import '../../widgets/clinic_services_widget.dart';

class ServicesTab extends StatelessWidget {
  final ClinicEntity clinic;

  const ServicesTab({
    Key? key,
    required this.clinic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClinicServicesWidget(
      services: clinic.services,
      facilities: clinic.facilities,
      insuranceAccepted: clinic.insuranceAccepted,
    );
  }
}