// lib/features/search/domain/models/search_filter.dart

import 'package:equatable/equatable.dart';

class SearchFilter extends Equatable {
  final bool? isOpen;           // null = show all, true = open only, false = closed only
  final double? minRating;      // null = no filter, e.g. 4.0 = show 4.0+
  // 🔮 Future: final RangeValues? priceRange;

  const SearchFilter({
    this.isOpen,
    this.minRating,
    // 🔮 Future: this.priceRange,
  });

  const SearchFilter.empty()
      : isOpen = null,
        minRating = null;

  bool get isActive => isOpen != null || minRating != null;
  // 🔮 Future: || priceRange != null;

  SearchFilter copyWith({
    Object? isOpen = _sentinel,          // use sentinel to allow clearing to null
    Object? minRating = _sentinel,
    // 🔮 Future: Object? priceRange = _sentinel,
  }) {
    return SearchFilter(
      isOpen: isOpen == _sentinel ? this.isOpen : isOpen as bool?,
      minRating: minRating == _sentinel ? this.minRating : minRating as double?,
      // 🔮 Future: priceRange: priceRange == _sentinel ? this.priceRange : priceRange as RangeValues?,
    );
  }

  @override
  List<Object?> get props => [isOpen, minRating];
}

// sentinel so copyWith can distinguish "not passed" from "explicitly null"
const _sentinel = Object();