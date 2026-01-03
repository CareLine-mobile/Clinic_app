class UserModel {
  final String? name;
  final String? email;
  final String? image;
  final String? token;

  const UserModel({
    this.name,
    this.email,
    this.image,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String?,
      email: json['email'] as String?,
      image: json['image'] as String?,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'image': image,
      'token': token,
    };
  }
}
