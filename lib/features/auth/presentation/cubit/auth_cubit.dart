// lib/features/auth/presentation/cubit/auth_cubit.dart
// ============================================
import 'package:clinic_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../user_data/user_repo.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';
import 'auth_state.dart';



class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final SignupUseCase signupUseCase;
  final AuthRepository authRepository;
  final UserRepository userRepository;

  AuthCubit({
    required this.loginUseCase,
    required this.signupUseCase,
    required this.authRepository,
    required this.userRepository,
  }) : super(AuthInitial());

  // ── App Start ─────────────────────────────────────────────
  Future<void> loadCurrentUser() async {
    final user = userRepository.currentUser;
    if (user != null) {
      emit(AuthAuthenticated(user: user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  // ── Login ─────────────────────────────────────────────────
  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());

    final result = await loginUseCase(
      LoginParams(email: email, password: password),
    );

    await result.fold(
          (failure) async => emit(AuthFailure(message: failure.message)),
          (user) async {
        await userRepository.setUser(user);
        emit(LoginSuccess(user: user));
      },
    );
  }

  // ── Signup ────────────────────────────────────────────────
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

  // ── Logout ────────────────────────────────────────────────
  Future<void> logout() async {
    try {
      await authRepository.logout();
    } catch (_) {}
    await userRepository.clearUser();
    emit(AuthUnauthenticated());
  }
}