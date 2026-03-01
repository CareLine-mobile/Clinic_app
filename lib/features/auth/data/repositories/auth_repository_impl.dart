import 'package:clinic_app/core/api/base_api_services.dart';
import '../../../../core/api/model/endpoints.dart';
import '../../../../core/api/model/http_method.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../model/auth_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final BaseApiServices apiServices;

  AuthRepositoryImpl({required this.apiServices});

  @override
  Future<User> login({required String email, required String password}) async {
    final response = await apiServices.request(
      method: HttpMethod.post,
      url: Endpoints.login,
      body: {'email': email, 'password': password},
    );

    final authResponse = AuthResponseModel.fromJson(response);

    if (authResponse.user != null) {
      return authResponse.user!.toEntity();
    }

    throw ServerException(
      authResponse.message.isNotEmpty ? authResponse.message : 'Login failed',
      'LOGIN_FAILED',
    );
  }

  @override
  Future<String> signup({required String name, required String email, required String phone, required String password}) async {
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

    if (authResponse.data != null) {
      return authResponse.data!['email'] as String? ?? email;
    }

    throw ServerException(
      authResponse.message.isNotEmpty ? authResponse.message : 'Signup failed',
      'SIGNUP_FAILED',
    );
  }

  @override
  Future<void> logout() async {
    await apiServices.request(method: HttpMethod.post, url: Endpoints.logout);
  }
}