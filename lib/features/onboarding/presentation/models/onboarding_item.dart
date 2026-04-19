// lib/features/onboarding/presentation/models/onboarding_item.dart

import 'package:flutter/material.dart';
class OnboardingItem {
  final String   image;
  final IconData icon;
  final String   title;
  final String   subtitle;

  const OnboardingItem({
    required this.image,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}