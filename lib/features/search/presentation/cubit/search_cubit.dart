// lib/features/search/presentation/cubit/search_cubit.dart

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/utils/debouncer.dart';
import '../../../home/domain/entities/clinic_summary.dart';
import '../../domain/usecases/search_clinics_usecase.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchClinicsUseCase searchClinicsUseCase;
  final Debouncer _debouncer;

  SearchCubit({
    required this.searchClinicsUseCase,
    Debouncer? debouncer,
  })  : _debouncer = debouncer ?? Debouncer(),
        super(const SearchInitial());

  // ─── Called on every keystroke ────────────────────────────────────────
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

    // حطينا الـ Loading هنا! (هتظهر بس لما الـ 600ms يخلصوا ونقرر نكلم السيرفر)
    emit(const SearchLoading());

    final result = await searchClinicsUseCase(query: query);

    if (isClosed) return;

    result.fold(
          (failure) => emit(SearchError(failure.message)),
          (clinics) => clinics.isEmpty
          ? emit(const SearchEmpty())
          : emit(SearchLoaded(clinics)),
    );
  }

  // ─── Retry بنفس الـ query الأخير ─────────────────────────────────────
  String _lastQuery = '';

  void retry() {
    if (_lastQuery.isEmpty) return;
    emit(const SearchLoading());
    _search(_lastQuery);
  }

  @override
  Future<void> close() {
    _debouncer.dispose();
    return super.close();
  }
}