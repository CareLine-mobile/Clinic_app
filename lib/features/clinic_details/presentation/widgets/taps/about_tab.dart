// ==================== tabs/about_tab.dart ====================
import 'package:flutter/material.dart';
import '../../../domain/entites/clinic_entities.dart';
import '../../widgets/taps/clinic_info_tab_widget.dart';

class AboutTab extends StatelessWidget {
  final ClinicEntity clinic;

  const AboutTab({
    Key? key,
    required this.clinic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClinicInfoTabWidget(
      description: clinic.description,
      location: clinic.location,
      fullAddress: clinic.fullAddress,
      openingHours: clinic.openingHours,
      contactInfo: clinic.contactInfo,
      accentColor: Theme.of(context).primaryColor,
    );
  }
}