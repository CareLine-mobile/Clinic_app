import 'package:equatable/equatable.dart';

class SocialMediaEntity extends Equatable {
  final String facebook;
  final String instagram;

  const SocialMediaEntity({
    required this.facebook,
    required this.instagram,
  });

  // Business Logic
  bool get hasFacebook => facebook.isNotEmpty;
  bool get hasInstagram => instagram.isNotEmpty;
  bool get hasSocialMedia => hasFacebook || hasInstagram;

  @override
  List<Object?> get props => [facebook, instagram];
}