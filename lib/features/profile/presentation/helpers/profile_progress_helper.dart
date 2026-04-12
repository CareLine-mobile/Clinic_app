import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ProfileProgressHelper {
  ProfileProgressHelper._();

  static Color progressColor(double value, ThemeData theme) {
    if (value < 0.41) return Colors.red.shade400;
    if (value < 0.81) return Colors.orange.shade500;
    return Colors.green.shade500;
  }

  static String progressHint(int completed) {
    if (completed >= 5) return '';
    return 'profile.completion.hint$completed'.tr();
  }

  static String formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}';
  }
}