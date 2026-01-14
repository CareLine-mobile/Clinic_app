
import 'package:flutter/material.dart';

enum ClinicCardLayout {
  list,
  carousel,
  featured,
}

/// Error Type
enum ErrorType {
  network,
  server,
  auth,
  cache,
  validation,
  unknown;

  String get translationKey {
    switch (this) {
      case ErrorType.network:
        return 'errors.network';
      case ErrorType.server:
        return 'errors.server';
      case ErrorType.auth:
        return 'errors.auth';
      case ErrorType.cache:
        return 'errors.cache';
      case ErrorType.unknown:
        return 'errors.unknown';
        case ErrorType.validation:
        return 'errors.validation';
    }
  }
}

/// Medication Filter Types
enum MedicationFilter {
  all('all', 'الكل', Icons.grid_view_rounded),
  daily('daily', 'يومي', Icons.calendar_today),
  alternateDays('alternate_days', 'أيام متبادلة', Icons.event_repeat),
  weekly('weekly', 'أسبوعي', Icons.calendar_month),
  asNeeded('as_needed', 'عند الحاجة', Icons.notifications_active);

  final String value;
  final String label;
  final IconData icon;

  const MedicationFilter(this.value, this.label, this.icon);

  static MedicationFilter fromValue(String value) {
    return MedicationFilter.values.firstWhere(
          (e) => e.value == value,
      orElse: () => MedicationFilter.all,
    );
  }
}
