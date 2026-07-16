import 'package:clinic_app/core/theme/colors.dart';
import 'package:clinic_app/features/doctor_details/domain/entities/doctor_profile_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/circle_icon_button.dart';

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
      expandedHeight: 220.h,
      floating: false,
      pinned: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: isAppBarSolid ? 0.5 : 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      leading: CircleIconButton(
        onTap: onBackTap,
        icon: Icons.arrow_back_ios_new_rounded,
        heroic: false,
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              CircleAvatar(
                radius: 45.r,
                backgroundColor: theme.dividerColor.withOpacity(0.1),
                backgroundImage: doctor.imageUrl.isNotEmpty
                    ? NetworkImage(doctor.imageUrl)
                    : null,
                child: doctor.imageUrl.isEmpty
                    ? Text(
                        doctor.name.substring(0, 1),
                        style: TextStyle(
                          fontSize: 24.sp,
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              SizedBox(height: 16.h),
              Text(
                doctor.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (doctor.specialty.isNotEmpty) ...[
                SizedBox(height: 4.h),
                Text(
                  doctor.specialty,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}