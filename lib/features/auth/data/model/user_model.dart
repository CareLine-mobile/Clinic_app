import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.phone,
    super.avatar,
    required super.token,
    super.emailVerifiedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      token: json['token'] as String? ?? '',
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'token': token,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
    };
  }

  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      phone: phone,
      avatar: avatar,
      token: token,
      emailVerifiedAt: emailVerifiedAt,
    );
  }
}