import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ─── Clinic Avatar ──────────────────────────────────────────────────────────
class ClinicAvatar extends StatelessWidget {
  final String? thumbnailUrl;
  final double size;
  final double radius;

  const ClinicAvatar({
    super.key,
    this.thumbnailUrl,
    this.size = 48,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(radius.r),
      ),
      child: thumbnailUrl != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(radius.r),
        child: Image.network(
          thumbnailUrl!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _Placeholder(theme: theme),
        ),
      )
          : _Placeholder(theme: theme),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final ThemeData theme;
  const _Placeholder({required this.theme});

  @override
  Widget build(BuildContext context) =>
      Icon(Icons.local_hospital_outlined, color: theme.primaryColor);
}

