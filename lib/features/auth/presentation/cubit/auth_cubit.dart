import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../../user_data/user_repo.dart';
import '../../domain/entities/verify_otp_params.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final LogoutUseCase logoutUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final AuthRepository authRepository;
  final UserRepository userRepository;

  AuthCubit({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.logoutUseCase,
    required this.verifyOtpUseCase,
    required this.authRepository,
    required this.userRepository,
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

  Future<void> logout() async {
    try {
      await authRepository.logout();
    } catch (_) {}
    await userRepository.clearUser();
    emit(AuthUnauthenticated());
  }
}