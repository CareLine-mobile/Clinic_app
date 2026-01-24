// lib/features/auth/presentation/cubit/auth_cubit.dart
// ============================================
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/usecase.dart';
import 'auth_state.dart';


class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(AuthInitial());

  /// Check if user is already logged in (on app start)
  Future<void> checkAuthStatus() async {
    emit(AuthLoading());

    final result = await getCurrentUserUseCase(NoParams());

    result.fold(
          (failure) => emit(AuthUnauthenticated()),
          (user) {
        if (user != null) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  /// Login
  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    final result = await loginUseCase(
      LoginParams(
        email: email,
        password: password,
      ),
    );

    result.fold(
          (failure) => emit(AuthFailure(message: failure.message)),
          (user) {
        emit(LoginSuccess(user: user));
        emit(AuthAuthenticated(user: user));
      },
    );
  }

  /// Signup
  Future<void> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    emit(AuthLoading());

    final result = await signupUseCase(
      SignupParams(
        name: name,
        email: email,
        phone: phone,
        password: password,
      ),
    );

    result.fold(
          (failure) => emit(AuthFailure(message: failure.message)),
          (email) {
        // Return email for OTP verification
        emit(SignupSuccess(email: email));
      },
    );
  }

  /// Logout
  Future<void> logout() async {
    emit(AuthLoading());

    final result = await logoutUseCase(NoParams());

    result.fold(
          (failure) => emit(AuthFailure(message: failure.message)),
          (_) => emit(AuthUnauthenticated()),
    );
  }

  /// Load current user
  Future<void> loadUser() async {
    final result = await getCurrentUserUseCase(NoParams());

    result.fold(
          (failure) => emit(AuthUnauthenticated()),
          (user) {
        if (user != null) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }
}