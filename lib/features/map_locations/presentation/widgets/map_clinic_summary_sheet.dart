// lib/features/map_locations/presentation/widgets/map_clinic_summary_sheet.dart

import 'package:clinic_app/core/routes/routes.dart';
import 'package:clinic_app/core/theme/colors.dart';
import 'package:clinic_app/core/widgets/custom_network_image.dart';
import 'package:clinic_app/features/home/domain/entities/clinic_summary.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

// ── Entry point ──────────────────────────────────────────────────────────────
//
// Usage: MapClinicSummarySheet.show(context, clinic)
//
// Pushes a transparent custom route so Hero animations work properly between
// the floating card thumbnail and the large cover image in the sheet.
// ─────────────────────────────────────────────────────────────────────────────

class MapClinicSummarySheet {
  MapClinicSummarySheet._();

  static void show(BuildContext context, ClinicSummary clinic) {
    Navigator.of(context).push(_ClinicSheetRoute(clinic: clinic));
  }
}

// ── Custom transparent PageRoute (enables Hero + slide from bottom) ──────────

class _ClinicSheetRoute extends PageRoute<void> {
  _ClinicSheetRoute({required this.clinic})
      : super(fullscreenDialog: true);

  final ClinicSummary clinic;

  @override
  Color get barrierColor => Colors.black54;

  @override
  String get barrierLabel => '';

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 420);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _ClinicSummaryPage(clinic: clinic, animation: animation);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // Barrier fade
    final fade = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
    return FadeTransition(opacity: fade, child: child);
  }
}

// ── The actual page rendered by the route ───────────────────────────────────

class _ClinicSummaryPage extends StatefulWidget {
  const _ClinicSummaryPage({
    required this.clinic,
    required this.animation,
  });

  final ClinicSummary clinic;
  final Animation<double> animation;

  @override
  State<_ClinicSummaryPage> createState() => _ClinicSummaryPageState();
}

class _ClinicSummaryPageState extends State<_ClinicSummaryPage> {
  // Slide the sheet up from the bottom
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: widget.animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    ));
  }

  Future<void> _openMaps() async {
    if (widget.clinic.lat == null || widget.clinic.lng == null) return;
    final uri = Uri.parse(
        'https://maps.google.com/?q=${widget.clinic.lat},${widget.clinic.lng}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return GestureDetector(
      // Tap outside the sheet → pop
      onTap: () => Navigator.of(context).pop(),
      behavior: HitTestBehavior.opaque,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          // Prevent tap-through on the sheet itself
          onTap: () {},
          child: SlideTransition(
            position: _slideAnim,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
              ),
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, bottomPad + 24.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Drag handle ────────────────────────────────────
                  Container(
                    width: 40.w,
                    height: 4.h,
                    margin: EdgeInsets.only(bottom: 24.h),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.black12,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),

                  // ── Cover image — Hero flies from card ─────────────
                  Stack(
                    children: [
                      Hero(
                        tag: 'clinic_map_image_${widget.clinic.id}',
                        // Keep ClipRRect during flight so corners animate
                        flightShuttleBuilder: (_, anim, __, ___, ____) {
                          return AnimatedBuilder(
                            animation: anim,
                            builder: (_, child) {
                              // Corner radius interpolates: 14→24
                              final radius = Tween<double>(
                                begin: 14,
                                end: 24,
                              ).evaluate(anim);
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(radius.r),
                                child: child,
                              );
                            },
                            child: CustomNetworkImage(
                              imageUrl: widget.clinic.firstImageUrl,
                              width: double.infinity,
                              height: 200.h,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24.r),
                          child: CustomNetworkImage(
                            imageUrl: widget.clinic.firstImageUrl,
                            width: double.infinity,
                            height: 200.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // Open/Closed badge on the image
                      Positioned(
                        top: 12.h,
                        right: 12.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: widget.clinic.isOpen
                                ? ColorsManager.successSurface
                                : ColorsManager.errorSurface,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Text(
                            widget.clinic.isOpen
                                ? 'clinic.status.open'.tr()
                                : 'clinic.status.closed'.tr(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: widget.clinic.isOpen
                                  ? ColorsManager.successText
                                  : ColorsManager.errorText,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // ── Title & Rating ──────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.clinic.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color:
                              ColorsManager.warningFill.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star_rounded,
                                size: 16.sp,
                                color: ColorsManager.warningFill),
                            SizedBox(width: 4.w),
                            Text(
                              widget.clinic.rating,
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: ColorsManager.warningText,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // ── Location ────────────────────────────────────────
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.location_on_rounded,
                            size: 16.sp, color: theme.primaryColor),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          widget.clinic.location,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.hintColor,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 28.h),

                  // ── Action buttons ──────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _openMaps,
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            side: BorderSide(color: theme.primaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.directions_rounded,
                                  size: 18.sp, color: theme.primaryColor),
                              SizedBox(width: 6.w),
                              Text(
                                'map.navigate'.tr(),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context); // close sheet
                            Navigator.of(context).pushNamed(
                              Routes.clinicDetails,
                              arguments: widget.clinic.id,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            backgroundColor: theme.primaryColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          child: Text(
                            'booking.bottom_bar.book_now'.tr(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
