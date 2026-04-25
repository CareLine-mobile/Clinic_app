// ─── Status Config ─────────────────────────────────────────────────────────

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BookingStatusConfig {
  final String label;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const BookingStatusConfig({
    required this.label,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  static BookingStatusConfig from(String status) => switch (status) {
    'confirmed' => BookingStatusConfig(
      label: 'bookings.status.confirmed'.tr(),
      icon: Icons.check_circle_outline_rounded,
      color: const Color(0xFF2E7D32),
      bgColor: const Color(0xFFE8F5E9),
    ),
    'cancelled' => BookingStatusConfig(
      label: 'bookings.status.cancelled'.tr(),
      icon: Icons.cancel_outlined,
      color: const Color(0xFFC62828),
      bgColor: const Color(0xFFFFEBEE),
    ),
    'pending' => BookingStatusConfig(
      label: 'bookings.status.pending'.tr(),
      icon: Icons.hourglass_empty_rounded,
      color: const Color(0xFFE65100),
      bgColor: const Color(0xFFFFF3E0),
    ),
    'in-doctor' => BookingStatusConfig(
      label: 'bookings.status.in-doctor'.tr(),
      icon: Icons.medical_services_rounded,
      color: const Color(0xFF1565C0),
      bgColor: const Color(0xFFE3F2FD),
    ),
    'completed' => BookingStatusConfig(
      label: 'bookings.status.completed'.tr(),
      icon: Icons.task_alt_rounded,
      color: const Color(0xFF1565C0),
      bgColor: const Color(0xFFE3F2FD),
    ),
    _ => BookingStatusConfig(
      label: status,
      icon: Icons.info_outline_rounded,
      color: Colors.grey[600]!,
      bgColor: Colors.grey[100]!,
    ),
  };
}
