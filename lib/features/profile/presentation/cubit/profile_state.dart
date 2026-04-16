import 'package:equatable/equatable.dart';
import '../../data/profile_model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
  @override
  List<Object?> get props => [];
}

/// Before any call has been made
class ProfileInitial extends ProfileState {}

/// Initial GET in progress
class ProfileLoading extends ProfileState {}

/// Initial GET succeeded — form should populate
class ProfileLoaded extends ProfileState {
  final ProfileModel profile;
  const ProfileLoaded(this.profile);
  @override
  List<Object?> get props => [profile];
}

/// Initial GET failed (no data at all)
class ProfileLoadError extends ProfileState {
  final String message;
  const ProfileLoadError(this.message);
  @override
  List<Object?> get props => [message];
}

/// PUT in progress — keep profile visible so form stays rendered
class ProfileUpdating extends ProfileState {
  final ProfileModel currentProfile;
  const ProfileUpdating(this.currentProfile);
  @override
  List<Object?> get props => [currentProfile];
}

/// PUT succeeded
class ProfileUpdateSuccess extends ProfileState {
  final ProfileModel profile;
  const ProfileUpdateSuccess(this.profile);
  @override
  List<Object?> get props => [profile];
}

/// PUT failed — keep profile so the user can fix and retry
class ProfileUpdateFailure extends ProfileState {
  final String message;
  final ProfileModel currentProfile;
  const ProfileUpdateFailure({required this.message, required this.currentProfile});
  @override
  List<Object?> get props => [message, currentProfile];
}
/// User tapped Save but nothing was modified

class ProfileNoChanges extends ProfileState {
  final ProfileModel currentProfile;
  const ProfileNoChanges(this.currentProfile);
  @override
  List<Object?> get props => [currentProfile];
}