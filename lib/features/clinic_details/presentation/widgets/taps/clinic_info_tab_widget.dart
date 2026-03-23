// ==================== clinic_info_tab_widget.dart ====================
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../core/utils/app_size.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../../core/widgets/CustomIcon.dart';
import 'package:clinic_app/features/clinic_details/domain/entites/clinic_entities.dart';
import 'package:clinic_app/features/clinic_details/domain/entites/contact_info_entity.dart';

class ClinicInfoTabWidget extends StatelessWidget {
  final String description;
  final String location;
  final String fullAddress;
  final String openingHours;
  final ContactInfoEntity contactInfo;
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

  static final _v = AppSizeVertical.instance;
  static final _h = AppSizeHorizontal.instance;
  static final _t = TextSizeApp.instance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: _h.s20,
        vertical: _v.s16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ─── 1. Description ───────────────────────────────────────
          _SectionHeader(
            title: 'clinic.info.about'.tr(),
            accentColor: accentColor,
          ),
          SizedBox(height: _v.s8),
          _ExpandableDescription(
            description: description,
            theme: theme,
          ),

          _Divider(theme: theme),

          // ─── 2. Opening hours ─────────────────────────────────────
          _SectionHeader(
            title: 'clinic.info.opening_hours'.tr(),
            accentColor: accentColor,
          ),
          SizedBox(height: _v.s8),
          _InfoTile(
            icon: Icons.access_time_filled_rounded,
            value: openingHours,
            accentColor: accentColor,
            theme: theme,
          ),

          _Divider(theme: theme),

          // ─── 3. Location ──────────────────────────────────────────
          _SectionHeader(
            title: 'clinic.info.location'.tr(),
            accentColor: accentColor,
          ),
          SizedBox(height: _v.s8),
          ClinicLocationSection(
            locationName: location,
            fullAddress: fullAddress,
            lat: 30.516541,
            lng: 31.513654,
            accentColor: accentColor,
            theme: theme,
          ),

          _Divider(theme: theme),

          // ─── 4. Contact ───────────────────────────────────────────
          _SectionHeader(
            title: 'clinic.info.contact'.tr(),
            accentColor: accentColor,
          ),
          SizedBox(height: _v.s4),
          _ContactItem(
            icon: Icons.phone_rounded,
            value: contactInfo.phone,
            label: 'clinic.info.call'.tr(),
            accentColor: accentColor,
            theme: theme,
            onTap: () => _launchPhone(contactInfo.phone),
          ),
          _ContactItem(
            icon: Icons.chat_rounded,
            value: contactInfo.phone,
            label: 'clinic.info.whatsapp'.tr(),
            iconColor: const Color(0xFF25D366),
            accentColor: accentColor,
            theme: theme,
            onTap: () => _launchWhatsApp(contactInfo.phone),
          ),

          SizedBox(height: _v.s40),
        ],
      ),
    );
  }

  // ─── Launchers ────────────────────────────────────────────────────
  Future<void> _launchPhone(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _launchWhatsApp(String phone) async {
    final cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('https://wa.me/$cleaned');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color accentColor;

  const _SectionHeader({required this.title, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 3.w,
          height: 18.h,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          // titleSmall → 13sp, w500 ✓
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: TextSizeApp.instance.s16,
          ),
        ),
      ],
    );
  }
}

// ─── Divider ──────────────────────────────────────────────────────────────────

class _Divider extends StatelessWidget {
  final ThemeData theme;
  const _Divider({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizeVertical.instance.s20),
      child: Divider(
        color: theme.dividerColor.withOpacity(0.15),
        thickness: 1,
      ),
    );
  }
}

// ─── Expandable Description ───────────────────────────────────────────────────

class _ExpandableDescription extends StatefulWidget {
  final String description;
  final ThemeData theme;

  const _ExpandableDescription({
    required this.description,
    required this.theme,
  });

  @override
  State<_ExpandableDescription> createState() => _ExpandableDescriptionState();
}


class _ExpandableDescriptionState extends State<_ExpandableDescription> {
  bool _expanded = false;
  static const int _collapsedLines = 4;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // shared style — bodyMedium من الـ theme
    final textStyle = theme.textTheme.bodyMedium?.copyWith(height: 1.75);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),
          crossFadeState: _expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: Text(
            widget.description,
            maxLines: _collapsedLines,
            overflow: TextOverflow.ellipsis,
            style: textStyle,
          ),
          secondChild: Text(
            widget.description,
            style: textStyle,
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Text(
            _expanded
                ? 'clinic.info.show_less'.tr()
                : 'clinic.info.show_more'.tr(),
            // labelLarge → primaryColor, w600 ✓
            style: theme.textTheme.labelLarge?.copyWith(
              fontSize: TextSizeApp.instance.s12,
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color accentColor;
  final ThemeData theme;

  const _InfoTile({
    required this.icon,
    required this.value,
    required this.accentColor,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizeHorizontal.instance.s16,
        vertical: AppSizeVertical.instance.s12,
      ),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: accentColor.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Icon(icon, color: accentColor, size: 18.sp),
          SizedBox(width: AppSizeHorizontal.instance.s10),
          Text(
            value,
            // bodyMedium + bold ✓
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Contact Item ─────────────────────────────────────────────────────────────

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color? iconColor;
  final Color accentColor;
  final ThemeData theme;
  final VoidCallback onTap;

  const _ContactItem({
    required this.icon,
    required this.value,
    required this.label,
    this.iconColor,
    required this.accentColor,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? accentColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: AppSizeVertical.instance.s10,
            horizontal: AppSizeHorizontal.instance.s4,
          ),
          child: Row(
            children: [
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18.r, color: color),
              ),
              SizedBox(width: AppSizeHorizontal.instance.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      // bodyMedium + bold ✓
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      label,
                      // bodySmall ✓
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14.r,
                color: theme.hintColor.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// ─── Location Section ─────────────────────────────────────────────────────────

class ClinicLocationSection extends StatelessWidget {
  final String locationName;
  final String fullAddress;
  final double? lat;
  final double? lng;
  final Color accentColor;
  final ThemeData theme;

  const ClinicLocationSection({
    Key? key,
    required this.locationName,
    required this.fullAddress,
    this.lat,
    this.lng,
    required this.accentColor,
    required this.theme,
  }) : super(key: key);

  static final _v = AppSizeVertical.instance;
  static final _h = AppSizeHorizontal.instance;
  static final _t = TextSizeApp.instance;

  Future<void> _openMaps() async {
    if (lat == null || lng == null) return;
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Address row ──────────────────────────────────────────
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomIcon(
              assetPath: Assets.locationIcon,
              color: accentColor,
              size: _t.s18,
            ),
            SizedBox(width: _h.s8),
            Expanded(
              child: Text(
                '$locationName — $fullAddress',
                // bodyMedium ✓ — hintColor من الـ theme
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
              ),

            ),
          ],
        ),

        SizedBox(height: _v.s14),

        // ─── Map ──────────────────────────────────────────────────
        if (lat != null && lng != null)
          GestureDetector(
            onTap: _openMaps,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14.r),
              child: Stack(
                children: [
                  SizedBox(
                    height: 160.h,
                    width: double.infinity,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(lat!, lng!),
                        zoom: 15,
                      ),
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      scrollGesturesEnabled: false,
                      zoomGesturesEnabled: false,
                      rotateGesturesEnabled: false,
                      tiltGesturesEnabled: false,
                      markers: {
                        Marker(
                          markerId: const MarkerId('clinic'),
                          position: LatLng(lat!, lng!),
                        ),
                      },
                    ),
                  ),
                  // ─── Open in Maps overlay ──────────────────────
                  Positioned(
                    bottom: 10.h,
                    left: 10.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: _h.s12,
                        vertical: _v.s6,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.open_in_new_rounded,
                            size: 13.sp,
                            color: Colors.white,
                          ),
                          SizedBox(width: _h.s4),
                          Text(
                            'clinic.info.open_maps'.tr(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}