import 'package:clinic_app/core/api/base_api_services.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/api/model/endpoints.dart';
import '../../../../core/api/model/http_method.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../model/auth_response_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final BaseApiServices apiServices;

  AuthRepositoryImpl({required this.apiServices});

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiServices.request(
        method: HttpMethod.post,
        url: Endpoints.login,
        body: {'email': email, 'password': password},
      );

      final authResponse = AuthResponseModel.fromJson(response);

      if (authResponse.user != null) {
        return Right(authResponse.user!.toEntity());
      }

      throw ServerException(
        authResponse.message.isNotEmpty ? authResponse.message : 'Login failed',
        'LOGIN_FAILED',
      );
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, String>> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
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
        return Right(authResponse.data!['email'] as String? ?? email);
      }

      throw ServerException(
        authResponse.message.isNotEmpty ? authResponse.message : 'Signup failed',
        'SIGNUP_FAILED',
      );
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, User>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await apiServices.request(
        method: HttpMethod.post,
        url: Endpoints.verifyOTP,
        body: {'email': email, 'otp': otp},
      );

      final authResponse = AuthResponseModel.fromJson(response);

      if (authResponse.user != null) {
        return Right(authResponse.user!.toEntity());
      }

      throw ServerException(
        authResponse.message.isNotEmpty
            ? authResponse.message
            : 'Verification failed',
        'VERIFY_OTP_FAILED',
      );
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

  @override
  Future<void> logout() async {
    await apiServices.request(method: HttpMethod.post, url: Endpoints.logout);
  }
}
