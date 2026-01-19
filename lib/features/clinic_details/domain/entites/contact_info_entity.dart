import 'package:equatable/equatable.dart';
import 'social_media_entity.dart';

class ContactInfoEntity extends Equatable {
  final String phone;
  final String email;
  final String website;
  final SocialMediaEntity socialMedia;

  const ContactInfoEntity({
    required this.phone,
    required this.email,
    required this.website,
    required this.socialMedia,
  });

  @override
  List<Object?> get props => [
    phone, email, website, socialMedia,
  ];
}