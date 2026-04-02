import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/routes/routes.dart';
import '../../../../../core/utils/enums.dart';
import '../../../../../core/widgets/card/clinic_card.dart';
import '../../../../home/domain/entities/clinic_summary.dart';
import '../../cubit/search_cubit.dart';
import 'filter_bar.dart';

class SearchResultsView extends StatelessWidget {
  final List<ClinicSummary> clinics;
  final SearchLoaded loadedState;    // ← pass full state for filter access
  const SearchResultsView({required this.clinics, required this.loadedState});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilterBar(state: loadedState),   // ← active-filter chips row
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemCount: clinics.length,
            itemBuilder: (context, index) {
              final clinic = clinics[index];
              return ClinicCard(
                key: ValueKey(clinic.id),
                clinic: clinic,
                layout: ClinicCardLayout.list,
                onTap: () => Navigator.pushNamed(
                  context, Routes.clinicDetails, arguments: clinic.id,
                ),
                onFavoriteToggle:()=> context.read<SearchCubit>().toggleFavorite(clinic.id),
              );
            },
          ),
        ),
      ],
    );
  }
}