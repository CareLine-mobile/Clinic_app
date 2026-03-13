import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entites/clinic_entities.dart';
import '../cubit/clinic_details_cubit.dart';
import '../widgets/components/booking_bottom_bar.dart';
import '../widgets/components/clinic_app_bar.dart';
import '../widgets/sections/image_gallery_section.dart';
import '../widgets/sections/statistics_section.dart';
import '../widgets/sections/tab_bar_section.dart';
import '../widgets/sections/tab_bar_view_section.dart';

class ContentView extends StatelessWidget {
  final ClinicEntity clinic;
  final ScrollController scrollController;
  final TabController tabController;

  const ContentView({
    Key? key,
    required this.clinic,
    required this.scrollController,
    required this.tabController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClinicDetailsCubit, ClinicDetailsState>(
      builder: (context, state) {
        // Read everything from state, not cubit getters
        final loaded = state is ClinicDetailsLoaded ? state : null;

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: ClinicAppBar(
            clinic: clinic,
            isTransparent: loaded?.isAppBarTransparent ?? true,
            isFavorite: clinic.isOpen,
            onFavoriteToggle: () =>
                context.read<ClinicDetailsCubit>().toggleFavorite(),
          ),
          body: NestedScrollView(
            controller: scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              ImageGallerySection(clinic: clinic),
              StatisticsSection(clinic: clinic),
              TabBarSection(clinic: clinic, tabController: tabController),
            ],
            body: TabBarViewSection(
              clinic: clinic,
              tabController: tabController,
            ),
          ),
          // Only show bottom bar when doctor AND time are both selected
          bottomNavigationBar: loaded?.selectedDoctor != null
              ? BookingBottomBar(
            clinic: clinic,
            doctor: loaded!.selectedDoctor!,
          )
              : null,
        );
      },
    );
  }
}