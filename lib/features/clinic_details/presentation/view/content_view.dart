// lib/features/clinic_details/presentation/pages/content_view.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entites/clinic_entities.dart';
import '../cubit/clinic_details_cubit.dart';
import '../widgets/components/booking_bottom_bar.dart';
import '../widgets/components/clinic_app_bar.dart';
import '../widgets/sections/clinic_name_header.dart' show ClinicNameHeader;
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
        final loaded = state is ClinicDetailsLoaded ? state : null;
       // print('dfdfdfdfd ${clinic.isFavorite}');
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: ClinicAppBar(
            clinic: clinic,
            isTransparent: loaded?.isAppBarTransparent ?? true,
          isFavorite: clinic.isFavorite,

            onFavoriteToggle: () =>
                context.read<ClinicDetailsCubit>().toggleFavorite(),
          ),
          body: NestedScrollView(
            controller: scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              // 1 — Image gallery (full bleed, behind appbar)
              ImageGallerySection(clinic: clinic),

              // 2 — Clinic name header ← new
              ClinicNameHeader(clinic: clinic),

              // 3 — Statistics row
              StatisticsSection(clinic: clinic),

              // 4 — Tab bar
              TabBarSection(clinic: clinic, tabController: tabController),
            ],
            body: TabBarViewSection(
              clinic: clinic,
              tabController: tabController,
            ),
          ),
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
