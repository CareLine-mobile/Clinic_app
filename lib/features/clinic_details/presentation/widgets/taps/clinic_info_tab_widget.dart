// ==================== clinic_info_tab_widget.dart ====================
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../core/utils/app_size.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../../core/widgets/CustomIcon.dart';
import '../../../domain/entites/clinic_entities.dart' show ContactInfo;


import 'package:clinic_app/features/clinic_details/domain/entites/clinic_entities.dart';

class ClinicInfoTabWidget extends StatelessWidget {
  final String description;
  final String location;
  final String fullAddress;
  final String openingHours;
  final ContactInfo contactInfo;
  final Color accentColor;

  const ClinicInfoTabWidget({
    Key? key,
    required this.description,
    required this.location,
    required this.fullAddress,
    required this.openingHours,
    required this.contactInfo,
    required this.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hSize = AppSizeHorizontal.instance;
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: hSize.s20, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. عن العيادة (بدون كارت، نص مباشر)
          _buildMinimalHeader('عن العيادة', accentColor),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: theme.hintColor.withOpacity(0.9),
            ),
          ),

          _buildSectionDivider(theme),

          // 2. الموقع (تصميم الخريطة الجديد)
          _buildMinimalHeader('الموقع', accentColor),
          ClinicLocationSection(
            locationName: location,
            lat: 30.516541,
            lng: 31.513654,
            fullAddress: fullAddress,
            accentColor: accentColor,
          ),

          _buildSectionDivider(theme),

          // 3. ساعات العمل (Row بسيط)
          _buildMinimalHeader('ساعات العمل', accentColor),
          _SimpleTile(
            icon: Icons.access_time_filled_rounded,
            title: openingHours,
            accentColor: accentColor,
          ),

          _buildSectionDivider(theme),

          // 4. التواصل (قائمة بسيطة)
          _buildMinimalHeader('معلومات التواصل', accentColor),
          _ContactItemSimple(
            icon: Icons.phone_rounded,
            value: contactInfo.phone,
            label: 'اتصال',
            onTap: () {},
          ),
          _ContactItemSimple(
            icon: Icons.chat_bubble_rounded,
            value: contactInfo.phone,
            label: 'واتساب',
            iconColor: Colors.green,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMinimalHeader(String title, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, top: 8.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildSectionDivider(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Divider(color: theme.dividerColor.withOpacity(0.08), thickness: 1),
    );
  }
}

// ==================== Simple Tile ====================
class _SimpleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color accentColor;

  const _SimpleTile({required this.icon, required this.title, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: accentColor.withOpacity(0.7), size: 20.r),
        SizedBox(width: 10.w),
        Text(title, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

// ==================== Contact Item Simple ====================
class _ContactItemSimple extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color? iconColor;
  final VoidCallback onTap;

  const _ContactItemSimple({
    required this.icon,
    required this.value,
    required this.label,
    this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 18.r,
        backgroundColor: (iconColor ?? Theme.of(context).primaryColor).withOpacity(0.1),
        child: Icon(icon, size: 18.r, color: iconColor ?? Theme.of(context).primaryColor),
      ),
      title: Text(value, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
      subtitle: Text(label, style: TextStyle(fontSize: 12.sp)),
      trailing: Icon(Icons.arrow_forward_ios, size: 12.r, color: Colors.grey),
      onTap: onTap,
    );
  }
}

// ==================== Location Section (Updated) ====================
class ClinicLocationSection extends StatelessWidget {
  final String locationName;
  final String fullAddress;
  final double? lat;
  final double? lng;
  final Color accentColor;

  const ClinicLocationSection({
    Key? key,
    required this.locationName,
    required this.fullAddress,
    this.lat,
    this.lng,
    required this.accentColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIcon(assetPath: Assets.locationIcon, noColor: false, color: accentColor),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                "$locationName - $fullAddress",
                style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        if (lat != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              height: 140.h,
              width: double.infinity,
              color: Colors.grey[200], // Placeholder
              child: GoogleMap(
                initialCameraPosition: CameraPosition(target: LatLng(lat!, lng!), zoom: 15),
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                markers: {Marker(markerId: const MarkerId('1'), position: LatLng(lat!, lng!))},
              ),
            ),
          ),
      ],
    );
  }
}