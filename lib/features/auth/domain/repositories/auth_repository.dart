
import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> login({required String email, required String password});
  Future<String> signup({required String name, required String email, required String phone, required String password});
  Future<void> logout();
}