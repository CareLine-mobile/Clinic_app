import 'package:clinic_app/core/api/base_api_services.dart';
import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
      final failure = ErrorHandler.handleException(e);

      if (failure is AccountNotVerifiedFailure) {
        return Left(AccountNotVerifiedFailure(email));
      }

      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, User>> googleLogin() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in flow
        return Left(ServerFailure(
          'errors.auth.cancelled'.tr(),
          'CANCELLED',
        ));
      }

      // Get authentication details
      final response = await apiServices.request(
        method: HttpMethod.post,
        url: Endpoints.googleLogin,
        body: {
          'email': googleUser.email,
          'name': googleUser.displayName ?? '',
          'google_id': googleUser.id,
        },
      );

      final authResponse = AuthResponseModel.fromJson(response);

      if (authResponse.user != null) {
        return Right(authResponse.user!.toEntity());
      }

      throw ServerException(
        authResponse.message.isNotEmpty
            ? authResponse.message
            : 'errors.server.unexpected'.tr(),
        'GOOGLE_LOGIN_FAILED',
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        'errors.auth.googleSignInFailed'.tr(),
        'GOOGLE_SIGN_IN_ERROR',
      );
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
  Future<Either<Failure, void>> reSendOtp({
    required String email,
  }) async {
    try {
      await apiServices.request(
        method: HttpMethod.post,
        url: Endpoints.resendOTP,
        body: {'email': email},
      );
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

// ─── Forgot Password — بيبعت OTP على الإيميل ────────────────────────────
  @override
  Future<Either<Failure, void>> sendForgotPassword({
    required String email,
  }) async {
    try {
      await apiServices.request(
        method: HttpMethod.post,
        url: Endpoints.sendForgetPassword,
        body: {'email': email},
      );
      // response: { status: 200, message: "...", data: null }
      // مفيش user — مجرد success
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }

// ─── Reset Password — بيستقبل email + otp + password ────────────────────
  @override
  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      await apiServices.request(
        method: HttpMethod.post,
        url: Endpoints.resetPassword, // تأكد من الـ endpoint
        body: {
          'email': email,
          'otp': otp,
          'password': newPassword,
          'password_confirmation': newPassword,
        },
      );
      return const Right(null);
    } catch (e) {
      return Left(ErrorHandler.handleException(e));
    }
  }
  @override
  Future<void> logout() async {
    await apiServices.request(method: HttpMethod.post, url: Endpoints.logout);
  }

  @override
  Future<void> deleteAccount() async{
    await Future.delayed(const Duration(seconds: 4));
    await apiServices.request(method: HttpMethod.delete, url: Endpoints.deleteAccount);
  }

}
