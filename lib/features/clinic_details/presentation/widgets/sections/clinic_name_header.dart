// lib/features/clinic_details/presentation/widgets/components/clinic_name_header.dart

import 'package:easy_localization/easy_localization.dart';
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
            if (clinic.specialty != null && clinic.specialty!.isNotEmpty) ...[
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: _h.s10,
                  vertical: _v.s4,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  clinic.specialty!,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(height: _v.s10),
            ],

            // ─── Clinic name ──────────────────────────────────────────
            Text(
              clinic.name,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),

            // ─── Location ─────────────────────────────────────────────
            if (clinic.location != null && clinic.location!.isNotEmpty) ...[
              SizedBox(height: _v.s10),
              Row(
                children: [
                  CustomIcon(
                    assetPath: Assets.locationIcon,
                    size: _t.s16,
                    color: theme.hintColor,
                  ),
                  SizedBox(width: _h.s6),
                  Expanded(
                    child: Text(
                      clinic.location!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],

            SizedBox(height: _v.s16),
            Divider(height: 1, color: theme.dividerColor.withOpacity(0.4)),
          ],
        ),
      ),
    );
  }
}