import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/user_data/user_repo.dart';

import '../../data/profile_model.dart';
import '../../data/profile_repository.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _repository;
  final UserRepository _userRepository;

  ProfileCubit({
    required ProfileRepository repository,
    required UserRepository userRepository,
  })  : _repository = repository,
        _userRepository = userRepository,
        super(ProfileInitial());
  bool isProfileDataExists = false;
  // ── Load ─────────────────────────────────────────────────────────────────
  Future<void> loadProfile() async {
    emit(ProfileLoading());
    final result = await _repository.getProfile();  result.fold(
          (failure) => emit(ProfileLoadError(failure.message)),
          (profile) {
        // enrich profile لو البيانات ناقصة
        final enriched =
        (profile.fullName == null || profile.fullName!.trim().isEmpty)
            ? profile.copyWith(
          fullName: _userRepository.currentUser?.name,
          phone: profile.phone ?? _userRepository.currentUser?.phone,
        )
            : profile;

        // ✅ هنا تحدد هل فيه بيانات ولا لا
        isProfileDataExists = enriched.hasData;

        // ✅ emit مرة واحدة بس
        emit(ProfileLoaded(enriched));
      },
    );
  }

  // ── Update ────────────────────────────────────────────────────────────────
  Future<void> updateProfile({
    required String fullName,
    required DateTime birthDate,
    required String gender,
    String? bloodType,
    List<String>? chronicDiseases,
    required String emergencyContact,
  }) async {
    final current = _currentProfileFromState();
    if (current == null) return;

    final toUpdate = current.copyWith(
      fullName: fullName,
      birthDate: birthDate,
      gender: gender,
      bloodType: bloodType,
      chronicDiseases: chronicDiseases,
      emergencyContact: emergencyContact,
    );

    emit(ProfileUpdating(toUpdate));

    final result = await _repository.updateProfile(toUpdate,isProfileDataExists);
    result.fold(
          (failure) => emit(ProfileUpdateFailure(
        message: failure.message,
        currentProfile: toUpdate,
      )),
          (updated) async {
        // Keep UserRepository stream in sync (name may have changed)
        await _userRepository.updateUser(
          name: updated.fullName,
          phone: updated.phone,
          avatar: updated.avatar,
        );
        emit(ProfileUpdateSuccess(updated));
      },
    );
  }

  ProfileModel? _currentProfileFromState() {
    final s = state;
    if (s is ProfileLoaded) return s.profile;
    if (s is ProfileUpdateFailure) return s.currentProfile;
    return null;
  }
}