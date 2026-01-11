// ==================== sections/statistics_section.dart ====================
import 'package:flutter/material.dart';
import '../../../domain/entites/clinic_entities.dart';
import '../../widgets/clinic_statistics_widget.dart';

class StatisticsSection extends StatelessWidget {
  final ClinicDetails clinic;

  const StatisticsSection({
    Key? key,
    required this.clinic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: ClinicStatisticsWidget(
        statistics: clinic.statistics,
        accentColor: Theme.of(context).primaryColor,
      ),
    );
  }
}