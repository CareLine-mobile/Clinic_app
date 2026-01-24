
import '../model/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<String> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  });

  Future<void> logout();
}