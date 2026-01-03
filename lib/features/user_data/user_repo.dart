import 'dart:async';
import 'dart:convert';
import 'package:clinic_app/features/user_data/user_model.dart';


import 'package:shared_preferences/shared_preferences.dart';

import '../../core/db/shared_pref_helper.dart';
import '../../core/utils/app_constans.dart';


class UserRepository {

  static final UserRepository _instance = UserRepository._internal();

  factory UserRepository() => _instance;

  UserRepository._internal();
  final _controller = StreamController<UserModel?>.broadcast();

  Stream<UserModel?> get userStream => _controller.stream;

  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  /// Initialize from storage
  Future<void> loadUser() async {
    UserModel? userModel = await SharedPrefHelper.getUserData();


    if (userModel != null) {
      _currentUser = userModel;
      _controller.add(_currentUser);
    }
  }

  /// Update user (after login/register/reset password)
  Future<void> setUser(UserModel user) async {
    _currentUser = user;
    _controller.add(user);


    
    SharedPrefHelper.saveJson(key: AppConst.userKey, value: user.toJson());
  }

  /// Clear user (logout)
  Future<void> clearUser() async {
    _currentUser = null;
    _controller.add(null);


    SharedPrefHelper.delete(key: AppConst.userKey);
  }

  void dispose() {
    _controller.close();
  }
}
