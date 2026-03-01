import '../../domain/entites/social_media_entity.dart';

class SocialMediaModel extends SocialMediaEntity {
  const SocialMediaModel({
    required super.facebook,
    required super.instagram,
  });

  factory SocialMediaModel.fromJson(Map<String, dynamic> json) {
    return SocialMediaModel(
      facebook: json['facebook'] ?? '',
      instagram: json['instagram'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'facebook': facebook,
      'instagram': instagram,
    };
  }

  factory SocialMediaModel.fromEntity(SocialMediaEntity entity) {
    return SocialMediaModel(
      facebook: entity.facebook,
      instagram: entity.instagram,
    );
  }
}