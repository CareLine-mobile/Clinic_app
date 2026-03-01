import '../../../user_data/user_model.dart';

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
    final rawStatus = json['status'];
    final bool parsedStatus = rawStatus is bool
        ? rawStatus
        : rawStatus is int
        ? rawStatus >= 200 && rawStatus < 300
        : false;

    // Handle login response
    if (json.containsKey('user') && json['user'] != null) {
      final userJson = json['user'] as Map<String, dynamic>;
      final token = json['token'] as String? ?? '';

      return AuthResponseModel(
        message: json['message'] as String? ?? '',
        status: parsedStatus,
        user: UserModel.fromJson({...userJson, 'token': token}),
        token: token,
      );
    }

    // Handle signup / OTP response
    if (json.containsKey('data') && json['data'] != null) {
      return AuthResponseModel(
        message: json['message'] as String? ?? '',
        status: parsedStatus,
        data: json['data'] as Map<String, dynamic>,
      );
    }

    // Default
    return AuthResponseModel(
      message: json['message'] as String? ?? '',
      status: parsedStatus,
    );
  }
}