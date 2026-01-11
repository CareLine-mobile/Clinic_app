import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/clinic_summary.dart';
import '../../domain/repositories/home_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository homeRepository;

  HomeCubit({required this.homeRepository}) : super(HomeInitial());

  List<ClinicSummary> _featuredClinics = [];
  List<ClinicSummary> _nearbyClinics = [];
  List<ClinicSummary> _allClinics = [];

  Future<void> loadClinics() async {
    emit(HomeLoading());

    try {
      final results = await Future.wait([
        homeRepository.getFeaturedClinics(),
        homeRepository.getNearbyClinics(),
      ]);

      final featuredResult = results[0];
      final nearbyResult = results[1];

      featuredResult.fold(
            (failure) {
          final message = FailureMessageMapper.mapFailureToMessage(failure);
          final action = FailureMessageMapper.getActionMessage(failure);
          emit(HomeError(message: message, actionMessage: action));
        },
            (featured) {
          _featuredClinics = featured;

          nearbyResult.fold(
                (failure) {
              final message = FailureMessageMapper.mapFailureToMessage(failure);
              final action = FailureMessageMapper.getActionMessage(failure);
              emit(HomeError(message: message, actionMessage: action));
            },
                (nearby) {
              _nearbyClinics = nearby;
              _allClinics = [..._featuredClinics, ..._nearbyClinics];

              emit(HomeLoaded(
                featuredClinics: _featuredClinics,
                nearbyClinics: _nearbyClinics,
                allClinics: _allClinics,
                lastBooking: null, // Added missing parameter
              ));
            },
          );
        },
      );
    } catch (e) {
      emit(HomeError(
        message: 'حدث خطأ غير متوقع',
        actionMessage: 'حاول مرة أخرى',
      ));
    }
  }

  Future<void> toggleFavorite(int clinicId) async {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    // Optimistic Update
    final updatedFeatured = _updateClinicFavorite(_featuredClinics, clinicId);
    final updatedNearby = _updateClinicFavorite(_nearbyClinics, clinicId);
    final updatedAll = _updateClinicFavorite(_allClinics, clinicId);

    _featuredClinics = updatedFeatured;
    _nearbyClinics = updatedNearby;
    _allClinics = updatedAll;

    emit(currentState.copyWith(
      featuredClinics: updatedFeatured,
      nearbyClinics: updatedNearby,
      allClinics: updatedAll,
    ));

    // Call API
    final result = await homeRepository.toggleFavorite(clinicId);

    result.fold(
          (failure) {
        // Rollback on failure
        final revertedFeatured = _updateClinicFavorite(updatedFeatured, clinicId);
        final revertedNearby = _updateClinicFavorite(updatedNearby, clinicId);
        final revertedAll = _updateClinicFavorite(updatedAll, clinicId);

        _featuredClinics = revertedFeatured;
        _nearbyClinics = revertedNearby;
        _allClinics = revertedAll;

        // Return to loaded state with reverted data
        emit(currentState.copyWith(
          featuredClinics: revertedFeatured,
          nearbyClinics: revertedNearby,
          allClinics: revertedAll,
        ));
      },
          (_) => null,
    );
  }

  List<ClinicSummary> _updateClinicFavorite(
      List<ClinicSummary> clinics,
      int clinicId,
      ) {
    return clinics.map((clinic) {
      if (clinic.id == clinicId) {
        return clinic.copyWith(isFavorite: !clinic.isFavorite);
      }
      return clinic;
    }).toList();
  }

  Future<void> bookAppointment(int clinicId) async {
    // Don't change state here - let UI handle loading via HomeUiCubit
    final result = await homeRepository.bookAppointment(clinicId);

    result.fold(
          (failure) {
        // Error will be handled in UI via .catchError
        throw Exception(FailureMessageMapper.mapFailureToMessage(failure));
      },
          (_) {
        // Success - reload clinics
        loadClinics();
      },
    );
  }

  Future<void> refresh() async {
    await loadClinics();
  }
}