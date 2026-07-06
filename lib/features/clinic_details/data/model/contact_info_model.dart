import 'package:clinic_app/features/clinic_details/data/model/social_media_model.dart';

import '../../domain/entites/contact_info_entity.dart';

class ContactInfoModel extends ContactInfoEntity {
  const ContactInfoModel({
    required super.phone,
    required super.email,
    required super.website,
    required super.socialMedia,
  });

  factory ContactInfoModel.fromJson(Map<String, dynamic> json) {
    return ContactInfoModel(
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      website: json['website'] ?? '',
      socialMedia: SocialMediaModel.fromJson(
        json['social_media'] is Map<String, dynamic>
            ? json['social_media'] as Map<String, dynamic>
            : {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'email': email,
      'website': website,
      'social_media': SocialMediaModel.fromEntity(socialMedia).toJson(),
    };
  }

  factory ContactInfoModel.fromEntity(ContactInfoEntity entity) {
    return ContactInfoModel(
      phone: entity.phone,
      email: entity.email,
      website: entity.website,
      socialMedia: entity.socialMedia,
    );
  }
}
