import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clinic_app/features/user_data/user_model.dart';
import 'package:clinic_app/features/user_data/user_repo.dart';
import 'package:meta/meta.dart';


part 'user_state.dart';

class UserCubit extends Cubit<UserModel?> {
  final UserRepository userRepository;
  late final StreamSubscription _subscription;

  UserCubit(this.userRepository) : super(userRepository.currentUser) {

    _subscription = userRepository.userStream.listen((user) {
      emit(user);
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
