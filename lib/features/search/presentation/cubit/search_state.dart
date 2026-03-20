// lib/features/search/presentation/cubit/search_state.dart

part of 'search_cubit.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchLoaded extends SearchState {
  final List<ClinicSummary> clinics;
  const SearchLoaded(this.clinics);

  @override
  List<Object?> get props => [clinics];
}

class SearchEmpty extends SearchState {
  const SearchEmpty();
}

class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}