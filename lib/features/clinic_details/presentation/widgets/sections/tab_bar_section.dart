// ==================== sections/tab_bar_section.dart ====================
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entites/clinic_entities.dart';
import '../../cubit/clinic_ui_cubit.dart';
import '../tab_bar_delegate.dart';


class TabBarSection extends StatelessWidget {
  final ClinicDetails clinic;
  final TabController tabController;

  const TabBarSection({
    Key? key,
    required this.clinic,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: TabBarDelegate(
        tabBar: _buildTabBar(context),
      ),
    );
  }

  TabBar _buildTabBar(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.primaryColor;

    return TabBar(
      controller: tabController,
      isScrollable: true,
      labelColor: accentColor,
      unselectedLabelColor: theme.hintColor,
      indicatorColor: accentColor,
      labelStyle: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      onTap: (index) {
        context.read<ClinicUiCubit>().changeTab(index);
      },
      tabs: const [
        Tab(text: 'الحجز'),
        Tab(text: 'الخدمات'),
        Tab(text: 'التقييمات'),
        Tab(text: 'عن العيادة'),
      ],
    );
  }
}