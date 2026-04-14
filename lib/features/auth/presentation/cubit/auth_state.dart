// lib/features/auth/presentation/cubit/auth_state.dart
// ============================================
import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';


abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class GoogleLoginLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {}

class LoginSuccess extends AuthState {}

class SignupSuccess extends AuthState {
  final String email;

  const SignupSuccess({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class OtpLoading extends AuthState {
  const OtpLoading();
}

class OtpFailure extends AuthState {
  final String message;

  const OtpFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class AccountNotVerified extends AuthState {
  final String email;

  const AccountNotVerified({required this.email});

  @override
  List<Object?> get props => [email];
}

class OtpResendLoading extends AuthState {
  const OtpResendLoading();
}

class OtpResendSuccess extends AuthState {
  const OtpResendSuccess();
}

// auth_state.dart

// ─── Forgot Password ─────────────────────────────────────────────────────
class ForgotPasswordLoading extends AuthState {}

class ForgotPasswordSuccess extends AuthState {
  final String email;
  const ForgotPasswordSuccess(this.email);

  @override
  List<Object?> get props => [email];
}

class ForgotPasswordFailure extends AuthState {
  final String message;
  const ForgotPasswordFailure(this.message);

  @override
  List<Object?> get props => [message];
}

// ─── Reset Password ───────────────────────────────────────────────────────
class ResetPasswordLoading extends AuthState {}

class ResetPasswordSuccess extends AuthState {}

class ResetPasswordFailure extends AuthState {
  final String message;
  const ResetPasswordFailure(this.message);

  @override
  List<Object?> get props => [message];
}
class DeleteAccountLoading extends AuthState {}

class DeleteAccountSuccess extends AuthState {}

class DeleteAccountFailure extends AuthState{
  final String message;
  const DeleteAccountFailure(this.message);
}