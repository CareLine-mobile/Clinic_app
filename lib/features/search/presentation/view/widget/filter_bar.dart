import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/colors.dart';
import '../../../domain/model/search_filter.dart';
import '../../cubit/search_cubit.dart';

class FilterBar extends StatelessWidget {
  final SearchLoaded state;
  const FilterBar({required this.state});

  @override
  Widget build(BuildContext context) {
    final filter = state.filter;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          // ── Filter icon button ──
          _FilterIconButton(hasActiveFilter: filter.isActive),
          SizedBox(width: 8.w),

          // ── isOpen chip ──
          if (filter.isOpen != null)
            _ActiveChip(
              label: filter.isOpen! ? 'search.filter.open'.tr() : 'search.filter.closed'.tr(),
              onRemove: () => context.read<SearchCubit>().toggleIsOpen(null),
            ),

          // ── rating chip ──
          if (filter.minRating != null) ...[
            if (filter.isOpen != null) SizedBox(width: 6.w),
            _ActiveChip(
              label: '${'search.filter.rating'.tr()} ${filter.minRating!.toInt()}+',
              onRemove: () => context.read<SearchCubit>().setMinRating(null),
            ),
          ],

          // 🔮 Future: price chip here
        ],
      ),
    );
  }
}

class _FilterIconButton extends StatelessWidget {
  final bool hasActiveFilter;
  const _FilterIconButton({required this.hasActiveFilter});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFilterSheet(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: hasActiveFilter
              ? ColorsManager.primaryColor
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: hasActiveFilter
                ? ColorsManager.primaryColor
                : Theme.of(context).dividerColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.tune_rounded,
              size: 16.sp,
              color: hasActiveFilter ? Colors.white : Theme.of(context).hintColor,
            ),
            SizedBox(width: 4.w),
            Text(
              'search.filter.label'.tr(),
              style: TextStyle(
                fontSize: 12.sp,
                color: hasActiveFilter ? Colors.white : Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;
  const _ActiveChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: ColorsManager.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorsManager.primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: TextStyle(fontSize: 12.sp, color: ColorsManager.primaryColor)),
          SizedBox(width: 4.w),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close_rounded, size: 14.sp, color: ColorsManager.primaryColor),
          ),
        ],
      ),
    );
  }
}

// ─── Filter Bottom Sheet ──────────────────────────────────────────────────────

void _showFilterSheet(BuildContext context) {
  // Capture cubit BEFORE entering showModalBottomSheet
  final cubit = context.read<SearchCubit>();
  final currentState = cubit.state as SearchLoaded;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: _FilterSheet(initialState: currentState),
    ),
  );
}

class _FilterSheet extends StatefulWidget {
  final SearchLoaded initialState;
  const _FilterSheet({required this.initialState});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late SearchFilter _localFilter;

  @override
  void initState() {
    super.initState();
    _localFilter = widget.initialState.filter;   // local copy — apply on tap
  }

  @override
  Widget build(BuildContext context) {
    final availableRatings = widget.initialState.availableRatings;

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40.w, height: 4.h,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('search.filter.title'.tr(),
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => setState(() => _localFilter = const SearchFilter.empty()),
                child: Text('search.filter.clear_all'.tr(),
                    style: TextStyle(color: ColorsManager.primaryColor)),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // ── isOpen (local — always 2 values) ──────────────────────────
          Text('search.filter.availability'.tr(),
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.w,
            children: [
              _SheetChip(
                label: 'search.filter.all'.tr(),
                selected: _localFilter.isOpen == null,
                onTap: () => setState(() => _localFilter = _localFilter.copyWith(isOpen: null)),
              ),
              _SheetChip(
                label: 'search.filter.open'.tr(),
                selected: _localFilter.isOpen == true,
                onTap: () => setState(() => _localFilter = _localFilter.copyWith(isOpen: true)),
              ),
              _SheetChip(
                label: 'search.filter.closed'.tr(),
                selected: _localFilter.isOpen == false,
                onTap: () => setState(() => _localFilter = _localFilter.copyWith(isOpen: false)),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // ── Rating (dynamic from API data) ────────────────────────────
          if (availableRatings.isNotEmpty) ...[
            Text('search.filter.min_rating'.tr(),
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
            SizedBox(height: 10.h),
            Wrap(
              spacing: 8.w,
              children: [
                _SheetChip(
                  label: 'search.filter.all'.tr(),
                  selected: _localFilter.minRating == null,
                  onTap: () => setState(() => _localFilter = _localFilter.copyWith(minRating: null)),
                ),
                ...availableRatings.map((r) => _SheetChip(
                  label: '${r.toInt()}+ ⭐',
                  selected: _localFilter.minRating == r,
                  onTap: () => setState(() => _localFilter = _localFilter.copyWith(minRating: r)),
                )),
              ],
            ),
            SizedBox(height: 20.h),
          ],

          // 🔮 Future: Price section goes here

          // ── Apply button ──────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<SearchCubit>()
                  ..clearFilters()           // reset first
                  ..toggleIsOpen(_localFilter.isOpen)
                  ..setMinRating(_localFilter.minRating);
                // 🔮 Future: ..setPriceRange(_localFilter.priceRange)
                Navigator.pop(context);
              },
              child: Text('search.filter.apply'.tr()),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _SheetChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          color: selected ? ColorsManager.primaryColor : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: selected ? ColorsManager.primaryColor : Theme.of(context).dividerColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            color: selected ? Colors.white : Theme.of(context).hintColor,
          ),
        ),
      ),
    );
  }
}