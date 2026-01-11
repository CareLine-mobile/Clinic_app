// ==================== sections/tab_bar_view_section.dart ====================
import 'package:flutter/material.dart';
import '../../../domain/entites/clinic_entities.dart';
import '../taps/about_tab.dart';
import '../taps/booking_tab.dart';
import '../taps/reviews_tab.dart';
import '../taps/services_tab.dart';


class TabBarViewSection extends StatelessWidget {
  final ClinicDetails clinic;
  final TabController tabController;

  const TabBarViewSection({
    Key? key,
    required this.clinic,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        BookingTab(clinic: clinic),
        ServicesTab(clinic: clinic),
        ReviewsTab(clinic: clinic),
        AboutTab(clinic: clinic),
      ],
    );
  }
}