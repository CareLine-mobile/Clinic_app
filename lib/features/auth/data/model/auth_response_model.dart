import 'user_model.dart';

class AuthResponseModel {
  final String message;
  final bool status;
  final UserModel? user;
  final String? token;
  final Map<String, dynamic>? data;

  AuthResponseModel({
    required this.message,
    required this.status,
    this.user,
    this.token,
    this.data,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    // Handle login response
    if (json.containsKey('user') && json['user'] != null) {
      final userJson = json['user'] as Map<String, dynamic>;
      final token = json['token'] as String? ?? '';

      // Add token to user model
      final userWithToken = {
        ...userJson,
        'token': token,
      };

      return AuthResponseModel(
        message: json['message'] as String? ?? '',
        status: json['status'] as bool? ?? true,
        user: UserModel.fromJson(userWithToken),
        token: token,
      );
    }

    // Handle signup response (OTP case)
    if (json.containsKey('data') && json['data'] != null) {
      return AuthResponseModel(
        message: json['message'] as String? ?? '',
        status: json['status'] as bool? ?? true,
        data: json['data'] as Map<String, dynamic>,
      );
    }

    // Default case
    return AuthResponseModel(
      message: json['message'] as String? ?? '',
      status: json['status'] as bool? ?? false,
    );
  }
}