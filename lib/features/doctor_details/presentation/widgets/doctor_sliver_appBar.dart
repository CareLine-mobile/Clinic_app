import 'package:clinic_app/core/theme/colors.dart';
import 'package:clinic_app/features/doctor_details/domain/entities/doctor_profile_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/circle_icon_button.dart';
import 'gradient_place_holder.dart';


class DoctorSliverAppBar extends StatelessWidget {
  final DoctorProfileEntity doctor;
  final bool isAppBarSolid;
  final VoidCallback onBackTap;

  const DoctorSliverAppBar({
    super.key,
    required this.doctor,
    required this.isAppBarSolid,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverAppBar(
      expandedHeight: 280.h,
      floating: false,
      pinned: true,
      backgroundColor:
      isAppBarSolid ? theme.scaffoldBackgroundColor : Colors.transparent,
      elevation: isAppBarSolid ? 0.5 : 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness:
        isAppBarSolid ? Brightness.dark : Brightness.light,
      ),
      leading: CircleIconButton(
        onTap: onBackTap,
        icon: Icons.arrow_back_ios_new_rounded,
        heroic: !isAppBarSolid,
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // Background image / gradient
            doctor.imageUrl.isNotEmpty
                ? Image.network(
              doctor.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  GradientPlaceholder(name: doctor.name),
            )
                : GradientPlaceholder(name: doctor.name),
            // Gradient overlay for text legibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.15),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            // Name + specialty badge
            Positioned(
              left: 20.w,
              right: 20.w,
              bottom: 20.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (doctor.specialty.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 4.h),
                      margin: EdgeInsets.only(bottom: 8.h),
                      decoration: BoxDecoration(
                        color: ColorsManager.primaryColor.withOpacity(0.85),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        doctor.specialty,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  Text(
                    doctor.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  if (doctor.clinical != null)
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded,
                            color: Colors.white70, size: 14.sp),
                        SizedBox(width: 4.w),
                        Flexible(
                          child: Text(
                            doctor.clinical!.name,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}