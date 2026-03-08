// ==================== views/content_view.dart ====================
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entites/clinic_entities.dart';
import '../cubit/clinic_details_cubit.dart';
import '../cubit/clinic_ui_cubit.dart';
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
      builder: (context, uiState) {
        final clinicCubit = context.read<ClinicDetailsCubit>();


        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: ClinicAppBar(
            clinic: clinic,
            isTransparent: clinicCubit.isAppBarTransparent,
            isFavorite: clinic.isOpen,
            onFavoriteToggle: () {

            },
          ),
          body: NestedScrollView(
            controller: scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              ImageGallerySection(clinic: clinic),
              StatisticsSection(clinic: clinic),
              TabBarSection(
                clinic: clinic,
                tabController: tabController,
              ),
            ],
            body: TabBarViewSection(
              clinic: clinic,
              tabController: tabController,
            ),
          ),
          bottomNavigationBar: clinicCubit.selectedDoctor != null
              ? BookingBottomBar(
            clinic: clinic,
            doctor: clinicCubit.selectedDoctor!,
          )
              : null,
        );
      },
    );
  }
}