// lib/features/auth/data/repositories/auth_repository_impl.dart
// ============================================
import 'package:clinic_app/core/api/base_api_services.dart';

import '../../../../core/api/model/endpoints.dart';
import '../../../../core/api/model/http_method.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../user_data/user_model.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../model/auth_response_model.dart';


class AuthRepositoryImpl implements AuthRepository {
  final BaseApiServices apiServices;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.apiServices,
    required this.localDataSource,
  });

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {

    final response = await apiServices.request(
      method: HttpMethod.post,
      url: Endpoints.login,
      body: {
        'email': email,
        'password': password,
      },
    );

    final authResponse = AuthResponseModel.fromJson(response);

    if (authResponse.data != null) {
      final userModel = authResponse.user!;

      // Cache user locally
      await localDataSource.cacheUser(userModel);

      return userModel.toEntity();
    } else {

      // Throw exception with proper message
      throw ServerException(
        authResponse.message.isNotEmpty
            ? authResponse.message
            : 'Login failed',
        'LOGIN_FAILED',
      );
    }
  }

  @override
  Future<String> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    // No try-catch - just data operations
    final response = await apiServices.request(
      method: HttpMethod.post,
      url: Endpoints.register,
      body: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': password,
      },
    );

    final authResponse = AuthResponseModel.fromJson(response);

    // Return email for OTP verification
    if (authResponse.data != null &&
        authResponse.data!.containsKey('email')) {
      return authResponse.data!['email'] as String;
    }

    // If user is directly returned (no OTP)
    if (authResponse.user != null) {
      return email;
    }

    // Throw exception with proper message
    throw ServerException(
      authResponse.message.isNotEmpty
          ? authResponse.message
          : 'Signup failed',
      'SIGNUP_FAILED',
    );
  }

  @override
  Future<void> logout() async {
    // No try-catch - just data operations
    await apiServices.request(
      method: HttpMethod.post,
      url: Endpoints.logout,
    );

    // Clear local cache
    await localDataSource.clearCache();
  }

  @override
  Future<User> getCurrentUser() async {
    // No try-catch - just data operations
    final userModel = await localDataSource.getCachedUser();

    if (userModel == null) {
      throw CacheException('No cached user found', 'NO_CACHED_USER');
    }

    return userModel.toEntity();
  }

  @override
  Future<User?> getCachedUser() async {
    // No try-catch - just data operations
    final userModel = await localDataSource.getCachedUser();
    return userModel?.toEntity();
  }

  @override
  Future<void> saveUserLocally(User user) async {
    // No try-catch - just data operations
    final userModel = UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      avatar: user.avatar,
      token: user.token,
      emailVerifiedAt: user.emailVerifiedAt,
    );

    await localDataSource.cacheUser(userModel);
  }
}