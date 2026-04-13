import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../../user_data/user_repo.dart';
import '../../domain/entities/verify_otp_params.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/delete_acount_usecase.dart';
import '../../domain/usecases/google_login_usecase.dart' show GoogleLoginUseCase;
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/send_forgot_password_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final GoogleLoginUseCase googleLoginUseCase;
  final SignupUseCase signupUseCase;
  final LogoutUseCase logoutUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final SendForgotPasswordUseCase sendForgotPasswordUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;


  AuthCubit({
    required this.loginUseCase,
    required this.googleLoginUseCase,
    required this.signupUseCase,
    required this.logoutUseCase,
    required this.verifyOtpUseCase,
    required this.authRepository,
    required this.userRepository,
    required this.sendForgotPasswordUseCase,
    required this.resetPasswordUseCase,
    required this.deleteAccountUseCase,
  }) : super(AuthInitial());

  Future<void> loadCurrentUser() async {
    final user = userRepository.currentUser;
    if (user != null) {
      emit(AuthAuthenticated(user: user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    final result = await loginUseCase(
      LoginParams(email: email, password: password),
    );

    result.fold(
          (failure) {
        if (failure is AccountNotVerifiedFailure) {
          emit(AccountNotVerified(email: failure.email));
        } else {
          emit(AuthFailure(message: failure.message));
        }
      },
          (user) async {
        await userRepository.setUser(user);
        emit(LoginSuccess());
        emit(AuthAuthenticated(user: user));
      },
    );
  }

  Future<void> googleLogin() async {
    emit(AuthLoading());

    final result = await googleLoginUseCase();

    result.fold(
          (failure) => emit(AuthFailure(message: failure.message)),
          (user) async {
        await userRepository.setUser(user);
        emit(LoginSuccess());
        emit(AuthAuthenticated(user: user));
      },
    );
  }

  Future<void> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    emit(AuthLoading());

    final result = await signupUseCase(
      SignupParams(name: name, email: email, phone: phone, password: password),
    );

    result.fold(
          (failure) => emit(AuthFailure(message: failure.message)),
          (email) => emit(SignupSuccess(email: email)),
    );
  }

  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    if (state is OtpLoading) return;
    emit(const OtpLoading());

    final result = await verifyOtpUseCase(
      VerifyOtpParams(email: email, otp: otp),
    );

    result.fold(
          (failure) => emit(OtpFailure(message: failure.message)),
          (user) async {
        await userRepository.setUser(user);
        emit(LoginSuccess());
        emit(AuthAuthenticated(user: user));
      },
    );
  }

  // ─── Resend OTP ────────────────────────────────────────────────────────
  Future<void> resendOtp({required String email}) async {
    if (state is OtpResendLoading) return; // prevent double tap
    emit(const OtpResendLoading());

    final result = await authRepository.reSendOtp(email: email);

    result.fold(
          (failure) => emit(OtpFailure(message: failure.message)),
          (_) => emit(const OtpResendSuccess()),
    );
  }

  // ─── Forgot Password ──────────────────────────────────────────────────────
  Future<void> sendForgotPassword({required String email}) async {
    emit(ForgotPasswordLoading());

    final result = await sendForgotPasswordUseCase(email: email);

    result.fold(
          (failure) => emit(ForgotPasswordFailure(failure.message)),
          (_) => emit(ForgotPasswordSuccess(email)), // بيمرر الـ email للـ next screen
    );
  }

  // ─── Reset Password ───────────────────────────────────────────────────────
  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    emit(ResetPasswordLoading());

    final result = await resetPasswordUseCase(
      email: email,
      otp: otp,
      newPassword: newPassword,
    );

    result.fold(
          (failure) => emit(ResetPasswordFailure(failure.message)),
          (_) => emit(ResetPasswordSuccess()),
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    final result = await logoutUseCase();
    result.fold(
          (failure) => emit(AuthUnauthenticated()),
          (_) => emit(AuthUnauthenticated()),
    );
  }
  Future<void> deleteAccount() async {
    emit(DeleteAccountLoading());
    final result = await deleteAccountUseCase();
    result.fold(
          (failure) => emit(DeleteAccountFailure(failure.message)),
          (_) => emit(DeleteAccountSuccess()),
    );
  }
}