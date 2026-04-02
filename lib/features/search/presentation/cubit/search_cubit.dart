// lib/features/search/presentation/cubit/search_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/utils/debouncer.dart';
import '../../../home/domain/entities/clinic_summary.dart';
import '../../domain/model/search_filter.dart';
import '../../domain/usecases/search_clinics_usecase.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchClinicsUseCase searchClinicsUseCase;
  final Debouncer _debouncer;
  String _lastQuery = '';

  SearchCubit({
    required this.searchClinicsUseCase,
    Debouncer? debouncer,
  })  : _debouncer = debouncer ?? Debouncer(),
        super(const SearchInitial());

  void onSearchQueryChanged(String query) {
    final trimmed = query.trim();
    _lastQuery = trimmed;

    if (trimmed.isEmpty) {
      _debouncer.cancel();
      emit(const SearchInitial());
      return;
    }
    _debouncer(() => _search(trimmed));
  }

  Future<void> _search(String query) async {
    if (isClosed) return;
    emit(const SearchLoading());

    final result = await searchClinicsUseCase(query: query);
    if (isClosed) return;

    result.fold(
          (failure) => emit(SearchError(failure.message)),
          (clinics) => clinics.isEmpty
          ? emit(const SearchEmpty())
          : emit(SearchLoaded.fromClinics(clinics)),  // ← clean factory
    );
  }

  // ─── Filter actions ───────────────────────────────────────────────────

  /// Toggle isOpen filter
  void toggleIsOpen(bool? value) => _updateFilter(
        (f) => f.copyWith(isOpen: value),
  );

  /// Set minimum rating (pass null to clear)
  void setMinRating(double? rating) => _updateFilter(
        (f) => f.copyWith(minRating: rating),
  );

  /// Clear all filters at once
  void clearFilters() => _updateFilter((_) => const SearchFilter.empty());

  // 🔮 Future: void setPriceRange(RangeValues? range) => _updateFilter(
  //       (f) => f.copyWith(priceRange: range),
  //     );

  void _updateFilter(SearchFilter Function(SearchFilter) updater) {
    final current = state;
    if (current is! SearchLoaded) return;
    emit(current.withFilter(updater(current.filter)));
  }

  void retry() {
    if (_lastQuery.isEmpty) return;
    _search(_lastQuery);
  }

  @override
  Future<void> close() {
    _debouncer.dispose();
    return super.close();
  }
}