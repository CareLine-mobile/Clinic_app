// lib/features/clinics/presentation/widgets/clinic_info_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_size.dart';
import '../../data/clinic_details_model.dart';
import '../../domain/entites/clinic_entities.dart';

class ClinicInfoWidget extends StatelessWidget {
  final String name;
  final String specialty;
  final String location;
  final String fullAddress;
  final String openingHours;
  final Color accentColor;
  final ContactInfo contactInfo;

  const ClinicInfoWidget({
    Key? key,
    required this.name,
    required this.specialty,
    required this.location,
    required this.fullAddress,
    required this.openingHours,
    required this.accentColor,
    required this.contactInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vSize = AppSizeVertical.instance;
    final hSize = AppSizeHorizontal.instance;

    return Padding(
      padding: EdgeInsets.all(hSize.s20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name & Specialty
          Text(
            name,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 24.sp,
            ),
          ),
          SizedBox(height: vSize.s8),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: hSize.s12,
              vertical: vSize.s6,
            ),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(hSize.s8),
            ),
            child: Text(
              specialty,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          SizedBox(height: vSize.s16),

          // Info Cards
          Container(
            padding: EdgeInsets.all(hSize.s16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(hSize.s12),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Column(
              children: [
                // Location
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  text: fullAddress,
                  iconColor: Colors.red,
                  onTap: () {
                    // Open maps
                  },
                ),
                Divider(height: vSize.s16),

                // Opening Hours
                _InfoRow(
                  icon: Icons.access_time,
                  text: openingHours,
                  iconColor: Colors.blue,
                ),
                Divider(height: vSize.s16),

                // Phone
                _InfoRow(
                  icon: Icons.phone_outlined,
                  text: contactInfo.phone,
                  iconColor: Colors.green,
                  onTap: () {
                    // Call
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  final VoidCallback? onTap;

  const _InfoRow({
    required this.icon,
    required this.text,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hSize = AppSizeHorizontal.instance;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20.r, color: iconColor),
            ),
            SizedBox(width: hSize.s12),
            Expanded(
              child: Text(
                text,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios,
                size: 16.r,
                color: theme.hintColor,
              ),
          ],
        ),
      ),
    );
  }
}