



part of 'search_cubit.dart';

sealed class SearchState extends Equatable {
  const SearchState();
}

final class SearchInitial extends SearchState {
  const SearchInitial();
  @override List<Object?> get props => [];
}

final class SearchLoading extends SearchState {
  const SearchLoading();
  @override List<Object?> get props => [];
}

/// Loaded: holds BOTH raw + filtered lists + current filter + available ratings
final class SearchLoaded extends SearchState {
  final List<ClinicSummary> allClinics;       // untouched API results
  final List<ClinicSummary> filteredClinics;  // what the UI renders
  final SearchFilter filter;
  final List<double> availableRatings;        // derived from allClinics

  const SearchLoaded({
    required this.allClinics,
    required this.filteredClinics,
    required this.filter,
    required this.availableRatings,
  });

  /// Convenience: no active filter
  factory SearchLoaded.fromClinics(List<ClinicSummary> clinics) {
    return SearchLoaded(
      allClinics: clinics,
      filteredClinics: clinics,
      filter: const SearchFilter.empty(),
      availableRatings: _extractRatings(clinics),
    );
  }

  /// Re-apply a new filter on the same raw data
  SearchLoaded withFilter(SearchFilter newFilter) {
    return SearchLoaded(
      allClinics: allClinics,
      filteredClinics: _applyFilter(allClinics, newFilter),
      filter: newFilter,
      availableRatings: availableRatings,
    );
  }

  @override
  List<Object?> get props => [allClinics, filteredClinics, filter, availableRatings];
}

final class SearchEmpty extends SearchState {
  const SearchEmpty();
  @override List<Object?> get props => [];
}

final class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);
  @override List<Object?> get props => [message];
}

// ─── Pure filter logic ────────────────────────────────────────────────────────

List<ClinicSummary> _applyFilter(
    List<ClinicSummary> clinics,
    SearchFilter filter,
    ) {
  return clinics.where((clinic) {
    // isOpen filter
    if (filter.isOpen != null && clinic.isOpen != filter.isOpen) return false;

    // rating filter
    if (filter.minRating != null) {
      final rating = double.tryParse(clinic.rating) ?? 0.0;
      if (rating < filter.minRating!) return false;
    }

    // 🔮 Future: price filter
    // if (filter.priceRange != null) {
    //   if (clinic.price < filter.priceRange!.start ||
    //       clinic.price > filter.priceRange!.end) return false;
    // }

    return true;
  }).toList();
}

/// Extract unique sorted rating values from the loaded list
List<double> _extractRatings(List<ClinicSummary> clinics) {
  final ratings = clinics
      .map((c) => double.tryParse(c.rating))
      .whereType<double>()
      .map((r) => r.floorToDouble()) // group by whole stars: 4.7 → 4.0
      .toSet()
      .toList()
    ..sort();
  return ratings;
}
