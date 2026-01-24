// import 'dart:async';
// import 'package:clinic_app/features/user_data/user_model.dart';
// import '../../core/db/shared_pref_helper.dart';
// import '../../core/utils/app_constans.dart';
// import '../auth/data/model/user_model.dart';
// import '../auth/domain/entities/user.dart';
//
//
//
// class UserRepository {
//   static final UserRepository _instance = UserRepository._internal();
//
//   factory UserRepository() => _instance;
//
//   UserRepository._internal();
//
//   final _controller = StreamController<User?>.broadcast();
//
//   Stream<User?> get userStream => _controller.stream;
//
//   User? _currentUser;
//
//   User? get currentUser => _currentUser;
//
//   bool get isLoggedIn => _currentUser != null;
//
//   /// Initialize from storage (call on app start)
//   Future<void> loadUser() async {
//     final userData = await SharedPrefHelper.getData(key: AppConstants.userKey);
//
//     if (userData != null && userData is Map<String, dynamic>) {
//       final userModel = UserModel.fromJson(userData);
//       _currentUser = userModel.toEntity();
//       _controller.add(_currentUser);
//     }
//   }
//
//   /// Update user (after login/register)
//   Future<void> setUser(User user) async {
//     _currentUser = user;
//     _controller.add(user);
//
//     final userModel = UserModel(
//       id: user.id,
//       name: user.name,
//       email: user.email,
//       phone: user.phone,
//       avatar: user.avatar,
//       token: user.token,
//       emailVerifiedAt: user.emailVerifiedAt,
//     );
//
//     await SharedPrefHelper.saveJson(
//       key: AppConstants.userKey,
//       value: userModel.toJson(),
//     );
//   }
//
//   /// Clear user (logout)
//   Future<void> clearUser() async {
//     _currentUser = null;
//     _controller.add(null);
//
//     await SharedPrefHelper.delete(key: AppConstants.userKey);
//   }
//
//   /// Update user fields
//   Future<void> updateUser({
//     String? name,
//     String? phone,
//     String? avatar,
//   }) async {
//     if (_currentUser == null) return;
//
//     _currentUser = _currentUser!.copyWith(
//       name: name,
//       phone: phone,
//       avatar: avatar,
//     );
//
//     _controller.add(_currentUser);
//
//     final userModel = UserModel(
//       id: _currentUser!.id,
//       name: _currentUser!.name,
//       email: _currentUser!.email,
//       phone: _currentUser!.phone,
//       avatar: _currentUser!.avatar,
//       token: _currentUser!.token,
//       emailVerifiedAt: _currentUser!.emailVerifiedAt,
//     );
//
//     await SharedPrefHelper.saveJson(
//       key: AppConstants.userKey,
//       value: userModel.toJson(),
//     );
//   }
//
//   void dispose() {
//     _controller.close();
//   }
// }