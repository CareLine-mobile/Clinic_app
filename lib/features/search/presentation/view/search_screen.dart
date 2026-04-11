// lib/features/search/presentation/pages/search_screen.dart

import 'package:clinic_app/core/widgets/card/clinic_card.dart';
import 'package:clinic_app/features/home/domain/entities/clinic_summary.dart';
import 'package:clinic_app/features/search/presentation/view/widget/search_error_view.dart';
import 'package:clinic_app/features/search/presentation/view/widget/search_laoding_widget.dart';
import 'package:clinic_app/features/search/presentation/view/widget/search_result_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../../core/widgets/CustomIcon.dart';
import '../../../../../core/widgets/app_text_feild.dart';
import '../../../../../core/widgets/empty_state_widget.dart';
import '../../domain/model/search_filter.dart';
import '../cubit/search_cubit.dart';
import '../../../../../core/utils/enums.dart';
import '../../../../../core/routes/routes.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _SearchHeader(
              controller: _searchController,
              focusNode: _focusNode,
            ),
            const Expanded(child: _SearchBody()),
          ],
        ),
      ),
    );
  }
}



class _SearchHeader extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const _SearchHeader({
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 40.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, value, _) {
          return AppTextFieldFactory.search(
            controller: controller,
            focusNode: focusNode,
          //  autofocus: true,
            hintText: 'search.hint'.tr(),
            prefixIcon: Padding(
              padding: EdgeInsets.all(10.r),
              child: CustomIcon(
                assetPath: Assets.searchBarIcon,
                size: 20.sp,
                color: value.text.isEmpty
                    ? Theme.of(context).hintColor
                    : ColorsManager.primaryColor,
              ),
            ),
            suffixIcon: value.text.isNotEmpty
                ? IconButton(
              onPressed: () {
                controller.clear();
                context
                    .read<SearchCubit>()
                    .onSearchQueryChanged('');
              },
              icon: Icon(
                Icons.close_rounded,
                size: 18.sp,
                color: Theme.of(context).hintColor,
              ),
            )
                : null,
            onChanged: (q) =>
                context.read<SearchCubit>().onSearchQueryChanged(q),
            fillColor: theme.cardColor,
            focusedFillColor: theme.cardColor,
            borderRadius: 14,
          );
        },
      ),
    );
  }
}



class _SearchBody extends StatelessWidget {
  const _SearchBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) => switch (state) {
        SearchInitial() => const _SearchInitialView(),
        SearchLoading() => const SearchLoadingView(),
       // SearchLoaded(:final clinics) => _SearchResultsView(clinics: clinics, loadedState: null,),
        SearchLoaded(:final allClinics, :final filteredClinics) =>
        filteredClinics.isEmpty
            ? const _SearchEmptyView()    // filtered to zero
            : SearchResultsView(
          clinics: filteredClinics,   // ← render filtered
          loadedState: state,         // ← pass for filter bar
        ),
        SearchEmpty() => const _SearchEmptyView(),
        SearchError(:final message) => SearchErrorView(message: message),
        _ => const SizedBox.shrink(),
      },
    );
  }
}
class _SearchInitialView extends StatelessWidget {
  const _SearchInitialView();

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.search_rounded,
      title: 'search.initial_title'.tr(),
      subtitle: 'search.initial_hint'.tr(),
      enableBackButton: false,   // ← no back button
    );
  }
}
class _SearchEmptyView extends StatelessWidget {
  const _SearchEmptyView();

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.search_off_rounded,
      title: 'search.empty_title'.tr(),
      subtitle: 'search.no_results'.tr(),
      enableBackButton: false,   // ← no back button
    );
  }
}



