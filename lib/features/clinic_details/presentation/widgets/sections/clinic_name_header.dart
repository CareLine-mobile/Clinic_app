// lib/features/clinic_details/presentation/widgets/components/clinic_name_header.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/utils/app_size.dart';
import '../../../../../core/utils/assets.dart';
import '../../../../../core/widgets/CustomIcon.dart';
import '../../../domain/entites/clinic_entities.dart';

class ClinicNameHeader extends StatelessWidget {
  final ClinicEntity clinic;

  const ClinicNameHeader({Key? key, required this.clinic}) : super(key: key);

  static final _v = AppSizeVertical.instance;
  static final _h = AppSizeHorizontal.instance;
  static final _t = TextSizeApp.instance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Container(
        color: theme.scaffoldBackgroundColor,
        padding: EdgeInsets.fromLTRB(_h.s20, _v.s20, _h.s20, _v.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ─── Specialty chip ───────────────────────────────────────
            if (clinic.specialty.isNotEmpty) ...[
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: _h.s12,
                  vertical: _v.s6,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r), // More rounded (pill shape)
                ),
                child: Text(
                  clinic.specialty,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              SizedBox(height: _v.s12),
            ],

            // ─── Clinic name & Rating ─────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    clinic.name,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                ),
                if (clinic.rating > 0) ...[
                  SizedBox(width: _h.s10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: _h.s8, vertical: _v.s6),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star_rounded, color: Colors.amber, size: _t.s18),
                        SizedBox(width: 4.w),
                        Text(
                          clinic.rating.toStringAsFixed(1),
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: Colors.amber.shade800,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),

            // ─── Location ─────────────────────────────────────────────
            if (clinic.location.isNotEmpty) ...[
              SizedBox(height: _v.s16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(_h.s8),
                    decoration: BoxDecoration(
                      color: theme.hintColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIcon(
                      assetPath: Assets.locationIcon,
                      size: _t.s16,
                      color: theme.hintColor,
                    ),
                  ),
                  SizedBox(width: _h.s12),
                  Expanded(
                    child: Text(
                      clinic.location,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],

            SizedBox(height: _v.s24),
          ],
        ),
      ),
    );
  }
}