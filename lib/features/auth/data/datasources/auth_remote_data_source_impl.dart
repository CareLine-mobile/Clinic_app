// lib/features/auth/data/datasources/auth_remote_data_source_impl.dart
// ============================================

import 'package:clinic_app/core/api/endpoints.dart';
import '../../../../core/api/api_service.dart';
import '../../../../core/errors/exceptions.dart';
import '../model/auth_response_model.dart';
import '../model/user_model.dart';
import 'auth_remote_data_source.dart';


class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl({required this.apiService});

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiService.post(
        Endpoints.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final authResponse = AuthResponseModel.fromJson(response.data);

      if (authResponse.user != null) {
        return authResponse.user!;
      } else {
        throw ServerException(
          authResponse.message.isNotEmpty
              ? authResponse.message
              : 'Login failed',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await apiService.post(
        Endpoints.register,
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'password_confirmation': password,
        },
      );

      final authResponse = AuthResponseModel.fromJson(response.data);

      // Return email for OTP verification
      if (authResponse.data != null &&
          authResponse.data!.containsKey('email')) {
        return authResponse.data!['email'] as String;
      }

      // If user is directly returned (no OTP)
      if (authResponse.user != null) {
        return email;
      }

      throw ServerException(
        authResponse.message.isNotEmpty
            ? authResponse.message
            : 'Signup failed',
      );
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      await apiService.post(Endpoints.logout);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}